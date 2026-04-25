class_name CharacterMovement
extends RigidBody2D

# Movement
@export var speed : float = 800.0
@export var accel : float = 2000.0
@export var decel : float = 1200.0
@export var look_smooth : float = 20.0

# Dash Settings
@export var dash_speed: float = 1500.0
@export var dash_time: float = 0.15
@export var dash_cooldown: float = 0.5

var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_cd_timer: float = 0.0
var dash_dir: Vector2 = Vector2.ZERO

# Movement State
var move_dir : Vector2
var look_dir : Vector2
var moving : bool
var looking : bool

var predicted_point : Vector2

# Animation
@onready var anim_tree: AnimationTree = $AnimationTree
@export var hands : Array[Node2D]

func _process(delta: float) -> void:
	# Animation blend
	var running = move_dir != Vector2.ZERO
	anim_tree["parameters/Running/blend_amount"] = lerp(
		anim_tree["parameters/Running/blend_amount"], 
		float(running), 
		5 * delta
	)

func _physics_process(delta: float) -> void:
	handle_dash(delta)
	move_and_look(delta)
	
	predicted_point = global_position + linear_velocity * delta

#  DASH SYSTEM
func handle_dash(delta: float) -> void:
	# Cooldown timer
	if dash_cd_timer > 0:
		dash_cd_timer -= delta
	
	# Start dash
	if Input.is_action_just_pressed("dash") and dash_cd_timer <= 0:
		start_dash()
	
	# While dashing
	if is_dashing:
		dash_timer -= delta
		linear_velocity = dash_dir * dash_speed
		
		if dash_timer <= 0:
			is_dashing = false

func start_dash() -> void:
	is_dashing = true
	dash_timer = dash_time
	dash_cd_timer = dash_cooldown
	
	# Choose direction
	if move_dir != Vector2.ZERO:
		dash_dir = move_dir.normalized()
	elif look_dir != Vector2.ZERO:
		dash_dir = look_dir.normalized()
	else:
		dash_dir = Vector2.RIGHT.rotated(rotation)

# Movement + Rotation
func move_and_look(delta: float) -> void:
	#  Disable normal movement during dash
	if is_dashing:
		return
	
	moving = move_dir != Vector2.ZERO
	looking = look_dir != Vector2.ZERO
	
	var change : float = accel if moving else decel
	
	var target_velocity = move_dir.normalized() * speed
	linear_velocity = linear_velocity.move_toward(target_velocity, change * delta)
	
	# Rotation
	if looking:
		rotation = atan2(look_dir.y, look_dir.x)
	elif moving:
		rotation = lerp_angle(rotation, atan2(move_dir.y, move_dir.x), look_smooth * delta)
	
	rotation = wrapf(rotation, -PI, PI)

# Hand placement
func place_hands(hand_p: Array[Marker2D]) -> void:
	if hand_p == null or hand_p.size() < 2:
		print("Invalid hand placement data!")
		return
	
	if hands == null or hands.size() < 2:
		print("Character hands not assigned!")
		return
	
	hands[0].global_position = hand_p[0].global_position
	hands[1].global_position = hand_p[1].global_position
