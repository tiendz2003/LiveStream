#!/bin/bash

# DỪNG SCRIPT NẾU CÓ LỖI
set -e

# --- THAM SỐ CẦN THAY THẾ ---
# Tên package cũ trong project mẫu của bạn
OLD_PACKAGE_NAME="com.ronaldo.livestream"
# Tên ứng dụng mẫu
OLD_APP_NAME="LiveStream"


# --- LẤY THAM SỐ TỪ NGƯỜI DÙNG ---
NEW_PACKAGE_NAME=$1
# Tham số thứ 2 (tùy chọn) là tên ứng dụng. Mặc định là "NewApp" nếu không được cung cấp.
NEW_APP_NAME=${2:-"NewApp"}

# Kiểm tra xem người dùng đã nhập đủ tham số bắt buộc chưa
if [ -z "$NEW_PACKAGE_NAME" ]; then
  # Cập nhật lại hướng dẫn sử dụng cho đúng
  echo "Usage: ./mysetup.sh your.new.package [NewAppName]"
  exit 1
fi

echo "🚀 Đang setup dự án cho bạn..."
echo "Tên package mới: $NEW_PACKAGE_NAME"
echo "Tên ứng dụng mới: $NEW_APP_NAME"
echo "-------------------------------------"


# --- THỰC HIỆN THAY THẾ NỘI DUNG ---
echo "🔄 Đang thực hiện thay thế nội dung trong các tệp..."
# Tìm tất cả các file liên quan và thay thế nội dung
# Lưu ý: trên macOS `sed` yêu cầu một extension cho backup, dùng `sed -i ''`
# trên Linux/Git Bash, dùng `sed -i`
SED_CMD="sed -i"
if [[ "$OSTYPE" == "darwin"* ]]; then
  SED_CMD="sed -i ''"
fi

find . -type f \( -name "*.kt" -o -name "*.kts" -o -name "*.xml" -o -name "*.pro" \) -exec $SED_CMD "s/${OLD_PACKAGE_NAME}/${NEW_PACKAGE_NAME}/g" {} +
find . -type f -name "*.xml" -exec $SED_CMD "s/${OLD_APP_NAME}/${NEW_APP_NAME}/g" {} +


# --- ĐỔI TÊN THƯ MỤC ---
echo "🔄 Đang đổi tên cấu trúc thư mục package..."
OLD_PACKAGE_PATH=$(echo $OLD_PACKAGE_NAME | tr . /)
NEW_PACKAGE_PATH=$(echo $NEW_PACKAGE_NAME | tr . /)

# Tạo cấu trúc thư mục mới
mkdir -p "app/src/main/java/$NEW_PACKAGE_PATH"
mkdir -p "app/src/test/java/$NEW_PACKAGE_PATH"
mkdir -p "app/src/androidTest/java/$NEW_PACKAGE_PATH"

# Di chuyển các file từ thư mục cũ sang thư mục mới
# Thêm `|| true` để bỏ qua lỗi nếu thư mục nguồn không có file nào (ví dụ: project không có test)
mv app/src/main/java/${OLD_PACKAGE_PATH}/* app/src/main/java/${NEW_PACKAGE_PATH}/ || true
mv app/src/test/java/${OLD_PACKAGE_PATH}/* app/src/test/java/${NEW_PACKAGE_PATH}/ || true
mv app/src/androidTest/java/${OLD_PACKAGE_PATH}/* app/src/androidTest/java/${NEW_PACKAGE_PATH}/ || true

# Xóa cấu trúc thư mục cũ - SỬA LỖI Ở ĐÂY
# Thay vì xóa thư mục gốc chung (ví dụ: "com"), ta xóa thư mục của package cũ (ví dụ: "com/ronaldo")
rm -rf "app/src/main/java/$(echo $OLD_PACKAGE_PATH | cut -d/ -f1-2)"
rm -rf "app/src/test/java/$(echo $OLD_PACKAGE_PATH | cut -d/ -f1-2)"
rm -rf "app/src/androidTest/java/$(echo $OLD_PACKAGE_PATH | cut -d/ -f1-2)"


# --- DỌN DẸP ---
echo "🧹 Đang dọn dẹp..."
# Xóa chính script này
rm -- "$0"
# (Tùy chọn) Xóa README của project mẫu và tạo README mới
if [ -f "README.md" ]; then
  rm README.md
fi
echo "# $NEW_APP_NAME" > README.md

# (Tùy chọn) Khởi tạo lại Git
echo "🔄 Đang khởi tạo lại Git..."
rm -rf .git
git init
git add .
git commit -m "Initial commit"

echo "✅ Hoàn tất! Dự án mới của bạn đã sẵn sàng."

