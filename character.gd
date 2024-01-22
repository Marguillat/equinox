extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var dooble_jump = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if (Input.is_action_just_pressed("jump") and is_on_floor()):
		velocity.y = JUMP_VELOCITY
		dooble_jump = 0
	elif Input.is_action_just_pressed("jump") and dooble_jump == 0:
		velocity.y = JUMP_VELOCITY
		dooble_jump=dooble_jump+1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
