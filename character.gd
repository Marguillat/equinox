extends CharacterBody2D

#import de l'image rémanante
@export var r_node : PackedScene
@onready var timer_remanance = $TimerRemanance

const SPEED = 300.0
const dashSpeedMultiplicator = 1.5
const JUMP_VELOCITY = -400.0
var dooble_jump = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#process physics and movement
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

#créée l'image rémanante
func add_ghost():
	var ghost = r_node.instantiate()
	ghost.set_property(position,$Sprite2D.scale)
	get_tree().current_scene.add_child(ghost)

#quand timeout créée l'image rémanante
func _on_timer_remanance_timeout():
	add_ghost()

func dash():
	#start timer
	timer_remanance.start()
	velocity.y = 0
	var previous_gravity = gravity
	gravity = 0
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + velocity * dashSpeedMultiplicator,0.30)
	
	await tween.finished
	timer_remanance.stop()
	gravity = previous_gravity

func _input(event):
	if event.is_action_pressed("dash"):
		dash()
