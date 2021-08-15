-----------SQL SERVER ÖNEMLÝ KODLAR ---------------
-- kaynak:   https://www.sqlkodlari.com/31-sql-primary-key-kullanimi.asp
-- Kaynak  : https://sqlserveregitimleri.com/sql-server-primary-key-constraint-kullanimi

-- INDEX
--		1. DATABASE CREATE ETME 
--		2. TABLO CREATE ETME
--		3. INSERT INTO ÝLE TABLOYA VERÝ GÝRMEK
--		4. INSERT INTO ÝLE BÝR TABLODAKÝ VERÝLERÝ ALIP VAROLAN BÝR TABLO ÝÇÝNE KOPYALAMAK
--		5. PRIMARY KEY TANIMLAMAK
--		6. PRIMARY KEY ALANINI KALDIRMAK
--		7. FOREIGN KEY TANIMLAMAK
--		8. FOREIGN KEY ALANINI KALDIRMAK
--		9. ALTER TABLE
--		10.DROP
--		11.DELETE
--		12.CONVERT KULLANIMI
--		13.CREATE VIEW ...AS
--		14.CTE COMMON TABLE EXPRESSIONS 
--		15.CREATE INDEX
--		16.LIKE



-- 1. DATABASE CREATE ETME-----------------------------------------------------------------------------------
	-- Bu iþlemi yapabilmek için mevcut kullanýcýmýzýn veritabaný oluþturma yetkisine sahip olmasý gerekmektedir.

CREATE DATABASE veritabani_adi


-- 2. TABLO CREATE ETME---------------------------------------------------------------------------------------
	-- Bu iþlemi yapabilmek için mevcut kullanýcýmýzýn tablo oluþturma yetkisine sahip olmasý gerekmektedir.

CREATE TABLE tablo_adý
(
alan_adi1 veri_tipi(boyut) Constraint_Adý,
alan_adi2 veri_tipi(boyut),
alan_adi3 veri_tipi(boyut),
....
)
-- CONSTRAINT'LER:

--NOT NULL   : Alanýnda boþ geçilemeyeceðini belirtir.
--UNIQUE     : Bu alana girilecek verilerin hiç biri birbirine benzeyemez. Yani tekrarlý kayýt içeremez.
--PRIMERY KEY: Not Null ve Unique kriterlerinin her ikisini birden uygulanmasýdýr.
--FOREIGN KEY: Baþka bir tablodaki kayýtlarla eþleþtirmek için alandaki kayýtlarýn tutarlýlýðýný belirtir.
--CHECK      : Alandaki deðerlerin belli bir koþulu saðlamasý için kullanýlýr.
--DEFAULT    : Alan için herhangi bir deðer girilmezse, varsýyalan olarak bir deðer giremeyi saðlar.

-- örnek:
CREATE TABLE Personel
(
id int,
adi_soyadi varchar(25),
sehir varchar(15),
bolum varchar(15),
medeni_durum bolean
)


-- 3. INSERT INTO ÝLE TABLOYA VERÝ GÝRMEK-----------------------------------------------------------------------

	-- Burada dikkat edeceðimiz nokta eklenecek deðer tablomuzdaki alan sýrasýna göre olmalýdýr.
	-- Values ifadesinden yazýlacak deðerler sýrasý ile iþlenir.

INSERT INTO  tablo_adi
VALUES (deger1, deger2, ...)

-- diðer yöntem:
	--Bu yöntemde ise eklenecek alanlarý ve deðerleri kendimiz belirtiriz. 
	-- Burada dikkat edilmesi gereken þey; yazdýðýmýz alan adýnýn sýrasýna göre deðerleri eklememiz olacaktýr.

INSERT INTO  tablo_adi (alan_adi1, alan_adi2, alan_adi3)
VALUES (deger1, deger2, deger3)

--örnek1 (tablonun tüm sütunlarýna veri giriþi)
INSERT INTO Personel 
VALUES (3, 'Serkan ÖZGÜREL', 'Erzincan', 'Muhasebe', 3456789)
-- örnek2 (tablonun yalnýzca 3 alanýna veri giriþi) 
INSERT INTO Personel (id, adi_soyadi, sehir)
VALUES (3, 'Serkan ÖZGÜREL', 'Erzincan')
 


-- 4. "INSERT INTO" VE "SELECT INTO" ÝLE BÝR TABLODAN BAÞKA BÝR TABLO ÝÇÝNE SÜTUN EKLEMEK-----------------------------

	-- INSERT INTO --> Hedefte belirttiðimiz tablonun var olmasý gerekmektedir. 
	-- Hedef tabloda var olan alanlar silinmez. Var olan alanlarýn yanýna yeni alanlar eklenir.
	-- SELECT INTO --> Hedef tablo yok ise create eder.

INSERT INTO Hedef_tablo (alan_adi1,alan_adi2...)
SELECT alan_adi1,alan_adi2...
FROM tablo1

---- 4. a. Tüm sütunlarý kopyalama
INSERT INTO personel_yedek
SELECT *
FROM personel

---- 4. b. Sütun isimlerini deðiþtirerek kopyalama
INSERT INTO personel_yedek (isim, sehir)
SELECT  ad_soyad, sehir
FROM personel

---- 4. c. Belirli kriterlere göre kopyalama 
INSERT INTO istanbul_personelleri (isim)
SELECT ad_soyad
FROM personel
WHERE sehir='istanbul'

---- 4. d. SELECT INTO ile TABLOYA BAÞKA TABLODAN SÜTUN EKLEMEK

	-- Yok ise yeni tablo oluþturur!
SELECT CustomerName, ContactName 
INTO CustomersBackup2017  -- Bu tabloyu oluþturdu
FROM Customers;


-- 5. PRIMARY KEY TANIMLAMAK ----------------------------------------------------------------------------

	-- Satýrlara ait deðerlerin karýþmamasý adýna bu alana ait bilginin tekrarlanmamasý gerekir. 
	-- Temel iþlevi, verilerin hangi satýra dizileceðine (veya hangi satýrda verilerin düzenleneceðine) karar vermesidir
	-- genelde sayýlar birincil anahtar olarak seçilirler, ancak zorunluluk deðildir. 
	-- Birincil anahtar deðeri boþ geçilemez ve NULL deðer alamaz. 
	-- Ýliþkisel veri tabanlarýnda (relational database management system) mutlaka birincil anahtar olmalýdýr. 

----- 5. a. TABLO OLUÞTURURKEN TANIMLAMAK

---------5. a. (1) sadece bir alanda kullaným biçimine örnek
CREATE TABLE Personel
(
id int NOT NULL PRIMARY KEY,
adi_soyadi varchar(20) ,
Sehir varchar(20)
)

--------5. a. (2) birden fazla alanda kullaným biçimine örnek
CREATE TABLE Personel
(
id int NOT NULL,
adi_soyadi varchar(20) NOT NULL ,
Sehir varchar(20),
CONSTRAINT id_no PRIMARY KEY  (id,adi_soyadi)
)
-- Burada görüleceði üzere birden fazla alan PRIMARY KEY yapýsý içine alýnýyor. 
	-- CONSTRAINT ifadesi ile bu iþleme bir taným giriliyor. Aslýnda bu taným bizim tablomuzun index alanýný oluþturmaktadýr. 
	-- Ýndexleme sayesinde tablomuzdaki verilerin bütülüðü daha saðlam olurken aramalarda da daha hýzlý sonuçlar elde ederiz. 
	-- Ayrýca kullandýðýnz uygulama geliþtirme ortamlarýnda (ör .Net) tablo üzerinde daha etkin kullaným imkanýnýz olacaktýr.
	-- PRIMARY KEY ifadesinden sonra ise ilgili alanlarý virgül ile ayýrarak yazarýz.


-----5. b. PRIMARY KEY TANIMLAMAK (VAR OLAN BÝR TABLOYA)

--------5. b. (1) Sadece bir alanda (sütunda) kullaným biçimine örnek:
ALTER TABLE Personel
ADD PRIMARY KEY (id)

-- VEYA:
ALTER TABLE Calisanlar
ADD CONSTRAINT PK_CalisanID PRIMARY KEY (ID); 
--Kodu çalýþtýrdýðýmýz zaman Calisanlar tablomuzdaki ID alanýný Primary Key olarak yapmýþ oluyoruz. 
	--PK_CalisanID ifadesi ise bu primary key ifadesine verdiðimiz isimdir. Ýstediðiniz ismi verebilirsiniz. 
	-- Ben primary key alaný belli olsun diye PK ifadesi koydum ve 
	-- sonrasýnda CalisanID diyerek çalýþan id deðeri olduðunu belirttim.


--------5. b. (2) Birden fazla alanda (sütunda) kullaným biçimine örnek:
ALTER TABLE Personel
ADD CONSTRAINT  id_no PRIMARY KEY (id,adi_soyadi)

-- Burada dikkat edilecek nokta; ALTER ile sonradan bir alana PRIMARY KEY kriteri tanýmlanýrken 
	-- ilgili alanda veya alanlarda NULL yani boþ kayýt olmamalýdýr.


-------5. b. (3) Tabloya yeni bir sütun ekleyerek PRIMARY KEY tanýmlamak:
ALTER TABLE market_fact
ADD Market_ID INT PRIMARY KEY IDENTITY(1,1)


--6. PRIMARY KEY ALANINI KALDIRMAK---------------------------------------------------------------------------
ALTER TABLE Personel
DROP  CONSTRAINT id_no

--!!! Burada dikkat edilmesi gereken nokta eðer çoklu alanda PRIMARY KEY iþlemi yaptýysak, 
	-- CONSTRAINT ifadesinden sonra tablomuzdaki alan adý deðil, oluþturduðumuz "index adý" yazýlmalýdýr. 
	-- Eðer tek bir alanda oluþturduysak o zaman CONSTRAINT  ifadesinden sonra sadece alana adýný yazabiliriz.


-- 7. FOREIGN KEY TANIMLAMAK---------------------------------------------------------------------------------

	-- Foreign Key (yabancý anahtar) ikincil anahtar olarak da ifade edilmektedir.
	-- Bir veri tablosuna girilebilecek deðerleri baþka bir veri tablosundaki alanlarla iliþkilendirmeye yarar. 
	-- Temel olarak FOREIGN KEY yardýmcý index oluþturmak için kullanýlýr. 
	-- Özetle, baþka bir tablonun birincil anahtarýnýn bir diðer tablo içerisinde yer almasýdýr.
	--  Çoðunlukla bir ana tablo (parent) ile alt tablonun (child) iliþkilendirilmesinde kullanýlýr.
	-- Bir tabloda "id" alanýna PRIMARY KEY uygulayabiliriz. Ancak ayný tablodaki baþka bir alan farklý bir tablodaki kayda baðlý çalýþabilir
	-- Ýþte bu iki tablo arasýnda bir bað kurmak gerektiði durumlarda FOREIGN KEY devreye giriyor.
	-- Böylece tablolar arasý veri akýþý daha hýzlý olduðu gibi ileride artan kayýt sayýsý sonucu veri bozulmalarýnýn önüne geçilmiþ olunur.


------ 7. a. Tablo oluþtururken FOREIGN KEY tanýmlama:
CREATE TABLE Satislar
(
id int NOT NULL PRIMARY KEY,
Urun varchar(20) ,
Satis_fiyati varchar(20),
satan_id int CONSTRAINT fk_satici FOREIGN KEY References Personel(id)
)
-- !! FOREIGN KEY tanýmlamasý yapýlýrken hangi tablodaki hangi alanla iliþkili oldðunu 
	-- REFERENCES ifadesinden sonra yazmak gerekir!!
--  CONSTRAINT ile ona bir isim veriliyor. Böylece daha sonra bu FOREIGN KEY yapýsýný kaldýrmak istersek 
	-- bu verdiðimiz ismi kullanmamýz gerekecektir.

------ 7. b. Var olan tabloya FOREIGN KEY tanýmlama:
ALTER TABLE Satislar
ADD CONSTRAIN fk_satici FOREIGN KEY (satan_id) REFERENCES Personel(id)

ALTER TABLE [dbo].[market_fact] 
ADD CONSTRAIN FK_PROPID FOREIGN KEY ([Prod_id]) REFERENCES [dbo].[prod_dimen]



--8. FOREIGN KEY ALANINI KALDIRMAK ---------------------------------------------------------------------------

ALTER TABLE Satislar
DROP  CONSTRAINT fk_satici


--9. ALTER TABLE -----------------------------------------------------------------------------------------

---- 9. a. Sütun eklemek için:
ALTER TABLE tablo_adi
ADD alan_adi veri_tipi

ALTER TABLE dbo.doc_exa 
ADD column_b VARCHAR(20) NULL, 
	column_c INT NULL ;

---- 9. b. Sütun silmek için:
ALTER TABLE tablo_adi
DROP COLUMN IF EXISTS alan_adi -- IF EXISTS opsiyonel

---- 9. c. Sütun tipini deðiþtirmek:
ALTER TABLE tablo_adi
ALTER COLUMN  alan_adi  veri_tipi



--10.  DROP ve TRUNCATE-------------------------------------------------------------------------------------------

	-- DROP yapýsý ile indexler, alanlar, tablolar ve veritabanlarý kolaylýkla silinebilir. 
	-- DELETE yapýsý ile karýþtýrýlabilir. DELETE ile sadece tablomuzdaki kayýtlarý silebiliriz. 
	-- Eðer tablomuzu veya veritabanýmýzý silmek istiyorsak DROP yapýsýný kullanmamýz gerekmektedir.

DROP INDEX tablo_adi.index_adi
DROP TABLE tablo_adi
DROP DATABASE veritabani_adi
ALTER TABLE dbo.doc_exb DROP COLUMN column_b;

--TRUNCATE TABLE Kullaným Biçimi
	--Eðer tablomuzu deðilde sadece içindeki kayýtlarý silmek istiyorsak yani tablomuzun içini boþaltmak istiyorsak 
	--aþaðýdaki kodu kullanabiliriz:
TRUNCATE TABLE tablo_adi
--Truncate yapýsýnda parametre girilmez direkt olarak tüm kayýtlarý siler. Yeni kayýt yapýlýrsa numarasý 1 den baþlar.
-- Delete ile bütün kayýtlarý sildiðimiz zaman otomatik numara sýrasý baþtan baþlamaz.
	-- örneðin 150 kayýt silindiðinde ve yeni kayýt eklediðimizde bu 151 olur.



--11. DELETE -------------------------------------------------------------------------------------------

	-- Burada dikkat edilecek nokta WHERE ifadesi ile belli bir kayýt seçilip silinir. 
	-- Eðer WHERE ifadesini kullanmadan yaparsak tablodaki bütün kayýtlarý silmiþ oluruz.

DELETE  FROM tablo_adi
WHERE secilen_alan_adi=alan_degeri

DELETE FROM Personel 
WHERE Sehir='Ýstanbul'
AND id = 3



--12. CONVERT KULLANIMI-----------------------------------------------------------------------------------
	--tarih alanýný farklý biçimlerde ekrana yazdýrmak için:

SELECT  CONVERT(hedef_veri_tipi, alan_adi, gosterim_formati)
FROM tablo_adi

-- örnek:
SELECT ad_soyad, CONVERT(VARCHAR(11), dogum_tar, 106) AS [Doðum Tarihi] 
FROM Personel

CONVERT(VARCHAR(19),GETDATE())
CONVERT(VARCHAR(10),GETDATE(),10)
CONVERT(VARCHAR(10),GETDATE(),110)
CONVERT(VARCHAR(11),GETDATE(),6)
CONVERT(VARCHAR(11),GETDATE(),106)
CONVERT(VARCHAR(24),GETDATE(),113)

Çýktýsý:
Nov 04 2014 11:45 PM
11-04-14
11-04-2014
04 Nov 14
04 Nov 2014
04 Nov 2014 11:45:34:243



-- 13. CREATE VIEW ...AS ---------------------------------------------------------------------------------

---- 13. a. Yeni VIEW oluþturmak:
CREATE VIEW view_adi AS
Select * From Tablo_adi
Where sorgulama_sartlari

---- 13. b. Var olan bir VIEW üzerinde deðiþiklik yapmak (CREATE OR REPLACE VIEW .. AS)
CREATE OR REPLACE VIEW view_adi AS
Select * From Tablo_adi
Where sorgulama_sartlari

---- 13. c. VIEW silmek:
DROP VIEW view_adi


-- 14. CTE - COMMON TABLE ESPRESSIONS ------------------------------------------------------------------

-- Subquery mantýðý ile ayný. Subquery'de içerde bir tablo ile ilgileniyorduk CTE'de yukarda yazýyoruz.

--(CTE), baþka bir SELECT, INSERT, DELETE veya UPDATE deyiminde baþvurabileceðiniz veya içinde kullanabileceðiniz geçici bir sonuç kümesidir. 
-- Baþka bir SQL sorgusu içinde tanýmlayabileceðiniz bir sorgudur. Bu nedenle, diðer sorgular CTE'yi bir tablo gibi kullanabilir. 
-- CTE, daha büyük bir sorguda kullanýlmak üzere yardýmcý ifadeler yazmamýzý saðlar.


-----14. a. ORDINARY CTE

	--subquery den hiç bir farký yok. subquery içerde kullanýlýyor, Ordinary CTE yukarda WITH ile oluþturuluyor.

WITH query_name [(column_name1, ....)] AS
	(SELECT ....)   -- CTE Definition

SQL_Statement

-- sadece WITH kýsmýný yazarsan tek baþýna çalýþmaz. WITH ile belirttiðim query'yi birazdan kullanacaðým demek bu. 
-- asýl SQL statement içinde bunu kullanýyoruz.


---- 14. b. RECURSIVE CTE

	-- UNION ALL ile kullanýlýyor.

WITH table_name (colum_list)
AS
(
	-- Anchor member
	initial_query
	UNION ALL
	-- Recursive member that references table_name.
	recursive_query
)
-- references table_name
SELECT *
FROM table_name

-- WITH ile yukarda tablo oluþturuyor, aþaðýda da SELECT FROM ile bu tabloyu kullanýyor



--15. CREATE INDEX--------------------------------------------------------------------------------------------

	-- Eðer tablomuza index tanýmý yaparsak yazacaðýmýz uygulamada kayýt arama esnasýnda bütün veritabanýný taramak yerine
	-- indexleri kullanarak daha hýzlý sonuçlar elde ederiz

	-- Tekrar eden deðerlere sahip alana index tanýmý yapýlacaksa:
CREATE INDEX index_adi
ON tablo_adi(alan_adi)

	-- "id" gibi tekrar etmeyen numaralarý barýndýran bir alana index tanýmý yapýlacak ise :
CREATE UNIQUE INDEX index_adi
ON tablo_adi(alan_adi)



--16. LIKE -------------------------------------------------------------------------------------------------

SELECT *
FROM Personel 
WHERE Sehir LIKE 'Ý%'
--Sehir alanýnda Ý harfi ile baþlayan kayýtlar seçilmiþtir. 
SELECT *
FROM Personel 
WHERE Bolum LIKE '%Yönetici%'
--Bolum alanýnýn herhangi bir yerinde (baþýnda, ortasýnda veya sonunda) Yönetici kelimesini seçer.
SELECT *
FROM Personel 
WHERE Bolum NOT LIKE '%Yönetici%'
--Bolum alanýnýn herhangi bir yerinde Yönetici yazmayan kayýtlarý seçer
SELECT *
FROM Personel 
WHERE Sehir  LIKE 'Ýzmi_'
--Ýzmi ile baþlayan ve son harfi ne olursa olsun farketmeyen
SELECT *
FROM Personel 
WHERE Adi_soyadi  LIKE '[S,A]%'
--ilk harfi S veya A ile baþlayan kayýtlarý seçer. 
SELECT *
FROM Personel 
WHERE Adi_soyadi  LIKE '[A-K]%'
--ilk harfi A ile K harfleri arasýnda ki herhangi bir harf ile baþlayan
SELECT *
FROM Personel 
WHERE Adi_soyadi  LIKE '%[A-K]'
-- A ile K harfleri arasýnda ki herhangi bir harf ile biten


