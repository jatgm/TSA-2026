extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -200.0

const ACCELERATION = 500.0
const FRICTION = 1000.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		# 2. Accelerate: Slowly move velocity.x toward the target speed
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	else:
		# 3. Friction: Slowly move velocity.x toward 0
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	move_and_slide()
