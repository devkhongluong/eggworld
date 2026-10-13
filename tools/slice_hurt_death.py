"""
Cắt trực tiếp từ ảnh mẫu Hurt+Death (1024x512).
Layout:
  Hàng trên (y=0..256):   5 khung Hurt  → mỗi ô ~204x256
  Hàng dưới (y=256..512): 7 khung Death → mỗi ô ~146x256
Resize về 32x32 NEAREST để giữ pixel art.
"""
import sys, io, os
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
from PIL import Image

SRC  = r"C:\Users\behoa\.gemini\antigravity\brain\62492e13-e916-43f0-bd2c-66b632ffed5c\.user_uploaded\media_1791881980635_236a4809.png"
OUT  = "assets/sprites/player"
PREV = r"C:/Users/behoa/.gemini/antigravity/brain/62492e13-e916-43f0-bd2c-66b632ffed5c"
FRAME = 32
SCALE = 5

src = Image.open(SRC).convert("RGBA")
W, H = src.size   # 1024 x 512
print(f"Source: {W}x{H}")

# ── Chia hàng (bỏ vùng chữ tiêu đề) ──────────
# Chữ "Hurt (bị thương)" chiếm y=30..70, sprite thật từ y=75..245
# Chữ "Death (chết)"     chiếm y=268..300, sprite thật từ y=300..490
ROW_HURT  = (75,  220)
ROW_DEATH = (320, 460)

HURT_COLS  = 5
DEATH_COLS = 7

def extract_strip(row_y0, row_y1, n_cols, name):
    row_h = row_y1 - row_y0
    cell_w = W // n_cols

    strip = Image.new("RGBA", (FRAME * n_cols, FRAME), (0, 0, 0, 0))
    prev  = Image.new("RGB",  (FRAME * n_cols * SCALE, FRAME * SCALE), (15, 15, 25))

    for col in range(n_cols):
        x0 = col * cell_w
        cell = src.crop((x0, row_y0, x0 + cell_w, row_y1))

        # Auto-crop vùng có nội dung (bỏ nền đen xung quanh)
        arr = cell.load()
        bbox = None
        for cx in range(cell.width):
            for cy in range(cell.height):
                r, g, b, a = arr[cx, cy]
                if r > 30 or g > 30 or b > 30:
                    if bbox is None:
                        bbox = [cx, cy, cx, cy]
                    else:
                        bbox[0] = min(bbox[0], cx)
                        bbox[1] = min(bbox[1], cy)
                        bbox[2] = max(bbox[2], cx)
                        bbox[3] = max(bbox[3], cy)

        if bbox:
            pad = 6
            x1c = max(0, bbox[0] - pad)
            y1c = max(0, bbox[1] - pad)
            x2c = min(cell.width,  bbox[2] + pad)
            y2c = min(cell.height, bbox[3] + pad)
            cell = cell.crop((x1c, y1c, x2c, y2c))

        # Xóa nền đen → trong suốt
        data = cell.load()
        for cx in range(cell.width):
            for cy in range(cell.height):
                r, g, b, a = data[cx, cy]
                if r < 25 and g < 25 and b < 25:
                    data[cx, cy] = (0, 0, 0, 0)

        # Resize về 32x32
        frame = cell.resize((FRAME, FRAME), Image.NEAREST)
        strip.paste(frame, (col * FRAME, 0))

        # Preview x5
        big = frame.resize((FRAME * SCALE, FRAME * SCALE), Image.NEAREST)
        bg  = Image.new("RGBA", big.size, (15, 15, 25, 255))
        bg.paste(big, mask=big)
        prev.paste(bg.convert("RGB"), (col * FRAME * SCALE, 0))

    out_path  = os.path.join(OUT, f"player_egg_{name}.png")
    prev_path = os.path.join(PREV, f"preview_{name}.png")
    strip.save(out_path)
    prev.save(prev_path)
    print(f"[OK] {name}.png  ({n_cols} frames)")

extract_strip(*ROW_HURT,  HURT_COLS,  "hurt")
extract_strip(*ROW_DEATH, DEATH_COLS, "death")
print("Done!")
