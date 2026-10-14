extends RefCounted
class_name CombatFeedback

# CombatFeedback: Quản lý toàn bộ hiệu ứng cảm giác đánh (Game Feel)
# Hit-stop (dừng hình), Rung camera, Sát thương bay lên (floating text), Chớp trắng

static func trigger_hit_stop(tree: SceneTree, duration: float) -> void:
	if not bool(GameData.get_stat("game_feel", "hit_stop_enabled", true)):
		return
	if tree == null or duration <= 0.0:
		return
	Engine.time_scale = 0.05
	var timer := tree.create_timer(duration, true, false, true)
	timer.timeout.connect(func():
		Engine.time_scale = 1.0
	)

static func shake_camera(camera: Camera2D, duration: float, intensity: float) -> void:
	if not bool(GameData.get_stat("game_feel", "camera_shake_enabled", true)):
		return
	if camera == null or duration <= 0.0:
		return
	if camera.has_method("apply_shake"):
		camera.apply_shake(duration, intensity)
	else:
		# Fallback cho Camera2D thông thường
		var orig_offset := camera.offset
		var timer := camera.get_tree().create_timer(duration, false, false, true)
		var tween := camera.create_tween()
		for i in range(int(duration * 30.0)):
			var rand_off := Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
			tween.tween_property(camera, "offset", rand_off, duration / 30.0)
		tween.tween_property(camera, "offset", orig_offset, 0.05)

static func spawn_floating_text(parent: Node, text: String, world_pos: Vector2, color: Color = Color.WHITE, is_big: bool = false) -> void:
	if not bool(GameData.get_stat("game_feel", "floating_numbers_enabled", true)):
		return
	if parent == null:
		return
	
	var label := Label.new()
	label.text = text
	label.top_level = true
	label.global_position = world_pos + Vector2(-16.0 + randf_range(-3.0, 3.0), -18.0)
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_size_override("font_size", 10 if is_big else 8)
	label.z_index = 60
	parent.add_child(label)
	
	var dur: float = float(GameData.get_stat("game_feel", "floating_text_duration", 0.7))
	var tween := label.create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "global_position:y", label.global_position.y - 12.0, dur).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "modulate:a", 0.0, dur).set_delay(dur * 0.35)
	tween.chain().tween_callback(label.queue_free)
