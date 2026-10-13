"""
validate_sprites.py - Kiểm tra mọi file PNG trong assets/sprites/ theo tiêu chuẩn GDD
1. Kích thước khung chuẩn (chiều cao 32 hoặc 64; chiều rộng chia hết cho chiều cao)
2. Nền trong suốt (có kênh alpha, có pixel trong suốt)
3. 16 màu cố định trong Palette mục 3 của GDD
"""
import os
import sys
import io

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

SPRITES_DIR = os.path.normpath(os.path.join(os.path.dirname(__file__), "..", "assets", "sprites"))

def validate():
    print(f"=== KIỂM ĐỊNH TÀI NGUYÊN SPRITE: {SPRITES_DIR} ===\n")
    if not os.path.isdir(SPRITES_DIR):
        print(f"Lỗi: Không tìm thấy thư mục {SPRITES_DIR}")
        return

    png_files = []
    for root, dirs, files in os.walk(SPRITES_DIR):
        for f in sorted(files):
            if f.lower().endswith(".png"):
                png_files.append(os.path.join(root, f))

    if not png_files:
        print("Không tìm thấy file PNG nào trong assets/sprites/.")
        return

    total_files = len(png_files)
    passed_files = 0

    for path in png_files:
        rel_path = os.path.relpath(path, SPRITES_DIR).replace("\\", "/")
        errors = []
        warnings = []

        try:
            with Image.open(path) as img:
                w, h = img.size
                mode = img.mode

                # 1. Kiểm tra kích thước khung
                frame_size = h
                if frame_size not in (32, 64):
                    warnings.append(f"Chiều cao ảnh h={h} khác kích thước khung tiêu chuẩn (32 hoặc 64 px)")
                
                if frame_size > 0 and w % frame_size != 0:
                    errors.append(f"Chiều rộng w={w} không chia hết cho kích thước khung h={frame_size}")
                else:
                    frames_count = w // frame_size if frame_size > 0 else 0

                # 2. Kiểm tra kênh alpha / nền trong suốt
                if mode != "RGBA":
                    errors.append(f"Ảnh không có kênh Alpha (Mode: {mode}), bắt buộc RGBA để có nền trong suốt")
                    has_transparency = False
                else:
                    # Kiểm tra xem có pixel trong suốt hay không
                    alpha_channel = img.getchannel("A")
                    min_a, max_a = alpha_channel.getextrema()
                    if min_a != 0:
                        errors.append("Ảnh không có pixel nào trong suốt (nền chưa xóa hoàn toàn)")
                    has_transparency = (min_a == 0)

                # 3. Kiểm tra bảng màu 16 màu
                rgba_img = img.convert("RGBA")
                data = list(rgba_img.getdata())
                non_palette_colors = set()
                transparent_pixel_count = 0
                non_binary_alpha_count = 0

                for r, g, b, a in data:
                    if a == 0:
                        transparent_pixel_count += 1
                        continue
                    if a < 255:
                        non_binary_alpha_count += 1
                    
                    rgb = (r, g, b)
                    if rgb not in PALETTE_RGB_SET:
                        non_palette_colors.add(f"RGB({r},{g},{b})")

                if non_binary_alpha_count > 0:
                    warnings.append(f"Có {non_binary_alpha_count} pixel bán trong suốt (anti-aliasing / mờ nhẹ, quy tắc GDD yêu cầu hard pixel)")

                if non_palette_colors:
                    sample = list(non_palette_colors)[:5]
                    more = f" ... và {len(non_palette_colors) - 5} màu khác" if len(non_palette_colors) > 5 else ""
                    warnings.append(f"Có {len(non_palette_colors)} mã màu không khớp chính xác 16 màu cố định: {', '.join(sample)}{more}")

                # Tổng kết file
                status = "PASS" if not errors and not warnings else ("WARN" if not errors else "FAIL")
                if status == "PASS":
                    passed_files += 1
                    print(f"[OK]   {rel_path:<32} | {w}x{h} ({frames_count} frames) | Nền trong suốt | 100% Palette")
                else:
                    tag = "[FAIL]" if errors else "[WARN]"
                    print(f"{tag} {rel_path:<32} | {w}x{h} ({frames_count} frames)")
                    for err in errors:
                        print(f"       ❌ Lỗi: {err}")
                    for warn in warnings:
                        print(f"       ⚠️  Cảnh báo: {warn}")

        except Exception as ex:
            print(f"[FAIL] {rel_path:<32} | Không thể đọc ảnh: {ex}")

    print(f"\n=== KẾT QUẢ: {passed_files}/{total_files} file đạt chuẩn hoàn toàn 100% ===")

if __name__ == "__main__":
    validate()
