class_name Meelee
extends Node2D

@onready var weapon := get_parent()
@onready var hitbox: Area2D = weapon.get_node("Hitbox")
@onready var attack_timer: Timer = weapon.get_node("AttackTimer")
@onready var player := weapon.get_parent().get_parent() as RigidBody2D
@onready var camera := get_viewport().get_camera_2d() as CameraController

var can_attack := true

#  Melee tuning
@export var lunge_force: float = 2000.0
@export var lunge_time: float = 0.25
@export var hit_time: float = 0.06

#  Cooldown
@export var cooldown: float = 0.75
var cooldown_timer: float = 0.0

#  Throw
@export var throw_scene: PackedScene

func _ready():
	attack_timer.timeout.connect(_on_attack_finished)

func _process(delta):
	if cooldown_timer > 0:
		cooldown_timer -= delta

func attack():
	if not can_attack or cooldown_timer > 0:
		return
	
	can_attack = false
	cooldown_timer = cooldown
	
	var dir = (get_global_mouse_position() - player.global_position).normalized()
	
	# lunge forward
	player.apply_central_impulse(dir * lunge_force)
	
	# camera shake
	if camera:
		camera.Shake(6.0, 0.15)
	
	# enable hitbox briefly
	hitbox.monitoring = true
	_disable_hitbox_soon()
	
	attack_timer.start(lunge_time)

func _disable_hitbox_soon():
	await get_tree().create_timer(hit_time).timeout
	hitbox.monitoring = false

func _on_attack_finished():
	player.linear_velocity *= 0.3
	can_attack = true

func throw_weapon():
	if throw_scene == null:
		return
	
	var knife = throw_scene.instantiate() as Bullets
	get_tree().current_scene.add_child(knife)
	
	knife.global_position = player.global_position
	
	var dir = (get_global_mouse_position() - player.global_position).normalized()
	
	# orient bullet correctly
	knife.rotation = dir.angle()
	
	#  configure as melee projectile
	knife.speed = 1200
	knife.damage = 1
	knife.max_dist = 600
	knife.is_melee = true
	knife.destroy_on_hit = true
	
	# camera feedback
	if camera:
		camera.Shake(4.0, 0.1)

func _on_Hitbox_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(1)
		
		if camera:
			camera.Shake(10.0, 0.1)
