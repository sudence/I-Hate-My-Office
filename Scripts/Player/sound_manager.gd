extends Node

const sound_player : Resource = preload("uid://1xca44png5oh")

func play_at_position(pos: Vector2, clip: AudioStream, volume_db: float, pitch: float, pitch_variation: float, bus: String):
	var sound : AudioStreamPlayer2D = sound_player.instantiate()
	get_tree().root.add_child(sound)
	
	sound.global_position = pos
	sound.stream = clip
	sound.bus = bus
	sound.pitch_scale = pitch + randf_range(-pitch_variation, pitch_variation)
	sound.volume_db = volume_db
	sound.play()
	
	sound.finished.connect(sound.queue_free)
