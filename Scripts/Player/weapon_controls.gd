class_name WeaponControls
extends Node2D

@onready var character: CharacterMovement = $".."
@export var current_weapon : Weapons

func equip_weapon(cur_weapon: Weapons):
	position = cur_weapon.hold_pos
	character.place_hands(cur_weapon.hand_placement)
	
	current_weapon = cur_weapon

func attack():
	if current_weapon:
		current_weapon.attack()
