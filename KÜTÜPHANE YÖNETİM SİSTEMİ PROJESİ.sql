--K�T�PHANE Y�NET�M S�STEM� PROJES�
-- 1. Veritaban�n� olu�tur
IF DB_ID('K�t�phane') IS NULL
    CREATE DATABASE K�t�phane;
GO

-- 2. K�t�phane veritaban�n� kullan
USE K�t�phane;
GO

-- 3. Varsa tablolar� sil
IF OBJECT_ID('kitaplar', 'U') IS NOT NULL DROP TABLE kitaplar;
IF OBJECT_ID('yazarlar', 'U') IS NOT NULL DROP TABLE yazarlar;
IF OBJECT_ID('yay�nevleri', 'U') IS NOT NULL DROP TABLE yay�nevleri;
GO

-- 4. Tablolar� olu�tur
CREATE TABLE yazarlar (
    yazarID INT PRIMARY KEY,
    ad VARCHAR(50),
    soyad VARCHAR(50)
);

CREATE TABLE yay�nevleri (
    yay�neviID INT PRIMARY KEY,
    ad VARCHAR(100),
    adres VARCHAR(200)
);

CREATE TABLE kitaplar (
    kitapID INT PRIMARY KEY,
    baslik VARCHAR(200),
    yazarID INT,
    yay�neviID INT,
    stokmiktari INT,
    yayinTarihi DATE,
    FOREIGN KEY (yazarID) REFERENCES yazarlar(yazarID),
    FOREIGN KEY (yay�neviID) REFERENCES yay�nevleri(yay�neviID)
);
GO

-- 5. Veri ekle (yazarlar)
INSERT INTO yazarlar (yazarID, ad, soyad) VALUES
(12, 'Jack', 'London'),
(16, 'Antoine de', 'Saint-Exup�ry'),
(25, 'George', 'Orwell');

-- 6. Veri ekle (yay�nevleri)
INSERT INTO yay�nevleri (yay�neviID, ad, adres) VALUES
(139, 'XYZ Yay�nevi', '�stanbul'),
(122, 'ABC Yay�nevi', 'Ankara'),
(250, 'DEF Yay�nevi', '�zmir');

-- 7. Veri ekle (kitaplar)
INSERT INTO kitaplar (kitapID, baslik, yazarID, yay�neviID, stokmiktari, yayinTarihi) VALUES
(321, 'Beyaz Di�', 12, 139, 10, '2000-01-15'),
(324, 'K���k Prens', 16, 122, 15, '1995-05-20'),
(246, '1984', 25, 250, 8, '1984-06-08'),
(555, 'Serenad', 25, 139, 12, '2011-01-01'); -- ekstra kitap

-- 8. Tablolar� g�r�nt�le
SELECT * FROM yazarlar;
SELECT * FROM yay�nevleri;
SELECT * FROM kitaplar;

-- 9. JOIN ile detayl� kitap bilgileri
SELECT 
    k.kitapID,
    k.baslik AS KitapAdi,
    y.ad + ' ' + y.soyad AS YazarAdi,
    yy.ad AS Yay�nevi,
    k.stokmiktari,
    k.yayinTarihi
FROM kitaplar k
INNER JOIN yazarlar y ON k.yazarID = y.yazarID
INNER JOIN yay�nevleri yy ON k.yay�neviID = yy.yay�neviID;

-- 10. Stok miktar�n� g�r�nt�le ve g�ncelle
SELECT stokmiktari FROM kitaplar WHERE kitapID = 321;

UPDATE kitaplar
SET stokmiktari = stokmiktari - 1
WHERE kitapID = 321;

-- 11. Yazar baz�nda kitap say�s�
SELECT 
    y.ad,
    y.soyad,
    COUNT(k.kitapID) AS KitapSayisi
FROM yazarlar y
LEFT JOIN kitaplar k ON y.yazarID = k.yazarID
GROUP BY y.ad, y.soyad;

-- 12. En yeni kitaplar� d�nd�ren fonksiyon
GO
CREATE OR ALTER FUNCTION dbo.EnYeniKitaplar()
RETURNS @results TABLE (
    kitapID INT,
    baslik VARCHAR(200),
    yazarAdi VARCHAR(100),
    yay�neviAdi VARCHAR(100),
    yayinTarihi DATE
)
AS
BEGIN
    INSERT INTO @results (kitapID, baslik, yazarAdi, yay�neviAdi, yayinTarihi)
    SELECT TOP 5 
        k.kitapID,
        k.baslik,
        y.ad + ' ' + y.soyad AS yazarAdi,
        yy.ad AS yay�neviAdi,
        k.yayinTarihi
    FROM kitaplar k
    INNER JOIN yazarlar y ON k.yazarID = y.yazarID
    INNER JOIN yay�nevleri yy ON k.yay�neviID = yy.yay�neviID
    WHERE k.yayinTarihi IS NOT NULL
    ORDER BY k.yayinTarihi DESC;

    RETURN;
END;
GO

-- 13. Fonksiyonu �al��t�r
SELECT * FROM dbo.EnYeniKitaplar();

-- �nceki komutlar...

GO  -- �nceki sorgular� bitir, yeni batch ba�lat

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
        yay�nevleri yay
    INNER JOIN 
        kitaplar k ON yay.yay�neviID = k.yay�neviID
    GROUP BY 
        yay.ad;

    RETURN;
END;
GO  -- Fonksiyon tan�mlamas�n� bitir

-- �imdi fonksiyonu �al��t�r (ayr� batch)
SELECT * FROM dbo.YayineviStokToplami();