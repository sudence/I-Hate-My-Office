class_name Meelee
extends Node2D

@onready var weapon := get_parent()
@onready var hitbox: Area2D = weapon.get_node("Hitbox")
@onready var attack_timer: Timer = weapon.get_node("AttackTimer")

# get player
@onready var player := weapon.get_parent().get_parent() as RigidBody2D

var can_attack := true

@export var lunge_force: float = 1200.0
@export var lunge_time: float = 0.5

func _ready():
	attack_timer.timeout.connect(_on_attack_finished)

func attack():
	if not can_attack:
		return
	
	can_attack = false
	
	# direction from player to mouse
	var dir = (get_global_mouse_position() - player.global_position).normalized()
	
	# apply forward push (lunge)
	player.linear_velocity = dir * lunge_force
	
	# enable hitbox
	hitbox.monitoring = true
	
	# start timer
	attack_timer.start(lunge_time)

func _on_attack_finished():
	# stop movement quickly
	player.linear_velocity = Vector2.ZERO
	
	# disable hitbox
	hitbox.monitoring = false
	
	can_attack = true


func _on_Hitbox_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(1)
