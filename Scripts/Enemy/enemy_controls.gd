extends Node2D

@export var min_distance : float = 200

@onready var movement : CharacterMovement = $".."
@onready var nav_agent: NavigationAgent2D = $"../NavigationAgent2D"

@onready var player : CharacterMovement = $"../../../Player"

func _physics_process(delta: float) -> void:
	nav_agent.target_position = player.global_position
	
	var move_dir = global_position.direction_to(nav_agent.get_next_path_position())
	
	movement.look_dir = move_dir
	
	if global_position.distance_to(player.global_position) > min_distance:
		movement.move_dir = move_dir
	else:
		movement.move_dir = Vector2.ZERO
