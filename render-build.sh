#!/usr/bin/env bash

echo "🔹 Render build işlemi başladı..."

# 1️⃣ Python bağımlılıklarını yükle
pip install --upgrade pip
pip install -r requirements.txt

echo "✅ Build işlemi tamamlandı!"
