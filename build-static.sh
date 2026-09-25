#!/bin/bash
# Sinh bản sao index.html cho từng đường dẫn có trong sitemap.xml
# → GitHub Pages trả HTTP 200 (thay vì 404) cho link sâu, để Google lập chỉ mục được.
# Dùng <path>.html (không phải <path>/index.html) để tránh redirect 301 sang URL có dấu / cuối.
# CHẠY LẠI MỖI KHI SỬA index.html:  ./build-static.sh
#
# BẢN GỐC nằm NGOÀI repo: ../source/index.html  (dễ đọc, có ghi chú — CHỈ SỬA Ở ĐÂY, không đưa lên GitHub).
# Bước 0 nén bản gốc → deploy/index.html (xoá ghi chú, gộp dòng, đổi tên biến cục bộ) rồi mới sinh trang tĩnh.
# KHÔNG sửa tay deploy/index.html — lần build sau sẽ ghi đè.
set -e
cd "$(dirname "$0")"
# ── Bước 0: nén bản gốc ──
SRC="../source/index.html"
[ -f "$SRC" ] || { echo "Không thấy $SRC — bản gốc phải nằm ở thư mục source/ cạnh deploy/"; exit 1; }
npx -y html-minifier-terser@7 "$SRC" -o index.html \
  --collapse-whitespace --conservative-collapse --remove-comments \
  --minify-css true --minify-js '{"mangle":true,"compress":{"passes":1}}'
grep -q "G-2V1YEGCF4C" index.html || { echo "LỖI: mất thẻ GA4 (xác minh Search Console) sau khi nén"; exit 1; }
echo "Đã nén: $(wc -c < "$SRC") → $(wc -c < index.html) byte."
# Xoá thư mục sinh tự động ở lần trước
if [ -f .static-paths ]; then
  while read -r d; do [ -n "$d" ] && rm -rf "$d" "$d.html"; done < .static-paths
fi
# Trang tiện ích: KHÔNG nằm trong sitemap (chặn lập chỉ mục) nhưng vẫn cần file
# tĩnh, nếu không mở thẳng link sẽ trả HTTP 404 — hỏng xem trước link khi chia sẻ.
EXTRA="dang-nhap gio-hang thanh-toan dat-hang-thanh-cong tai-khoan
en/login en/cart en/checkout en/order-success en/account"

paths=$( { grep -o '<loc>[^<]*' sitemap.xml \
  | sed 's|<loc>||; s|https://langelulus.com||; s|?.*||; s|^/||; s|/$||'; echo "$EXTRA" | tr ' ' '\n'; } \
  | sort -u | grep -v '^$')
: > .static-paths
n=0
while read -r p; do
  d=$(dirname "$p")
  [ "$d" != "." ] && mkdir -p "$d"
  cp index.html "$p.html"
  echo "${p%%/*}" >> .static-paths
  n=$((n+1))
done <<< "$paths"
sort -u -o .static-paths .static-paths
echo "Đã sinh $n trang tĩnh."
