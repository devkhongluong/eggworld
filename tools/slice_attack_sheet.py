"""Slice attack sprite sheet (5 cols x 3 rows) into animation strips."""
import sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

from PIL import Image
import os

SRC = r"C:\Users\behoa\Downloads\Bảng sprite gà trứng tấn công pixel art.png"
DEST_DIR = r"d:/game/vo-vo/assets/sprites/player"
PREV_DIR = r"C:/Users/behoa/.gemini/antigravity/brain/62492e13-e916-43f0-bd2c-66b632ffed5c"
FRAME_SIZE = 32
COLS = 5
ROWS = 3

# Layout hàng trong ảnh mẫu (nền đen, 3 hàng x 5 khung):
#   Hàng 0 → Right  → attack_side
#   Hàng 1 → Back   → attack_up
#   Hàng 2 → Front  → attack_down
ROW_NAMES = [
    "player_egg_attack_side",
    "player_egg_attack_up",
    "player_egg_attack_down",
]

src = Image.open(SRC).convert("RGBA")
W, H = src.size
cell_w = W // COLS
cell_h = H // ROWS

print(f"Size: {W}x{H}, cell: {cell_w}x{cell_h}")

for row in range(ROWS):
    # Strip 5 khung × 32px
    strip = Image.new("RGBA", (FRAME_SIZE * COLS, FRAME_SIZE), (0, 0, 0, 0))
    # Preview trên nền tối
    prev = Image.new("RGB", (FRAME_SIZE * COLS * 5, FRAME_SIZE * 5), (15, 15, 25))

    for col in range(COLS):
        x0 = col * cell_w
        y0 = row * cell_h
        cell = src.crop((x0, y0, x0 + cell_w, y0 + cell_h))

        # Loại bỏ nền đen: chuyển pixel rất tối thành trong suốt
        r, g, b, a = cell.split()
        cell_rgb = Image.merge("RGB", (r, g, b))

        # Tự crop vùng có nội dung (non-black)
        bbox = None
        arr = cell.load()
        for cx in range(cell.width):
            for cy in range(cell.height):
                px = arr[cx, cy]
                if px[0] > 20 or px[1] > 20 or px[2] > 20:
                    if bbox is None:
                        bbox = [cx, cy, cx, cy]
                    else:
                        bbox[0] = min(bbox[0], cx)
                        bbox[1] = min(bbox[1], cy)
                        bbox[2] = max(bbox[2], cx)
                        bbox[3] = max(bbox[3], cy)

        if bbox:
            pad = 4
            x1c = max(0, bbox[0] - pad)
            y1c = max(0, bbox[1] - pad)
            x2c = min(cell.width,  bbox[2] + pad)
            y2c = min(cell.height, bbox[3] + pad)
            cell = cell.crop((x1c, y1c, x2c, y2c))

        # Xóa nền đen → trong suốt
        cell = cell.convert("RGBA")
        data = cell.load()
        for cx in range(cell.width):
            for cy in range(cell.height):
                r2, g2, b2, a2 = data[cx, cy]
                # Pixel gần đen → trong suốt
                if r2 < 25 and g2 < 25 and b2 < 25:
                    data[cx, cy] = (0, 0, 0, 0)

        # Resize về 32x32 NEAREST để giữ pixel art
        frame = cell.resize((FRAME_SIZE, FRAME_SIZE), Image.NEAREST)
        strip.paste(frame, (col * FRAME_SIZE, 0))

        # Preview x5
        frame_big = frame.resize((FRAME_SIZE * 5, FRAME_SIZE * 5), Image.NEAREST)
        bg = Image.new("RGBA", frame_big.size, (15, 15, 25, 255))
        bg.paste(frame_big, (0, 0), frame_big)
        prev.paste(bg.convert("RGB"), (col * FRAME_SIZE * 5, 0))

    # Lưu strip
    out_path = os.path.join(DEST_DIR, ROW_NAMES[row] + ".png")
    strip.save(out_path)
    print(f"[OK] {ROW_NAMES[row]}.png")

    # Lưu preview
    short = ROW_NAMES[row].replace("player_egg_", "preview_")
    prev_path = os.path.join(PREV_DIR, short + ".png")
    prev.save(prev_path)
    print(f"[OK] {short}.png")

print("Done!")
