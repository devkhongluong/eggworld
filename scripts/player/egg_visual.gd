extends Node2D

# Vẽ hình khối tạm của Trứng theo GDD Mục 2, Mục 3 & Mục 4.1:
# - Thân cao ~20 px, rộng ~16 px
# - Viền Nâu Hầm (NAU_HAM)
# - Vỏ chính Giấy Da (GIAY_DA)
# - Vùng sáng Kem (KEM) ở trên-trái
# - Vùng tối Cát (CAT) ở dưới-phải
# - Hai mắt chấm Nâu Hầm (NAU_HAM)
# - Chân tay mảnh

func _draw() -> void:
	# 1. Chân tạm (mảnh khảnh)
	draw_rect(Rect2(-5, 8, 2, 4), Palette.NAU_HAM)
	draw_rect(Rect2(3, 8, 2, 4), Palette.NAU_HAM)
	draw_rect(Rect2(-5, 8, 2, 3), Palette.GIAY_DA)
	draw_rect(Rect2(3, 8, 2, 3), Palette.GIAY_DA)
	
	# 2. Viền ngoài quả trứng (Nâu Hầm)
	var outline_points: PackedVector2Array = PackedVector2Array([
		Vector2(-5, -11), Vector2(5, -11),
		Vector2(9, -6), Vector2(10, 0), Vector2(9, 6),
		Vector2(6, 10), Vector2(-6, 10),
		Vector2(-9, 6), Vector2(-10, 0), Vector2(-9, -6)
	])
	draw_colored_polygon(outline_points, Palette.NAU_HAM)
	
	# 3. Lõi thân vỏ trứng (Giấy Da)
	var body_points: PackedVector2Array = PackedVector2Array([
		Vector2(-4, -10), Vector2(4, -10),
		Vector2(8, -5), Vector2(9, 0), Vector2(8, 5),
		Vector2(5, 9), Vector2(-5, 9),
		Vector2(-8, 5), Vector2(-9, 0), Vector2(-8, -5)
	])
	draw_colored_polygon(body_points, Palette.GIAY_DA)
	
	# 4. Vùng tối dưới-phải (Cát)
	var shadow_points: PackedVector2Array = PackedVector2Array([
		Vector2(3, 4), Vector2(8, 0), Vector2(8, 5),
		Vector2(5, 9), Vector2(0, 9)
	])
	draw_colored_polygon(shadow_points, Palette.CAT)
	
	# 5. Vùng sáng trên-trái (Kem)
	var highlight_points: PackedVector2Array = PackedVector2Array([
		Vector2(-3, -9), Vector2(1, -9),
		Vector2(3, -7), Vector2(-2, -5),
		Vector2(-6, -5), Vector2(-6, -7)
	])
	draw_colored_polygon(highlight_points, Palette.KEM)
	
	# 6. Hai chấm mắt Nâu Hầm (1-2 px)
	draw_rect(Rect2(-4, -2, 2, 2), Palette.NAU_HAM)
	draw_rect(Rect2(2, -2, 2, 2), Palette.NAU_HAM)
