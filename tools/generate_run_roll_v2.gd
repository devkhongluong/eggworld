extends SceneTree

# ============================================================
# Palette GDD – 16 màu cố định
# ============================================================
const C_OUT  : Color = Color("#2B1F1A")  # Nâu Hầm (viền)
const C_BODY : Color = Color("#E8D9B0")  # Giấy Da
const C_LIT  : Color = Color("#F4EBD0")  # Kem (highlight)
const C_SHD  : Color = Color("#D4A86A")  # Cát (shadow)
const C_SPOT : Color = Color("#A0693B")  # Nâu Da (đốm)
const C_MOUT : Color = Color("#6E1423")  # Đỏ Rượu (khoang miệng)
const C_TONG : Color = Color("#A8342B")  # Đỏ Gạch (lưỡi)
const C_EYE  : Color = Color("#F4EBD0")  # Kem (lòng trắng mắt)
const C_TR   : Color = Color(0,0,0,0)   # Trong suốt

const SPRITES_DIR : String = "d:/game/vo-vo/assets/sprites/player/"
const PREV_DIR    : String = "C:/Users/behoa/.gemini/antigravity/brain/62492e13-e916-43f0-bd2c-66b632ffed5c/"
const W : int = 32
const H : int = 32

# ============================================================
# HELPER: đặt pixel an toàn
# ============================================================
func px(img: Image, x: int, y: int, c: Color) -> void:
	if x >= 0 and x < img.get_width() and y >= 0 and y < H:
		img.set_pixel(x, y, c)

func new_img(frames: int) -> Image:
	var img := Image.create(W * frames, H, true, Image.FORMAT_RGBA8)
	img.fill(C_TR)
	return img

# ============================================================
# BODY: thân trứng to, tròn, chiếm gần hết 32x32
# Tâm tại (cx, cy), bán kính ngang rw, dọc rh
# ============================================================
func draw_body(img: Image, cx: int, cy: int, rw: float, rh: float) -> void:
	var ox : int = 0
	var x_start : int = cx
	# Outline trước
	for dy in range(-int(rh)-2, int(rh)+3):
		for dx in range(-int(rw)-2, int(rw)+3):
			var nx : float = float(dx)/( rw + 1.0)
			var ny : float = float(dy)/(rh + 1.0)
			var ins_nx : float = float(dx)/rw
			var ins_ny : float = float(dy)/rh
			if nx*nx + ny*ny <= 1.0 and ins_nx*ins_nx + ins_ny*ins_ny > 1.0:
				px(img, cx+dx, cy+dy, C_OUT)
	# Fill bên trong
	for dy in range(-int(rh)-1, int(rh)+2):
		for dx in range(-int(rw)-1, int(rw)+2):
			var nx : float = float(dx)/rw
			var ny : float = float(dy)/rh
			if nx*nx + ny*ny <= 1.0:
				var c : Color = C_BODY
				# Highlight trái-trên
				if nx < -0.25 and ny < -0.1:
					c = C_LIT
				# Shadow phải-dưới
				if nx > 0.30 and ny > 0.20:
					c = C_SHD
				px(img, cx+dx, cy+dy, c)

func draw_spots(img: Image, cx: int, cy: int) -> void:
	# Đốm vỏ: 3-4 đốm nhỏ phân bố tự nhiên
	px(img, cx-4, cy-5, C_SPOT)
	px(img, cx+3, cy-6, C_SPOT)
	px(img, cx-2, cy+3, C_SPOT)
	px(img, cx+5, cy+1, C_SPOT)

func draw_spots_back(img: Image, cx: int, cy: int) -> void:
	# Đốm mặt sau – vị trí khác
	px(img, cx-5, cy-3, C_SPOT)
	px(img, cx+2, cy-5, C_SPOT)
	px(img, cx-1, cy+4, C_SPOT)
	px(img, cx+4, cy-1, C_SPOT)

# ============================================================
# MẮT – hướng xuống (nhìn thẳng)
# Hai ô vuông 2x2 với lòng trắng và đồng tử
# ============================================================
func draw_eyes_front(img: Image, cx: int, cy: int, squish: int) -> void:
	# Lòng trắng trái
	px(img, cx-4, cy-2+squish, C_EYE)
	px(img, cx-3, cy-2+squish, C_EYE)
	px(img, cx-4, cy-1+squish, C_EYE)
	px(img, cx-3, cy-1+squish, C_EYE)
	# Đồng tử trái
	px(img, cx-3, cy-1+squish, C_OUT)
	# Lòng trắng phải
	px(img, cx+2, cy-2+squish, C_EYE)
	px(img, cx+3, cy-2+squish, C_EYE)
	px(img, cx+2, cy-1+squish, C_EYE)
	px(img, cx+3, cy-1+squish, C_EYE)
	# Đồng tử phải
	px(img, cx+3, cy-1+squish, C_OUT)

func draw_mouth_front(img: Image, cx: int, cy: int, open_w: int) -> void:
	# Khoang miệng to, hình chữ U rộng
	for dx in range(-open_w, open_w+1):
		px(img, cx+dx, cy+2, C_MOUT)
		px(img, cx+dx, cy+3, C_MOUT)
	px(img, cx-open_w-1, cy+3, C_MOUT)
	px(img, cx+open_w+1, cy+3, C_MOUT)
	# Lưỡi
	px(img, cx-1, cy+4, C_TONG)
	px(img, cx,   cy+4, C_TONG)
	px(img, cx+1, cy+4, C_TONG)

# ============================================================
# MẮT – hướng ngang (nhìn nghiêng phải)
# ============================================================
func draw_eye_side(img: Image, cx: int, cy: int, squish: int) -> void:
	# Chỉ thấy 1 mắt
	px(img, cx+3, cy-2+squish, C_EYE)
	px(img, cx+4, cy-2+squish, C_EYE)
	px(img, cx+3, cy-1+squish, C_EYE)
	px(img, cx+4, cy-1+squish, C_EYE)
	# Đồng tử
	px(img, cx+4, cy-1+squish, C_OUT)

func draw_mouth_side(img: Image, cx: int, cy: int) -> void:
	# Miệng mở hướng phải – nhìn thấy cạnh
	px(img, cx+5, cy+1, C_MOUT)
	px(img, cx+6, cy+1, C_MOUT)
	px(img, cx+5, cy+2, C_MOUT)
	px(img, cx+6, cy+2, C_MOUT)
	px(img, cx+6, cy+3, C_MOUT)
	# Lưỡi nhỏ
	px(img, cx+6, cy+2, C_TONG)
	px(img, cx+7, cy+2, C_TONG)

# ============================================================
# CHÂN – ngắn, to, rõ bước như trong tham khảo
# ============================================================
func draw_feet_run(img: Image, cx: int, base_y: int, phase: int) -> void:
	# 6 pha: chân trái/phải đổi bước
	# lift > 0 = chân nhấc lên (giảm y)
	var lift_table : Array = [
		[0, 0],   # pha 0: cả hai chân đất
		[2, -1],  # pha 1: trái nhấc, phải sau
		[3, -2],  # pha 2: trái cao nhất
		[0, 0],   # pha 3: đổi chân
		[-1, 2],  # pha 4: phải nhấc
		[-2, 3],  # pha 5: phải cao nhất
	]
	var lifts : Array = lift_table[phase]

	# Chân trái (2px rộng)
	var lx : int = cx - 4
	var ly : int = base_y - int(lifts[0])
	px(img, lx,   ly-3, C_OUT)
	px(img, lx+1, ly-3, C_OUT)
	px(img, lx,   ly-2, C_OUT)
	px(img, lx+1, ly-2, C_OUT)
	# Bàn chân trái (3px ngang)
	px(img, lx-1, ly-1, C_OUT)
	px(img, lx,   ly-1, C_OUT)
	px(img, lx+1, ly-1, C_OUT)

	# Chân phải (2px rộng)
	var rx : int = cx + 3
	var ry : int = base_y - int(lifts[1])
	px(img, rx,   ry-3, C_OUT)
	px(img, rx+1, ry-3, C_OUT)
	px(img, rx,   ry-2, C_OUT)
	px(img, rx+1, ry-2, C_OUT)
	# Bàn chân phải
	px(img, rx,   ry-1, C_OUT)
	px(img, rx+1, ry-1, C_OUT)
	px(img, rx+2, ry-1, C_OUT)

# Chân cho hướng nghiêng – nhìn từ bên
func draw_feet_side_run(img: Image, cx: int, base_y: int, phase: int) -> void:
	var phases_front : Array[int] = [0, 2, 3, 0, -2, -1]
	var phases_back  : Array[int] = [0, -2, -1, 0, 2, 3]
	var fl := phases_front[phase]
	var bl := phases_back[phase]

	# Chân sau (hơi nhạt)
	var bx := cx - 2
	var by := base_y - bl
	px(img, bx,   by-3, C_SHD)
	px(img, bx+1, by-3, C_SHD)
	px(img, bx,   by-2, C_SHD)
	px(img, bx-1, by-1, C_SHD)
	px(img, bx,   by-1, C_SHD)

	# Chân trước (đậm)
	var fx := cx + 2
	var fy := base_y - fl
	px(img, fx,   fy-3, C_OUT)
	px(img, fx+1, fy-3, C_OUT)
	px(img, fx,   fy-2, C_OUT)
	px(img, fx+1, fy-2, C_OUT)
	px(img, fx+1, fy-1, C_OUT)
	px(img, fx+2, fy-1, C_OUT)

# ============================================================
# TAY – nhỏ, sát thân, vung nhẹ khi chạy
# ============================================================
func draw_arms_front(img: Image, cx: int, cy: int, swing: int) -> void:
	# Tay trái
	px(img, cx-7, cy+swing,   C_OUT)
	px(img, cx-8, cy+swing,   C_OUT)
	px(img, cx-8, cy+1+swing, C_OUT)
	# Tay phải
	px(img, cx+6, cy-swing,   C_OUT)
	px(img, cx+7, cy-swing,   C_OUT)
	px(img, cx+7, cy+1-swing, C_OUT)

func draw_arms_side(img: Image, cx: int, cy: int, swing: int) -> void:
	# Chỉ thấy 1 tay rõ (trước) và gợi tay sau
	# Tay sau (nhạt)
	px(img, cx-5, cy+swing,   C_SHD)
	px(img, cx-6, cy+swing,   C_SHD)
	# Tay trước (đậm)
	px(img, cx+5, cy-swing,   C_OUT)
	px(img, cx+6, cy-swing,   C_OUT)
	px(img, cx+6, cy+1-swing, C_OUT)

# ============================================================
# RUN DOWN – mặt trước nhìn thẳng
# ============================================================
func make_run_down() -> Image:
	var img := new_img(6)
	# Thân nảy nhẹ lên khi chạy
	var bobs    : Array[int] = [0, -1, 0, 0, -1, 0]
	var squish  : Array[int] = [0,  0, 0, 0,  0, 0]
	var swings  : Array[int] = [0,  1, 0, 0, -1, 0]

	for f in range(6):
		var cx := 16
		var cy := 14 + bobs[f]
		var base_y := 30

		draw_body(img, cx + f*W, cy, 9.0, 10.0)
		draw_spots(img, cx + f*W, cy)
		draw_eyes_front(img, cx + f*W, cy, squish[f])
		draw_mouth_front(img, cx + f*W, cy, 2)
		draw_arms_front(img, cx + f*W, cy, swings[f])
		draw_feet_run(img, cx + f*W, base_y, f)

	return img

# ============================================================
# RUN UP – mặt sau
# ============================================================
func make_run_up() -> Image:
	var img := new_img(6)
	var bobs : Array[int] = [0, -1, 0, 0, -1, 0]
	var swings : Array[int] = [0, 1, 0, 0, -1, 0]

	for f in range(6):
		var cx := 16
		var cy := 14 + bobs[f]
		var base_y := 30

		draw_body(img, cx + f*W, cy, 9.0, 10.0)
		draw_spots_back(img, cx + f*W, cy)
		# Không vẽ mắt/miệng (mặt sau)
		# Nhưng vẫn vẽ tay/chân
		draw_arms_front(img, cx + f*W, cy, swings[f])
		draw_feet_run(img, cx + f*W, base_y, f)

	return img

# ============================================================
# RUN SIDE – nhìn nghiêng phải
# ============================================================
func make_run_side() -> Image:
	var img := new_img(6)
	var bobs   : Array[int] = [0, -1, 0, 0, -1, 0]
	var squish : Array[int] = [0,  0, 0, 0,  0, 0]
	var swings : Array[int] = [0,  1, 0, 0, -1, 0]

	for f in range(6):
		# Thân hơi dẹt ngang khi nhìn nghiêng
		var cx := 15
		var cy := 14 + bobs[f]
		var base_y := 30

		draw_body(img, cx + f*W, cy, 8.0, 10.0)
		# Đốm bên hông
		px(img, cx + f*W - 4, cy - 3, C_SPOT)
		px(img, cx + f*W + 2, cy - 5, C_SPOT)
		px(img, cx + f*W - 1, cy + 3, C_SPOT)

		draw_eye_side(img, cx + f*W, cy, squish[f])
		draw_mouth_side(img, cx + f*W, cy)
		draw_arms_side(img, cx + f*W, cy, swings[f])
		draw_feet_side_run(img, cx + f*W, base_y, f)

	return img

# ============================================================
# ROLL – thu dần vào, xoay tròn
# Hàng 4 tham khảo: còn thấy mắt, thu tay chân vào
# Hàng 5: oval tròn hoàn toàn
# Hàng 6: bắt đầu mở ra (nhỏ hơn)
# → Tôi mô phỏng: 6 khung liên tục
#   0-1: còn mặt, thu tay chân
#   2-3: oval hoàn toàn, xoay
#   4-5: bắt đầu mở ra lại
# ============================================================
func draw_roll_body(img: Image, ox: int, cx: int, cy: int, 
					rw: float, rh: float, angle: float) -> void:
	# Vẽ oval xoay góc angle (radian)
	var ca := cos(angle)
	var sa := sin(angle)
	# Outline
	for dy in range(-13, 14):
		for dx in range(-13, 14):
			var rx : float = float(dx)*ca + float(dy)*sa
			var ry : float = -float(dx)*sa + float(dy)*ca
			var nx : float = rx/(rw+1.0)
			var ny : float = ry/(rh+1.0)
			var inx : float = rx/rw
			var iny : float = ry/rh
			if nx*nx+ny*ny <= 1.0 and inx*inx+iny*iny > 1.0:
				px(img, ox+cx+dx, cy+dy, C_OUT)
	# Fill
	for dy in range(-12, 13):
		for dx in range(-12, 13):
			var rx : float = float(dx)*ca + float(dy)*sa
			var ry : float = -float(dx)*sa + float(dy)*ca
			var nx : float = rx/rw
			var ny : float = ry/rh
			if nx*nx+ny*ny <= 1.0:
				var c : Color = C_BODY
				if rx < -1.5 and ry < -1.5:
					c = C_LIT
				if rx > 1.5 and ry > 1.5:
					c = C_SHD
				px(img, ox+cx+dx, cy+dy, c)

func make_roll_all() -> Array:
	# Trả về [roll_down, roll_up, roll_side] – dùng chung logic
	var results : Array = []
	for variant in range(3):  # 0=down, 1=up, 2=side
		var img := new_img(6)

		# Kích thước ban đầu (hơi dẹt đứng, như thân chạy)
		# → thu dần thành tròn → rồi oval ngang nhỏ hơn
		var rws : Array[float] = [9.0, 8.5, 9.5, 10.0, 9.5, 8.5]
		var rhs : Array[float] = [10.0, 9.5, 9.0, 9.5, 10.0, 10.5]
		# Góc xoay từng khung (rad)
		var angles : Array[float] = [0.0, 0.52, 1.05, 1.57, 2.09, 2.62]
		# Vị trí cy thay đổi (thu thân lên cao)
		var cys : Array[int] = [15, 15, 16, 16, 15, 15]

		for f in range(6):
			var cx := 16
			var cy : int = cys[f]
			var rw : float = rws[f]
			var rh : float = rhs[f]
			var angle : float = angles[f]

			draw_roll_body(img, f*W, cx, cy, rw, rh, angle)

			# Đốm quay theo oval
			var sp1x := int(cx + (-3.0)*cos(angle) + (-5.0)*sin(angle))
			var sp1y := int(cy + 3.0*sin(angle) + (-5.0)*cos(angle))
			var sp2x := int(cx + 3.0*cos(angle) + (-3.0)*sin(angle))
			var sp2y := int(cy + (-3.0)*sin(angle) + (-3.0)*cos(angle))
			px(img, f*W + sp1x, sp1y, C_SPOT)
			px(img, f*W + sp2x, sp2y, C_SPOT)

			# Khung 0-1: vẫn còn thấy mặt và chân nhỏ
			if f <= 1:
				# Mắt nhỏ chớp (thu dần)
				if variant != 1:  # không vẽ mắt cho hướng lưng
					px(img, f*W + cx - 3 + int(f), cy - 2, C_EYE)
					px(img, f*W + cx + 2 + int(f), cy - 2, C_EYE)
					px(img, f*W + cx - 3 + int(f), cy - 1, C_OUT)
					px(img, f*W + cx + 2 + int(f), cy - 1, C_OUT)
				# Chân nhỏ ló ra đáy
				px(img, f*W + cx - 3, cy + int(rh) - 2, C_OUT)
				px(img, f*W + cx - 2, cy + int(rh) - 2, C_OUT)
				px(img, f*W + cx + 1, cy + int(rh) - 2, C_OUT)
				px(img, f*W + cx + 2, cy + int(rh) - 2, C_OUT)

		results.append(img)
	return results

# ============================================================
# PREVIEW: phóng to 5x, nền tối
# ============================================================
func make_preview(strip: Image) -> Image:
	var fw : int = strip.get_width() / W
	var prev := Image.create(fw * W * 5, H * 5, false, Image.FORMAT_RGBA8)
	prev.fill(Color("#1A1A2E"))
	for f in range(fw):
		for py2 in range(H):
			for px2 in range(W):
				var c := strip.get_pixel(f * W + px2, py2)
				for sy in range(5):
					for sx in range(5):
						prev.set_pixel(f*W*5 + px2*5+sx, py2*5+sy, c)
	return prev

func save_png(img: Image, path: String) -> void:
	var err := img.save_png(path)
	print(("[OK] " if err == OK else "[ERR] ") + path)

# ============================================================
# MAIN
# ============================================================
func _init() -> void:
	print("=== Vẽ lại Run & Roll theo style tham khảo ===")

	var run_down := make_run_down()
	var run_up   := make_run_up()
	var run_side := make_run_side()
	save_png(run_down, SPRITES_DIR + "player_egg_run_down.png")
	save_png(run_up,   SPRITES_DIR + "player_egg_run_up.png")
	save_png(run_side, SPRITES_DIR + "player_egg_run_side.png")

	var rolls := make_roll_all()
	save_png(rolls[0], SPRITES_DIR + "player_egg_roll_down.png")
	save_png(rolls[1], SPRITES_DIR + "player_egg_roll_up.png")
	save_png(rolls[2], SPRITES_DIR + "player_egg_roll_side.png")

	# Previews
	save_png(make_preview(run_down),  PREV_DIR + "preview_run_down.png")
	save_png(make_preview(run_up),    PREV_DIR + "preview_run_up.png")
	save_png(make_preview(run_side),  PREV_DIR + "preview_run_side.png")
	save_png(make_preview(rolls[0]),  PREV_DIR + "preview_roll_down.png")
	save_png(make_preview(rolls[2]),  PREV_DIR + "preview_roll_side.png")

	print("=== Xong ===")
	quit(0)
