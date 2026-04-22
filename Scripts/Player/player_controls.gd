extends Node2D

@onready var movement : CharacterMovement = $".."

#Gun
@onready var weapon_controller: WeaponControls = $"../GunHolder"
@export var shoot_threshold : float = 0.8
var look_dir : Vector2
const look_stop : float = 150
var shooting : bool

#Interaction
@onready var interactor: Interactor = $"../Interactor"

func _input(event: InputEvent) -> void:
	#Movement
	movement.move_dir = Input.get_vector("left", "right", "up", "down")
	
	if global_position.distance_to(get_global_mouse_position()) > look_stop:
		look_dir = weapon_controller.global_position.direction_to(get_global_mouse_position())
	else:
		look_dir = global_position.direction_to(get_global_mouse_position())
	
	if event.is_action_pressed("attack"):
		shooting = true
	elif event.is_action_released("attack"):
		shooting = false
	
	movement.look_dir = look_dir
	#look_dir = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	
	#Interactions
	if event.is_action_pressed("interact"):
		interactor.interact()

func _physics_process(delta: float) -> void:
	if shooting:
		weapon_controller.attack()
	#if look_dir.length() > shoot_threshold:
		#weapon_controller.attack()
