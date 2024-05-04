#!/bin/bash

# Cài đặt gói reflector nếu chưa được cài đặt
sudo pacman -Syu --needed reflector

# Tạo thư mục cấu hình reflector nếu chưa tồn tại
sudo mkdir -p /etc/xdg/reflector

# Tạo tệp cấu hình reflector
sudo tee /etc/xdg/reflector/reflector.conf > /dev/null <<EOT
--save /etc/pacman.d/mirrorlist
--protocol https
--latest 5
--sort rate
EOT

# Tạo tệp dịch vụ reflector
sudo tee /etc/systemd/system/reflector.service > /dev/null <<EOT
[Unit]
Description=Pacman mirrorlist update

[Service]
Type=oneshot
ExecStart=/usr/bin/reflector --save /etc/pacman.d/mirrorlist

[Install]
WantedBy=multi-user.target
EOT

# Kích hoạt và bật dịch vụ reflector
sudo systemctl daemon-reload
sudo systemctl enable reflector.service
sudo systemctl start reflector.service

echo "Cấu hình reflector đã hoàn tất."
