class_name PickUp
extends Area2D

@onready var effects : Node2D = $Effects
var enabled : bool
@onready var item_sprite: Sprite2D = $ItemSprite
@onready var destroy_timer: Timer = $DestroyTimer

#Settings
@export_enum("weapons", "quest", "power_ups") var pickup_type
@export var sprite : Texture2D = preload("res://Sprites/Objects/Guns/Pisstol.png")
@export var weapon : SceneTree

func _ready() -> void:
	item_sprite.texture = sprite
	enable(false)

func pick_up():
	destroy_timer.start()
	destroy_timer.timeout.connect(queue_free)
	#return weapon

func enable(varia: bool) -> void:
	effects.visible = varia
	enabled = varia
