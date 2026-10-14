"""
Extracts weapon icons and 6-frame attack animation spritesheets from user reference image.
Generates:
1. assets/sprites/weapons/weapon_staff_wood.png (32x32)
2. assets/sprites/weapons/weapon_dagger.png (32x32)
3. assets/sprites/weapons/weapon_sling.png (32x32)
4. assets/sprites/player/player_egg_attack_staff_side.png (384x48: 6 frames of 64x48)
5. assets/sprites/player/player_egg_attack_dagger_side.png (384x48: 6 frames of 64x48)
6. assets/sprites/player/player_egg_attack_sling_side.png (384x48: 6 frames of 64x48)
7. Preview images in artifact directory
"""
import sys, os
from PIL import Image

SRC = r"C:/Users/behoa/.gemini/antigravity/brain/62492e13-e916-43f0-bd2c-66b632ffed5c/.user_uploaded/media_1792002870298_c2a482a0.png"
ARTIFACT_DIR = r"C:/Users/behoa/.gemini/antigravity/brain/62492e13-e916-43f0-bd2c-66b632ffed5c"
WEAPONS_DIR = r"d:/game/vo-vo/assets/sprites/weapons"
PLAYER_DIR = r"d:/game/vo-vo/assets/sprites/player"

os.makedirs(WEAPONS_DIR, exist_ok=True)
os.makedirs(PLAYER_DIR, exist_ok=True)

im = Image.open(SRC).convert("RGBA")
W_IMG, H_IMG = im.size

def remove_black_bg(img, thresh=18, feather=14):
    """Replaces black background with transparent alpha."""
    out = Image.new("RGBA", img.size, (0, 0, 0, 0))
    src_data = img.load()
    out_data = out.load()
    for y in range(img.height):
        for x in range(img.width):
            r, g, b, a = src_data[x, y]
            br = (r + g + b) / 3.0
            if br <= thresh:
                out_data[x, y] = (0, 0, 0, 0)
            elif br <= thresh + feather:
                alpha = int(255 * (br - thresh) / float(feather))
                out_data[x, y] = (r, g, b, alpha)
            else:
                out_data[x, y] = (r, g, b, 255)
    return out

# --- 1. EXTRACT WEAPON ICONS ---
def extract_weapon_icon(bbox, target_size=(32, 32)):
    crop = im.crop(bbox)
    clean = remove_black_bg(crop)
    # tight crop
    tb = clean.getbbox()
    if tb:
        clean = clean.crop(tb)
    
    # Fit into target_size with aspect ratio preserved
    scale = min((target_size[0] - 4) / float(clean.width), (target_size[1] - 4) / float(clean.height))
    new_w = max(1, int(clean.width * scale))
    new_h = max(1, int(clean.height * scale))
    scaled = clean.resize((new_w, new_h), Image.Resampling.LANCZOS)
    
    # Center on canvas
    canvas = Image.new("RGBA", target_size, (0, 0, 0, 0))
    paste_x = (target_size[0] - new_w) // 2
    paste_y = (target_size[1] - new_h) // 2
    canvas.paste(scaled, (paste_x, paste_y), scaled)
    return canvas

print("Extracting weapon icons...")
staff_icon = extract_weapon_icon((28, 75, 58, 191), (32, 32))
staff_icon.save(os.path.join(WEAPONS_DIR, "weapon_staff_wood.png"))
staff_icon.save(os.path.join(ARTIFACT_DIR, "weapon_staff_wood_preview.png"))

dagger_icon = extract_weapon_icon((20, 312, 68, 412), (32, 32))
dagger_icon.save(os.path.join(WEAPONS_DIR, "weapon_dagger.png"))
dagger_icon.save(os.path.join(ARTIFACT_DIR, "weapon_dagger_preview.png"))

sling_icon = extract_weapon_icon((18, 520, 65, 605), (32, 32))
sling_icon.save(os.path.join(WEAPONS_DIR, "weapon_sling.png"))
sling_icon.save(os.path.join(ARTIFACT_DIR, "weapon_sling_preview.png"))
print("Weapon icons saved!")

# --- 2. EXTRACT 6-FRAME ANIMATION SPRITESHEETS ---
# Frame dimensions: 64x48 per frame (total 384x48)
FRAME_W = 64
FRAME_H = 48
NUM_FRAMES = 6
SCALE = 1.0 / 2.75  # Scale down from reference image

def extract_animation_sheet(row_name, col_ranges, y_top, y_ground, base_x_offsets):
    sheet = Image.new("RGBA", (FRAME_W * NUM_FRAMES, FRAME_H), (0, 0, 0, 0))
    
    for i, (x0, x1) in enumerate(col_ranges):
        # Crop frame with ground alignment
        crop = im.crop((x0, y_top, x1, y_ground))
        clean = remove_black_bg(crop)
        
        # Scale down
        new_w = max(1, int(clean.width * SCALE))
        new_h = max(1, int(clean.height * SCALE))
        scaled = clean.resize((new_w, new_h), Image.Resampling.LANCZOS)
        
        # Calculate ground placement: feet should sit at y = 43 in 48-high frame
        target_ground_y = 44
        target_y = target_ground_y - new_h
        
        # Anchor character horizontally at around x = 20 (facing right)
        target_x = base_x_offsets[i]
        
        frame_canvas = Image.new("RGBA", (FRAME_W, FRAME_H), (0, 0, 0, 0))
        frame_canvas.paste(scaled, (target_x, target_y), scaled)
        sheet.paste(frame_canvas, (i * FRAME_W, 0), frame_canvas)
        
    out_path = os.path.join(PLAYER_DIR, f"player_egg_attack_{row_name}_side.png")
    sheet.save(out_path)
    print(f"Saved {out_path} ({sheet.size})")
    
    # Save preview image (3x enlarged on dark background for user review)
    PREV_SCALE = 3
    prev_w = FRAME_W * NUM_FRAMES * PREV_SCALE
    prev_h = FRAME_H * PREV_SCALE
    prev = Image.new("RGB", (prev_w, prev_h), (20, 17, 15))  # Palette.DEN_THAN
    sheet_scaled = sheet.resize((prev_w, prev_h), Image.Resampling.NEAREST)
    prev.paste(sheet_scaled, (0, 0), sheet_scaled)
    prev_path = os.path.join(ARTIFACT_DIR, f"preview_attack_{row_name}.png")
    prev.save(prev_path)
    print(f"Saved preview: {prev_path}")
    return sheet

# Row 1: Gậy Gỗ (Staff)
r1_cols = [(82, 170), (212, 335), (378, 525), (555, 692), (720, 840), (895, 990)]
r1_x_offsets = [12, 10, 12, 12, 12, 12]
extract_animation_sheet("staff", r1_cols, 68, 198, r1_x_offsets)

# Row 2: Dao Găm (Dagger)
r2_cols = [(98, 188), (242, 360), (402, 543), (574, 688), (740, 852), (914, 988)]
r2_x_offsets = [12, 12, 12, 12, 12, 12]
extract_animation_sheet("dagger", r2_cols, 290, 417, r2_x_offsets)

# Row 3: Ná (Sling)
r3_cols = [(90, 182), (235, 356), (399, 508), (557, 700), (738, 854), (898, 982)]
r3_x_offsets = [12, 12, 12, 10, 12, 12]
extract_animation_sheet("sling", r3_cols, 515, 612, r3_x_offsets)

print("All extractions completed successfully!")
