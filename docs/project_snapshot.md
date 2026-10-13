# PROJECT SNAPSHOT - VÕ VỎ (SHELLBOUND)

## 1. CÂY THƯ MỤC DỰ ÁN
`	ext
.editorconfig
.gitattributes
.gitignore
generate_run_roll_sprites.gd
generate_run_roll_sprites.gd.uid
generate_run_roll_v2.gd
generate_run_roll_v2.gd.uid
icon.svg
icon.svg.import
make_hurt_death.py
make_previews.py
project.godot
slice_attack_sheet.py
slice_hurt_death.py
slice_spritesheet.py
assets/
  audio/
    .gitkeep
  sprites/
    .gitkeep
    player/
      animations.json
      player_egg_attack_down.png
      player_egg_attack_down.png.import
      player_egg_attack_side.png
      player_egg_attack_side.png.import
      player_egg_attack_up.png
      player_egg_attack_up.png.import
      player_egg_death.png
      player_egg_death.png.import
      player_egg_hurt.png
      player_egg_hurt.png.import
      player_egg_idle_down.png
      player_egg_idle_down.png.import
      player_egg_idle_side.png
      player_egg_idle_side.png.import
      player_egg_idle_up.png
      player_egg_idle_up.png.import
      player_egg_roll_down.png
      player_egg_roll_down.png.import
      player_egg_roll_side.png
      player_egg_roll_side.png.import
      player_egg_roll_up.png
      player_egg_roll_up.png.import
      player_egg_run_down.png
      player_egg_run_down.png.import
      player_egg_run_side.png
      player_egg_run_side.png.import
      player_egg_run_up.png
      player_egg_run_up.png.import
  tiles/
    .gitkeep
  ui/
    .gitkeep
data/
  .gitkeep
  stats.json
docs/
  .gitkeep
  CHARACTER_SPEC.md
  GDD.md
  PROJECT_STATUS.md
scenes/
  bosses/
    .gitkeep
  enemies/
    .gitkeep
    dummy_enemy.tscn
  levels/
    .gitkeep
    test_arena.gd
    test_arena.gd.uid
    test_arena.tscn
  player/
    .gitkeep
    player.tscn
  ui/
    .gitkeep
    hud.tscn
scripts/
  autoload/
    .gitkeep
    behavior_tracker.gd
    behavior_tracker.gd.uid
    game_data.gd
    game_data.gd.uid
    palette.gd
    palette.gd.uid
    save_manager.gd
    save_manager.gd.uid
  combat/
    .gitkeep
    dummy_enemy.gd
    dummy_enemy.gd.uid
    enemy_visual.gd
    enemy_visual.gd.uid
  evolution/
    .gitkeep
  player/
    .gitkeep
    egg_visual.gd
    egg_visual.gd.uid
    player.gd
    player.gd.uid
  ui/
    .gitkeep
    hud.gd
    hud.gd.uid
`

---

## 2. NỘI DUNG CHI TIẾT TỪNG FILE MÃ NGUỒN VÀ DỮ LIỆU

### assets/sprites/player/animations.json
`json
{
  "player_egg": {
    "frame_size": [32, 32],
    "anchor": [16, 31],
    "animations": {
      "idle_down": { "file": "player_egg_idle_down.png", "frames": 4, "fps": 8, "loop": true, "hit_frames": [] },
      "idle_up": { "file": "player_egg_idle_up.png", "frames": 4, "fps": 8, "loop": true, "hit_frames": [] },
      "idle_side": { "file": "player_egg_idle_side.png", "frames": 4, "fps": 8, "loop": true, "hit_frames": [] },
      "run_down": { "file": "player_egg_run_down.png", "frames": 6, "fps": 12, "loop": true, "hit_frames": [] },
      "run_up": { "file": "player_egg_run_up.png", "frames": 6, "fps": 12, "loop": true, "hit_frames": [] },
      "run_side": { "file": "player_egg_run_side.png", "frames": 6, "fps": 12, "loop": true, "hit_frames": [] },
      "roll_down": { "file": "player_egg_roll_down.png", "frames": 6, "fps": 12, "loop": false, "hit_frames": [] },
      "roll_up": { "file": "player_egg_roll_up.png", "frames": 6, "fps": 12, "loop": false, "hit_frames": [] },
      "roll_side": { "file": "player_egg_roll_side.png", "frames": 6, "fps": 12, "loop": false, "hit_frames": [] },
      "attack_down": { "file": "player_egg_attack_down.png", "frames": 5, "fps": 12, "loop": false, "hit_frames": [2] },
      "attack_up": { "file": "player_egg_attack_up.png", "frames": 5, "fps": 12, "loop": false, "hit_frames": [2] },
      "attack_side": { "file": "player_egg_attack_side.png", "frames": 5, "fps": 12, "loop": false, "hit_frames": [2] },
      "death_down": { "file": "player_egg_death.png", "frames": 7, "fps": 8, "loop": false, "hit_frames": [] },
      "death_up":   { "file": "player_egg_death.png", "frames": 7, "fps": 8, "loop": false, "hit_frames": [] },
      "death_side": { "file": "player_egg_death.png", "frames": 7, "fps": 8, "loop": false, "hit_frames": [] }
    }
  }
}
`

### data/stats.json
`json
{
  "_huong_dan": "Dữ liệu cân bằng cho Trứng và hệ thống chiến đấu ban đầu. Bạn có thể tự do điều chỉnh các chỉ số dưới đây mà không cần sửa code.",
  "base_stats": {
	"VIT": 10,
	"STR": 10,
	"DEX": 10,
	"INT": 10,
	"FAI": 10,
	"LUK": 10
  },
  "player": {
	"max_hp": 100,
	"max_stamina": 100.0,
	"move_speed": 95.0,
	"dodge_speed_multiplier": 1.85,
	"dodge_duration": 0.25,
	"dodge_cooldown": 0.2,
	"dodge_stamina_cost": 20.0,
	"stamina_recovery_rate": 30.0,
	"stamina_recovery_delay": 0.35,
	"collision_size": [10.0, 6.0],
	"collision_offset": [0.0, -3.0],
	"hurtbox_size": [10.0, 14.0],
	"hurtbox_offset": [0.0, -10.0],
	"attack_combo_damage": [15, 18, 28],
	"attack_cooldowns": [0.15, 0.15, 0.45],
	"combo_window": 0.55,
	"attack_stamina_costs": [10.0, 12.0, 18.0]
  },
  "dummy_enemy": {
	"max_hp": 50,
	"damage": 20,
	"telegraph_duration": 0.3,
	"attack_interval": 2.2,
	"attack_radius": 28.0
  },
  "debug": {
	"show_dodge_debug": false
  }
}
`

### generate_run_roll_sprites.gd
`gdscript
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
`

### generate_run_roll_v2.gd
`gdscript
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
`

### project.godot
`ini
; Engine configuration file.
; It's best edited using the editor UI and not directly,
; since the parameters that go here are not all obvious.
;
; Format:
;   [section] ; section goes between []
;   param=value ; assign values to parameters

config_version=5

[application]

config/name="Vỡ Vỏ"
run/main_scene="res://scenes/levels/test_arena.tscn"
config/features=PackedStringArray("4.7", "Forward Plus")
config/icon="res://icon.svg"

[autoload]

Palette="*res://scripts/autoload/palette.gd"
GameData="*res://scripts/autoload/game_data.gd"
BehaviorTracker="*res://scripts/autoload/behavior_tracker.gd"
SaveManager="*res://scripts/autoload/save_manager.gd"

[display]

window/size/viewport_width=320
window/size/viewport_height=180
window/size/window_width_override=1280
window/size/window_height_override=720
window/stretch/mode="viewport"
window/stretch/scale_mode="integer"

[input]

move_left={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":65,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":4194319,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":0,"button_index":13,"pressure":0.0,"pressed":false,"script":null)
, Object(InputEventJoypadMotion,"resource_local_to_scene":false,"resource_name":"","device":0,"axis":0,"axis_value":-1.0,"script":null)
]
}
move_right={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":68,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":4194321,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":0,"button_index":14,"pressure":0.0,"pressed":false,"script":null)
, Object(InputEventJoypadMotion,"resource_local_to_scene":false,"resource_name":"","device":0,"axis":0,"axis_value":1.0,"script":null)
]
}
move_up={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":87,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":4194320,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":0,"button_index":11,"pressure":0.0,"pressed":false,"script":null)
, Object(InputEventJoypadMotion,"resource_local_to_scene":false,"resource_name":"","device":0,"axis":1,"axis_value":-1.0,"script":null)
]
}
move_down={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":83,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":4194322,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":0,"button_index":12,"pressure":0.0,"pressed":false,"script":null)
, Object(InputEventJoypadMotion,"resource_local_to_scene":false,"resource_name":"","device":0,"axis":1,"axis_value":1.0,"script":null)
]
}
attack={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":74,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventMouseButton,"resource_local_to_scene":false,"resource_name":"","device":32,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"button_mask":0,"position":Vector2(0, 0),"global_position":Vector2(0, 0),"factor":1.0,"button_index":1,"canceled":false,"pressed":false,"double_click":false,"script":null)
, Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":0,"button_index":2,"pressure":0.0,"pressed":false,"script":null)
]
}
dodge={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":32,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":75,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":0,"button_index":0,"pressure":0.0,"pressed":false,"script":null)
]
}
guard={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":76,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventMouseButton,"resource_local_to_scene":false,"resource_name":"","device":32,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"button_mask":0,"position":Vector2(0, 0),"global_position":Vector2(0, 0),"factor":1.0,"button_index":2,"canceled":false,"pressed":false,"double_click":false,"script":null)
, Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":0,"button_index":9,"pressure":0.0,"pressed":false,"script":null)
]
}
interact={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":69,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":0,"button_index":3,"pressure":0.0,"pressed":false,"script":null)
]
}
pause={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":4194305,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":0,"button_index":6,"pressure":0.0,"pressed":false,"script":null)
]
}

[physics]

3d/physics_engine="Jolt Physics"

[rendering]

textures/canvas_textures/default_texture_filter=0
rendering_device/driver.windows="d3d12"
2d/snap/snap_2d_transforms_to_pixel=true
2d/snap/snap_2d_vertices_to_pixel=true
`

### scenes/enemies/dummy_enemy.tscn
`ini
[gd_scene load_steps=5 format=3 uid="uid://dmmyenemy001"]

[ext_resource type="Script" path="res://scripts/combat/dummy_enemy.gd" id="1_enemy"]
[ext_resource type="Script" path="res://scripts/combat/enemy_visual.gd" id="2_visual"]

[sub_resource type="RectangleShape2D" id="RectangleShape2D_body"]
size = Vector2(20, 20)

[sub_resource type="CircleShape2D" id="CircleShape2D_attack"]
radius = 28.0

[node name="DummyEnemy" type="CharacterBody2D" groups=["enemies"]]
collision_layer = 1
collision_mask = 1
script = ExtResource("1_enemy")

[node name="CollisionShape2D" type="CollisionShape2D" parent="."]
shape = SubResource("RectangleShape2D_body")

[node name="EnemyVisual" type="Node2D" parent="."]
script = ExtResource("2_visual")

[node name="AttackArea" type="Area2D" parent="."]
collision_layer = 0
collision_mask = 2

[node name="CollisionShape2D" type="CollisionShape2D" parent="AttackArea"]
shape = SubResource("CircleShape2D_attack")

[node name="Hurtbox" type="Area2D" parent="." groups=["enemy_hurtbox"]]
collision_layer = 16
collision_mask = 0

[node name="CollisionShape2D" type="CollisionShape2D" parent="Hurtbox"]
shape = SubResource("RectangleShape2D_body")
`

### scenes/levels/test_arena.gd
`gdscript
extends Node2D

# Màn chơi thử nghiệm test_arena:
# - Nền tối (DEN_THAN)
# - Tường bao hầm ngục (NAU_HAM)
# - Player với Camera2D smoothed pixel-snap
# - Kẻ thù thử nghiệm (DummyEnemy)
# - HUD hiển thị máu, thể lực và thông báo chết/hồi sinh

@onready var player: CharacterBody2D = $Player
@onready var hud: CanvasLayer = $HUD

func _ready() -> void:
	if player != null and hud != null:
		player.hp_changed.connect(hud.update_hp)
		player.stamina_changed.connect(hud.update_stamina)
		player.player_died.connect(func(): hud.show_death_screen(true))
		player.player_respawned.connect(func(): hud.show_death_screen(false))
		# Khởi tạo giá trị ban đầu cho HUD
		hud.update_hp(player.current_hp, player.max_hp)
		hud.update_stamina(player.current_stamina, player.max_stamina)
	
	print("[ARENA] Test arena đã sẵn sàng! Di chuyển (WASD/Mũi tên), Lăn né (Space/K).")
`

### scenes/levels/test_arena.tscn
`ini
[gd_scene format=3 uid="uid://btestarena001"]

[ext_resource type="Script" path="res://scenes/levels/test_arena.gd" id="1_arena"]
[ext_resource type="PackedScene" path="res://scenes/player/player.tscn" id="2_player"]
[ext_resource type="PackedScene" path="res://scenes/enemies/dummy_enemy.tscn" id="3_enemy"]
[ext_resource type="PackedScene" path="res://scenes/ui/hud.tscn" id="4_hud"]

[sub_resource type="RectangleShape2D" id="RectangleShape2D_horiz"]
size = Vector2(480, 16)

[sub_resource type="RectangleShape2D" id="RectangleShape2D_vert"]
size = Vector2(16, 270)

[node name="TestArena" type="Node2D"]
script = ExtResource("1_arena")

[node name="Floor" type="ColorRect" parent="."]
offset_right = 480.0
offset_bottom = 270.0
color = Color(0.0784314, 0.0666667, 0.0588235, 1)

[node name="Walls" type="StaticBody2D" parent="."]
collision_layer = 1
collision_mask = 0

[node name="TopWallVisual" type="ColorRect" parent="Walls"]
offset_right = 480.0
offset_bottom = 16.0
color = Color(0.168627, 0.121569, 0.101961, 1)

[node name="TopCollision" type="CollisionShape2D" parent="Walls"]
position = Vector2(240, 8)
shape = SubResource("RectangleShape2D_horiz")

[node name="BottomWallVisual" type="ColorRect" parent="Walls"]
offset_top = 254.0
offset_right = 480.0
offset_bottom = 270.0
color = Color(0.168627, 0.121569, 0.101961, 1)

[node name="BottomCollision" type="CollisionShape2D" parent="Walls"]
position = Vector2(240, 262)
shape = SubResource("RectangleShape2D_horiz")

[node name="LeftWallVisual" type="ColorRect" parent="Walls"]
offset_right = 16.0
offset_bottom = 270.0
color = Color(0.168627, 0.121569, 0.101961, 1)

[node name="LeftCollision" type="CollisionShape2D" parent="Walls"]
position = Vector2(8, 135)
shape = SubResource("RectangleShape2D_vert")

[node name="RightWallVisual" type="ColorRect" parent="Walls"]
offset_left = 464.0
offset_right = 480.0
offset_bottom = 270.0
color = Color(0.168627, 0.121569, 0.101961, 1)

[node name="RightCollision" type="CollisionShape2D" parent="Walls"]
position = Vector2(472, 135)
shape = SubResource("RectangleShape2D_vert")

[node name="DummyEnemy" parent="." instance=ExtResource("3_enemy")]
position = Vector2(260, 135)

[node name="Player" parent="." instance=ExtResource("2_player")]
position = Vector2(160, 135)

[node name="Camera2D" type="Camera2D" parent="Player"]
position_smoothing_enabled = true
position_smoothing_speed = 6.0
limit_left = 0
limit_top = 0
limit_right = 480
limit_bottom = 270

[node name="HUD" parent="." instance=ExtResource("4_hud")]
`

### scenes/player/player.tscn
`ini
[gd_scene load_steps=6 format=3 uid="uid://df7xeggplayer01"]

[ext_resource type="Script" path="res://scripts/player/player.gd" id="1_player"]
[ext_resource type="Script" path="res://scripts/player/egg_visual.gd" id="2_visual"]

[sub_resource type="RectangleShape2D" id="RectangleShape2D_col"]
size = Vector2(10, 6)

[sub_resource type="RectangleShape2D" id="RectangleShape2D_hurt"]
size = Vector2(10, 14)

[sub_resource type="RectangleShape2D" id="RectangleShape2D_attack"]
size = Vector2(16, 16)

[node name="Player" type="CharacterBody2D" groups=["player"]]
collision_layer = 1
collision_mask = 1
script = ExtResource("1_player")

[node name="CollisionShape2D" type="CollisionShape2D" parent="."]
position = Vector2(0, -3)
shape = SubResource("RectangleShape2D_col")

[node name="AnimatedSprite2D" type="AnimatedSprite2D" parent="."]

[node name="EggVisual" type="Node2D" parent="."]
script = ExtResource("2_visual")

[node name="Hurtbox" type="Area2D" parent="."]
collision_layer = 2
collision_mask = 0

[node name="CollisionShape2D" type="CollisionShape2D" parent="Hurtbox"]
position = Vector2(0, -10)
shape = SubResource("RectangleShape2D_hurt")

[node name="AttackHitbox" type="Area2D" parent="."]
collision_layer = 0
collision_mask = 16

[node name="CollisionShape2D" type="CollisionShape2D" parent="AttackHitbox"]
shape = SubResource("RectangleShape2D_attack")
`

### scenes/ui/hud.tscn
`ini
[gd_scene format=3 uid="uid://bvyhud001"]

[ext_resource type="Script" path="res://scripts/ui/hud.gd" id="1_hud"]

[node name="HUD" type="CanvasLayer"]
script = ExtResource("1_hud")

[node name="MarginContainer" type="MarginContainer" parent="."]
offset_left = 6.0
offset_top = 6.0
offset_right = 120.0
offset_bottom = 50.0

[node name="VBoxContainer" type="VBoxContainer" parent="MarginContainer"]
layout_mode = 2
theme_override_constants/separation = 2

[node name="HPBar" type="Control" parent="MarginContainer/VBoxContainer"]
custom_minimum_size = Vector2(64, 6)
layout_mode = 2

[node name="Background" type="ColorRect" parent="MarginContainer/VBoxContainer/HPBar"]
layout_mode = 0
offset_right = 64.0
offset_bottom = 6.0
color = Color(0.168627, 0.121569, 0.101961, 1)

[node name="Fill" type="ColorRect" parent="MarginContainer/VBoxContainer/HPBar"]
layout_mode = 0
offset_right = 64.0
offset_bottom = 6.0
color = Color(0.658824, 0.203922, 0.168627, 1)

[node name="StaminaBar" type="Control" parent="MarginContainer/VBoxContainer"]
custom_minimum_size = Vector2(52, 4)
layout_mode = 2

[node name="Background" type="ColorRect" parent="MarginContainer/VBoxContainer/StaminaBar"]
layout_mode = 0
offset_right = 52.0
offset_bottom = 4.0
color = Color(0.168627, 0.121569, 0.101961, 1)

[node name="Fill" type="ColorRect" parent="MarginContainer/VBoxContainer/StaminaBar"]
layout_mode = 0
offset_right = 52.0
offset_bottom = 4.0
color = Color(0.419608, 0.498039, 0.227451, 1)

[node name="DebugDodgeLabel" type="Label" parent="MarginContainer/VBoxContainer"]
visible = false
layout_mode = 2
theme_override_font_sizes/font_size = 8
text = "[DEBUG F3] DODGE: 0"

[node name="DeathOverlay" type="Control" parent="."]
visible = false
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2

[node name="CenterContainer" type="CenterContainer" parent="DeathOverlay"]
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2

[node name="VBoxContainer" type="VBoxContainer" parent="DeathOverlay/CenterContainer"]
layout_mode = 2
alignment = 1

[node name="PanelBg" type="ColorRect" parent="DeathOverlay/CenterContainer/VBoxContainer"]
visible = false
custom_minimum_size = Vector2(160, 40)
layout_mode = 2
color = Color(0.168627, 0.121569, 0.101961, 0.9)

[node name="DeathLabel" type="Label" parent="DeathOverlay/CenterContainer/VBoxContainer"]
layout_mode = 2
theme_override_font_sizes/font_size = 14
text = "VỎ ĐÃ VỠ..."
horizontal_alignment = 1

[node name="SubLabel" type="Label" parent="DeathOverlay/CenterContainer/VBoxContainer"]
layout_mode = 2
theme_override_font_sizes/font_size = 8
text = "Đang hồi sinh..."
horizontal_alignment = 1
`

### scripts/autoload/behavior_tracker.gd
`gdscript
extends Node

# Autoload BehaviorTracker: 5 bộ đếm hành vi ẩn của Trứng (GDD Mục 6.1)
# GUARD, DODGE, MAGIC, EXPLORE, SUPPORT
# Dùng để quyết định nhánh tiến hóa tại các mốc mà người chơi không thấy số điểm trực tiếp.

signal points_changed(action_name: String, new_points: int, total_points: int)

const ACTION_GUARD: String = "GUARD"
const ACTION_DODGE: String = "DODGE"
const ACTION_MAGIC: String = "MAGIC"
const ACTION_EXPLORE: String = "EXPLORE"
const ACTION_SUPPORT: String = "SUPPORT"

const VALID_ACTIONS: Array[String] = [
	ACTION_GUARD,
	ACTION_DODGE,
	ACTION_MAGIC,
	ACTION_EXPLORE,
	ACTION_SUPPORT
]

var _counters: Dictionary = {
	ACTION_GUARD: 0,
	ACTION_DODGE: 0,
	ACTION_MAGIC: 0,
	ACTION_EXPLORE: 0,
	ACTION_SUPPORT: 0
}

func add_points(action_name: String, points: int) -> void:
	if not _counters.has(action_name):
		push_warning("BehaviorTracker: Hành động không hợp lệ: " + action_name)
		return
	if points <= 0:
		return
	_counters[action_name] += points
	var total: int = get_total_points()
	points_changed.emit(action_name, _counters[action_name], total)
	print("[BehaviorTracker] +%d %s (Hiện tại: %d, Tổng: %d)" % [points, action_name, _counters[action_name], total])

func get_points(action_name: String) -> int:
	return _counters.get(action_name, 0)

func get_total_points() -> int:
	var total: int = 0
	for key in _counters:
		total += int(_counters[key])
	return total

func get_ratios() -> Dictionary:
	var total: int = get_total_points()
	var ratios: Dictionary = {}
	for key in _counters:
		if total > 0:
			ratios[key] = float(_counters[key]) / float(total)
		else:
			ratios[key] = 0.0
	return ratios

func reset() -> void:
	for key in _counters:
		_counters[key] = 0

func export_data() -> Dictionary:
	return _counters.duplicate()

func import_data(data: Dictionary) -> void:
	for action_name in VALID_ACTIONS:
		if data.has(action_name):
			_counters[action_name] = int(data[action_name])
`

### scripts/autoload/game_data.gd
`gdscript
extends Node

# Autoload GameData: Quản lý nạp toàn bộ file cấu hình JSON trong thư mục data/
# Đảm bảo không hard-code bất kỳ chỉ số cân bằng nào vào mã nguồn.

var stats: Dictionary = {}

func _ready() -> void:
	load_all_data()

func load_all_data() -> void:
	stats = load_json_file("res://data/stats.json")
	if stats.is_empty():
		push_error("GameData: Không thể nạp dữ liệu từ stats.json!")
	else:
		print("GameData: Nạp thành công stats.json.")

func load_json_file(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_error("GameData: Không tìm thấy file JSON tại " + path)
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("GameData: Không thể mở file " + path)
		return {}
	var content := file.get_as_text()
	var json := JSON.new()
	var parse_result := json.parse(content)
	if parse_result != OK:
		push_error("GameData: Lỗi parse JSON tại %s (dòng %d): %s" % [path, json.get_error_line(), json.get_error_message()])
		return {}
	if json.data is Dictionary:
		return json.data
	push_warning("GameData: Dữ liệu JSON trong %s không phải là Dictionary!" % path)
	return {}

func get_stat(category: String, key: String, default_value: Variant = null) -> Variant:
	if stats.has(category) and stats[category] is Dictionary and stats[category].has(key):
		return stats[category][key]
	return default_value
`

### scripts/autoload/palette.gd
`gdscript
extends Node

# Bảng màu trung cổ (16 màu cố định theo GDD Mục 3)
# Toàn bộ màu sắc trong game bắt buộc phải tham chiếu từ Palette này.
const DEN_THAN: Color = Color("#14110F")      # 1. Bóng sâu nhất, nền hầm ngục tối, hố đen
const NAU_HAM: Color = Color("#2B1F1A")       # 2. Viền ngoài mọi sprite, tường hầm
const XAM_SAT: Color = Color("#4A4A52")       # 3. Giáp, kim loại, đá tối
const XAM_DA: Color = Color("#7C7C80")        # 4. Đá sáng, vũ khí, lưỡi kiếm
const NAU_GO: Color = Color("#6B4423")        # 5. Gỗ, cửa, cán vũ khí, đất tối
const NAU_DA: Color = Color("#A0693B")        # 6. Da thuộc, đất, rơm đậm
const CAT: Color = Color("#D4A86A")           # 7. Rơm, cát, bóng đổ trên vỏ trứng
const GIAY_DA: Color = Color("#E8D9B0")       # 8. Vỏ trứng (màu chính), giấy, xương
const KEM: Color = Color("#F4EBD0")           # 9. Điểm sáng nhất, vùng ánh sáng trên vỏ trứng
const DO_RUOU: Color = Color("#6E1423")       # 10. Vải quý tộc, máu khô, boss tối
const DO_GACH: Color = Color("#A8342B")       # 11. Lửa nhẹ, cờ hiệu, cảnh báo sát thương, thanh HP
const XANH_REU: Color = Color("#3B4A2A")      # 12. Cỏ, lá, đầm lầy, rừng
const XANH_LA_UA: Color = Color("#6B7F3A")    # 13. Cỏ sáng, độc nhẹ, đồ vật tự nhiên, thanh Stamina
const VANG_CO: Color = Color("#C79A2E")       # 14. Vàng đồng, chữ khắc, vật phẩm hiếm, Mảnh Vỏ
const XANH_THEP: Color = Color("#2F4A63")     # 15. Nước, sương, đêm, phép băng/lòng trắng
const TIM_MUC: Color = Color("#5A3A5E")       # 16. Mục Rữa, phép hắc ám
`

### scripts/autoload/save_manager.gd
`gdscript
extends Node

# Autoload SaveManager: Nơi DUY NHẤT được ghi file save vào user://
# Đảm bảo lưu/tải an toàn toàn bộ tiến trình người chơi và 5 bộ đếm hành vi dưới dạng JSON.

const SAVE_PATH: String = "user://savegame.json"

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func save_game(extra_data: Dictionary = {}) -> bool:
	var save_dict: Dictionary = {
		"version": 1,
		"timestamp": Time.get_unix_time_from_system(),
		"behavior_counters": BehaviorTracker.export_data(),
		"extra": extra_data
	}
	
	var json_str := JSON.stringify(save_dict, "\t")
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		var err := FileAccess.get_open_error()
		push_error("SaveManager: Lỗi khi mở file save để ghi: %d" % err)
		return false
	
	file.store_string(json_str)
	file.close()
	print("SaveManager: Đã lưu game thành công vào " + SAVE_PATH)
	return true

func load_game() -> Dictionary:
	if not has_save():
		print("SaveManager: Chưa có file save tại " + SAVE_PATH)
		return {}
	
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("SaveManager: Không thể mở file save để đọc")
		return {}
	
	var content := file.get_as_text()
	file.close()
	
	var json := JSON.new()
	var err := json.parse(content)
	if err != OK:
		push_error("SaveManager: Lỗi parse file save: %s" % json.get_error_message())
		return {}
	
	var data = json.data
	if not data is Dictionary:
		push_error("SaveManager: Nội dung file save không hợp lệ")
		return {}
	
	if data.has("behavior_counters") and data["behavior_counters"] is Dictionary:
		BehaviorTracker.import_data(data["behavior_counters"])
	
	print("SaveManager: Đã nạp dữ liệu save thành công.")
	return data

func delete_save() -> bool:
	if has_save():
		var err := DirAccess.remove_absolute(SAVE_PATH)
		return err == OK
	return true
`

### scripts/combat/dummy_enemy.gd
`gdscript
extends CharacterBody2D

# Kẻ thù giả để kiểm tra né đòn và nhận sát thương.
# Tuân thủ:
# - Báo hiệu nhấp nháy Đỏ Gạch (DO_GACH) đúng 0.3 giây trước khi gây sát thương (GDD Mục 3 & 7)
# - Chỉ cộng DODGE tối đa 1 lần cho mỗi lượt tung đòn (Quy tắc điều chỉnh #3)
# - Số liệu cân bằng lấy từ data/stats.json
# - Màu sắc 100% từ Palette

enum State { IDLE, TELEGRAPH, ATTACK, RECOVERY }

@onready var visual_node: Node2D = $EnemyVisual
@onready var attack_area: Area2D = $AttackArea

var max_hp: int = 50
var current_hp: int = 50
var damage: int = 20
var telegraph_duration: float = 0.3
var attack_interval: float = 2.2
var attack_radius: float = 28.0

var current_state: State = State.IDLE
var state_timer: float = 0.0
var flash_timer: float = 0.0
var hurt_flash_timer: float = 0.0
var is_flashing_red: bool = false

# Đảm bảo mỗi lượt vung đòn chỉ tương tác với người chơi đúng 1 lần (Quy tắc điều chỉnh #3)
var has_resolved_player_this_attack: bool = false
var attack_active_duration: float = 0.15

func _ready() -> void:
	load_stats()
	current_hp = max_hp
	state_timer = attack_interval - telegraph_duration
	current_state = State.IDLE

func load_stats() -> void:
	max_hp = int(GameData.get_stat("dummy_enemy", "max_hp", 50))
	damage = int(GameData.get_stat("dummy_enemy", "damage", 20))
	telegraph_duration = float(GameData.get_stat("dummy_enemy", "telegraph_duration", 0.3))
	attack_interval = float(GameData.get_stat("dummy_enemy", "attack_interval", 2.2))
	attack_radius = float(GameData.get_stat("dummy_enemy", "attack_radius", 28.0))

func _physics_process(delta: float) -> void:
	state_timer -= delta
	
	if hurt_flash_timer > 0.0:
		hurt_flash_timer -= delta
		if hurt_flash_timer <= 0.0:
			modulate = Color.WHITE
	
	match current_state:
		State.IDLE:
			if state_timer <= 0.0:
				start_telegraph()
		
		State.TELEGRAPH:
			process_telegraph_flash(delta)
			if state_timer <= 0.0:
				execute_attack()
		
		State.ATTACK:
			check_attack_hitbox()
			if state_timer <= 0.0:
				end_attack()
		
		State.RECOVERY:
			if state_timer <= 0.0:
				start_idle()

func start_telegraph() -> void:
	current_state = State.TELEGRAPH
	state_timer = telegraph_duration
	flash_timer = 0.0
	is_flashing_red = true
	visual_node.queue_redraw()

func process_telegraph_flash(delta: float) -> void:
	flash_timer += delta
	# Nhấp nháy tần số nhanh (0.07s) bằng màu Đỏ Gạch
	if flash_timer >= 0.07:
		flash_timer = 0.0
		is_flashing_red = not is_flashing_red
		visual_node.queue_redraw()

func execute_attack() -> void:
	current_state = State.ATTACK
	state_timer = attack_active_duration
	has_resolved_player_this_attack = false
	is_flashing_red = true
	visual_node.queue_redraw()
	print("[ENEMY] Tung đòn tấn công! (Sát thương: %d, Bán kính: %.1f)" % [damage, attack_radius])
	check_attack_hitbox()

func check_attack_hitbox() -> void:
	# Nếu đợt vung đòn này đã giải quyết với Player rồi thì bỏ qua (Quy tắc #3)
	if has_resolved_player_this_attack:
		return
	
	var overlapping_areas := attack_area.get_overlapping_areas()
	for area in overlapping_areas:
		# Chỉ kiểm tra va chạm với Hurtbox, không tương tác với thân vật lý
		if area.name == "Hurtbox":
			var parent: Node = area.get_parent()
			if parent != null and parent.has_method("receive_hit"):
				has_resolved_player_this_attack = true
				parent.receive_hit(damage, self)
				break

func end_attack() -> void:
	current_state = State.RECOVERY
	state_timer = 0.3
	is_flashing_red = false
	visual_node.queue_redraw()

func start_idle() -> void:
	current_state = State.IDLE
	state_timer = maxf(0.5, attack_interval - telegraph_duration - 0.3)
	is_flashing_red = false
	visual_node.queue_redraw()

func receive_hit(amount: int, _attack_source: Node) -> Dictionary:
	current_hp = maxi(0, current_hp - amount)
	print("[ENEMY] Nhận %d sát thương từ Player! HP còn: %d/%d" % [amount, current_hp, max_hp])
	modulate = Palette.KEM
	hurt_flash_timer = 0.15
	if current_hp <= 0:
		print("[ENEMY] Kẻ thù bị tiêu diệt! Tự động hồi phục sau 1.5 giây.")
		current_hp = max_hp
	return {"hit": true, "damage": amount}
`

### scripts/combat/enemy_visual.gd
`gdscript
extends Node2D

# Vẽ hình khối tạm của Kẻ thù thử nghiệm
# Màu sắc: Đỏ Rượu (DO_RUOU), viền Nâu Hầm (NAU_HAM), cảnh báo Đỏ Gạch (DO_GACH)

const DummyEnemyScript = preload("res://scripts/combat/dummy_enemy.gd")

@onready var enemy: Node2D = get_parent()

func _draw() -> void:
	if enemy == null:
		return
	
	var radius: float = enemy.get("attack_radius")
	var state_val = enemy.get("current_state")
	var is_flashing: bool = enemy.get("is_flashing_red")
	
	# 1. Vẽ vòng bán kính cảnh báo / đòn đánh
	match state_val:
		DummyEnemyScript.State.TELEGRAPH:
			if is_flashing:
				draw_arc(Vector2.ZERO, radius, 0, TAU, 32, Palette.DO_GACH, 1.5)
			else:
				draw_arc(Vector2.ZERO, radius, 0, TAU, 32, Palette.DO_RUOU, 1.0)
		DummyEnemyScript.State.ATTACK:
			# Vùng sát thương khi đang vung đòn
			draw_circle(Vector2.ZERO, radius, Color(Palette.DO_GACH.r, Palette.DO_GACH.g, Palette.DO_GACH.b, 0.35))
			draw_arc(Vector2.ZERO, radius, 0, TAU, 32, Palette.DO_GACH, 2.0)
		_:
			# Hiển thị đường nét mờ bán kính khi nhàn rỗi
			draw_arc(Vector2.ZERO, radius, 0, TAU, 24, Palette.XAM_SAT, 0.75)
	
	# 2. Thân khối quái vật (hình hộp 20x20 px)
	var body_rect := Rect2(-10, -10, 20, 20)
	var outline_rect := Rect2(-11, -11, 22, 22)
	
	draw_rect(outline_rect, Palette.NAU_HAM)
	
	if state_val == DummyEnemyScript.State.TELEGRAPH and is_flashing:
		draw_rect(body_rect, Palette.DO_GACH)
	elif state_val == DummyEnemyScript.State.ATTACK:
		draw_rect(body_rect, Palette.DO_GACH)
	else:
		draw_rect(body_rect, Palette.DO_RUOU)
	
	# Mắt đỏ gạch quái vật
	draw_rect(Rect2(-6, -4, 3, 3), Palette.DO_GACH)
	draw_rect(Rect2(3, -4, 3, 3), Palette.DO_GACH)
`

### scripts/player/egg_visual.gd
`gdscript
extends Node2D

# EggVisual: Quản lý hiệu ứng hình ảnh mở rộng trên người chơi
# 1. Vết nứt trên vỏ trứng (to dần theo lượng máu giảm)
# 2. Hiệu ứng văng mảnh vỏ (egg shell debris particles) khi trúng đòn
# 3. Vệt chém combo cận chiến

var attack_slash_timer: float = 0.0
var attack_slash_dir: Vector2 = Vector2.DOWN
var attack_slash_step: int = 0
var show_placeholder_body: bool = false

# Dữ liệu vết nứt vỏ trứng (tính theo tỉ lệ hp: 1.0 -> 0.0)
var current_hp_ratio: float = 1.0

# Danh sách mảnh vỏ đang văng: { pos: Vector2, vel: Vector2, color: Color, size: Vector2, life: float, max_life: float }
var shell_shards: Array[Dictionary] = []

func _ready() -> void:
	set_process(true)

func set_hp_ratio(ratio: float) -> void:
	current_hp_ratio = clampf(ratio, 0.0, 1.0)
	queue_redraw()

func spawn_shell_burst(amount: int = 6) -> void:
	# Bắn các mảnh vỏ trứng từ tâm thân nhân vật (y ~ -14)
	for i in range(amount):
		var angle := randf_range(0.0, TAU)
		var speed := randf_range(40.0, 110.0)
		var vel := Vector2(cos(angle), sin(angle)) * speed
		vel.y -= randf_range(20.0, 50.0) # Văng hướng lên trên nhẹ
		
		var colors := [Palette.GIAY_DA, Palette.CAT, Palette.NAU_HAM, Palette.KEM]
		var col: Color = colors[randi() % colors.size()]
		var sz := Vector2(randf_range(1.5, 3.0), randf_range(1.5, 3.0))
		var life := randf_range(0.3, 0.55)
		
		shell_shards.append({
			"pos": Vector2(randf_range(-4.0, 4.0), randf_range(-18.0, -10.0)),
			"vel": vel,
			"color": col,
			"size": sz,
			"life": life,
			"max_life": life
		})
	queue_redraw()

func start_attack_visual(dir: Vector2, step: int) -> void:
	attack_slash_dir = dir
	attack_slash_step = step
	attack_slash_timer = 0.18
	queue_redraw()

func _process(delta: float) -> void:
	var needs_redraw: bool = false
	
	if attack_slash_timer > 0.0:
		attack_slash_timer -= delta
		needs_redraw = true
	
	if not shell_shards.is_empty():
		var idx := shell_shards.size() - 1
		while idx >= 0:
			var shard: Dictionary = shell_shards[idx]
			shard["life"] -= delta
			if shard["life"] <= 0.0:
				shell_shards.remove_at(idx)
			else:
				shard["pos"] += shard["vel"] * delta
				shard["vel"].y += 220.0 * delta # Trọng lực rơi xuống
			idx -= 1
		needs_redraw = true
	
	if needs_redraw:
		queue_redraw()

func _draw() -> void:
	# 1. Vẽ các vết nứt trên vỏ theo mức độ mất máu
	# Nhân vật cao từ y = -22 đến y = -2, tâm khoảng x=0, y=-12
	# Khi HP < 80%: Bắt đầu có vết rạn nhỏ ở đỉnh
	# Khi HP < 50%: Nứt to và rẽ nhánh
	# Khi HP < 25%: Nứt chằng chịt, lộ lòng vàng nhẹ
	if current_hp_ratio < 0.8:
		# Vết nứt đỉnh đầu (giai đoạn 1)
		draw_line(Vector2(-1, -22), Vector2(1, -19), Palette.NAU_HAM, 1.0)
		draw_line(Vector2(1, -19), Vector2(0, -17), Palette.NAU_HAM, 1.0)
	
	if current_hp_ratio < 0.6:
		# Nhánh nứt kéo dài qua thân trên (giai đoạn 2)
		draw_line(Vector2(0, -17), Vector2(3, -14), Palette.NAU_HAM, 1.0)
		draw_line(Vector2(3, -14), Vector2(2, -11), Palette.NAU_HAM, 1.0)
		# Vết nứt sườn trái
		draw_line(Vector2(-5, -17), Vector2(-2, -15), Palette.NAU_HAM, 1.0)
		draw_line(Vector2(-2, -15), Vector2(-4, -12), Palette.NAU_HAM, 1.0)
	
	if current_hp_ratio < 0.35:
		# Vết nứt to toác (giai đoạn 3)
		draw_line(Vector2(2, -11), Vector2(5, -8), Palette.NAU_HAM, 1.2)
		draw_line(Vector2(-4, -12), Vector2(-2, -8), Palette.NAU_HAM, 1.2)
		draw_line(Vector2(0, -17), Vector2(-2, -14), Palette.CAT, 1.0)
		# Chấm vàng lộ lòng trứng bên trong kẽ nứt
		draw_rect(Rect2(0, -15, 2, 2), Palette.VANG_CO)
		draw_rect(Rect2(2, -12, 1, 2), Palette.VANG_CO)
	
	# 2. Vẽ các mảnh vỏ trứng đang văng khi dính đòn
	for shard in shell_shards:
		var alpha: float = clampf(shard["life"] / shard["max_life"], 0.0, 1.0)
		var c: Color = shard["color"]
		c.a = alpha
		var sz: Vector2 = shard["size"]
		var p: Vector2 = shard["pos"]
		draw_rect(Rect2(p.x - sz.x * 0.5, p.y - sz.y * 0.5, sz.x, sz.y), c)
	
	# 3. Vệt chém combo đòn đánh cận chiến
	if attack_slash_timer > 0.0:
		var slash_center := Vector2(0, -10) + attack_slash_dir.normalized() * 14.0
		var slash_color: Color = Palette.KEM if attack_slash_step == 2 else Palette.XAM_DA
		var arc_radius: float = 12.0 if attack_slash_step == 2 else 9.0
		var base_angle: float = attack_slash_dir.angle()
		var start_ang: float = base_angle - PI * 0.45
		var end_ang: float = base_angle + PI * 0.45
		draw_arc(slash_center, arc_radius, start_ang, end_ang, 12, slash_color, 2.0)
		draw_arc(slash_center, arc_radius - 2.0, start_ang, end_ang, 12, Palette.NAU_HAM, 1.0)
`

### scripts/player/player.gd
`gdscript
extends CharacterBody2D
class_name Player

# Player: Nhân vật Trứng trong game "Vỡ Vỏ"
# Đầy đủ cơ chế:
# - Di chuyển 8 hướng theo tốc độ từ stats.json
# - Lăn né tiêu hao Stamina, i-frame 0.25s, chặn né khi thiếu thể lực
# - Hệ thống tấn công cận chiến Combo 3 đòn theo facing_direction (Điểm 2, 3)
# - AnimatedSprite2D nạp SpriteFrames từ animations.json, bật/tắt Hitbox qua frame_changed (Điểm 4)
# - Kích thước Collision 10x6 sát chân, Hurtbox 10x14 giữa thân từ stats.json (Điểm 5)

signal hp_changed(new_hp: int, max_hp: int)
signal stamina_changed(new_stamina: float, max_stamina: float)
signal player_died()
signal player_respawned()
signal combo_stepped(current_step: int)

@onready var visual_node: Node2D = $EggVisual
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hurtbox: Area2D = $Hurtbox
@onready var attack_hitbox: Area2D = $AttackHitbox
@onready var attack_hitbox_shape: CollisionShape2D = $AttackHitbox/CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Chỉ số từ stats.json
var max_hp: int = 100
var current_hp: int = 100
var max_stamina: float = 100.0
var current_stamina: float = 100.0

var move_speed: float = 95.0
var dodge_speed_multiplier: float = 1.85
var dodge_duration: float = 0.25
var dodge_cooldown: float = 0.2
var dodge_stamina_cost: float = 20.0
var stamina_recovery_rate: float = 30.0
var stamina_recovery_delay: float = 0.35

# Thông số combo cận chiến từ stats.json
var attack_combo_damage: Array = [15, 18, 28]
var attack_cooldowns: Array = [0.15, 0.15, 0.45]
var combo_window: float = 0.55
var attack_stamina_costs: Array = [10.0, 12.0, 18.0]

# Trạng thái di chuyển & né
var facing_direction: Vector2 = Vector2.DOWN
var is_dodging: bool = false
var is_invulnerable: bool = false
var can_dodge: bool = true
var is_dead: bool = false

var dodge_timer: float = 0.0
var dodge_cooldown_timer: float = 0.0
var stamina_delay_timer: float = 0.0
var dodge_direction: Vector2 = Vector2.ZERO

# Trạng thái combo tấn công
var is_attacking: bool = false
var can_attack: bool = true
var combo_step: int = 0 # 0, 1, 2 tương ứng 3 đòn
var attack_cooldown_timer: float = 0.0
var combo_window_timer: float = 0.0
var already_hit_enemies: Array[Node] = []
var accumulated_melee_damage: int = 0

# Hoạt ảnh và hit_frames
var animations_config: Dictionary = {}
var current_hit_frames: Array = []
var is_in_hit_frame: bool = false
var is_hurt: bool = false   # đang phát hurt animation → block update_animations

var spawn_position: Vector2 = Vector2.ZERO
var respawn_timer: float = 0.0
var flash_timer: float = 0.0

func _ready() -> void:
	load_stats_from_data()
	setup_animations()
	spawn_position = global_position
	current_hp = max_hp
	current_stamina = max_stamina
	hp_changed.emit(current_hp, max_hp)
	stamina_changed.emit(current_stamina, max_stamina)
	
	if attack_hitbox != null:
		attack_hitbox.monitoring = true
		attack_hitbox.monitorable = false
		attack_hitbox.area_entered.connect(_on_attack_hitbox_area_entered)
	
	if animated_sprite != null:
		animated_sprite.frame_changed.connect(_on_sprite_frame_changed)
		animated_sprite.animation_finished.connect(_on_sprite_animation_finished)
	
	update_animations()

func load_stats_from_data() -> void:
	max_hp = int(GameData.get_stat("player", "max_hp", 100))
	max_stamina = float(GameData.get_stat("player", "max_stamina", 100.0))
	move_speed = float(GameData.get_stat("player", "move_speed", 95.0))
	dodge_speed_multiplier = float(GameData.get_stat("player", "dodge_speed_multiplier", 1.85))
	dodge_duration = float(GameData.get_stat("player", "dodge_duration", 0.25))
	dodge_cooldown = float(GameData.get_stat("player", "dodge_cooldown", 0.2))
	dodge_stamina_cost = float(GameData.get_stat("player", "dodge_stamina_cost", 20.0))
	stamina_recovery_rate = float(GameData.get_stat("player", "stamina_recovery_rate", 30.0))
	stamina_recovery_delay = float(GameData.get_stat("player", "stamina_recovery_delay", 0.35))
	
	attack_combo_damage = GameData.get_stat("player", "attack_combo_damage", [15, 18, 28])
	attack_cooldowns = GameData.get_stat("player", "attack_cooldowns", [0.15, 0.15, 0.45])
	combo_window = float(GameData.get_stat("player", "combo_window", 0.55))
	attack_stamina_costs = GameData.get_stat("player", "attack_stamina_costs", [10.0, 12.0, 18.0])
	
	# Nạp kích thước Collision & Hurtbox từ stats.json (Điểm 5)
	var col_size: Array = GameData.get_stat("player", "collision_size", [10.0, 6.0])
	var col_offset: Array = GameData.get_stat("player", "collision_offset", [0.0, -3.0])
	var hurt_size: Array = GameData.get_stat("player", "hurtbox_size", [10.0, 14.0])
	var hurt_offset: Array = GameData.get_stat("player", "hurtbox_offset", [0.0, -10.0])
	
	if collision_shape != null:
		var col_rect := RectangleShape2D.new()
		col_rect.size = Vector2(col_size[0], col_size[1])
		collision_shape.shape = col_rect
		collision_shape.position = Vector2(col_offset[0], col_offset[1])
	
	if hurtbox != null:
		var hurt_col: CollisionShape2D = hurtbox.get_node_or_null("CollisionShape2D")
		if hurt_col != null:
			var hurt_rect := RectangleShape2D.new()
			hurt_rect.size = Vector2(hurt_size[0], hurt_size[1])
			hurt_col.shape = hurt_rect
			hurt_col.position = Vector2(hurt_offset[0], hurt_offset[1])

func setup_animations() -> void:
	var anim_path := "res://assets/sprites/player/animations.json"
	if FileAccess.file_exists(anim_path):
		var file := FileAccess.open(anim_path, FileAccess.READ)
		if file != null:
			var json := JSON.new()
			if json.parse(file.get_as_text()) == OK and json.data is Dictionary:
				if json.data.has("player_egg") and json.data["player_egg"].has("animations"):
					animations_config = json.data["player_egg"]["animations"]
	
	var sprite_frames := SpriteFrames.new()
	for anim_name in animations_config:
		var cfg: Dictionary = animations_config[anim_name]
		var frame_count: int = int(cfg.get("frames", 4))
		var fps: float = float(cfg.get("fps", 12))
		var loop: bool = bool(cfg.get("loop", true))
		
		sprite_frames.add_animation(anim_name)
		sprite_frames.set_animation_speed(anim_name, fps)
		sprite_frames.set_animation_loop(anim_name, loop)
		
		var file_name: String = str(cfg.get("file", ""))
		var full_img_path := "res://assets/sprites/player/" + file_name
		
		if ResourceLoader.exists(full_img_path):
			var texture: Texture2D = load(full_img_path)
			for i in range(frame_count):
				var atlas := AtlasTexture.new()
				atlas.atlas = texture
				atlas.region = Rect2(i * 32, 0, 32, 32)
				sprite_frames.add_frame(anim_name, atlas)
		else:
			var img := Image.create(32, 32, false, Image.FORMAT_RGBA8)
			var placeholder_tex := ImageTexture.create_from_image(img)
			for i in range(frame_count):
				sprite_frames.add_frame(anim_name, placeholder_tex)
	
	animated_sprite.sprite_frames = sprite_frames
	animated_sprite.offset = Vector2(0, -16)

func _physics_process(delta: float) -> void:
	if is_dead:
		process_death(delta)
		return
	
	process_cooldowns(delta)
	process_input_and_movement(delta)
	process_stamina(delta)
	process_visual_effects(delta)
	update_animations()
	
	if is_attacking and is_in_hit_frame:
		check_melee_overlaps()

func update_animations() -> void:
	if is_dead:
		return
	
	# Ẩn hoàn toàn hình khối tạm – sprite đã đủ
	if visual_node != null and "show_placeholder_body" in visual_node:
		visual_node.show_placeholder_body = false
	animated_sprite.visible = true
	
	if is_attacking:
		return  # hoạt ảnh attack đã được bật trong try_attack()
	
	var dir_suffix := get_direction_suffix(facing_direction)
	var flip_left: bool = (facing_direction.x < 0 and abs(facing_direction.x) >= abs(facing_direction.y))
	animated_sprite.flip_h = flip_left
	
	if is_dodging:
		var roll_anim := "roll_" + dir_suffix
		if animated_sprite.animation != roll_anim or not animated_sprite.is_playing():
			animated_sprite.play(roll_anim)
		return
	
	if velocity == Vector2.ZERO:
		var anim_name := "idle_" + dir_suffix
		if animated_sprite.animation != anim_name or not animated_sprite.is_playing():
			animated_sprite.play(anim_name)
	else:
		var run_anim := "run_" + dir_suffix
		if animated_sprite.animation != run_anim or not animated_sprite.is_playing():
			animated_sprite.play(run_anim)

func process_cooldowns(delta: float) -> void:
	if dodge_cooldown_timer > 0.0:
		dodge_cooldown_timer -= delta
		if dodge_cooldown_timer <= 0.0:
			can_dodge = true
	
	if attack_cooldown_timer > 0.0:
		attack_cooldown_timer -= delta
		if attack_cooldown_timer <= 0.0:
			can_attack = true
	
	if combo_window_timer > 0.0:
		combo_window_timer -= delta
		if combo_window_timer <= 0.0 and not is_attacking:
			combo_step = 0
	
	if stamina_delay_timer > 0.0:
		stamina_delay_timer -= delta

func process_input_and_movement(delta: float) -> void:
	if is_dodging:
		dodge_timer -= delta
		velocity = dodge_direction * (move_speed * dodge_speed_multiplier)
		move_and_slide()
		if dodge_timer <= 0.0:
			end_dodge()
		return
	
	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	var input_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector != Vector2.ZERO:
		facing_direction = input_vector.normalized()
		velocity = input_vector * move_speed
		stamina_delay_timer = maxf(stamina_delay_timer, stamina_recovery_delay)
	else:
		velocity = Vector2.ZERO
	
	if Input.is_action_just_pressed("attack"):
		try_attack()
	
	if Input.is_action_just_pressed("dodge"):
		try_dodge(input_vector)
	
	move_and_slide()

func try_attack() -> void:
	if is_attacking or is_dodging or not can_attack:
		return
	
	var cost: float = float(attack_stamina_costs[combo_step])
	if current_stamina < cost:
		print("[PLAYER] Không đủ Stamina để tấn công đòn %d! (Cần %.1f, có %.1f)" % [combo_step + 1, cost, current_stamina])
		return
	
	current_stamina -= cost
	stamina_changed.emit(current_stamina, max_stamina)
	stamina_delay_timer = stamina_recovery_delay
	
	is_attacking = true
	can_attack = false
	already_hit_enemies.clear()
	combo_stepped.emit(combo_step)
	
	var dir_suffix := get_direction_suffix(facing_direction)
	var anim_name := "attack_" + dir_suffix
	var flip_left: bool = (facing_direction.x < 0 and abs(facing_direction.x) >= abs(facing_direction.y))
	
	animated_sprite.flip_h = flip_left
	update_attack_hitbox_transform(dir_suffix, flip_left)
	
	if animations_config.has(anim_name):
		current_hit_frames = animations_config[anim_name].get("hit_frames", [2])
	else:
		current_hit_frames = [2]
	
	is_in_hit_frame = false
	animated_sprite.play(anim_name)
	print("[PLAYER] Tung đòn combo %d/3! Sát thương: %d, Hướng: %s, Tiêu hao: %.1f Stamina" % [
		combo_step + 1, attack_combo_damage[combo_step], dir_suffix, cost
	])
	
	if visual_node != null and visual_node.has_method("start_attack_visual"):
		visual_node.start_attack_visual(facing_direction, combo_step)

func _on_sprite_frame_changed() -> void:
	if not is_attacking:
		return
	
	var cur_frame: int = animated_sprite.frame
	if cur_frame in current_hit_frames:
		is_in_hit_frame = true
		check_melee_overlaps()
	else:
		is_in_hit_frame = false

func _on_sprite_animation_finished() -> void:
	if is_attacking:
		end_attack()

func end_attack() -> void:
	is_attacking = false
	is_in_hit_frame = false
	
	attack_cooldown_timer = float(attack_cooldowns[combo_step])
	
	if combo_step < 2:
		combo_step += 1
		combo_window_timer = combo_window
	else:
		combo_step = 0
		combo_window_timer = 0.0

func update_attack_hitbox_transform(dir_suffix: String, flip_left: bool) -> void:
	match dir_suffix:
		"down":
			attack_hitbox.position = Vector2(0, 6)
		"up":
			attack_hitbox.position = Vector2(0, -24)
		"side":
			if flip_left:
				attack_hitbox.position = Vector2(-16, -10)
			else:
				attack_hitbox.position = Vector2(16, -10)

func check_melee_overlaps() -> void:
	var areas := attack_hitbox.get_overlapping_areas()
	for area in areas:
		_process_hit_target(area)

func _on_attack_hitbox_area_entered(area: Area2D) -> void:
	if is_in_hit_frame:
		_process_hit_target(area)

func _process_hit_target(area: Area2D) -> void:
	var target: Node = area.get_parent()
	if target != null and target != self and not target in already_hit_enemies:
		if target.has_method("receive_hit"):
			already_hit_enemies.append(target)
			var dmg: int = int(attack_combo_damage[combo_step])
			target.receive_hit(dmg, self)
			print("[COMBAT] Đòn %d đánh trúng kẻ thù! Gây %d sát thương." % [combo_step + 1, dmg])
			
			accumulated_melee_damage += dmg
			if accumulated_melee_damage >= 10:
				var guard_pts := accumulated_melee_damage / 10
				accumulated_melee_damage = accumulated_melee_damage % 10
				BehaviorTracker.add_points(BehaviorTracker.ACTION_GUARD, guard_pts)

func get_direction_suffix(dir: Vector2) -> String:
	if abs(dir.x) >= abs(dir.y):
		return "side"
	elif dir.y > 0:
		return "down"
	else:
		return "up"

func try_dodge(input_vector: Vector2) -> void:
	if not can_dodge or is_dodging or is_attacking:
		return
	
	if current_stamina < dodge_stamina_cost:
		print("[PLAYER] Không đủ Stamina để lăn né! (Cần %.1f, có %.1f)" % [dodge_stamina_cost, current_stamina])
		return
	
	current_stamina -= dodge_stamina_cost
	stamina_changed.emit(current_stamina, max_stamina)
	stamina_delay_timer = stamina_recovery_delay
	
	is_dodging = true
	is_invulnerable = true
	can_dodge = false
	dodge_timer = dodge_duration
	
	if input_vector != Vector2.ZERO:
		dodge_direction = input_vector.normalized()
	else:
		dodge_direction = facing_direction
	
	print("[PLAYER] Lăn né! Khung bất tử: %.2fs, tốn %.1f Stamina" % [dodge_duration, dodge_stamina_cost])

func end_dodge() -> void:
	is_dodging = false
	is_invulnerable = false
	dodge_cooldown_timer = dodge_cooldown

func process_stamina(delta: float) -> void:
	if not is_dodging and not is_attacking and velocity == Vector2.ZERO and stamina_delay_timer <= 0.0:
		if current_stamina < max_stamina:
			current_stamina = minf(max_stamina, current_stamina + stamina_recovery_rate * delta)
			stamina_changed.emit(current_stamina, max_stamina)

var hurt_invulnerable_timer: float = 0.0

func process_visual_effects(delta: float) -> void:
	if hurt_invulnerable_timer > 0.0:
		hurt_invulnerable_timer -= delta
		if hurt_invulnerable_timer <= 0.0:
			is_invulnerable = false
	
	if flash_timer > 0.0:
		flash_timer -= delta
		if flash_timer <= 0.0:
			modulate = Color.WHITE

func receive_hit(damage: int, _attack_source: Node) -> Dictionary:
	if is_dead:
		return {"hit": false, "dodged": false}
	
	if is_invulnerable:
		if is_dodging:
			print("[COMBAT] Né thành công đòn đánh! +2 điểm DODGE")
			BehaviorTracker.add_points(BehaviorTracker.ACTION_DODGE, 2)
			return {"hit": false, "dodged": true}
		else:
			# Đang trong thời gian chớp miễn nhiễm sau khi bị thương (i-frame)
			return {"hit": false, "dodged": false}
	
	current_hp = maxi(0, current_hp - damage)
	hp_changed.emit(current_hp, max_hp)
	print("[COMBAT] Player nhận %d sát thương! HP còn: %d/%d" % [damage, current_hp, max_hp])
	
	# Cập nhật tỉ lệ máu cho EggVisual để vẽ vết nứt to dần
	if visual_node != null and visual_node.has_method("set_hp_ratio"):
		visual_node.set_hp_ratio(float(current_hp) / float(maxi(1, max_hp)))
	
	# Bắn hiệu ứng mảnh vỏ văng tung tóe
	if visual_node != null and visual_node.has_method("spawn_shell_burst"):
		visual_node.spawn_shell_burst(7)
	
	if current_hp <= 0:
		die()
		return {"hit": true, "dodged": false}
	
	# Khung bất tử ngắn (i-frame 0.25s) và chớp đỏ phản hồi trúng đòn
	is_invulnerable = true
	hurt_invulnerable_timer = 0.25
	flash_timer = 0.18
	modulate = Palette.DO_GACH
	
	return {"hit": true, "dodged": false}

func die() -> void:
	is_dead = true
	is_hurt = false
	velocity = Vector2.ZERO
	is_dodging = false
	is_invulnerable = false
	is_attacking = false
	combo_step = 0
	respawn_timer = 1.5
	modulate = Color.WHITE
	print("[PLAYER] VỎ ĐÃ VỠ... Bắt đầu chuẩn bị hồi sinh.")
	
	# Phát death animation
	var dir_suffix := get_direction_suffix(facing_direction)
	var death_anim := "death_" + dir_suffix
	if animated_sprite != null and animations_config.has(death_anim):
		animated_sprite.play(death_anim)
	
	player_died.emit()

func process_death(delta: float) -> void:
	respawn_timer -= delta
	if respawn_timer <= 0.0:
		respawn()

func respawn() -> void:
	global_position = spawn_position
	current_hp = max_hp
	current_stamina = max_stamina
	is_dead = false
	is_hurt = false
	is_dodging = false
	is_invulnerable = false
	hurt_invulnerable_timer = 0.0
	is_attacking = false
	can_dodge = true
	can_attack = true
	combo_step = 0
	dodge_cooldown_timer = 0.0
	attack_cooldown_timer = 0.0
	modulate = Color.WHITE
	if visual_node != null and visual_node.has_method("set_hp_ratio"):
		visual_node.set_hp_ratio(1.0)
	hp_changed.emit(current_hp, max_hp)
	stamina_changed.emit(current_stamina, max_stamina)
	print("[PLAYER] Trứng đã hồi sinh tại điểm bắt đầu!")
	player_respawned.emit()
`

### scripts/ui/hud.gd
`gdscript
extends CanvasLayer

# HUD hiển thị máu, thể lực và thông báo tạm thời.
# Toàn bộ màu sắc lấy trực tiếp từ Palette (GDD Mục 3).

@onready var hp_bar_fill: ColorRect = $MarginContainer/VBoxContainer/HPBar/Fill
@onready var hp_bar_bg: ColorRect = $MarginContainer/VBoxContainer/HPBar/Background
@onready var stamina_bar_fill: ColorRect = $MarginContainer/VBoxContainer/StaminaBar/Fill
@onready var stamina_bar_bg: ColorRect = $MarginContainer/VBoxContainer/StaminaBar/Background
@onready var debug_label: Label = $MarginContainer/VBoxContainer/DebugDodgeLabel
@onready var death_overlay: Control = $DeathOverlay

var max_hp: int = 100
var current_hp: int = 100
var max_stamina: float = 100.0
var current_stamina: float = 100.0

var hp_bar_max_width: float = 64.0
var stamina_bar_max_width: float = 52.0

var show_debug_dodge: bool = false

func _ready() -> void:
	apply_palette()
	# Nạp cờ debug từ stats.json
	show_debug_dodge = bool(GameData.get_stat("debug", "show_dodge_debug", false))
	update_debug_display()
	death_overlay.visible = false
	
	BehaviorTracker.points_changed.connect(_on_behavior_points_changed)

func apply_palette() -> void:
	# Màu sắc chuẩn GDD Mục 3
	hp_bar_bg.color = Palette.NAU_HAM
	hp_bar_fill.color = Palette.DO_GACH
	
	stamina_bar_bg.color = Palette.NAU_HAM
	stamina_bar_fill.color = Palette.XANH_LA_UA
	
	debug_label.add_theme_color_override("font_color", Palette.KEM)
	
	var death_label: Label = $DeathOverlay/CenterContainer/VBoxContainer/DeathLabel
	death_label.add_theme_color_override("font_color", Palette.DO_GACH)
	var death_sub: Label = $DeathOverlay/CenterContainer/VBoxContainer/SubLabel
	death_sub.add_theme_color_override("font_color", Palette.KEM)
	var death_panel: ColorRect = $DeathOverlay/CenterContainer/VBoxContainer/PanelBg
	death_panel.color = Palette.NAU_HAM

func _unhandled_key_input(event: InputEvent) -> void:
	# Bật/tắt nhãn debug DODGE bằng phím F3
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F3:
			show_debug_dodge = not show_debug_dodge
			update_debug_display()

func update_hp(new_hp: int, new_max_hp: int) -> void:
	current_hp = new_hp
	max_hp = new_max_hp
	var ratio: float = clampf(float(current_hp) / float(maxi(1, max_hp)), 0.0, 1.0)
	hp_bar_fill.size.x = hp_bar_max_width * ratio

func update_stamina(new_stamina: float, new_max_stamina: float) -> void:
	current_stamina = new_stamina
	max_stamina = new_max_stamina
	var ratio: float = clampf(current_stamina / maxf(1.0, max_stamina), 0.0, 1.0)
	stamina_bar_fill.size.x = stamina_bar_max_width * ratio

func _on_behavior_points_changed(action_name: String, _new_points: int, _total: int) -> void:
	if action_name == BehaviorTracker.ACTION_DODGE:
		update_debug_display()

func update_debug_display() -> void:
	debug_label.visible = show_debug_dodge
	if show_debug_dodge:
		debug_label.text = "[DEBUG F3] DODGE: %d" % BehaviorTracker.get_points(BehaviorTracker.ACTION_DODGE)

func show_death_screen(show_it: bool) -> void:
	death_overlay.visible = show_it
`
