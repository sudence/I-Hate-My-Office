class_name Interactor
extends Area2D

var nearby_areas: Array[PickUp]
@onready var weapon_controls: WeaponControls = $"../GunHolder"

func interact():
	if nearby_areas.is_empty():
		return
	
	var min_dist_item: PickUp
	var min_distance: float = INF
	
	for item: PickUp in nearby_areas:
		var dist = global_position.distance_squared_to(item.global_position)
		if dist < min_distance:
			min_distance = dist
			min_dist_item = item
	
	var weapon = min_dist_item.pick_up()
	if weapon:
		weapon_controls.equip_weapon(weapon)

func _on_area_entered(area: Area2D) -> void:
	if area not in nearby_areas:
		nearby_areas.append(area)
		area.enable(true)

func _on_area_exited(area: Area2D) -> void:
	if area in nearby_areas:
		nearby_areas.erase(area)
		area.enable(false)
