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
NEW_APP_NAME=${2:-$NEW_DATA_TYPE"App"} # Nếu không nhập tên app, tự động lấy tên từ Data Type

# Kiểm tra xem người dùng đã nhập đủ tham số chưa
if [ -z "$NEW_PACKAGE_NAME" ] || [ -z "$NEW_DATA_TYPE" ]; then
  echo "Usage: ./mysetup.sh your.new.package NewDataType [NewAppName]"
  exit 1
fi

echo "Đang setup dự án cho bạn..."
echo "Nhập tên package(com.example.something): $NEW_PACKAGE_NAME"
echo "Tên ứng dụng: $NEW_APP_NAME"
echo "-------------------------------------"


# --- THỰC HIỆN THAY THẾ NỘI DUNG ---
echo "Đang thực hiện thay thế nội dung trong file..."
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
echo "Đang đổi tên thư mục package..."
OLD_PACKAGE_PATH=$(echo $OLD_PACKAGE_NAME | tr . /)
NEW_PACKAGE_PATH=$(echo $NEW_PACKAGE_NAME | tr . /)

# Tạo cấu trúc thư mục mới
mkdir -p "app/src/main/java/$NEW_PACKAGE_PATH"
mkdir -p "app/src/test/java/$NEW_PACKAGE_PATH"
mkdir -p "app/src/androidTest/java/$NEW_PACKAGE_PATH"

# Di chuyển các file từ thư mục cũ sang thư mục mới
mv app/src/main/java/${OLD_PACKAGE_PATH}/* app/src/main/java/${NEW_PACKAGE_PATH}/
mv app/src/test/java/${OLD_PACKAGE_PATH}/* app/src/test/java/${NEW_PACKAGE_PATH}/
mv app/src/androidTest/java/${OLD_PACKAGE_PATH}/* app/src/androidTest/java/${NEW_PACKAGE_PATH}/

# Xóa cấu trúc thư mục cũ (nếu nó không rỗng thì lệnh này sẽ báo lỗi, cần xóa thủ công hoặc dùng rmdir -p)
rm -rf "app/src/main/java/$(echo $OLD_PACKAGE_PATH | cut -d/ -f1)"
rm -rf "app/src/test/java/$(echo $OLD_PACKAGE_PATH | cut -d/ -f1)"
rm -rf "app/src/androidTest/java/$(echo $OLD_PACKAGE_PATH | cut -d/ -f1)"


# --- DỌN DẸP ---
echo "Đang dọn dẹp..."
# Xóa chính script này
rm -- "$0"
# (Tùy chọn) Xóa README của project mẫu và tạo README mới
rm README.md
echo "# $NEW_APP_NAME" > README.md

# (Tùy chọn) Khởi tạo lại Git
echo "Đang khởi tạo lại Git..."
rm -rf .git
git init
git add .
git commit -m "Initial commit"

echo "✅ Done! Your new project is ready."