#!/usr/bin/env bash

echo "🔹 Chrome ve ChromeDriver yükleniyor..."

# Google Chrome ve bağımlılıkları yükle
apt-get update && apt-get install -y wget unzip curl

# Chrome'u indir ve yükle
curl -Lo /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i /tmp/chrome.deb || apt-get install -fy
rm /tmp/chrome.deb

# Python bağımlılıklarını yükle
pip install --upgrade pip
pip install -r requirements.txt

echo "✅ Kurulum tamamlandı!"
