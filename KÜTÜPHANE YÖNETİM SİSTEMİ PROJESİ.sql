--KÜTÜPHANE YÖNETÝM SÝSTEMÝ PROJESÝ
-- 1. Veritabanýný oluþtur
IF DB_ID('Kütüphane') IS NULL
    CREATE DATABASE Kütüphane;
GO

-- 2. Kütüphane veritabanýný kullan
USE Kütüphane;
GO

-- 3. Varsa tablolarý sil
IF OBJECT_ID('kitaplar', 'U') IS NOT NULL DROP TABLE kitaplar;
IF OBJECT_ID('yazarlar', 'U') IS NOT NULL DROP TABLE yazarlar;
IF OBJECT_ID('yayýnevleri', 'U') IS NOT NULL DROP TABLE yayýnevleri;
GO

-- 4. Tablolarý oluþtur
CREATE TABLE yazarlar (
    yazarID INT PRIMARY KEY,
    ad VARCHAR(50),
    soyad VARCHAR(50)
);

CREATE TABLE yayýnevleri (
    yayýneviID INT PRIMARY KEY,
    ad VARCHAR(100),
    adres VARCHAR(200)
);

CREATE TABLE kitaplar (
    kitapID INT PRIMARY KEY,
    baslik VARCHAR(200),
    yazarID INT,
    yayýneviID INT,
    stokmiktari INT,
    yayinTarihi DATE,
    FOREIGN KEY (yazarID) REFERENCES yazarlar(yazarID),
    FOREIGN KEY (yayýneviID) REFERENCES yayýnevleri(yayýneviID)
);
GO

-- 5. Veri ekle (yazarlar)
INSERT INTO yazarlar (yazarID, ad, soyad) VALUES
(12, 'Jack', 'London'),
(16, 'Antoine de', 'Saint-Exupéry'),
(25, 'George', 'Orwell');

-- 6. Veri ekle (yayýnevleri)
INSERT INTO yayýnevleri (yayýneviID, ad, adres) VALUES
(139, 'XYZ Yayýnevi', 'Ýstanbul'),
(122, 'ABC Yayýnevi', 'Ankara'),
(250, 'DEF Yayýnevi', 'Ýzmir');

-- 7. Veri ekle (kitaplar)
INSERT INTO kitaplar (kitapID, baslik, yazarID, yayýneviID, stokmiktari, yayinTarihi) VALUES
(321, 'Beyaz Diþ', 12, 139, 10, '2000-01-15'),
(324, 'Küçük Prens', 16, 122, 15, '1995-05-20'),
(246, '1984', 25, 250, 8, '1984-06-08'),
(555, 'Serenad', 25, 139, 12, '2011-01-01'); -- ekstra kitap

-- 8. Tablolarý görüntüle
SELECT * FROM yazarlar;
SELECT * FROM yayýnevleri;
SELECT * FROM kitaplar;

-- 9. JOIN ile detaylý kitap bilgileri
SELECT 
    k.kitapID,
    k.baslik AS KitapAdi,
    y.ad + ' ' + y.soyad AS YazarAdi,
    yy.ad AS Yayýnevi,
    k.stokmiktari,
    k.yayinTarihi
FROM kitaplar k
INNER JOIN yazarlar y ON k.yazarID = y.yazarID
INNER JOIN yayýnevleri yy ON k.yayýneviID = yy.yayýneviID;

-- 10. Stok miktarýný görüntüle ve güncelle
SELECT stokmiktari FROM kitaplar WHERE kitapID = 321;

UPDATE kitaplar
SET stokmiktari = stokmiktari - 1
WHERE kitapID = 321;

-- 11. Yazar bazýnda kitap sayýsý
SELECT 
    y.ad,
    y.soyad,
    COUNT(k.kitapID) AS KitapSayisi
FROM yazarlar y
LEFT JOIN kitaplar k ON y.yazarID = k.yazarID
GROUP BY y.ad, y.soyad;

-- 12. En yeni kitaplarý döndüren fonksiyon
GO
CREATE OR ALTER FUNCTION dbo.EnYeniKitaplar()
RETURNS @results TABLE (
    kitapID INT,
    baslik VARCHAR(200),
    yazarAdi VARCHAR(100),
    yayýneviAdi VARCHAR(100),
    yayinTarihi DATE
)
AS
BEGIN
    INSERT INTO @results (kitapID, baslik, yazarAdi, yayýneviAdi, yayinTarihi)
    SELECT TOP 5 
        k.kitapID,
        k.baslik,
        y.ad + ' ' + y.soyad AS yazarAdi,
        yy.ad AS yayýneviAdi,
        k.yayinTarihi
    FROM kitaplar k
    INNER JOIN yazarlar y ON k.yazarID = y.yazarID
    INNER JOIN yayýnevleri yy ON k.yayýneviID = yy.yayýneviID
    WHERE k.yayinTarihi IS NOT NULL
    ORDER BY k.yayinTarihi DESC;

    RETURN;
END;
GO

-- 13. Fonksiyonu çalýþtýr
SELECT * FROM dbo.EnYeniKitaplar();

-- Önceki komutlar...

GO  -- Önceki sorgularý bitir, yeni batch baþlat

CREATE OR ALTER FUNCTION dbo.YayineviStokToplami()
RETURNS @Result TABLE (
    YayineviAdi VARCHAR(100),
    ToplamStok INT
)
AS
BEGIN
    INSERT INTO @Result (YayineviAdi, ToplamStok)
    SELECT 
        yay.ad AS YayineviAdi,
        SUM(k.stokmiktari) AS ToplamStok
    FROM 
        yayýnevleri yay
    INNER JOIN 
        kitaplar k ON yay.yayýneviID = k.yayýneviID
    GROUP BY 
        yay.ad;

    RETURN;
END;
GO  -- Fonksiyon tanýmlamasýný bitir

-- Þimdi fonksiyonu çalýþtýr (ayrý batch)
SELECT * FROM dbo.YayineviStokToplami();