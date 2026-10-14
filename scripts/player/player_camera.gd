extends Camera2D
class_name PlayerCamera

# PlayerCamera: Camera2D có tính năng rung nhẹ (Camera Shake) cho Game Feel

var shake_timer: float = 0.0
var shake_intensity: float = 0.0

func apply_shake(duration: float, intensity: float) -> void:
	shake_timer = duration
	shake_intensity = intensity

func _process(delta: float) -> void:
	if shake_timer > 0.0:
		shake_timer -= delta
		offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		if shake_timer <= 0.0:
			offset = Vector2.ZERO
