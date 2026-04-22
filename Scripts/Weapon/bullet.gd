class_name Bullets
extends Node2D

#Stats
var speed : float
var max_dist : float = 2000
var damage : float

#Particles
@export var blood_particles = preload("uid://dag64bvvwjbsj")
@export var debri_particle = preload("uid://bnva134yncwyq")

#Physics
@onready var hit_check: RayCast2D = $HitCheck
@onready var decay_timer: Timer = $DecayTimer
var last_position: Vector2

func _ready() -> void:	
	var decay_time : float = max_dist/speed
	decay_timer.start(decay_time)
	
	#Setup
	hit_check.global_position = global_position
	hit_check.target_position = Vector2.ZERO

func _physics_process(delta: float) -> void:
	global_position += transform.y * -speed * delta
	
	ScanHit()
	
	#SavePosition
	last_position = global_position

func ScanHit():
	#Setup
	hit_check.global_position = last_position
	hit_check.target_position = global_position - last_position
	
	#Check
	if hit_check.is_colliding():
		var body : Node2D = hit_check.get_collider()
		$SmallBullet.visible = false
		if body.is_in_group("Health"):
			Damage(body, hit_check.get_collision_point())
		Destroy(body, hit_check.get_collision_point())

func Damage(body: Node2D, hit_point: Vector2):
	body.get_node("%Health").Change(-damage)
	
	Destroy(body, hit_point)

func Destroy(collision: Node2D, hit_point: Vector2):
	#Particles
	var particles : GPUParticles2D
	if collision.is_in_group("Bleedable"):
		particles = blood_particles.instantiate()
	else:
		particles = debri_particle.instantiate()
	
	get_tree().root.add_child(particles)
	
	var hit_rotation : float = (Vector2.UP.angle_to(hit_check.get_collision_normal()))
	particles.rotate(hit_rotation)
	particles.global_position = hit_point
	particles.emitting = true
	
	if particles.sub_emitter.is_empty():
		particles.finished.connect(particles.queue_free)
	else:
		var timer: Timer = particles.get_node("Timer")
		timer.timeout.connect(particles.queue_free)
	queue_free()

func _on_decay_timer_timeout() -> void:
	queue_free()
