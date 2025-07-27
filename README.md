# Flutter Grid Tasarım Aracı

Bu proje, Flutter kullanarak etkileşimli bir grid (ızgara) tasarım aracıdır. Kullanıcılar, görsel bir arayüz aracılığıyla grid hücrelerini kolayca renklendirebilir, farklı oranlarda bölebilir ve birden fazla hücreyi birleştirebilir. Tasarlanan gridin anında Flutter kodunu üreterek, UI geliştirme süreçlerini hızlandırmayı amaçlar.

## Özellikler

- **Esnek Grid Boyutlandırma:** İstediğiniz satır ve sütun sayısını ayarlayarak grid boyutunu belirleyin.
- **Renk Seçimi:** Geniş bir renk paletinden seçim yaparak grid hücrelerini renklendirin.
- **Hücre Bölme:** Bir hücreyi yatay (satır) veya dikey (sütun) olarak 2, 3 veya 4 eşit parçaya bölebilirsiniz. Ayrıca 1:2 veya 2:1 gibi özel oranlarda bölme seçenekleri de mevcuttur.
- **Hücre Birleştirme:** Bitişik hücreleri seçerek tek bir büyük hücre halinde birleştirme imkanı sunar.
- **Sürükle & Bırak ile Renklendirme:** Fare veya dokunmatik ekran üzerinde sürükleyerek birden fazla hücreyi hızlıca renklendirme yeteneği.
- **Anında Kod Üretimi:** Tasarladığınız gridin Flutter Column ve Row widget'larına dönüştürülmüş kodunu tek bir tıklamayla elde edin.
- **Kopyalama Fonksiyonu:** Üretilen kodu panonuza kolayca kopyalayın.
- **Tema Desteği:** Sistem temasına duyarlı (açık/koyu mod) ve özelleştirilebilir tema renkleri.
- **Seçimleri Temizleme:** Tüm gridi tek tıkla varsayılan durumuna geri döndürme.

## Ekran Görüntüleri
<img width="1928" height="952" alt="Ek1" src="https://github.com/user-attachments/assets/dfc35011-0b1c-4908-bf70-a5ffc26a0947" />
<img width="1905" height="938" alt="Ek2" src="https://github.com/user-attachments/assets/7f44a0bb-0732-4f78-b64a-297411e50028" />

## Kurulum

Bu projeyi yerel makinenizde çalıştırmak için aşağıdaki adımları izleyin:

### Flutter SDK Kurulumu

Henüz yüklü değilse, Flutter resmi web sitesi üzerinden Flutter SDK'yı kurun.

### Depoyu Klonlayın:

```bash
git clone
cd flutter_grid_design_tool # Klonladığınız klasörün adı
```

### Bağımlılıkları Yükleyin:

```bash
flutter pub get
```

### Uygulamayı Çalıştırın:

```bash
flutter run
```

Uygulama, varsayılan olarak bağlı olan cihazınızda (simülatör, emülatör veya fiziksel cihaz) başlayacaktır.

## Kullanım

- **Grid Boyutunu Ayarla:** Uygulama açıldığında, üst kısımda bulunan "Satır" ve "Sütun" giriş alanlarına istediğiniz sayıları girerek gridin boyutunu ayarlayabilirsiniz.
- **Renk Seçimi:** Sol tarafta bulunan renk paletinden istediğiniz rengi seçin. Seçili renk, bir sonraki tıklamalarınızda uygulanacak renktir.
- **Hücreleri Renklendir:**
  - Tek bir hücreye tıklayarak rengini değiştirebilir veya varsayılan boş renge geri döndürebilirsiniz.
  - Seçili renk ile birden fazla hücreyi renklendirmek için fareyi basılı tutarak (veya parmağınızı) grid üzerinde sürükleyin.
- **Hücreleri Böl:**
  - "Bölme Modları" kısmından istediğiniz bölme oranını seçin (örn: "2'ye Böl (Yatay)").
  - Ardından bölmek istediğiniz hücreye tıklayın. Hücre, seçtiğiniz orana göre içten bölünerek yeni alt hücreler oluşturacaktır.
  - Bölünmüş bir hücreyi tekrar renklendirmek, bölmeyi sıfırlayacak ve hücreyi tek parça haline getirecektir.
- **Hücreleri Birleştir:**
  - "Birleştirme Modu"nu etkinleştirmek için düğmeye tıklayın.
  - Birleştirmek istediğiniz ana grid hücrelerini seçin. Seçiminizin bitişik bir dikdörtgen alanı oluşturduğundan emin olun.
  - Tüm hücreleri seçtikten sonra, "Birleştir" düğmesine tıklayın. Seçilen hücreler tek bir büyük hücre olarak birleştirilecektir.
  - Birleştirilmiş bir alana tıklamak, tüm birleştirilmiş bloğun rengini değiştirecektir.
- **Kodu Görüntüle ve Kopyala:**
  - "Kodu Oluştur" düğmesine tıklayarak tasarladığınız gridin Flutter Column ve Row widget yapısını görüntüleyin.
  - Görüntülenen kodu kopyalamak için "Kodu Kopyala" düğmesini kullanabilirsiniz.
