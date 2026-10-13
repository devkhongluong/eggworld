extends SceneTree

# ============================================================
# Màu sắc Palette GDD (16 màu cố định)
# ============================================================
const C_OUTLINE : Color = Color("#2B1F1A")  # Nâu Hầm
const C_SHELL   : Color = Color("#E8D9B0")  # Giấy Da
const C_LIGHT   : Color = Color("#F4EBD0")  # Kem
const C_SHADOW  : Color = Color("#D4A86A")  # Cát
const C_SPOT    : Color = Color("#A0693B")  # Nâu Da (đốm vỏ)
const C_TRANSP  : Color = Color(0, 0, 0, 0) # Trong suốt

const OUT_DIR   : String = "d:/game/vo-vo/assets/sprites/player/"
const PREV_DIR  : String = "C:/Users/behoa/.gemini/antigravity/brain/62492e13-e916-43f0-bd2c-66b632ffed5c/"
const W         : int = 32
const H         : int = 32

# ============================================================
# HELPERS
# ============================================================
func px(img: Image, x: int, y: int, c: Color) -> void:
	if x >= 0 and x < W and y >= 0 and y < H:
		img.set_pixel(x, y, c)

func new_frame() -> Image:
	var img := Image.create(W, H, true, Image.FORMAT_RGBA8)
	img.fill(C_TRANSP)
	return img

func draw_body_base(img: Image, cx: int, cy: int) -> void:
	# Vẽ thân trứng tại tâm (cx, cy) – elipse ~14x16
	for dy in range(-8, 9):
		for dx in range(-7, 8):
			var nx : float = float(dx) / 7.0
			var ny : float = float(dy) / 8.0
			if nx * nx + ny * ny <= 1.0:
				var c : Color = C_SHELL
				# Highlight bên trái trên
				if nx < -0.3 and ny < -0.2:
					c = C_LIGHT
				# Shadow bên phải dưới
				if nx > 0.35 and ny > 0.25:
					c = C_SHADOW
				px(img, cx + dx, cy + dy, c)

func draw_body_outline(img: Image, cx: int, cy: int) -> void:
	for dy in range(-9, 10):
		for dx in range(-8, 9):
			var nx : float = float(dx) / 7.5
			var ny : float = float(dy) / 8.5
			if nx * nx + ny * ny <= 1.0:
				var inside_nx : float = float(dx) / 6.5
				var inside_ny : float = float(dy) / 7.5
				if inside_nx * inside_nx + inside_ny * inside_ny > 1.0:
					px(img, cx + dx, cy + dy, C_OUTLINE)

func draw_eyes_down(img: Image, cx: int, cy: int) -> void:
	# Mắt nhìn xuống: hai chấm tròn
	px(img, cx - 2, cy - 2, C_OUTLINE)
	px(img, cx - 2, cy - 1, C_OUTLINE)
	px(img, cx + 1, cy - 2, C_OUTLINE)
	px(img, cx + 1, cy - 1, C_OUTLINE)
	# Gleam trắng nhỏ
	px(img, cx - 2, cy - 2, C_LIGHT)
	px(img, cx + 1, cy - 2, C_LIGHT)
	# Đồng tử dưới
	px(img, cx - 2, cy - 1, C_OUTLINE)
	px(img, cx + 1, cy - 1, C_OUTLINE)

func draw_spot(img: Image, cx: int, cy: int) -> void:
	px(img, cx - 3, cy - 5, C_SPOT)
	px(img, cx + 2, cy - 6, C_SPOT)
	px(img, cx - 1, cy + 2, C_SPOT)

# ============================================================
# VẼ TAY – stick limb dạng que rõ ràng
# ============================================================
func draw_arm_left(img: Image, cx: int, body_mid_y: int, swing: int) -> void:
	# Vai trái
	var sx : int = cx - 8
	var sy : int = body_mid_y - 1
	px(img, sx, sy, C_OUTLINE)
	# Cánh tay xuống + swing
	px(img, sx - 1, sy + 1 + swing, C_OUTLINE)
	px(img, sx - 1, sy + 2 + swing, C_OUTLINE)
	# Bàn tay (2x2)
	px(img, sx - 2, sy + 3 + swing, C_OUTLINE)
	px(img, sx - 1, sy + 3 + swing, C_OUTLINE)

func draw_arm_right(img: Image, cx: int, body_mid_y: int, swing: int) -> void:
	# Vai phải
	var sx : int = cx + 7
	var sy : int = body_mid_y - 1
	px(img, sx, sy, C_OUTLINE)
	# Cánh tay xuống + swing
	px(img, sx + 1, sy + 1 - swing, C_OUTLINE)
	px(img, sx + 1, sy + 2 - swing, C_OUTLINE)
	# Bàn tay (2x2)
	px(img, sx + 1, sy + 3 - swing, C_OUTLINE)
	px(img, sx + 2, sy + 3 - swing, C_OUTLINE)

# ============================================================
# VẼ CHÂN – stick limb
# ============================================================
func draw_legs_run(img: Image, cx: int, ground_y: int, phase: int) -> void:
	# phase 0-5: chân trái/phải đổi bước
	var left_lift  : int = [0, 2, 3, 0, -2, -1][phase]
	var right_lift : int = [0, -2, -1, 0, 2, 3][phase]

	# Chân trái
	var lx : int = cx - 3
	px(img, lx, ground_y - 5, C_OUTLINE)
	px(img, lx, ground_y - 4, C_OUTLINE)
	px(img, lx - 1, ground_y - 3 + left_lift, C_OUTLINE)
	px(img, lx - 1, ground_y - 2 + left_lift, C_OUTLINE)
	# Bàn chân trái
	px(img, lx - 2, ground_y - 1 + left_lift, C_OUTLINE)
	px(img, lx - 1, ground_y - 1 + left_lift, C_OUTLINE)

	# Chân phải
	var rx : int = cx + 2
	px(img, rx, ground_y - 5, C_OUTLINE)
	px(img, rx, ground_y - 4, C_OUTLINE)
	px(img, rx + 1, ground_y - 3 + right_lift, C_OUTLINE)
	px(img, rx + 1, ground_y - 2 + right_lift, C_OUTLINE)
	# Bàn chân phải
	px(img, rx + 1, ground_y - 1 + right_lift, C_OUTLINE)
	px(img, rx + 2, ground_y - 1 + right_lift, C_OUTLINE)

# ============================================================
# RUN DOWN – thân nhìn thẳng, chân đổi bước, tay vung ngược
# ============================================================
func make_run_down() -> Image:
	var strip := Image.create(W * 6, H, true, Image.FORMAT_RGBA8)
	strip.fill(C_TRANSP)

	var arm_swings : Array[int] = [0, 2, 1, 0, -2, -1]
	var body_bobs  : Array[int] = [0, -1, -1, 0, -1, -1]  # thân nảy lên nhẹ

	for f in range(6):
		var frame := new_frame()
		var cx : int = 16
		var cy : int = 14 + body_bobs[f]
		var gy : int = 30  # ground_y cố định

		draw_body_outline(frame, cx, cy)
		draw_body_base(frame, cx, cy)
		draw_spot(frame, cx, cy)
		draw_eyes_down(frame, cx, cy)
		draw_arm_left(frame, cx, cy, arm_swings[f])
		draw_arm_right(frame, cx, cy, arm_swings[f])
		draw_legs_run(frame, cx, gy, f)

		strip.blit_rect(frame, Rect2i(0, 0, W, H), Vector2i(f * W, 0))

	return strip

# ============================================================
# RUN UP – thân mặt sau, chân đổi bước
# ============================================================
func draw_body_back(img: Image, cx: int, cy: int) -> void:
	# Vỏ mặt sau – giống nhưng không có mắt, có đốm khác
	draw_body_base(img, cx, cy)
	# Đốm mặt sau
	px(img, cx - 2, cy - 5, C_SPOT)
	px(img, cx + 3, cy - 4, C_SPOT)
	px(img, cx,     cy + 1, C_SPOT)
	# Tóc/đỉnh nổi lên thêm một chút
	px(img, cx - 1, cy - 9, C_OUTLINE)
	px(img, cx,     cy - 9, C_OUTLINE)

func make_run_up() -> Image:
	var strip := Image.create(W * 6, H, true, Image.FORMAT_RGBA8)
	strip.fill(C_TRANSP)

	var arm_swings : Array[int] = [0, 2, 1, 0, -2, -1]
	var body_bobs  : Array[int] = [0, -1, -1, 0, -1, -1]

	for f in range(6):
		var frame := new_frame()
		var cx : int = 16
		var cy : int = 14 + body_bobs[f]
		var gy : int = 30

		draw_body_outline(frame, cx, cy)
		draw_body_back(frame, cx, cy)
		draw_arm_left(frame, cx, cy, arm_swings[f])
		draw_arm_right(frame, cx, cy, arm_swings[f])
		draw_legs_run(frame, cx, gy, f)

		strip.blit_rect(frame, Rect2i(0, 0, W, H), Vector2i(f * W, 0))

	return strip

# ============================================================
# RUN SIDE – nhìn nghiêng phải (flip_h cho trái)
# ============================================================
func draw_body_side(img: Image, cx: int, cy: int) -> void:
	for dy in range(-8, 9):
		for dx in range(-6, 7):
			var nx : float = float(dx) / 6.0
			var ny : float = float(dy) / 8.0
			if nx * nx + ny * ny <= 1.0:
				var c : Color = C_SHELL
				if nx < -0.4 and ny < -0.2:
					c = C_LIGHT
				if nx > 0.3 and ny > 0.3:
					c = C_SHADOW
				px(img, cx + dx, cy + dy, c)
	# Outline
	for dy in range(-9, 10):
		for dx in range(-7, 8):
			var nx : float = float(dx) / 6.5
			var ny : float = float(dy) / 8.5
			if nx * nx + ny * ny <= 1.0:
				var ins_nx : float = float(dx) / 5.5
				var ins_ny : float = float(dy) / 7.5
				if ins_nx * ins_nx + ins_ny * ins_ny > 1.0:
					px(img, cx + dx, cy + dy, C_OUTLINE)

func draw_eyes_side(img: Image, cx: int, cy: int, blink: bool) -> void:
	if blink:
		# Mắt nhắm (1 đường ngang)
		px(img, cx + 2, cy - 2, C_OUTLINE)
		px(img, cx + 3, cy - 2, C_OUTLINE)
	else:
		px(img, cx + 2, cy - 3, C_OUTLINE)
		px(img, cx + 2, cy - 2, C_OUTLINE)
		px(img, cx + 3, cy - 3, C_OUTLINE)
		px(img, cx + 3, cy - 2, C_OUTLINE)
		# Gleam
		px(img, cx + 2, cy - 3, C_LIGHT)

func draw_legs_side_run(img: Image, cx: int, gy: int, phase: int) -> void:
	# Nhìn nghiêng: chỉ thấy 2 chân rõ (trước/sau)
	var front_lift : int = [0, 3, 2, 0, -2, -1][phase]
	var back_lift  : int = [0, -2, -1, 0, 3, 2][phase]

	# Chân sau (mờ hơn – nhạt hơn)
	px(img, cx - 1, gy - 4, C_SHADOW)
	px(img, cx - 1, gy - 3, C_SHADOW)
	px(img, cx - 2, gy - 2 + back_lift, C_SHADOW)
	px(img, cx - 2, gy - 1 + back_lift, C_SHADOW)
	px(img, cx - 3, gy + back_lift, C_SHADOW)

	# Chân trước (đậm)
	px(img, cx + 1, gy - 4, C_OUTLINE)
	px(img, cx + 1, gy - 3, C_OUTLINE)
	px(img, cx + 2, gy - 2 + front_lift, C_OUTLINE)
	px(img, cx + 2, gy - 1 + front_lift, C_OUTLINE)
	px(img, cx + 2, gy + front_lift,     C_OUTLINE)
	px(img, cx + 3, gy + front_lift,     C_OUTLINE)

func draw_arms_side_run(img: Image, cx: int, cy: int, phase: int) -> void:
	# Tay phía sau (nhạt)
	var back_sw : int = [0, -2, -1, 0, 2, 1][phase]
	px(img, cx - 4, cy,     C_SHADOW)
	px(img, cx - 5, cy + 1 + back_sw, C_SHADOW)
	px(img, cx - 5, cy + 2 + back_sw, C_SHADOW)
	px(img, cx - 6, cy + 3 + back_sw, C_SHADOW)

	# Tay phía trước (đậm)
	var front_sw : int = [0, 2, 1, 0, -2, -1][phase]
	px(img, cx + 5, cy,     C_OUTLINE)
	px(img, cx + 5, cy + 1 + front_sw, C_OUTLINE)
	px(img, cx + 5, cy + 2 + front_sw, C_OUTLINE)
	px(img, cx + 6, cy + 3 + front_sw, C_OUTLINE)

func make_run_side() -> Image:
	var strip := Image.create(W * 6, H, true, Image.FORMAT_RGBA8)
	strip.fill(C_TRANSP)

	var body_bobs  : Array[int] = [0, -1, -1, 0, -1, -1]
	var blink_frames : Array[bool] = [false, false, false, false, false, false]

	for f in range(6):
		var frame := new_frame()
		var cx : int = 15
		var cy : int = 14 + body_bobs[f]
		var gy : int = 30

		draw_body_side(frame, cx, cy)
		# Đốm vỏ bên cạnh
		px(frame, cx - 3, cy - 4, C_SPOT)
		px(frame, cx + 1, cy - 6, C_SPOT)
		px(frame, cx - 1, cy + 2, C_SPOT)
		draw_eyes_side(frame, cx, cy, blink_frames[f])
		draw_arms_side_run(frame, cx, cy, f)
		draw_legs_side_run(frame, cx, gy, f)

		strip.blit_rect(frame, Rect2i(0, 0, W, H), Vector2i(f * W, 0))

	return strip

# ============================================================
# ROLL – trứng cuộn tròn (xoay hình oval, tay chân thu lại)
# ============================================================
func make_roll_down() -> Image:
	# 6 khung: trứng nghiêng, xoay tròn, thu tứ chi
	var strip := Image.create(W * 6, H, true, Image.FORMAT_RGBA8)
	strip.fill(C_TRANSP)

	# Góc nghiêng mỗi khung (độ) – xoay: 0→30→60→90→120→150
	var tilts : Array[int] = [0, 30, 60, 90, 120, 150]

	for f in range(6):
		var frame := new_frame()
		var cx : int = 16
		var cy : int = 16
		var tilt_deg : float = float(tilts[f])
		var tilt_rad : float = deg_to_rad(tilt_deg)

		# Vẽ thân hình oval xoay
		for dy in range(-9, 10):
			for dx in range(-9, 10):
				# Biến đổi tọa độ theo góc xoay
				var rx : float = float(dx) * cos(tilt_rad) + float(dy) * sin(tilt_rad)
				var ry : float = -float(dx) * sin(tilt_rad) + float(dy) * cos(tilt_rad)
				var nx : float = rx / 7.0
				var ny : float = ry / 9.0
				# Outline
				var onx : float = rx / 7.5
				var ony : float = ry / 9.5
				if onx * onx + ony * ony <= 1.0 and nx * nx + ny * ny > 1.0:
					px(frame, cx + dx, cy + dy, C_OUTLINE)
				elif nx * nx + ny * ny <= 1.0:
					# Gradient màu theo góc
					var c : Color = C_SHELL
					# Vùng sáng phần nhỏ của oval
					if rx < -2.0 and ry < -2.0:
						c = C_LIGHT
					# Vùng bóng
					if rx > 2.0 and ry > 2.0:
						c = C_SHADOW
					px(frame, cx + dx, cy + dy, c)

		# Đốm vỏ quay theo oval (cố định tương đối)
		var sp1x : int = int(cx + (-3) * cos(tilt_rad) + (-5) * sin(tilt_rad))
		var sp1y : int = int(cy - (-3) * sin(tilt_rad) + (-5) * cos(tilt_rad))
		var sp2x : int = int(cx + 3 * cos(tilt_rad) + (-4) * sin(tilt_rad))
		var sp2y : int = int(cy - 3 * sin(tilt_rad) + (-4) * cos(tilt_rad))
		px(frame, sp1x, sp1y, C_SPOT)
		px(frame, sp2x, sp2y, C_SPOT)

		# Tay chân thu vào – chỉ 2-3 px ló ra quanh rìa
		# Khung 0-1: vẫn còn tay chân; 2-5: thu hoàn toàn
		if f <= 1:
			# Chân nhỏ ở đáy
			px(frame, cx - 2, cy + 8, C_OUTLINE)
			px(frame, cx + 1, cy + 8, C_OUTLINE)
			# Tay nhỏ hai bên
			px(frame, cx - 9, cy - 1, C_OUTLINE)
			px(frame, cx + 8, cy - 1, C_OUTLINE)

		strip.blit_rect(frame, Rect2i(0, 0, W, H), Vector2i(f * W, 0))

	return strip

func make_roll_up() -> Image:
	# Giống roll_down nhưng theo hướng ngược (dùng bản sao roll_down ở giai đoạn này)
	return make_roll_down()

func make_roll_side() -> Image:
	var strip := Image.create(W * 6, H, true, Image.FORMAT_RGBA8)
	strip.fill(C_TRANSP)

	# Roll ngang: oval nghiêng sang phải → thẳng → nghiêng sang trái → ...
	var tilts : Array[int] = [0, 30, 60, 90, 120, 150]

	for f in range(6):
		var frame := new_frame()
		var cx : int = 16
		var cy : int = 15
		var tilt_rad : float = deg_to_rad(float(tilts[f]))

		for dy in range(-9, 10):
			for dx in range(-9, 10):
				var rx : float = float(dx) * cos(tilt_rad) + float(dy) * sin(tilt_rad)
				var ry : float = -float(dx) * sin(tilt_rad) + float(dy) * cos(tilt_rad)
				var nx : float = rx / 6.5
				var ny : float = ry / 9.0
				var onx : float = rx / 7.0
				var ony : float = ry / 9.5
				if onx * onx + ony * ony <= 1.0 and nx * nx + ny * ny > 1.0:
					px(frame, cx + dx, cy + dy, C_OUTLINE)
				elif nx * nx + ny * ny <= 1.0:
					var c : Color = C_SHELL
					if rx < -2.0 and ry < -2.0:
						c = C_LIGHT
					if rx > 2.0 and ry > 2.0:
						c = C_SHADOW
					px(frame, cx + dx, cy + dy, c)

		px(frame, int(cx + (-2) * cos(tilt_rad) + (-5) * sin(tilt_rad)),
		          int(cy - (-2) * sin(tilt_rad) + (-5) * cos(tilt_rad)), C_SPOT)
		px(frame, int(cx + 3 * cos(tilt_rad) + (-3) * sin(tilt_rad)),
		          int(cy - 3 * sin(tilt_rad) + (-3) * cos(tilt_rad)), C_SPOT)

		if f <= 1:
			px(frame, cx - 8, cy, C_OUTLINE)
			px(frame, cx + 7, cy, C_OUTLINE)
			px(frame, cx,     cy + 8, C_OUTLINE)
			px(frame, cx + 1, cy + 8, C_OUTLINE)

		strip.blit_rect(frame, Rect2i(0, 0, W, H), Vector2i(f * W, 0))

	return strip

# ============================================================
# PREVIEW helper: phóng to x5 và ghép hàng ngang
# ============================================================
func make_preview(strip: Image, label_y: int) -> Image:
	var frames_w : int = strip.get_width() / W
	var prev := Image.create(frames_w * W * 5, H * 5, false, Image.FORMAT_RGBA8)
	prev.fill(Color("#1A1A2E"))  # Nền tối
	for f in range(frames_w):
		for py in range(H):
			for ppx in range(W):
				var c := strip.get_pixel(f * W + ppx, py)
				for sy in range(5):
					for sx in range(5):
						prev.set_pixel(f * W * 5 + ppx * 5 + sx, py * 5 + sy, c)
	return prev

func save_png(img: Image, path: String) -> void:
	var err := img.save_png(path)
	if err == OK:
		print("[OK] Đã lưu: " + path)
	else:
		print("[ERR] Lỗi lưu: " + path + " code=" + str(err))

# ============================================================
# MAIN
# ============================================================
func _init() -> void:
	print("=== Bắt đầu tạo sprite Run & Roll ===")

	# --- RUN ---
	var run_down := make_run_down()
	var run_up   := make_run_up()
	var run_side := make_run_side()
	save_png(run_down, OUT_DIR + "player_egg_run_down.png")
	save_png(run_up,   OUT_DIR + "player_egg_run_up.png")
	save_png(run_side, OUT_DIR + "player_egg_run_side.png")

	# --- ROLL ---
	var roll_down := make_roll_down()
	var roll_up   := make_roll_up()
	var roll_side := make_roll_side()
	save_png(roll_down, OUT_DIR + "player_egg_roll_down.png")
	save_png(roll_up,   OUT_DIR + "player_egg_roll_up.png")
	save_png(roll_side, OUT_DIR + "player_egg_roll_side.png")

	# --- PREVIEW ---
	var prev_run_down := make_preview(run_down, 0)
	var prev_run_up   := make_preview(run_up,   0)
	var prev_run_side := make_preview(run_side, 0)
	var prev_roll_down := make_preview(roll_down, 0)
	var prev_roll_side := make_preview(roll_side, 0)

	save_png(prev_run_down,  PREV_DIR + "preview_run_down.png")
	save_png(prev_run_up,    PREV_DIR + "preview_run_up.png")
	save_png(prev_run_side,  PREV_DIR + "preview_run_side.png")
	save_png(prev_roll_down, PREV_DIR + "preview_roll_down.png")
	save_png(prev_roll_side, PREV_DIR + "preview_roll_side.png")

	print("=== Hoàn tất ===")
	quit(0)
