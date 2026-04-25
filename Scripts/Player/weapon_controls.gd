class_name WeaponControls
extends Node2D

@onready var character := get_parent() as CharacterMovement

@export var current_weapon: Weapons = null
@export var pickup_scene: PackedScene   # assign PickUp.tscn in inspector

func equip_weapon(new_weapon: Weapons) -> void:
	if new_weapon == null:
		return
	
	#  DROP CURRENT WEAPON FIRST
	if current_weapon:
		drop_weapon()
	
	#  EQUIP NEW WEAPON
	current_weapon = new_weapon
	add_child(current_weapon)
	current_weapon.position = Vector2.ZERO
	
	# place hands
	if character:
		character.place_hands(current_weapon.hand_placement)

func drop_weapon():
	if pickup_scene == null or current_weapon == null:
		return
	
	var pickup = pickup_scene.instantiate()
	get_tree().current_scene.add_child(pickup)
	
	# drop near player
	pickup.global_position = global_position
	
	# assign weapon back into pickup
	if current_weapon.scene_file_path != "":
		pickup.weapon_scene = load(current_weapon.scene_file_path)
	
	# copy sprite (so it looks correct on ground)
	if current_weapon.has_node("Sprite2D"):
		pickup.sprite = current_weapon.get_node("Sprite2D").texture
	
	# remove weapon from player
	current_weapon.queue_free()
	current_weapon = null

func attack():
	if current_weapon:
		current_weapon.attack()
