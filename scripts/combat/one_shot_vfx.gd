extends Node2D
class_name OneShotVfx

# OneShotVfx: Diễn hoạt hiệu ứng 1 lần từ Sprite Sheet và tự giải phóng khi xong
# Đảm bảo quy tắc pixel art GDD:
# - Kích thước gốc 1:1, không scale lẻ, không xoay góc lẻ, không làm mờ
# - Tọa độ làm tròn số nguyên pixel
# - Hỗ trợ lật flip_h cùng hướng nhân vật
# - Hỗ trợ vòng bụi code 1x1 pixel chuẩn Palette

var texture: Texture2D = null
var frame_width: int = 32
var frame_height: int = 32
var total_frames: int = 1
var fps: float = 12.0
var anchor: Vector2 = Vector2.ZERO
var flip_h: bool = false
var custom_data: Dictionary = {}

var _elapsed_time: float = 0.0
var _current_frame: int = 0
var _ring_particles: Array[Dictionary] = []

func setup(
	p_tex: Texture2D,
	p_fw: int,
	p_fh: int,
	p_frames: int,
	p_fps: float,
	p_anchor: Vector2,
	p_flip_h: bool = false,
	p_custom_data: Dictionary = {}
) -> void:
	texture = p_tex
	frame_width = p_fw
	frame_height = p_fh
	total_frames = maxi(1, p_frames)
	fps = maxf(1.0, p_fps)
	anchor = p_anchor
	flip_h = p_flip_h
	custom_data = p_custom_data
	_elapsed_time = 0.0
	_current_frame = 0
	
	if custom_data.has("code_dust_ring"):
		var ring_cfg: Dictionary = custom_data["code_dust_ring"]
		var count: int = int(ring_cfg.get("particle_count", 16))
		var max_r: float = float(ring_cfg.get("target_radius", 24.0))
		var dur: float = float(ring_cfg.get("duration", 0.33))
		var colors := [Palette.CAT, Palette.GIAY_DA, Palette.XAM_SAT]
		_ring_particles.clear()
		for i in range(count):
			var angle: float = (TAU / float(count)) * float(i) + randf_range(-0.15, 0.15)
			_ring_particles.append({
				"angle": angle,
				"max_radius": max_r,
				"color": colors[i % colors.size()],
				"duration": dur
			})

func _process(delta: float) -> void:
	_elapsed_time += delta
	var frame_idx: int = int(_elapsed_time * fps)
	if frame_idx >= total_frames:
		queue_free()
		return
	if frame_idx != _current_frame:
		_current_frame = frame_idx
		queue_redraw()
	elif not _ring_particles.is_empty():
		queue_redraw()

func _draw() -> void:
	if texture != null and _current_frame < total_frames:
		var src_rect := Rect2(_current_frame * frame_width, 0, frame_width, frame_height)
		var dst_pos := Vector2(round(-anchor.x), round(-anchor.y))
		
		if flip_h:
			draw_set_transform(Vector2.ZERO, 0.0, Vector2(-1.0, 1.0))
			draw_texture_rect_region(texture, Rect2(dst_pos.x, dst_pos.y, frame_width, frame_height), src_rect)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		else:
			draw_texture_rect_region(texture, Rect2(dst_pos.x, dst_pos.y, frame_width, frame_height), src_rect)
	
	# Vẽ vòng bụi phụ bằng code (các điểm 1x1 Palette) nếu có cấu hình
	if not _ring_particles.is_empty():
		for p in _ring_particles:
			var dur: float = float(p.get("duration", 0.33))
			var prog: float = clampf(_elapsed_time / maxf(0.01, dur), 0.0, 1.0)
			var cur_r: float = lerpf(8.0, float(p["max_radius"]), prog)
			var angle: float = float(p["angle"])
			var px: float = round(cos(angle) * cur_r)
			var py: float = round(sin(angle) * cur_r * 0.75) # Phối cảnh hơi dẹt mặt đất
			draw_rect(Rect2(px, py, 1, 1), p["color"])
