extends CharacterBody2D

#Creates a StateMachine for the 1st Playable Eye

# --- Movement variables ---
@export var speed := 200
@export var jump_velocity := -500
@export var gravity := 900

#--Physics Variables
@export var push_force = Vector2(100,0)
const MAX_VELOCITY := 100

# --- Look Up double press ---
var look_up_pressed_time := 0.0
@export var double_press_window := 1.0 # seconds
var look_up_press_count := 0
var look_up_timer = 0.0

# --- State machine ---
enum State { IDLE, WALKING, JUMPING, FALLING, LOOK_UP }
var current_state : State = State.IDLE

#rolls every second
func _physics_process(delta):
	
	#print("Current state: ", current_state)
	if look_up_pressed_time > 0:
		look_up_pressed_time -= delta
	#else:
		#look_up_press_count = 0
	
	# Detect look up press
	if Input.is_action_just_pressed("look_up1"):
		look_up_press_count += 1
		look_up_timer = double_press_window
		print("Look up pressed, count:", look_up_press_count)
		
		# Trigger jump if double press detected 
	if look_up_press_count >= 2:
		print("Double press detected! Jump!")
		change_state(State.JUMPING)
		look_up_press_count = 0  # reset after jump
		
	
	match current_state:
		State.IDLE:
			state_idle(delta)
		State.WALKING:
			state_walking(delta)
		State.JUMPING:
			state_jumping(delta)
		State.FALLING:
			state_falling(delta)
		State.LOOK_UP:
			state_look_up(delta)

# --- State functions ---
func state_idle(delta):
	if not is_on_floor():
		change_state(State.FALLING)
		return

	var direction = Input.get_axis("left_1", "right_1")

	#if input is held
	if direction != 0:
		change_state(State.WALKING)
	elif Input.is_action_just_pressed("look_up1"):
		change_state(State.LOOK_UP)

func state_walking(delta):
	var direction = Input.get_axis("left_1", "right_1")

	if direction == 0:
		change_state(State.IDLE)
		return

	velocity.x = direction * speed
	velocity.y += gravity * delta
	move_and_slide()

	if Input.is_action_just_pressed("ui_accept"):
		change_state(State.JUMPING)
	elif not is_on_floor():
		change_state(State.FALLING)
		
		
func state_look_up(delta):
	
	# Stay in look up until player releases input or triggers jump
	#handle_look_up()
	
	var direction = Input.get_axis("left_1", "right_1")
	velocity.x = direction * speed
	velocity.y += gravity * delta
	move_and_slide()

	# Trigger jump on double press
	if look_up_press_count >= 2:
		change_state(State.JUMPING) # Trigger jump on double press
	elif not Input.is_action_pressed("look_up1"):
		change_state(State.IDLE)
		
#handles looking up using a window after 
#func handle_look_up():
	#print("looking up")
	#
	#
	#if look_up_pressed_time > 0:
		## Second press within window
		#look_up_press_count += 1
	#else:
		#look_up_press_count = 1
	#look_up_pressed_time = double_press_window
	#change_state(State.LOOK_UP)
	
	
func state_jumping(delta):
	# Apply jump velocity only when entering this state
	if velocity.y == 0 or is_on_floor():
		velocity.y = jump_velocity

	var direction = Input.get_axis("left_1", "right_1")
	velocity.x = direction * speed
	velocity.y += gravity * delta
	move_and_slide()

	if velocity.y > 0:
		change_state(State.FALLING)

func state_falling(delta):
	velocity.y += gravity * delta
	var direction = Input.get_axis("left_1", "right_1")
	velocity.x = direction * speed
	move_and_slide()

	if is_on_floor():
		change_state(State.IDLE)

#  Helper function for changing state
func change_state(new_state: State):
	current_state = new_state
