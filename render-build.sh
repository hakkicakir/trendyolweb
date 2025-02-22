#!/usr/bin/env bash

echo "🔹 Güncellenmiş build scripti çalıştırılıyor..."

# 1️⃣ Paketleri güncelle ve bağımlılıkları yükle
apt-get update && apt-get install -y wget unzip

# 2️⃣ Google Chrome'u indir ve yükle
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb || apt-get install -fy
rm google-chrome-stable_current_amd64.deb

# 3️⃣ ChromeDriver'ı indir ve yükle
wget -O /tmp/chromedriver.zip https://storage.googleapis.com/chrome-for-testing-public/124.0.6367.91/linux64/chromedriver-linux64.zip
unzip /tmp/chromedriver.zip -d /usr/local/bin/
chmod +x /usr/local/bin/chromedriver

# 4️⃣ Python bağımlılıklarını yükle
pip install --upgrade pip
pip install -r requirements.txt

echo "✅ Build işlemi tamamlandı!"
