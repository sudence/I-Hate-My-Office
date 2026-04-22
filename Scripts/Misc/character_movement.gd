class_name CharacterMovement
extends RigidBody2D

@export var speed : float = 500.0
@export var accel : float = 100.0
@export var decel : float = 30.0
@export var look_smooth : float = 20.0

var move_dir : Vector2
var look_dir : Vector2
var moving : bool
var looking : bool

var predicted_point : Vector2

#Animation
@onready var anim_tree: AnimationTree = $AnimationTree
@export var hands : Array[Node2D]

func _process(delta: float) -> void:
	#Animation
	var running = move_dir != Vector2.ZERO
	anim_tree["parameters/Running/blend_amount"] = lerp(anim_tree["parameters/Running/blend_amount"], float(running), 5 * delta)

func _physics_process(delta: float) -> void:
	move_and_look(delta)
	
	predicted_point = global_position + linear_velocity

func move_and_look(delta: float) -> void:
	moving = move_dir != Vector2.ZERO
	looking = look_dir != Vector2.ZERO
	
	var change : float = accel if moving else decel
	
	linear_velocity = linear_velocity.move_toward(move_dir.normalized() * speed, change) 
	
	if looking:
		rotation = atan2(look_dir.x, -look_dir.y)
	elif moving:
		rotation = lerp_angle(rotation, atan2(move_dir.x, -move_dir.y), look_smooth * delta)
	rotation = wrap(rotation, -PI, PI)

func place_hands(hand_p: Array[Marker2D]):
	hands[0].global_position = hand_p[0].global_position
	hands[1].global_position = hand_p[1].global_position
