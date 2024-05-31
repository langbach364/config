#!/bin/bash

# Cài đặt các gói cần thiết
sudo pacman -Syu
sudo pacman -S expect nano fd fzf

# Tạo thư mục nếu chưa tồn tại
NANO_DIR="$HOME/.config/nano" # có thể tùy chỉnh đường dẫn lưu cấu hình
mkdir -p "$NANO_DIR"

# Tạo tệp hoặc ghi đè Nano.exp từ gói expect
cat <<'EOF' >"$NANO_DIR/Nano.exp"
#!/usr/bin/expect -f

set filename [lindex $argv 0]
set search_string [lindex $argv 1]

spawn nano $filename

sleep 0.1

send "\x17"

send "$search_string\r"

interact
EOF

# Đảm bảo tệp Nano.exp có quyền thực thi
chmod +x "$NANO_DIR/Nano.exp"

# Tạo tệp hoặc ghi đè  Nano.sh
cat <<'EOF' >"$NANO_DIR/Nano.sh"
# functions for nano editor

NANO="$HOME/.config/nano"
function nano_find() { 
  local file_find=$1; 
  nano $(fd -H $file_find / | fzf); 
}

function nano_search() {
  local file_find=$1
  local search_term=$2
  local selected_file=$(fd -H $file_find / | fzf)
  
  if [ -n "$selected_file" ]; then
    $NANO/Nano.exp "$selected_file" "$search_term"
  fi
}
EOF

# Đảm bảo tệp Nano.sh có quyền thực thi
chmod +x "$NANO_DIR/Nano.sh"

echo "Thiết lập hoàn tất. Các tệp đã được tạo trong $NANO_DIR"
