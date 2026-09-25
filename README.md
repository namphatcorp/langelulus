# L'ANGELULUS — Website Demo

Bản demo website thương mại điện tử của thương hiệu nước hoa L'ANGELULUS,
dựng theo Project Brief & Brand Guideline. Dùng để gửi agency tham khảo và báo giá.

## Nội dung

| File / thư mục | Mô tả |
|---|---|
| `index.html` | Toàn bộ website (HTML + CSS + JS trong một file) |
| `assets/products/` | Ảnh 9 sản phẩm, đặt tên theo mã SP |
| `assets/banners/` | Ảnh banner trang chủ (`hero-1/2/3.jpg`) |
| `netlify.toml` | Cấu hình deploy |
| `robots.txt` | Chặn công cụ tìm kiếm lập chỉ mục bản demo |

## Đặc điểm kỹ thuật

- Static site thuần — không cần server, database hay build step
- Không phụ thuộc CDN hay font ngoài, chạy được offline
- Song ngữ Việt / Anh, URL phân biệt theo ngôn ngữ (`#/vi/...`, `#/en/...`)
- SEO: canonical + hreflang riêng cho từng ngôn ngữ
- Có màn hình Admin/CMS demo (link ở footer)

## Cập nhật nội dung

Thay file `index.html` hoặc thêm ảnh vào `assets/`, commit lên nhánh `main`.
Netlify tự động cập nhật website sau khoảng 30 giây.

---
Công ty Cổ phần Mỹ phẩm Nam Phát
