class_name Weapons
extends Node2D

@export var hand_placement: Array[Marker2D]
@export var hold_pos : Vector2 = Vector2(-6, -62)
@onready var executor = $Executor

func _ready() -> void:
	hand_placement.append($HandPlacement/LeftHand)
	hand_placement.append($HandPlacement/RightHand)

func attack():
	if executor is Gun:
		executor.shoot()
	elif executor is Meelee:
		executor.attack()
