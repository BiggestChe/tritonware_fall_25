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
@export var double_press_window := 0.5 # seconds
var look_up_press_count := 0
var look_up_timer = 0.0

#Animation Variables
@onready var sprite = $Sprite2D

#Light Cone
@onready var light_cone = $Sprite2D/PointLight2D
var is_looking_up := false

#laser
@onready var laser_beam = $Laser
@export var rotation_speed := 3.0

@onready var aim_direction = Vector2.RIGHT

# --- State machine ---
enum State { IDLE, WALKING, JUMPING, FALLING, LOOK_UP }
var current_state : State = State.IDLE

#rolls every second
func _physics_process(delta):
	
	#print("Current state: ", current_state)
	
	#after jumping, create time window to create double press
	if look_up_timer > 0:
		look_up_timer -= delta
		if look_up_timer <= 0:
			look_up_press_count = 0
			look_up_timer = 0
		
	
	# Detect look up press
	if Input.is_action_just_pressed("look_up1"):
		look_up_press_count += 1
		look_up_timer = double_press_window
		#print("Look up pressed, count:", look_up_press_count)
		
		# Trigger jump if double press detected 
	if look_up_press_count >= 2:
		print("Double press detected! Jump!")
		change_state(State.JUMPING)
		look_up_press_count = 0  # reset after jump
		look_up_timer = 0
	
	#if Input.is_action_pressed("left_1"):
		#rotation -= rotation_speed * delta
	#elif Input.is_action_pressed("right_1"):
		#rotation += rotation_speed * delta

	# Fire when pressing "shoot"
	if Input.is_action_pressed("fire_laser"):
		laser_beam.active = true
	else:
		laser_beam.active = false	
	
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
			if is_looking_up:
				light_cone.rotation_degrees = 0
				aim_direction 
			else:
				light_cone.rotation_degrees = 90

# --- State functions ---
func state_idle(_delta):
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
	#print(direction)


	if direction == 0:
		change_state(State.IDLE)
		return
	if direction > 0 :
		sprite.flip_h = false
		light_cone.rotation_degrees = 90
		aim_direction = Vector2.RIGHT
	else:
		sprite.flip_h = true	
		light_cone.rotation_degrees = -90
		aim_direction = Vector2.LEFT
		
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
	
	is_looking_up = true
	aim_direction = Vector2.UP

	var direction = Input.get_axis("left_1", "right_1")
	velocity.x = direction * speed
	velocity.y += gravity * delta
	move_and_slide()
	
	# Trigger jump on double press
	if look_up_press_count >= 2:
		change_state(State.JUMPING) # Trigger jump on double press
	elif not Input.is_action_pressed("look_up1"):
		is_looking_up = false
		change_state(State.IDLE)
	
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
