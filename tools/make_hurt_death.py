"""
Generate Hurt (5 frames) and Death (7 frames) pixel art sprites for player egg.
Based on reference image. Uses 32x32 pixels per frame.
"""
import sys, io, os
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

from PIL import Image, ImageDraw

FRAME = 32
OUT_DIR  = "assets/sprites/player"
PREV_DIR = r"C:/Users/behoa/.gemini/antigravity/brain/62492e13-e916-43f0-bd2c-66b632ffed5c"
SCALE    = 5   # preview scale

# ─────────────────────────────────────────────
#  Palette (16 màu cố định)
# ─────────────────────────────────────────────
C = {
    "trans":   (0,   0,   0,   0),
    "black":   (20,  14,  26,  255),
    "shell1":  (210, 178, 128, 255),   # vỏ sáng
    "shell2":  (180, 148, 98,  255),   # vỏ trung
    "shell3":  (140, 108, 68,  255),   # vỏ tối
    "crack":   (80,  54,  30,  255),   # vết nứt
    "white_e": (240, 230, 200, 255),   # lòng trắng trứng
    "yolk1":   (255, 190, 30,  255),   # lòng đỏ sáng
    "yolk2":   (220, 140, 10,  255),   # lòng đỏ tối
    "eye_w":   (245, 245, 245, 255),   # tròng mắt trắng
    "eye_b":   (30,  14,  50,  255),   # con ngươi
    "cross":   (40,  10,  10,  255),   # mắt X (chết)
    "red":     (180, 30,  40,  255),   # má đỏ
    "shine1":  (255, 240, 100, 255),   # tia sáng 1
    "shine2":  (255, 200, 50,  255),   # tia sáng 2
    "white2":  (255, 255, 255, 255),   # trắng thuần
}

def new_frame():
    return Image.new("RGBA", (FRAME, FRAME), C["trans"])

def draw_egg_body(d, cx=16, cy=18, rx=9, ry=10, top_bias=2):
    """Vẽ thân trứng tròn."""
    for x in range(cx-rx-1, cx+rx+2):
        for y in range(cy-ry-top_bias-1, cy+ry+2):
            dx = (x - cx) / rx
            dy = (y - (cy - top_bias/2)) / ry
            dist = dx*dx + dy*dy
            if dist <= 1.0:
                if dist < 0.5:
                    d.point((x, y), C["shell1"])
                elif dist < 0.75:
                    d.point((x, y), C["shell2"])
                else:
                    d.point((x, y), C["shell3"])

def draw_eyes_normal(d, cx=16, cy=15):
    """Mắt tròn bình thường."""
    for ox in [-4, 3]:
        ex, ey = cx+ox, cy
        d.ellipse([ex-2, ey-2, ex+2, ey+2], fill=C["eye_w"])
        d.point((ex, ey), C["eye_b"])
    # Má đỏ
    for ox in [-5, 4]:
        d.point((cx+ox, cy+2), C["red"])

def draw_eyes_hurt(d, cx=16, cy=15):
    """Mắt choáng (nửa nhắm)."""
    for ox in [-4, 3]:
        ex, ey = cx+ox, cy
        d.ellipse([ex-2, ey-1, ex+2, ey+2], fill=C["eye_w"])
        d.point((ex, ey+1), C["eye_b"])
    d.line([(cx-6, cy-1), (cx-2, cy-1)], fill=C["black"], width=1)
    d.line([(cx+2, cy-1), (cx+5, cy-1)], fill=C["black"], width=1)

def draw_eyes_dead(d, cx=16, cy=16):
    """Mắt X (chết)."""
    for ox in [-4, 3]:
        ex, ey = cx+ox, cy
        d.line([(ex-2, ey-2), (ex+2, ey+2)], fill=C["cross"], width=1)
        d.line([(ex+2, ey-2), (ex-2, ey+2)], fill=C["cross"], width=1)

def draw_legs(d, cx=16, bot=27):
    """Chân nhỏ."""
    d.rectangle([cx-5, bot, cx-3, bot+2], fill=C["shell3"])
    d.rectangle([cx+2, bot, cx+4, bot+2], fill=C["shell3"])

def draw_crack_small(d, cx=16, cy=14):
    """Vết nứt nhỏ trên đầu."""
    d.line([(cx-1, cy-3), (cx, cy), (cx+2, cy+3)], fill=C["crack"], width=1)

def draw_crack_big(d, cx=16, cy=12):
    """Vết nứt lớn + tia sáng."""
    d.line([(cx-2, cy-5), (cx, cy-1), (cx+3, cy+4)], fill=C["crack"], width=1)
    d.line([(cx-4, cy-2), (cx-1, cy+1)], fill=C["crack"], width=1)
    # Tia sáng
    for pts in [[(cx-1, cy-7), (cx-3, cy-9)],
                [(cx,   cy-7), (cx,   cy-10)],
                [(cx+1, cy-7), (cx+3, cy-9)]]:
        d.line(pts, fill=C["shine1"], width=1)

def draw_yolk_drip(d, cx=16, start_y=20):
    """Lòng đỏ chảy ra."""
    d.ellipse([cx-3, start_y-3, cx+3, start_y+3], fill=C["yolk1"])
    d.ellipse([cx-2, start_y+2, cx+2, start_y+8], fill=C["yolk2"])
    # Lòng trắng chảy hai bên
    d.ellipse([cx-8, start_y, cx-3, start_y+5], fill=C["white_e"])
    d.ellipse([cx+3, start_y, cx+8, start_y+5], fill=C["white_e"])

def draw_shell_pieces(d, cx=16, cy=20, num=5, size=3):
    """Vảnh vỡ nhỏ xung quanh."""
    import math
    for i in range(num):
        angle = math.radians(360 / num * i)
        px = int(cx + math.cos(angle) * 12)
        py = int(cy + math.sin(angle) * 8)
        d.rectangle([px, py, px+size, py+size], fill=C["shell2"])

# ══════════════════════════════════════════════
#  HURT frames (5 khung, nhân vật luôn đứng)
# ══════════════════════════════════════════════
hurt_frames = []

# Khung 1: Bình thường
f = new_frame(); d = ImageDraw.Draw(f)
draw_egg_body(d)
draw_eyes_normal(d)
draw_legs(d)
hurt_frames.append(f)

# Khung 2: Xuất hiện vết nứt lớn + tia sáng
f = new_frame(); d = ImageDraw.Draw(f)
draw_egg_body(d)
draw_crack_big(d)
draw_eyes_normal(d, cy=16)
draw_legs(d)
hurt_frames.append(f)

# Khung 3: Nứt to, lộ lòng vàng và lòng trắng
f = new_frame(); d = ImageDraw.Draw(f)
draw_egg_body(d)
draw_crack_big(d)
draw_yolk_drip(d, cx=16, start_y=19)
draw_eyes_normal(d, cy=16)
draw_legs(d)
hurt_frames.append(f)

# Khung 4: Vỡ thêm, chảy trứng nhiều hơn
f = new_frame(); d = ImageDraw.Draw(f)
draw_egg_body(d, ry=9)
draw_crack_big(d, cy=11)
draw_yolk_drip(d, cx=16, start_y=18)
draw_shell_pieces(d, num=6, size=2)
draw_eyes_hurt(d, cy=16)
draw_legs(d)
hurt_frames.append(f)

# Khung 5: Kết thúc bị thương (trạng thái choáng)
f = new_frame(); d = ImageDraw.Draw(f)
draw_egg_body(d)
draw_crack_small(d)
draw_eyes_hurt(d)
# Dấu * choáng
d.text((8, 5), "*", fill=C["shine1"])
d.text((20, 4), "*", fill=C["shine2"])
draw_legs(d)
hurt_frames.append(f)

# ══════════════════════════════════════════════
#  DEATH frames (7 khung)
# ══════════════════════════════════════════════
death_frames = []

# Khung 1: Bắt đầu vỡ vỏ, mắt X
f = new_frame(); d = ImageDraw.Draw(f)
draw_egg_body(d)
draw_crack_small(d)
draw_eyes_dead(d, cy=15)
draw_legs(d)
# Dấu * quanh đầu
for ox, oy in [(-8, 8), (8, 6), (-6, 4), (7, 10)]:
    d.point((16+ox, oy), C["shine1"])
death_frames.append(f)

# Khung 2: Vỡ nứt to
f = new_frame(); d = ImageDraw.Draw(f)
draw_egg_body(d, ry=9)
draw_crack_big(d, cy=13)
draw_eyes_dead(d, cy=16)
draw_legs(d)
death_frames.append(f)

# Khung 3: Vỡ hoàn toàn, đầu bật lên
f = new_frame(); d = ImageDraw.Draw(f)
# Phần dưới (lòng trắng + vàng đổ ra)
d.ellipse([5, 18, 27, 30], fill=C["white_e"])
d.ellipse([10, 19, 22, 27], fill=C["yolk1"])
# Mảnh vỏ trên (bật lên)
d.arc([8, 4, 24, 16], start=200, end=340, fill=C["shell2"], width=4)
draw_eyes_dead(d, cx=16, cy=9)
# Vảnh bay
draw_shell_pieces(d, cx=16, cy=16, num=7, size=2)
death_frames.append(f)

# Khung 4: Ngã xuống — trứng nằm ngang
f = new_frame(); d = ImageDraw.Draw(f)
# Lòng trắng loang rộng
d.ellipse([3, 19, 29, 30], fill=C["white_e"])
# Lòng đỏ ở giữa
d.ellipse([11, 19, 21, 27], fill=C["yolk1"])
d.ellipse([13, 20, 19, 25], fill=C["yolk2"])
# Mảnh vỏ rải rác
for px, py in [(4,16),(6,18),(22,17),(25,19),(14,15),(18,16)]:
    d.rectangle([px, py, px+2, py+2], fill=C["shell2"])
death_frames.append(f)

# Khung 5: Tan dần — ít mảnh hơn
f = new_frame(); d = ImageDraw.Draw(f)
d.ellipse([5, 20, 27, 30], fill=C["white_e"])
d.ellipse([12, 21, 20, 28], fill=C["yolk1"])
for px, py in [(5,17),(23,18),(14,16)]:
    d.rectangle([px, py, px+2, py+2], fill=C["shell3"])
death_frames.append(f)

# Khung 6: Chỉ còn vỏ + vũng lòng
f = new_frame(); d = ImageDraw.Draw(f)
d.ellipse([7, 22, 25, 30], fill=C["white_e"])
d.ellipse([13, 22, 19, 27], fill=C["yolk2"])
for px, py in [(8,19),(22,20)]:
    d.rectangle([px, py, px+2, py+1], fill=C["shell3"])
death_frames.append(f)

# Khung 7: Biến mất — vết loang mờ
f = new_frame(); d = ImageDraw.Draw(f)
d.ellipse([9, 24, 23, 30], fill=(*C["white_e"][:3], 120))
death_frames.append(f)

# ══════════════════════════════════════════════
#  Xuất file strip + preview
# ══════════════════════════════════════════════
def save_strip(frames, name):
    n = len(frames)
    strip = Image.new("RGBA", (FRAME * n, FRAME), C["trans"])
    prev  = Image.new("RGB",  (FRAME * n * SCALE, FRAME * SCALE), (15, 15, 25))
    for i, fr in enumerate(frames):
        strip.paste(fr, (i * FRAME, 0))
        big = fr.resize((FRAME * SCALE, FRAME * SCALE), Image.NEAREST)
        bg  = Image.new("RGBA", big.size, (15, 15, 25, 255))
        bg.paste(big, mask=big)
        prev.paste(bg.convert("RGB"), (i * FRAME * SCALE, 0))

    out = os.path.join(OUT_DIR, f"player_egg_{name}.png")
    strip.save(out)
    print(f"[OK] {out}")

    pv = os.path.join(PREV_DIR, f"preview_{name}.png")
    prev.save(pv)
    print(f"[OK] preview_{name}.png")

save_strip(hurt_frames,  "hurt")
save_strip(death_frames, "death")
print("Done!")
