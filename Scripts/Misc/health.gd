class_name Health extends Node

@export var max_health : float = 10
@onready var health : float = max_health

@export var animated : bool = true
@onready var effect_player: AnimationPlayer = $"../EffectPlayer"

var camera : CameraController
@export var camera_shake_n_time : Vector2 = Vector2(0.5, 0.2)

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("Camera")

func Change(delta : float):
	if delta < 0:
		camera.Shake(camera_shake_n_time.x, camera_shake_n_time.y)
		effect_player.play("Flash Damage")
	elif delta > 0:
		pass
	
	health += delta
	clamp(health, 0, max_health)
	
	if health == 0: Destroy()

func Destroy():
	get_parent().queue_free()
