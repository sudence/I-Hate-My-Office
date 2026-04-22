class_name AudioSetting
extends AudioStreamPlayer2D

@export var pitch_variation : float = 0.1

func play_sound(pos: Vector2) -> void:
	SoundManager.play_at_position(pos, stream, volume_db, pitch_scale, pitch_variation, bus)
