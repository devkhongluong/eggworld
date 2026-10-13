"""Generate 5x preview images for all animation strips."""
import sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

from PIL import Image
import os

SPRITES_DIR = r"d:/game/vo-vo/assets/sprites/player"
PREV_DIR = r"C:/Users/behoa/.gemini/antigravity/brain/62492e13-e916-43f0-bd2c-66b632ffed5c"
SCALE = 5
FRAME_SIZE = 32
COLS = 6

names = [
    "player_egg_run_side",
    "player_egg_run_up",
    "player_egg_run_down",
    "player_egg_roll_side",
    "player_egg_roll_up",
    "player_egg_roll_down",
]

for name in names:
    strip = Image.open(os.path.join(SPRITES_DIR, name + ".png")).convert("RGBA")
    prev = Image.new("RGB", (COLS * FRAME_SIZE * SCALE, FRAME_SIZE * SCALE), (26, 26, 46))
    for f in range(COLS):
        frame = strip.crop((f * FRAME_SIZE, 0, (f+1) * FRAME_SIZE, FRAME_SIZE))
        frame_big = frame.resize((FRAME_SIZE * SCALE, FRAME_SIZE * SCALE), Image.NEAREST)
        # Composite onto dark background
        bg = Image.new("RGBA", frame_big.size, (26, 26, 46, 255))
        bg.paste(frame_big, (0, 0), frame_big)
        prev.paste(bg.convert("RGB"), (f * FRAME_SIZE * SCALE, 0))
    
    short_name = name.replace("player_egg_", "preview_")
    out = os.path.join(PREV_DIR, short_name + ".png")
    prev.save(out)
    print(f"[OK] {short_name}.png")

print("Done!")
