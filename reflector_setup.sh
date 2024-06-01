#!/bin/bash

# Đường dẫn tới thư mục chứa các tập tin dịch vụ của systemd
dir_path="/etc/systemd/system"

# Tạo file reflector.service tập tin dịch vụ
sudo bash -c "cat > $dir_path/reflector.service <<EOF
[Unit]
Description=Update Pacman Mirrorlist with Reflector
Wants=network-online.target
After=network-online.target NetworkManager-wait-online.service

[Service]
Type=oneshot
ExecStart=/usr/bin/reflector --verbose --latest 40 --sort rate --save /etc/pacman.d/mirrorlist

[Install]
WantedBy=multi-user.target
EOF"

# Tạo file reflector.timer tập tin thời gian hoạt động dịch vụ
sudo bash -c "cat > $dir_path/reflector.timer <<EOF
[Unit]
Description=Run Reflector Service at Boot

[Timer]
OnBootSec=0min
Persistent=true

[Install]
WantedBy=timers.target
EOF"

# Cài đặt reflector
sudo pacman -S reflector

# Bật timer reflector (sẽ tự động kích hoạt reflector.service)
sudo systemctl enable reflector.timer
sudo systemctl start reflector.timer

echo "Cấu hình tự động cập nhật mirror thành công. Hãy kiểm tra bằng lệnh: sudo systemctl status reflector.timer"
