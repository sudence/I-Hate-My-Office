class_name Interactor
extends Area2D

#Interactions
var nearby_areas: Array[PickUp]
@onready var weapon_controls: WeaponControls = $"../GunHolder"

#Interactions
func interact():
	if nearby_areas.is_empty():
		return
	
	var min_dist_item: PickUp
	var min_distance: float = 100000
	
	for item : PickUp in nearby_areas:
		var current_distance = global_position.distance_squared_to(item.global_position)
		if current_distance < min_distance:
			min_dist_item = item
	
	replace_weapon(min_dist_item.pick_up())

func replace_weapon(weapon: Weapons):
	weapon_controls.equip_weapon(weapon)

func _on_area_entered(area: Area2D) -> void:
	nearby_areas.append(area)
	area.enable(true)

func _on_area_exited(area: Area2D) -> void:
	for i : int in range(0, nearby_areas.size()):
		if nearby_areas[i] == area:
			nearby_areas.remove_at(i)
	area.enable(false)
