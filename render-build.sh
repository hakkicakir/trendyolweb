#!/usr/bin/env bash

echo "🔹 Render build işlemi başladı..."

# ✅ 1️⃣ Google Chrome'u indir ve yükle (dpkg KULLANMADAN!)
mkdir -p /opt/google/chrome
wget -q -O /opt/google/chrome/google-chrome https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
chmod +x /opt/google/chrome/google-chrome
ln -sf /opt/google/chrome/google-chrome /usr/bin/google-chrome

# ✅ 2️⃣ ChromeDriver'ı indir ve yükle
mkdir -p /opt/chromedriver
wget -q -O /opt/chromedriver/chromedriver.zip https://storage.googleapis.com/chrome-for-testing-public/124.0.6367.91/linux64/chromedriver-linux64.zip
unzip /opt/chromedriver/chromedriver.zip -d /opt/chromedriver/
chmod +x /opt/chromedriver/chromedriver
ln -sf /opt/chromedriver/chromedriver /usr/bin/chromedriver

# ✅ 3️⃣ Python bağımlılıklarını yükle
pip install --upgrade pip
pip install -r requirements.txt

echo "✅ Build işlemi tamamlandı!"
