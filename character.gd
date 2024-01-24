extends CharacterBody2D

#import de l'image rémanante
@export var r_node : PackedScene
@onready var timer_remanance = $TimerRemanance
@onready var tile_map = $"../TileMap"
@onready var animated_sprite_2d = %AnimatedSprite2D


const SPEED = 500.0

const JUMP_VELOCITY = -400.0
var dooble_jump = 0
var simple_dash = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#process physics and movement
func _physics_process(delta):
	
	#var lyer = get_meta("death")
	#print(lyer)
	
	if is_on_floor():
		simple_dash = 0
	
		#anim les personages
		if (velocity.x > 1) || (velocity.x < -1) :
			## on utilise play() au lieu de .animation pour éviter les beugs de première frame 
			animated_sprite_2d.play("run-" + tile_map.realm)
		else:
			animated_sprite_2d.play("idle-"+ tile_map.realm)
	
	# Add the gravity.
	if not is_on_floor(): 
		velocity.y += gravity * delta
		if velocity.y < 1:
			animated_sprite_2d.animation = "jump-" + tile_map.realm
		elif velocity.y > 1:
			animated_sprite_2d.play("fall-"+tile_map.realm)

	# Handle jump.
	if (Input.is_action_just_pressed("jump") and is_on_floor()):
		velocity.y = JUMP_VELOCITY
		dooble_jump = 1
	elif Input.is_action_just_pressed("jump") and dooble_jump == 1 and tile_map.realm == "heaven" :
		velocity.y = JUMP_VELOCITY * 1.4
		dooble_jump=dooble_jump+1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	var isLeft = velocity.x < 0
	animated_sprite_2d.flip_h = isLeft
	

#créée l'image rémanante
func add_ghost():
	var ghost = r_node.instantiate()
	ghost.set_property(position,$AnimatedSprite2D.scale)
	get_tree().current_scene.add_child(ghost)

#quand timeout créée l'image rémanante
func _on_timer_remanance_timeout():
	add_ghost()

func dash():
	#start timer
	timer_remanance.start()
	velocity.y = 0
	var previous_gravity = gravity
	gravity = 100
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + velocity,0.20)
	
	await tween.finished
	timer_remanance.stop()
	gravity = previous_gravity

func _input(event):
	if event.is_action_pressed("dash") && (tile_map.realm == "hell") && simple_dash == 0:
		dash()
		simple_dash = 1
		
func die():
	queue_free()
