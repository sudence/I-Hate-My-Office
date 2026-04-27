class_name WeaponControls
extends Node2D

@onready var character := get_parent() as CharacterMovement

@export var current_weapon: Weapons = null
@export var pickup_scene: PackedScene   # assign PickUp.tscn in inspector

func equip_weapon(new_weapon: Weapons) -> void:
	if new_weapon == null:
		return
	
	#  DROP CURRENT WEAPON (if exists)
	if current_weapon:
		_drop_current_weapon()
	
	#  EQUIP NEW WEAPON
	current_weapon = new_weapon
	add_child(current_weapon)
	current_weapon.position = Vector2.ZERO
	
	# place hands
	if character:
		character.place_hands(current_weapon.hand_placement)

func _drop_current_weapon():
	if pickup_scene == null:
		push_error("pickup_scene not assigned!")
		return
	
	var pickup = pickup_scene.instantiate()
	get_tree().current_scene.add_child(pickup)
	
	# drop near player
	pickup.global_position = global_position + Vector2(randf_range(-10,10), randf_range(-10,10))
	
	# assign weapon scene back
	if current_weapon.scene_file_path != "":
		pickup.weapon_scene = load(current_weapon.scene_file_path)
	
	# copy sprite (important for visuals)
	if current_weapon.has_node("Sprite2D"):
		pickup.sprite = current_weapon.get_node("Sprite2D").texture
	
	# remove weapon
	current_weapon.queue_free()
	current_weapon = null

func attack():
	if current_weapon:
		current_weapon.attack()
