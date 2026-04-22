class_name  CameraController
extends Camera2D

#ScreenEffects
var shake_strength: float
var shake_fade: float
var shake_multiplier: Vector2 = Vector2(1.6, 0.9)

#LookAhead
@onready var camera_follow: Node2D = $".."
@onready var player: CharacterMovement = $"../.."
@export var look_ahead_ratio: float = 0.9

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_follow.global_position = (get_global_mouse_position() * look_ahead_ratio + player.global_position) / 2

func _process(delta: float) -> void:
	if shake_strength > 0:
		offset = Vector2(randf_range(-shake_strength, shake_strength), 
		randf_range(-shake_strength, shake_strength)) * shake_fade * shake_multiplier
		
		shake_strength = lerp(shake_strength, 0.0, shake_fade * delta)

func Shake(strength: float, time: float):
	shake_strength = strength
	shake_fade = 1/time
