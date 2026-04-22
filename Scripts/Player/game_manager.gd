extends Node2D

@export var player : Node2D

const enemy = preload("uid://vy6kdag2vglb")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spawn"):
		var e_instance: CharacterMovement = enemy.instantiate()
		get_tree().root.get_node("Testerooni/Enemies").add_child(e_instance)
		e_instance.global_position = get_global_mouse_position()
