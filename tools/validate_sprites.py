"""
validate_sprites.py - Kiểm tra mọi file PNG trong assets/sprites/ và assets/vfx/ theo tiêu chuẩn GDD
1. Đọc kích thước khung từ animations.json (frame_width, frame_height) thay vì cố định 32x32
2. Quét thư mục assets/vfx/ với manifest assets/vfx/charge/manifest.json ghi: số khung, kích thước ô, fps, anchor
3. Tạo assets/vfx/charge/manifest.json từ danh sách file hiện có theo bảng quy định (đọc kích thước thực, báo lỗi nếu khác bảng)
4. Báo cáo chi tiết từng file đạt/không đạt kèm lý do (không tự ý sửa ảnh)
"""
import os
import sys
import io
import json

# Đảm bảo in utf-8 trên console Windows
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

try:
    from PIL import Image
except ImportError:
    print("Lỗi: Thiếu thư viện Pillow. Vui lòng cài đặt: pip install Pillow")
    sys.exit(1)

# 16 màu cố định theo GDD Mục 3
PALETTE_16 = {
    "#14110F": (0x14, 0x11, 0x0F), # 1. Đen Than
    "#2B1F1A": (0x2B, 0x1F, 0x1A), # 2. Nâu Hầm
    "#4A4A52": (0x4A, 0x4A, 0x52), # 3. Xám Sắt
    "#7C7C80": (0x7C, 0x7C, 0x80), # 4. Xám Đá
    "#6B4423": (0x6B, 0x44, 0x23), # 5. Nâu Gỗ
    "#A0693B": (0xA0, 0x69, 0x3B), # 6. Nâu Da
    "#D4A86A": (0xD4, 0xA8, 0x6A), # 7. Cát
    "#E8D9B0": (0xE8, 0xD9, 0xB0), # 8. Giấy Da
    "#F4EBD0": (0xF4, 0xEB, 0xD0), # 9. Kem
    "#6E1423": (0x6E, 0x14, 0x23), # 10. Đỏ Rượu
    "#A8342B": (0xA8, 0x34, 0x2B), # 11. Đỏ Gạch
    "#3B4A2A": (0x3B, 0x4A, 0x2A), # 12. Xanh Rêu
    "#6B7F3A": (0x6B, 0x7F, 0x3A), # 13. Xanh Lá Úa
    "#C79A2E": (0xC7, 0x9A, 0x2E), # 14. Vàng Cổ
    "#2F4A63": (0x2F, 0x4A, 0x63), # 15. Xanh Thép
    "#5A3A5E": (0x5A, 0x3A, 0x5E), # 16. Tím Mục
}

PALETTE_RGB_SET = set(PALETTE_16.values())

BASE_DIR = os.path.normpath(os.path.join(os.path.dirname(__file__), ".."))
SPRITES_DIR = os.path.join(BASE_DIR, "assets", "sprites")
VFX_DIR = os.path.join(BASE_DIR, "assets", "vfx")
VFX_CHARGE_DIR = os.path.join(VFX_DIR, "charge")
VFX_MANIFEST_PATH = os.path.join(VFX_CHARGE_DIR, "manifest.json")
ANIMATIONS_JSON_PATH = os.path.join(SPRITES_DIR, "player", "animations.json")

# Bảng quy định chuẩn cho VFX tích lực (Giai đoạn B - Mục 3)
CHARGE_TABLE = {
    "charge_staff_s1":        {"frames": 4, "frame_width": 32, "frame_height": 32, "fps": 12, "anchor": [16, 16]},
    "charge_staff_s2":        {"frames": 4, "frame_width": 32, "frame_height": 32, "fps": 12, "anchor": [16, 16]},
    "charge_staff_s3":        {"frames": 4, "frame_width": 32, "frame_height": 32, "fps": 12, "anchor": [16, 16]},
    "release_staff_dust":     {"frames": 4, "frame_width": 48, "frame_height": 48, "fps": 12, "anchor": [24, 24]},
    "glint_dagger":           {"frames": 3, "frame_width": 8,  "frame_height": 8,  "fps": 12, "anchor": [4, 4]},
    "release_dagger_speed":   {"frames": 3, "frame_width": 32, "frame_height": 16, "fps": 12, "anchor": [16, 8]},
    "stone_sling_s1":         {"frames": 2, "frame_width": 8,  "frame_height": 8,  "fps": 12, "anchor": [4, 4]},
    "stone_sling_s2":         {"frames": 2, "frame_width": 10, "frame_height": 10, "fps": 12, "anchor": [5, 5]},
    "stone_sling_s3":         {"frames": 2, "frame_width": 12, "frame_height": 12, "fps": 12, "anchor": [6, 6]},
    "release_sling_trail_s1": {"frames": 3, "frame_width": 16, "frame_height": 6,  "fps": 12, "anchor": [8, 3]},
    "release_sling_trail_s2": {"frames": 3, "frame_width": 24, "frame_height": 6,  "fps": 12, "anchor": [12, 3]},
    "release_sling_trail_s3": {"frames": 3, "frame_width": 32, "frame_height": 6,  "fps": 12, "anchor": [16, 3]},
    "flash_stage":            {"frames": 4, "frame_width": 24, "frame_height": 24, "fps": 12, "anchor": [12, 12]},
    "puff_cancel":            {"frames": 4, "frame_width": 16, "frame_height": 16, "fps": 12, "anchor": [8, 8]},
}

def analyze_rgba_image(rgba_img):
    """
    Phân tích màu và alpha cực nhanh bằng phương thức getcolors() ở tầng C của Pillow.
    Trả về: (has_transparent, min_a, max_a, semi_count, non_palette_set)
    """
    alpha = rgba_img.getchannel("A")
    min_a, max_a = alpha.getextrema()
    
    # Đếm pixel bán trong suốt qua bảng màu 256 mức của kênh alpha
    alpha_colors = alpha.getcolors(maxcolors=256) or []
    semi_count = sum(cnt for cnt, val in alpha_colors if 0 < val < 255)
    has_transparent = (min_a == 0)

    # Đếm và kiểm tra màu palette từ getcolors
    colors = rgba_img.getcolors(maxcolors=200000)
    non_palette = set()
    if colors:
        for cnt, (r, g, b, a) in colors:
            if a == 0:
                continue
            if (r, g, b) not in PALETTE_RGB_SET:
                non_palette.add(f"RGB({r},{g},{b})")
    else:
        # Nếu vượt quá 200,000 màu (ảnh canvas độ phân giải cao chưa xử lý)
        thumb = rgba_img.resize((min(rgba_img.width, 256), min(rgba_img.height, 256)), Image.Resampling.NEAREST)
        for cnt, (r, g, b, a) in (thumb.getcolors(maxcolors=200000) or []):
            if a > 0 and (r, g, b) not in PALETTE_RGB_SET:
                non_palette.add(f"RGB({r},{g},{b})")
        non_palette.add("Hơn 200,000 mã màu khác nhau")

    return has_transparent, min_a, max_a, semi_count, non_palette

def load_animations_config():
    """Tải cấu hình animations.json để lấy kích thước khung cho từng file sprite nhân vật."""
    anim_map = {}
    if not os.path.isfile(ANIMATIONS_JSON_PATH):
        return anim_map
    
    try:
        with open(ANIMATIONS_JSON_PATH, "r", encoding="utf-8") as f:
            data = json.load(f)
            if "player_egg" in data and "animations" in data["player_egg"]:
                anims = data["player_egg"]["animations"]
                default_size = data["player_egg"].get("frame_size", [32, 32])
                for anim_name, cfg in anims.items():
                    file_name = cfg.get("file", "")
                    if file_name:
                        fw = int(cfg.get("frame_width", default_size[0]))
                        fh = int(cfg.get("frame_height", default_size[1]))
                        frames = int(cfg.get("frames", 1))
                        fps = float(cfg.get("fps", 12))
                        anim_map[file_name] = {
                            "anim_name": anim_name,
                            "frame_width": fw,
                            "frame_height": fh,
                            "frames": frames,
                            "fps": fps
                        }
    except Exception as e:
        print(f"⚠️  Cảnh báo: Không thể đọc animations.json: {e}")
    return anim_map

def create_or_update_vfx_manifest():
    """Tạo assets/vfx/charge/manifest.json từ danh sách file thực tế theo bảng quy định."""
    print(f"\n=== TẠO / CẬP NHẬT MANIFEST VFX CHARGE: {VFX_MANIFEST_PATH} ===")
    os.makedirs(VFX_CHARGE_DIR, exist_ok=True)

    manifest_data = {}
    mismatch_errors = []

    # Quét các file thực tế trong assets/vfx/charge/
    actual_files = {}
    for f in os.listdir(VFX_CHARGE_DIR):
        p = os.path.join(VFX_CHARGE_DIR, f)
        if os.path.isfile(p) and f.lower().endswith(".png"):
            actual_files[f] = p

    # Đối chiếu từng mục trong CHARGE_TABLE
    for base_key, spec in CHARGE_TABLE.items():
        standard_filename = f"{base_key}.png"
        
        # Tìm file thực tế tương ứng (xử lý khoảng trắng hoặc tên mở rộng)
        matched_actual_file = None
        for actual_name in actual_files:
            actual_base = actual_name.rsplit(".", 1)[0].strip()
            if actual_base == base_key:
                matched_actual_file = actual_name
                break
        
        # Nếu chưa tìm thấy và là nhóm sling_trail, kiểm tra file gộp release_sling_trail_s1s2s3.png
        if not matched_actual_file and "release_sling_trail_" in base_key:
            for actual_name in actual_files:
                if "release_sling_trail_s1s2s3" in actual_name:
                    matched_actual_file = actual_name
                    break

        actual_size = None
        if matched_actual_file:
            img_path = actual_files[matched_actual_file]
            try:
                with Image.open(img_path) as im:
                    actual_size = list(im.size)
                    expected_w = spec["frames"] * spec["frame_width"]
                    expected_h = spec["frame_height"]
                    if actual_size[0] != expected_w or actual_size[1] != expected_h:
                        mismatch_errors.append(
                            f"File '{matched_actual_file}': Kích thước thực tế {actual_size[0]}x{actual_size[1]} "
                            f"KHÁC quy định bảng ({expected_w}x{expected_h} cho {spec['frames']} khung {spec['frame_width']}x{spec['frame_height']})"
                        )
            except Exception as e:
                mismatch_errors.append(f"Không thể đọc file '{matched_actual_file}': {e}")

        entry = {
            "frames": spec["frames"],
            "frame_width": spec["frame_width"],
            "frame_height": spec["frame_height"],
            "frame_size": [spec["frame_width"], spec["frame_height"]],
            "fps": spec["fps"],
            "anchor": spec["anchor"]
        }
        if actual_size:
            entry["actual_size"] = actual_size
        
        # Ghi vào manifest theo tên file chuẩn
        manifest_data[standard_filename] = entry

        # Nếu file trên đĩa có tên đặc thù (khoảng trắng / gộp), thêm alias vào manifest
        if matched_actual_file and matched_actual_file != standard_filename:
            alias_entry = dict(entry)
            alias_entry["note"] = f"Tên file thực tế trên đĩa tương ứng với {base_key}"
            manifest_data[matched_actual_file] = alias_entry

    # Ghi file manifest.json
    try:
        with open(VFX_MANIFEST_PATH, "w", encoding="utf-8") as f:
            json.dump(manifest_data, f, indent=2, ensure_ascii=False)
        print(f"✅ Đã ghi thành công {VFX_MANIFEST_PATH} ({len(manifest_data)} mục cấu hình).")
    except Exception as e:
        print(f"❌ Lỗi ghi file manifest: {e}")

    if mismatch_errors:
        print("\n[BÁO LỖI KÍCH THƯỚC THỰC TẾ SO VỚI BẢNG QUY ĐỊNH]:")
        for err in mismatch_errors:
            print(f"  ❌ {err}")
    else:
        print("  ✅ Tất cả các file đều có kích thước thực tế khớp bảng quy định.")

    return manifest_data

def validate_sprites_directory(anim_map):
    """Kiểm tra các file trong assets/sprites/ (Hỗ trợ frame_width/frame_height từ animations.json)."""
    print(f"\n=== 1. KIỂM ĐỊNH TÀI NGUYÊN SPRITE: {SPRITES_DIR} ===\n")
    if not os.path.isdir(SPRITES_DIR):
        print(f"Lỗi: Không tìm thấy thư mục {SPRITES_DIR}")
        return 0, 0

    png_files = []
    for root, dirs, files in os.walk(SPRITES_DIR):
        for f in sorted(files):
            if f.lower().endswith(".png"):
                png_files.append(os.path.join(root, f))

    if not png_files:
        print("Không tìm thấy file PNG nào trong assets/sprites/.")
        return 0, 0

    total_files = len(png_files)
    passed_files = 0

    for path in png_files:
        rel_path = os.path.relpath(path, SPRITES_DIR).replace("\\", "/")
        filename = os.path.basename(path)
        errors = []
        warnings = []

        try:
            with Image.open(path) as img:
                w, h = img.size
                mode = img.mode

                # 1. Kiểm tra kích thước khung từ animations.json hoặc mặc định
                if filename in anim_map:
                    cfg = anim_map[filename]
                    frame_w = cfg["frame_width"]
                    frame_h = cfg["frame_height"]
                    expected_frames = cfg["frames"]
                    expected_w = expected_frames * frame_w
                    
                    if h != frame_h:
                        errors.append(f"Chiều cao h={h} khác quy định animations.json (h={frame_h})")
                    if w != expected_w:
                        errors.append(f"Chiều rộng w={w} khác quy định animations.json ({expected_frames} khung x {frame_w} = {expected_w})")
                    frames_count = expected_frames
                else:
                    # File ngoài animations.json (ví dụ weapon icons): kiểm tra chia hết
                    frame_size = h
                    if frame_size not in (16, 24, 32, 48, 64):
                        warnings.append(f"Chiều cao ảnh h={h} khác kích thước chuẩn (16, 24, 32, 48, 64 px)")
                    if frame_size > 0 and w % frame_size != 0:
                        errors.append(f"Chiều rộng w={w} không chia hết cho kích thước khung h={frame_size}")
                    frames_count = w // frame_size if frame_size > 0 else 1

                # 2. Kiểm tra kênh alpha / nền trong suốt
                if mode != "RGBA":
                    errors.append(f"Ảnh không có kênh Alpha (Mode: {mode}), bắt buộc RGBA để có nền trong suốt")
                    has_transparent = False
                    semi_count = 0
                    non_palette_colors = set()
                else:
                    has_transparent, min_a, max_a, semi_count, non_palette_colors = analyze_rgba_image(img)
                    if not has_transparent:
                        errors.append(f"Ảnh không có pixel nào trong suốt (min_alpha={min_a}, nền chưa xóa)")

                if semi_count > 0:
                    warnings.append(f"Có {semi_count} pixel bán trong suốt (anti-aliasing, GDD yêu cầu hard pixel)")

                if non_palette_colors:
                    sample = list(non_palette_colors)[:5]
                    more = f" ... và {len(non_palette_colors) - 5} màu khác" if len(non_palette_colors) > 5 else ""
                    warnings.append(f"Có {len(non_palette_colors)} mã màu không khớp chính xác 16 màu cố định: {', '.join(sample)}{more}")

                status = "PASS" if not errors and not warnings else ("WARN" if not errors else "FAIL")
                if status == "PASS":
                    passed_files += 1
                    print(f"[OK]   {rel_path:<38} | {w}x{h} ({frames_count} frames) | Nền trong suốt | 100% Palette")
                else:
                    tag = "[FAIL]" if errors else "[WARN]"
                    print(f"{tag} {rel_path:<38} | {w}x{h} ({frames_count} frames)")
                    for err in errors:
                        print(f"       ❌ Lỗi: {err}")
                    for warn in warnings:
                        print(f"       ⚠️  Cảnh báo: {warn}")

        except Exception as ex:
            print(f"[FAIL] {rel_path:<38} | Không thể đọc ảnh: {ex}")

    print(f"\n-> Kết quả Sprites: {passed_files}/{total_files} file đạt chuẩn 100%")
    return passed_files, total_files

def validate_vfx_directory(manifest):
    """Kiểm định thư mục assets/vfx/charge/ dựa trên manifest.json."""
    print(f"\n=== 2. KIỂM ĐỊNH TÀI NGUYÊN VFX CHARGE: {VFX_CHARGE_DIR} ===\n")
    if not os.path.isdir(VFX_CHARGE_DIR):
        print(f"Lỗi: Không tìm thấy thư mục {VFX_CHARGE_DIR}")
        return 0, 0

    png_files = []
    for f in sorted(os.listdir(VFX_CHARGE_DIR)):
        if f.lower().endswith(".png"):
            png_files.append(f)

    if not png_files:
        print("Không có file PNG nào trong assets/vfx/charge/.")
        return 0, 0

    total_files = len(png_files)
    passed_files = 0

    for filename in png_files:
        path = os.path.join(VFX_CHARGE_DIR, filename)
        errors = []
        warnings = []

        # 1. Tra cứu thông số trong manifest
        spec = manifest.get(filename)
        if not spec:
            base_key = filename.rsplit(".", 1)[0].strip()
            spec = manifest.get(f"{base_key}.png") or manifest.get(base_key)

        if not spec:
            errors.append(f"File không có mục cấu hình nào trong manifest.json")
            print(f"[FAIL] {filename:<32} | Chưa khai báo trong manifest")
            for err in errors:
                print(f"       ❌ Lỗi: {err}")
            continue

        frames = int(spec["frames"])
        frame_w = int(spec.get("frame_width", spec.get("frame_size", [32, 32])[0]))
        frame_h = int(spec.get("frame_height", spec.get("frame_size", [32, 32])[1]))
        anchor = spec.get("anchor", [frame_w // 2, frame_h // 2])

        try:
            with Image.open(path) as img:
                w, h = img.size
                mode = img.mode

                # (1) Chiều rộng ảnh = số khung x chiều rộng ô
                expected_w = frames * frame_w
                if w != expected_w:
                    errors.append(f"Chiều rộng w={w} khác quy định ({frames} khung x {frame_w} = {expected_w})")

                # (2) Chiều cao = chiều cao ô
                if h != frame_h:
                    errors.append(f"Chiều cao h={h} khác chiều cao ô ({frame_h})")

                # (3) Nền trong suốt, (4) 16 màu GDD, (5) Không có pixel bán trong suốt
                has_transparent_bg = False
                if mode != "RGBA":
                    errors.append(f"Ảnh không có kênh Alpha (Mode: {mode}), bắt buộc RGBA để có nền trong suốt")
                else:
                    has_transparent_bg, min_a, max_a, semi_count, non_palette_colors = analyze_rgba_image(img)
                    
                    if not has_transparent_bg:
                        errors.append(f"Ảnh không có pixel nào trong suốt (min_alpha={min_a}, nền chưa xóa)")

                    if semi_count > 0:
                        errors.append(f"Có {semi_count} pixel bán trong suốt (yêu cầu alpha hoàn toàn 0 hoặc 255)")

                    if non_palette_colors:
                        sample = list(non_palette_colors)[:5]
                        more = f" ... và {len(non_palette_colors) - 5} màu khác" if len(non_palette_colors) > 5 else ""
                        errors.append(f"Có {len(non_palette_colors)} mã màu không thuộc 16 màu GDD: {', '.join(sample)}{more}")

                # (6) Tâm của nội dung từng khung không lệch quá 1 px so với anchor
                if w == expected_w and h == frame_h and has_transparent_bg:
                    for i in range(frames):
                        frame_crop = img.crop((i * frame_w, 0, (i + 1) * frame_w, frame_h))
                        bbox = frame_crop.getbbox()
                        if bbox is None:
                            continue
                        
                        bx0, by0, bx1, by1 = bbox
                        content_cx = (bx0 + bx1 - 1) / 2.0
                        content_cy = (by0 + by1 - 1) / 2.0
                        dx = abs(content_cx - anchor[0])
                        dy = abs(content_cy - anchor[1])
                        
                        if dx > 1.0 or dy > 1.0:
                            errors.append(
                                f"Khung {i+1}: Tâm nội dung ({content_cx:.1f}, {content_cy:.1f}) lệch quá 1px so với anchor ({anchor[0]}, {anchor[1]}) (lệch dx={dx:.1f}, dy={dy:.1f})"
                            )
                elif w != expected_w or h != frame_h:
                    errors.append(f"Không thể kiểm tra tâm anchor vì kích cỡ ảnh ({w}x{h}) không đúng chuẩn ô ({expected_w}x{frame_h})")

                # Cảnh báo tên file nếu có dấu cách thừa
                if " " in filename:
                    warnings.append(f"Tên file chứa khoảng trắng bất thường ('{filename}')")

                # Tổng kết trạng thái file
                status = "PASS" if not errors and not warnings else ("WARN" if not errors else "FAIL")
                if status == "PASS":
                    passed_files += 1
                    print(f"[OK]   {filename:<32} | {w}x{h} ({frames}x[{frame_w}x{frame_h}]) | Nền trong suốt | 100% Palette & Anchor")
                else:
                    tag = "[FAIL]" if errors else "[WARN]"
                    print(f"{tag} {filename:<32} | Kích thước hiện tại: {w}x{h} (Chuẩn: {expected_w}x{frame_h})")
                    for err in errors:
                        print(f"       ❌ Lỗi: {err}")
                    for warn in warnings:
                        print(f"       ⚠️  Cảnh báo: {warn}")

        except Exception as ex:
            print(f"[FAIL] {filename:<32} | Lỗi đọc ảnh: {ex}")

    print(f"\n-> Kết quả VFX Charge: {passed_files}/{total_files} file đạt chuẩn 100%")
    return passed_files, total_files

def validate_all():
    print("======================================================================")
    print("CHƯƠNG TRÌNH KIỂM ĐỊNH TOÀN DIỆN SPRITES & VFX (GDD PIXEL ART)")
    print("======================================================================")

    # 1. Nạp cấu hình animation của nhân vật
    anim_map = load_animations_config()

    # 2. Tạo / Cập nhật manifest cho VFX Charge theo bảng quy định
    vfx_manifest = create_or_update_vfx_manifest()

    # 3. Kiểm định assets/sprites/
    sp_pass, sp_total = validate_sprites_directory(anim_map)

    # 4. Kiểm định assets/vfx/charge/
    vfx_pass, vfx_total = validate_vfx_directory(vfx_manifest)

    print("\n======================================================================")
    print(f"TỔNG KẾT KIỂM ĐỊNH:")
    print(f"  - Sprites nhân vật & vũ khí: {sp_pass}/{sp_total} file đạt chuẩn 100%")
    print(f"  - Hiệu ứng tích lực VFX Charge: {vfx_pass}/{vfx_total} file đạt chuẩn 100%")
    print("======================================================================")

if __name__ == "__main__":
    validate_all()
