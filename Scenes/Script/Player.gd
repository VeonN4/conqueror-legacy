extends CharacterBody2D

const ACCELERATION = 800
const FRICTION = 500
const MAX_SPEED: float = 120.0
const JUMP_VELOCITY = -250
const GRAVITY = 1000  # Add a gravity constant

enum {IDLE, WALKING}
var state = IDLE

@onready var animationTree = $AnimationTree
@onready var state_machine = animationTree["parameters/playback"]

var blend_position : float = 0
var blend_pos_paths = [
	"parameters/idle/idle_bs2d/blend_position",
	"parameters/walking/walking_bs2d/blend_position"
]

var animTree_state_keys = [
	"idle",
	"walking"
]

func _physics_process(delta):
	move(delta)
	animate()
	
func move(delta):
	var input_vector = Input.get_axis("moveLeft", "moveRight")
	
	apply_gravity(delta)  # Apply gravity here
	
	if Input.is_action_pressed("jumpKey") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	change_position(delta)
	
	if input_vector == 0:
		state = IDLE
		apply_friction(FRICTION * delta)
	else:
		state = WALKING
		apply_movement(input_vector * ACCELERATION * delta)
		blend_position = input_vector
	move_and_slide()
	
func change_position(delta) -> void:
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	
func apply_gravity(delta) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta  # Apply gravity to the y-axis

func apply_friction(amount) -> void:
	if velocity.length() > amount:
		velocity.x -= velocity.normalized().x * amount
	else:
		velocity.x = 0
		
func apply_movement(amount) -> void:
	velocity.x += amount
	if velocity.x > MAX_SPEED:
		velocity.x = MAX_SPEED
	elif velocity.x < -MAX_SPEED:
		velocity.x = -MAX_SPEED
	
	
func animate() -> void:
	state_machine.travel(animTree_state_keys[state])
	animationTree.set(blend_pos_paths[state], blend_position)
