"""Slice sprite sheet 6x6 into animation strips."""
import sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')


from PIL import Image
import os

SRC = r"C:\Users\behoa\Downloads\Lưới Sprite Pixel Nghệch Ngợm 6×6.png"
DEST_DIR = r"d:/game/vo-vo/assets/sprites/player"
FRAME_SIZE = 32   # kích thước mỗi khung trong game
COLS = 6
ROWS = 6

# Ánh xạ hàng → tên file
ROW_NAMES = [
    "player_egg_run_side",   # hàng 0
    "player_egg_run_up",     # hàng 1
    "player_egg_run_down",   # hàng 2
    "player_egg_roll_side",  # hàng 3
    "player_egg_roll_up",    # hàng 4
    "player_egg_roll_down",  # hàng 5
]

src = Image.open(SRC).convert("RGBA")
W, H = src.size
cell_w = W // COLS
cell_h = H // ROWS

print(f"Ảnh gốc: {W}x{H}, mỗi ô: {cell_w}x{cell_h}")

for row in range(ROWS):
    # Strip kết quả: 6 khung x 32px
    strip = Image.new("RGBA", (FRAME_SIZE * COLS, FRAME_SIZE), (0, 0, 0, 0))

    for col in range(COLS):
        x0 = col * cell_w
        y0 = row * cell_h
        x1 = x0 + cell_w
        y1 = y0 + cell_h

        cell = src.crop((x0, y0, x1, y1))

        # Tự động crop vùng có nội dung (loại bỏ viền trắng/trong suốt)
        bbox = cell.getbbox()
        if bbox:
            cell = cell.crop(bbox)

        # Resize về FRAME_SIZE x FRAME_SIZE dùng NEAREST để giữ pixel art
        cell = cell.resize((FRAME_SIZE, FRAME_SIZE), Image.NEAREST)

        strip.paste(cell, (col * FRAME_SIZE, 0))

    out_path = os.path.join(DEST_DIR, ROW_NAMES[row] + ".png")
    strip.save(out_path)
    print(f"[OK] {ROW_NAMES[row]}.png")

print("Xong!")
