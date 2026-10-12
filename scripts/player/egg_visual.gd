extends Node2D

# Vẽ hình khối tạm của Trứng theo GDD Mục 2, Mục 3 & Mục 4.1:
# - Điểm neo chân tại y = 0 (tọa độ chân chạm đất)
# - Thân cao ~20 px, rộng ~16 px (từ y = -20 đến y = 0)
# - Viền Nâu Hầm (NAU_HAM)
# - Vỏ chính Giấy Da (GIAY_DA)
# - Vùng sáng Kem (KEM) ở trên-trái
# - Vùng tối Cát (CAT) ở dưới-phải
# - Hai mắt chấm Nâu Hầm (NAU_HAM) ở khoảng 40% tính từ đỉnh (y = -12)

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
	
	# 6. Hai chấm mắt Nâu Hầm (1x2 px, cách nhau 5 px, ở khoảng 40% chiều cao thân)
	draw_rect(Rect2(-4, -13, 2, 2), Palette.NAU_HAM)
	draw_rect(Rect2(2, -13, 2, 2), Palette.NAU_HAM)
