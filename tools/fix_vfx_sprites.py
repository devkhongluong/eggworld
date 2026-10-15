"""
tools/fix_vfx_sprites.py - Xử lý, chuẩn hóa kích thước, xóa nền và ánh xạ bảng màu 16 màu GDD cho toàn bộ VFX Charge.
"""
import os
import sys
import io

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
from PIL import Image

BASE_DIR = os.path.normpath(os.path.join(os.path.dirname(__file__), ".."))
VFX_CHARGE_DIR = os.path.join(BASE_DIR, "assets", "vfx", "charge")

PALETTE_16 = [
    (0x14, 0x11, 0x0F), # 1. Đen Than
    (0x2B, 0x1F, 0x1A), # 2. Nâu Hầm
    (0x4A, 0x4A, 0x52), # 3. Xám Sắt
    (0x7C, 0x7C, 0x80), # 4. Xám Đá
    (0x6B, 0x44, 0x23), # 5. Nâu Gỗ
    (0xA0, 0x69, 0x3B), # 6. Nâu Da
    (0xD4, 0xA8, 0x6A), # 7. Cát
    (0xE8, 0xD9, 0xB0), # 8. Giấy Da
    (0xF4, 0xEB, 0xD0), # 9. Kem
    (0x6E, 0x14, 0x23), # 10. Đỏ Rượu
    (0xA8, 0x34, 0x2B), # 11. Đỏ Gạch
    (0x3B, 0x4A, 0x2A), # 12. Xanh Rêu
    (0x6B, 0x7F, 0x3A), # 13. Xanh Lá Úa
    (0xC7, 0x9A, 0x2E), # 14. Vàng Cổ
    (0x2F, 0x4A, 0x63), # 15. Xanh Thép
    (0x5A, 0x3A, 0x5E), # 16. Tím Mục
]

def closest_palette_color(r, g, b):
    min_d = float('inf')
    best = PALETTE_16[0]
    for pr, pg, pb in PALETTE_16:
        d = (r - pr)**2 + (g - pg)**2 + (b - pb)**2
        if d < min_d:
            min_d = d
            best = (pr, pg, pb)
    return best

def is_magenta_bg(r, g, b):
    # Magenta chroma key
    return r > 160 and g < 130 and b > 160

def extract_content_from_slot(slot_img):
    """Xóa nền magenta và watermark góc dưới, trả về ảnh nội dung tight-crop."""
    w, h = slot_img.size
    rgba = slot_img.convert("RGBA")
    src = rgba.load()
    out = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    dst = out.load()

    min_x, min_y, max_x, max_y = w, h, 0, 0
    has_pixel = False

    for y in range(h):
        for x in range(w):
            # Bỏ qua watermark ở góc dưới bên phải
            if x > w - 120 and y > h - 120:
                continue
            r, g, b, a = src[x, y]
            if is_magenta_bg(r, g, b):
                continue
            
            # Map màu pixel về 16 màu GDD
            pr, pg, pb = closest_palette_color(r, g, b)
            dst[x, y] = (pr, pg, pb, 255)
            has_pixel = True
            if x < min_x: min_x = x
            if y < min_y: min_y = y
            if x > max_x: max_x = x
            if y > max_y: max_y = y

    if not has_pixel:
        return None
    
    return out.crop((min_x, min_y, max_x + 1, max_y + 1))

def process_frame(content_img, target_w, target_h, anchor_x, anchor_y, fit_margin=1):
    """
    Scale nội dung vừa vặn với kích thước ô và căn tâm chính xác tại anchor.
    Đảm bảo:
    - Bảng màu 100% thuộc 16 màu GDD
    - Alpha là 0 hoặc 255 (hard pixel)
    - Tâm nội dung lệch không quá 1px so với anchor
    """
    frame_canvas = Image.new("RGBA", (target_w, target_h), (0, 0, 0, 0))
    if content_img is None:
        return frame_canvas

    cw, ch = content_img.size
    # Giữ nguyên tỷ lệ, co về vừa khung
    scale = min((target_w - 2 * fit_margin) / float(cw), (target_h - 2 * fit_margin) / float(ch))
    new_w = max(1, int(round(cw * scale)))
    new_h = max(1, int(round(ch * scale)))

    # Resize pixel art
    scaled = content_img.resize((new_w, new_h), Image.Resampling.LANCZOS)
    s_data = scaled.load()

    # Binarize alpha và map palette màu
    clean_scaled = Image.new("RGBA", (new_w, new_h), (0, 0, 0, 0))
    cs_data = clean_scaled.load()
    for y in range(new_h):
        for x in range(new_w):
            r, g, b, a = s_data[x, y]
            if a >= 120:
                pr, pg, pb = closest_palette_color(r, g, b)
                cs_data[x, y] = (pr, pg, pb, 255)

    bbox = clean_scaled.getbbox()
    if bbox is None:
        return frame_canvas

    bw = bbox[2] - bbox[0]
    bh = bbox[3] - bbox[1]
    cropped_scaled = clean_scaled.crop(bbox)

    # Đặt tâm nội dung vào đúng anchor
    # anchor là (anchor_x, anchor_y), content_center = (paste_x + (bw-1)/2, paste_y + (bh-1)/2)
    paste_x = int(round(anchor_x - (bw - 1) / 2.0))
    paste_y = int(round(anchor_y - (bh - 1) / 2.0))

    # Đảm bảo nằm trong khung
    paste_x = max(0, min(target_w - bw, paste_x))
    paste_y = max(0, min(target_h - bh, paste_y))

    frame_canvas.paste(cropped_scaled, (paste_x, paste_y), cropped_scaled)

    # Kiểm tra độ lệch tâm
    final_bbox = frame_canvas.getbbox()
    if final_bbox:
        cx = (final_bbox[0] + final_bbox[2] - 1) / 2.0
        cy = (final_bbox[1] + final_bbox[3] - 1) / 2.0
        dx = abs(cx - anchor_x)
        dy = abs(cy - anchor_y)
        # Nếu lệch, dịch chuyển 1 px để tối ưu
        if dx > 1.0 or dy > 1.0:
            adj_x = paste_x + (-1 if cx > anchor_x else (1 if cx < anchor_x else 0))
            adj_y = paste_y + (-1 if cy > anchor_y else (1 if cy < anchor_y else 0))
            adj_x = max(0, min(target_w - bw, adj_x))
            adj_y = max(0, min(target_h - bh, adj_y))
            frame_canvas = Image.new("RGBA", (target_w, target_h), (0, 0, 0, 0))
            frame_canvas.paste(cropped_scaled, (adj_x, adj_y), cropped_scaled)

    return frame_canvas

def process_standard_sheet(src_filename, dest_filename, n_frames, frame_w, frame_h, anchor):
    """Xử lý dải sprite gồm n_frames slot bằng nhau."""
    src_path = os.path.join(VFX_CHARGE_DIR, src_filename)
    if not os.path.isfile(src_path):
        print(f"Không tìm thấy file nguồn: {src_path}")
        return False

    im = Image.open(src_path).convert("RGBA")
    total_w, total_h = im.size
    slot_w = total_w // n_frames

    out_sheet = Image.new("RGBA", (n_frames * frame_w, frame_h), (0, 0, 0, 0))

    for i in range(n_frames):
        slot = im.crop((i * slot_w, 0, (i + 1) * slot_w, total_h))
        content = extract_content_from_slot(slot)
        frame_canvas = process_frame(content, frame_w, frame_h, anchor[0], anchor[1])
        out_sheet.paste(frame_canvas, (i * frame_w, 0), frame_canvas)

    dest_path = os.path.join(VFX_CHARGE_DIR, dest_filename)
    out_sheet.save(dest_path)
    print(f"✅ Đã xử lý chuẩn hóa: {dest_filename} ({out_sheet.size})")
    return True

def process_sling_trails():
    """Tách và chuẩn hóa release_sling_trail_s1s2s3.png thành 3 file riêng theo bảng."""
    specs = [
        {"name": "release_sling_trail_s3.png", "slot": 0, "fw": 32, "fh": 6, "anchor": [16, 3]},
        {"name": "release_sling_trail_s2.png", "slot": 1, "fw": 24, "fh": 6, "anchor": [12, 3]},
        {"name": "release_sling_trail_s1.png", "slot": 2, "fw": 16, "fh": 6, "anchor": [8, 3]},
    ]

    for sp in specs:
        p = os.path.join(VFX_CHARGE_DIR, sp["name"])
        if not os.path.isfile(p):
            continue
        cur_im = Image.open(p).convert("RGBA")
        # Khung 0 hiện tại
        f0_crop = cur_im.crop((0, 0, sp["fw"], sp["fh"]))
        bbox0 = f0_crop.getbbox()
        if not bbox0:
            continue
        content = f0_crop.crop(bbox0)

        out_sheet = Image.new("RGBA", (3 * sp["fw"], sp["fh"]), (0, 0, 0, 0))
        
        # Khung 0: Vệt đạn nguyên vẹn
        f0 = process_frame(content, sp["fw"], sp["fh"], sp["anchor"][0], sp["anchor"][1], fit_margin=0)
        out_sheet.paste(f0, (0 * sp["fw"], 0), f0)

        # Khung 1: Vệt đạn tan biến dần (lấy content làm mờ rồi căn tâm lại ở anchor)
        f1_temp = f0.copy()
        f1_data = f1_temp.load()
        for y in range(sp["fh"]):
            for x in range(sp["fw"]):
                if (x + y) % 3 == 0 or x > sp["fw"] * 0.75:
                    f1_data[x, y] = (0, 0, 0, 0)
        b1 = f1_temp.getbbox()
        if b1:
            c1 = f1_temp.crop(b1)
            f1 = process_frame(c1, sp["fw"], sp["fh"], sp["anchor"][0], sp["anchor"][1], fit_margin=0)
        else:
            f1 = f1_temp
        out_sheet.paste(f1, (1 * sp["fw"], 0), f1)

        # Khung 2: Bụi tán xạ cuối (căn tâm lại ở anchor)
        f2_temp = f0.copy()
        f2_data = f2_temp.load()
        for y in range(sp["fh"]):
            for x in range(sp["fw"]):
                if (x + y) % 2 == 1 or x > sp["fw"] * 0.60:
                    f2_data[x, y] = (0, 0, 0, 0)
        b2 = f2_temp.getbbox()
        if b2:
            c2 = f2_temp.crop(b2)
            f2 = process_frame(c2, sp["fw"], sp["fh"], sp["anchor"][0], sp["anchor"][1], fit_margin=0)
        else:
            f2 = f2_temp
        out_sheet.paste(f2, (2 * sp["fw"], 0), f2)

        out_path = os.path.join(VFX_CHARGE_DIR, sp["name"])
        out_sheet.save(out_path)
        print(f"✅ Đã tạo vệt đạn riêng: {sp['name']} ({out_sheet.size})")

def process_stone_sling_s3():
    """Chuẩn hóa stone_sling_s3 thành 2 khung 12x12 theo bảng."""
    src_path = os.path.join(VFX_CHARGE_DIR, "stone_sling_s3.png")
    if not os.path.isfile(src_path):
        return

    im = Image.open(src_path).convert("RGBA")
    w, h = im.size
    # Ảnh nguồn có 4 slot, ta lấy 2 slot đầu
    slot_w = w // 4
    out_sheet = Image.new("RGBA", (2 * 12, 12), (0, 0, 0, 0))

    for i in range(2):
        slot = im.crop((i * slot_w, 0, (i + 1) * slot_w, h))
        content = extract_content_from_slot(slot)
        frame_canvas = process_frame(content, 12, 12, 6, 6)
        out_sheet.paste(frame_canvas, (i * 12, 0), frame_canvas)

    out_sheet.save(src_path)
    print(f"✅ Đã chuẩn hóa: stone_sling_s3.png (24x12)")

def main():
    print("=== BẮT ĐẦU CHUẨN HÓA VÀ SỬA TOÀN BỘ FILE LỖI TRONG VFX CHARGE ===")
    
    # 1. Gậy gỗ (charge_staff_s1, s2, s3: 4 khung 32x32)
    process_standard_sheet("charge_staff_s1.png", "charge_staff_s1.png", 4, 32, 32, [16, 16])
    process_standard_sheet("charge_staff_s2.png", "charge_staff_s2.png", 4, 32, 32, [16, 16])
    process_standard_sheet("charge_staff_s3.png", "charge_staff_s3.png", 4, 32, 32, [16, 16])

    # 2. Bụi xoáy gậy gỗ (release_staff_dust: 4 khung 48x48)
    process_standard_sheet("release_staff_dust.png", "release_staff_dust.png", 4, 48, 48, [24, 24])

    # 3. Dao găm (glint_dagger: 3 khung 8x8)
    process_standard_sheet("glint_dagger.png", "glint_dagger.png", 3, 8, 8, [4, 4])

    # 4. Dao găm lướt nhanh (release_dagger_speed: 3 khung 32x16)
    process_standard_sheet("release_dagger_speed.png", "release_dagger_speed.png", 3, 32, 16, [16, 8])

    # 5. Đạn đá ná (stone_sling_s1: 2 khung 8x8, s2: 2 khung 10x10)
    process_standard_sheet("stone_sling_s1.png", "stone_sling_s1.png", 2, 8, 8, [4, 4])
    process_standard_sheet("stone_sling_s2.png", "stone_sling_s2.png", 2, 10, 10, [5, 5])
    
    # 6. Đạn đá ná cấp 3 (stone_sling_s3: 2 khung 12x12)
    process_stone_sling_s3()

    # 7. Vệt đạn ná (tách release_sling_trail_s1s2s3.png thành s1: 16x6, s2: 24x6, s3: 32x6)
    process_sling_trails()

    # 8. Chớp sáng chuyển giai đoạn (flash_stage: 4 khung 24x24)
    process_standard_sheet("flash_stage.png", "flash_stage.png", 4, 24, 24, [12, 12])

    # 9. Bụi hủy đòn (puff_cancel: 4 khung 16x16)
    # File gốc có thể là 'puff_cancel .png' có khoảng trắng
    puff_src = "puff_cancel .png" if os.path.isfile(os.path.join(VFX_CHARGE_DIR, "puff_cancel .png")) else "puff_cancel.png"
    process_standard_sheet(puff_src, "puff_cancel.png", 4, 16, 16, [8, 8])

    # Xóa file thừa/file lỗi cũ (file có khoảng trắng và file gộp cũ)
    old_space_file = os.path.join(VFX_CHARGE_DIR, "puff_cancel .png")
    if os.path.isfile(old_space_file):
        os.remove(old_space_file)
        print("🗑️  Đã dọn dẹp file có khoảng trắng cũ: puff_cancel .png")
    
    old_combined_file = os.path.join(VFX_CHARGE_DIR, "release_sling_trail_s1s2s3.png")
    if os.path.isfile(old_combined_file):
        os.remove(old_combined_file)
        print("🗑️  Đã dọn dẹp file gộp cũ: release_sling_trail_s1s2s3.png")

    print("\n=== HOÀN TẤT CHUẨN HÓA VÀ SỬA TẤT CẢ FILE VFX CHARGE! ===")

if __name__ == "__main__":
    main()
