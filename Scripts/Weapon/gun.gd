class_name Gun
extends Weapons

#BulletConstants
@export var bullet_res = preload("res://Scenes/Objects/Bullets/Bullet.tscn")

#Stats
@export var bullet_speed : float = 5000
@export var bullet_damage : float = 2
@export var fire_rate : float = 4
@onready var shoot_timer: Timer = $"../ShootTimer"
@onready var reload_timer: Timer = $"../ReloadTimer"

var shooting : bool

#Effects
@export var camera_shake_n_time : Vector2 = Vector2(0.3, 0.1)
var camera : CameraController
@onready var muzzle: Marker2D = $"../Muzzle"
@onready var shoot_sound: AudioSetting = $"../ShootSound"

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("Camera")

func shoot():
	if shoot_timer.is_stopped():
		effects()
		var bullet_instance : Bullets = bullet_res.instantiate()
		bullet_instance.speed = bullet_speed
		bullet_instance.damage = bullet_damage
		
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.rotation = global_rotation
		bullet_instance.last_position = $"../..".global_position
		
		get_tree().root.add_child(bullet_instance)
		
		shoot_timer.start(1/fire_rate)

func effects() -> void:
	camera.Shake(camera_shake_n_time.x, camera_shake_n_time.y)
	
	shoot_sound.play_sound(muzzle.global_position)
