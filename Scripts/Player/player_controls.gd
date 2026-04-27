extends Node2D

@onready var movement: CharacterMovement = $".."

# Weapon
@onready var weapon_controller: WeaponControls = $"../GunHolder"
@export var shoot_threshold: float = 0.8
var look_dir: Vector2
const look_stop: float = 150
var shooting: bool

# Interaction
@onready var interactor: Interactor = $"../Interactor"

func _input(event: InputEvent) -> void:
	# Movement input
	movement.move_dir = Input.get_vector("left", "right", "up", "down")
	
	# Look direction (mouse)
	if global_position.distance_to(get_global_mouse_position()) > look_stop:
		look_dir = weapon_controller.global_position.direction_to(get_global_mouse_position())
	else:
		look_dir = global_position.direction_to(get_global_mouse_position())
	
	# Shooting input
	if event.is_action_pressed("attack"):
		shooting = true
	elif event.is_action_released("attack"):
		shooting = false
	
	#  THROW (for melee only)
	if event.is_action_pressed("throw"):
		var weapon = weapon_controller.current_weapon
		
		if weapon and weapon.executor is Meelee:
			weapon.executor.throw_weapon()
	
	# Apply look to movement
	movement.look_dir = look_dir
	
	# Optional keyboard look override
	look_dir = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	
	# Interactions
	if event.is_action_pressed("interact"):
		interactor.interact()


func _physics_process(delta: float) -> void:
	# Hold-to-shoot
	if shooting:
		weapon_controller.attack()
	
	# Controller aim shooting
	if look_dir.length() > shoot_threshold:
		weapon_controller.attack()
