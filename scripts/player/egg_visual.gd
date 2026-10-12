extends Node2D

# Vẽ hình khối tạm của Trứng theo GDD Mục 2, Mục 3 & Mục 4.1:
# - Điểm neo chân tại y = 0 (tọa độ chân chạm đất)
# - Thân cao ~20 px, rộng ~16 px (từ y = -20 đến y = 0)
# - Viền Nâu Hầm (NAU_HAM)
# - Vỏ chính Giấy Da (GIAY_DA)
# - Vùng sáng Kem (KEM) ở trên-trái
# - Vùng tối Cát (CAT) ở dưới-phải
# - Hai mắt chấm Nâu Hầm (NAU_HAM) ở khoảng 40% tính từ đỉnh (y = -12)
# - Hiệu ứng vệt chém cận chiến tạm thời theo hướng đánh

var attack_slash_timer: float = 0.0
var attack_slash_dir: Vector2 = Vector2.DOWN
var attack_slash_step: int = 0

func start_attack_visual(dir: Vector2, step: int) -> void:
	attack_slash_dir = dir
	attack_slash_step = step
	attack_slash_timer = 0.18
	queue_redraw()

func _process(delta: float) -> void:
	if attack_slash_timer > 0.0:
		attack_slash_timer -= delta
		if attack_slash_timer <= 0.0:
			queue_redraw()

func _draw() -> void:
	# 1. Chân tạm (sát đất y = 0)
	draw_rect(Rect2(-5, -2, 2, 2), Palette.NAU_HAM)
	draw_rect(Rect2(3, -2, 2, 2), Palette.NAU_HAM)
	draw_rect(Rect2(-5, -2, 2, 1), Palette.GIAY_DA)
	draw_rect(Rect2(3, -2, 2, 1), Palette.GIAY_DA)
	
	# 2. Viền ngoài quả trứng (Nâu Hầm) từ y = -21 đến y = -1
	var outline_points: PackedVector2Array = PackedVector2Array([
		Vector2(-5, -21), Vector2(5, -21),
		Vector2(9, -16), Vector2(10, -10), Vector2(9, -4),
		Vector2(6, 0), Vector2(-6, 0),
		Vector2(-9, -4), Vector2(-10, -10), Vector2(-9, -16)
	])
	draw_colored_polygon(outline_points, Palette.NAU_HAM)
	
	# 3. Lõi thân vỏ trứng (Giấy Da) từ y = -20 đến y = -1
	var body_points: PackedVector2Array = PackedVector2Array([
		Vector2(-4, -20), Vector2(4, -20),
		Vector2(8, -15), Vector2(9, -10), Vector2(8, -5),
		Vector2(5, -1), Vector2(-5, -1),
		Vector2(-8, -5), Vector2(-9, -10), Vector2(-8, -15)
	])
	draw_colored_polygon(body_points, Palette.GIAY_DA)
	
	# 4. Vùng tối dưới-phải (Cát)
	var shadow_points: PackedVector2Array = PackedVector2Array([
		Vector2(3, -6), Vector2(8, -10), Vector2(8, -5),
		Vector2(5, -1), Vector2(0, -1)
	])
	draw_colored_polygon(shadow_points, Palette.CAT)
	
	# 5. Vùng sáng trên-trái (Kem)
	var highlight_points: PackedVector2Array = PackedVector2Array([
		Vector2(-3, -19), Vector2(1, -19),
		Vector2(3, -17), Vector2(-2, -15),
		Vector2(-6, -15), Vector2(-6, -17)
	])
	draw_colored_polygon(highlight_points, Palette.KEM)
	
	# 6. Hai chấm mắt Nâu Hầm (1x2 px, cách nhau 5 px)
	draw_rect(Rect2(-4, -13, 2, 2), Palette.NAU_HAM)
	draw_rect(Rect2(2, -13, 2, 2), Palette.NAU_HAM)
	
	# 7. Vệt chém combo đòn đánh tạm thời
	if attack_slash_timer > 0.0:
		var slash_center := Vector2(0, -10) + attack_slash_dir.normalized() * 14.0
		var slash_color: Color = Palette.KEM if attack_slash_step == 2 else Palette.XAM_DA
		var arc_radius: float = 12.0 if attack_slash_step == 2 else 9.0
		var base_angle: float = attack_slash_dir.angle()
		var start_ang: float = base_angle - PI * 0.45
		var end_ang: float = base_angle + PI * 0.45
		draw_arc(slash_center, arc_radius, start_ang, end_ang, 12, slash_color, 2.0)
		draw_arc(slash_center, arc_radius - 2.0, start_ang, end_ang, 12, Palette.NAU_HAM, 1.0)
