from flask import Flask, render_template, request, send_file, jsonify
import os
import pandas as pd
import re
import time
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager

app = Flask(__name__)

progress_status = 0

@app.route("/", methods=["GET", "POST"])
def index():
    global progress_status
    if request.method == "POST":
        url = request.form["url"]
        dosya_adi = request.form["dosya_adi"]

        # Progress'i sıfırla
        progress_status = 0  

        # ✅ Google Chrome ve ChromeDriver Ayarları
        CHROME_PATH = "/usr/bin/google-chrome"
        CHROMEDRIVER_PATH = "/usr/bin/chromedriver"

        chrome_options = Options()
        chrome_options.binary_location = CHROME_PATH
        chrome_options.add_argument("--headless")  
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")

        # ✅ ChromeDriver'ı manuel yol ile başlat
        service = Service(CHROMEDRIVER_PATH)
        driver = webdriver.Chrome(service=service, options=chrome_options)

        driver.get(url)
        time.sleep(5)

        yorumlar = []
        sayfa_sonuna_ulaşıldı = False

        while not sayfa_sonuna_ulaşıldı:
            comment_elements = driver.find_elements(By.CLASS_NAME, "comment")
            toplam_yorum = len(comment_elements) if len(comment_elements) > 0 else 1
            ilerleme_adimi = 100 / toplam_yorum  

            for i, comment in enumerate(comment_elements):
                try:
                    comment_info = comment.find_elements(By.CLASS_NAME, "comment-info-item")
                    kullanici_adi = comment_info[0].text.strip() if len(comment_info) > 0 else ""
                    tarih = comment_info[1].text.strip() if len(comment_info) > 1 else ""

                    yorum_metni = comment.find_element(By.CLASS_NAME, "comment-text").text.strip()

                    try:
                        star_elements = comment.find_elements(By.CLASS_NAME, "star-w")
                        yildiz_sayisi = len(star_elements)
                        yildiz_puani = f"{yildiz_sayisi} Yıldız" if yildiz_sayisi > 0 else "Bilinmiyor"
                    except:
                        yildiz_puani = "Bilinmiyor"

                    boy = re.search(r"Boy: (\d+cm)", yorum_metni)
                    boy = boy.group(1) if boy else ""

                    kilo = re.search(r"Kilo: (\d+kg)", yorum_metni)
                    kilo = kilo.group(1) if kilo else ""

                    yorumlar.append([kullanici_adi, tarih, yildiz_puani, boy, kilo, yorum_metni])
                    progress_status += ilerleme_adimi

                except Exception as e:
                    print(f"Hata oluştu: {e}")

            driver.find_element(By.TAG_NAME, 'body').send_keys(Keys.END)
            time.sleep(2)

            try:
                daha_fazla_buton = WebDriverWait(driver, 5).until(
                    EC.element_to_be_clickable((By.CLASS_NAME, "p-button.p-button-secondary.p-button-outlined.p-button-icon-only"))
                )
                daha_fazla_buton.click()
                time.sleep(3)
            except:
                sayfa_sonuna_ulaşıldı = True

        driver.quit()

        if not os.path.exists("static"):
            os.makedirs("static")

        df = pd.DataFrame(yorumlar, columns=["Kullanıcı Adı", "Tarih", "Yıldız Puanı", "Boy", "Kilo", "Yorum Metni"])
        dosya_yolu = os.path.join("static", f"{dosya_adi}.xlsx")
        df.to_excel(dosya_yolu, index=False, engine="openpyxl")

        progress_status = 100  
        return send_file(dosya_yolu, as_attachment=True)

    return render_template("index.html")

@app.route("/progress")
def progress():
    return jsonify({"progress": progress_status})

if __name__ == "__main__":
    app.run(debug=True)
