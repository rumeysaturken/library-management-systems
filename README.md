# 📚 Kütüphane Yönetim Sistemi (SQL Server)

## 📌 Proje Tanımı  
Bu proje, **Microsoft SQL Server** kullanılarak geliştirilmiş bir veritabanı sistemidir.  
Amaç, bir kütüphanede kitapların, üyelerin ve ödünç işlemlerinin dijital ortamda takibini sağlamaktır.  
Sistem; kitap, yazar, kategori, üye, ödünç alma ve iade işlemlerini kapsayan ilişkisel veritabanı yapısını temel alır.

---

## 🗂️ Veritabanı Yapısı

### 🔸 Tablolar
- `Books` – Kitap bilgilerini içerir (ISBN, başlık, stok, yazarID, kategoriID)
- `Authors` – Yazar bilgileri
- `Categories` – Kitap kategorileri
- `Members` – Kütüphane üyeleri
- `Loans` – Kitap ödünç alma kayıtları
- `Returns` – Kitap iade bilgileri

### 🔸 İlişkiler
- Her kitap bir yazara ve kategoriye bağlıdır.  
- Bir üye birden fazla kitap alabilir.  
- Ödünç alınan her kitap bir iade kaydına bağlanabilir.

---

## ⚙️ Kullanılan Teknolojiler
- **SQL Server Management Studio (SSMS)**  
- **Microsoft SQL Server 2019**  
- **T-SQL (Transact-SQL)**

---

## 🔍 Özellikler
- 📖 Kitap kaydı, yazar ve kategori bilgileriyle birlikte yönetilir  
- 👤 Üye kayıtları tutulur ve her üyeye özel ödünç geçmişi izlenebilir  
- 📅 Ödünç alma ve iade işlemleri tarih bazlı yapılır  
- ⏱️ Gecikme kontrolü: Gecikmiş iade kayıtları SQL sorgularıyla analiz edilebilir  
- 📊 Stok takibi: Kitapların mevcutta ödünçte olup olmadığı tespit edilir

---

## 🛠️ Kurulum ve Çalıştırma

1. **SQL Server Management Studio** üzerinden yeni bir veritabanı oluşturun.  
2. `Create_Tables.sql` dosyasını çalıştırarak tüm tabloları oluşturun.  
3. `Insert_ExampleData.sql` dosyasıyla örnek verileri ekleyin.  
4. `Queries.sql` dosyasındaki sorgularla analizler yapabilirsiniz:
   - En çok okunan kitaplar  
   - Gecikmiş iadeler  
   - Hangi üyeler en çok kitap alıyor  
   - Stokta olmayan kitaplar

---

## ✅ Proje Değerlendirmesi

Bu proje ile birlikte:
- SQL Server ortamında ilişkilendirilmiş veritabanı tasarımı yapılmıştır  
- T-SQL dilinde ileri düzey SELECT, JOIN, GROUP BY ve HAVING gibi ifadeler kullanılmıştır  
- Gerçek hayattaki kütüphane senaryolarına uygun bir sistem modellenmiştir

