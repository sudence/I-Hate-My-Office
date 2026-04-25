class_name PickUp
extends Area2D

@onready var effects: Node2D = $Effects
@onready var item_sprite: Sprite2D = $ItemSprite
@onready var destroy_timer: Timer = $DestroyTimer

var enabled: bool = false

# Settings
@export_enum("weapons", "quest", "power_ups") var pickup_type
@export var sprite: Texture2D = preload("res://Sprites/Objects/Guns/Pisstol.png")
@export var weapon_scene: PackedScene

func _ready() -> void:
	item_sprite.texture = sprite
	enable(false)

func pick_up() -> Weapons:
	# Safety check
	if weapon_scene == null:
		push_error("PickUp: No weapon_scene assigned!")
		return null
	
	var weapon_instance := weapon_scene.instantiate() as Weapons
	
	if weapon_instance == null:
		push_error("PickUp: Scene is not of type Weapons!")
		return null
	
	# Prevent re-trigger
	set_deferred("monitoring", false)
	item_sprite.visible = false
	
	# Destroy safely
	if not destroy_timer.timeout.is_connected(queue_free):
		destroy_timer.timeout.connect(queue_free)
	destroy_timer.start()
	
	return weapon_instance

func enable(varia: bool) -> void:
	effects.visible = varia
	enabled = varia
