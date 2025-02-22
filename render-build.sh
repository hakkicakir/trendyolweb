#!/bin/bash

# Chrome ve ChromeDriver'ı yükle
echo "Google Chrome ve ChromeDriver yükleniyor..."
apt-get update && apt-get install -y wget unzip

# Google Chrome Yükleme
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb || apt-get install -fy
rm google-chrome-stable_current_amd64.deb

# ChromeDriver Yükleme
wget -O /tmp/chromedriver.zip https://storage.googleapis.com/chrome-for-testing-public/124.0.6367.91/linux64/chromedriver-linux64.zip
unzip /tmp/chromedriver.zip -d /usr/local/bin/
chmod +x /usr/local/bin/chromedriver
rm /tmp/chromedriver.zip

# Gerekli Python bağımlılıklarını yükle
pip install -r requirements.txt

echo "✅ Chrome ve ChromeDriver yüklendi!"
