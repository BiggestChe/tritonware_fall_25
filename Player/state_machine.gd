extends CharacterBody2D

# --- Movement variables ---
@export var speed := 200
@export var jump_velocity := -400
@export var gravity := 900

# --- State machine ---
enum State { IDLE, WALKING, JUMPING, FALLING }
var current_state : State = State.IDLE

#rolls every second
func _physics_process(delta):
	match current_state:
		State.IDLE:
			state_idle(delta)
		State.WALKING:
			state_walking(delta)
		State.JUMPING:
			state_jumping(delta)
		State.FALLING:
			state_falling(delta)

# --- State functions ---
func state_idle(delta):
	if not is_on_floor():
		change_state(State.FALLING)
		return

	var direction = Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		change_state(State.WALKING)
	elif Input.is_action_just_pressed("ui_accept"): # jump
		change_state(State.JUMPING)

func state_walking(delta):
	var direction = Input.get_axis("ui_left", "ui_right")

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

func state_jumping(delta):
	# Apply jump velocity only when entering this state
	if velocity.y == 0 or is_on_floor():
		velocity.y = jump_velocity

	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed
	velocity.y += gravity * delta
	move_and_slide()

	if velocity.y > 0:
		change_state(State.FALLING)

func state_falling(delta):
	velocity.y += gravity * delta
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed
	move_and_slide()

	if is_on_floor():
		change_state(State.IDLE)

# --- Helper function ---
func change_state(new_state: State):
	current_state = new_state
