----------------------------DBMD 19-08-2021 -----------------------------------


---------------------------- PROCEDURE------------------------
CREATE PROC sp_sampleproc_1
AS
BEGIN
	SELECT 'HELLO WORLD'

END;

EXECUTE sp_sampleproc_1   -- PROCEDURE'Ü ÇALIÞTIRMAK ÝÇÝN.

EXEC sp_sampleproc_1  -- BU ÞEKÝLDE DE ÇALIÞIR.

sp_sampleproc_1  -- VE BU ÞEKÝLDE DE ÇALIÞIR.


-- PROCEDURE'Ü DEÐÝÞTÝRELÝM.
ALTER PROC sp_sampleproc_1
AS
BEGIN
	SELECT 'QUERY COMPLETED' RESULT

END;

sp_sampleproc_1





--- BBUNDAN SONRAKÝ ÝÞLEMLER ÝÇÝN ÖRNEK TABLO OLUÞTURUYORUZ

CREATE TABLE ORDER_TBL
(
ORDER_ID TINYINT NOT NULL,
CUSTOMER_ID TINYINT NOT NULL,
CUSTOMER_NAME VARCHAR(50),
ORDER_DATE DATE,
EST_DELIVERY_DATE DATE--estimated delivery date
);
INSERT ORDER_TBL VALUES (1, 1, 'Adam', GETDATE()-10, GETDATE()-5 ),
						(2, 2, 'Smith',GETDATE()-8, GETDATE()-4 ),
						(3, 3, 'John',GETDATE()-5, GETDATE()-2 ),
						(4, 4, 'Jack',GETDATE()-3, GETDATE()+1 ),
						(5, 5, 'Owen',GETDATE()-2, GETDATE()+3 ),
						(6, 6, 'Mike',GETDATE(), GETDATE()+5 ),
						(7, 6, 'Rafael',GETDATE(), GETDATE()+5 ),
						(8, 7, 'Johnson',GETDATE(), GETDATE()+5 )


-- BU TABLO TESLÝMATIN GERÇEKLEÞTÝRÝLME ZAMANINI BÝZE SERGÝLÝYOR
CREATE TABLE ORDER_DELIVERY
(
ORDER_ID TINYINT NOT NULL,
DELIVERY_DATE DATE -- tamamlanan delivery date
);
SET NOCOUNT ON
INSERT ORDER_DELIVERY VALUES (1, GETDATE()-6 ),
						(2, GETDATE()-2 ),
						(3, GETDATE()-2 ),
						(4, GETDATE() ),
						(5, GETDATE()+2 ),
						(6, GETDATE()+3 ),
						(7, GETDATE()+5 ),
						(8, GETDATE()+5 )


SELECT * FROM ORDER_DELIVERY

--ORDER LARI SAYDIRAN BÝR PROC YAZALIM:
CREATE PROC sp_sumorder
AS
BEGIN
		SELECT COUNT(ORDER_ID) FROM Order_tbl

END;
-- BUNU ARTIK ÝSTEDÝÐÝM HER YERE ÇAÐIRIP ÇALIÞTIRALBÝLÝRÝM.
	--VE ORDER TABLOSUNDAKÝ SÝPARÝÞ SAYISINI GETÝREBÝLÝRÝM.
	--ORDER TABLOSU GÜNCELLENDÝKÇE BU PROCEDURE'ÜN SONUCU DA ONA BAÐLI OLARAK DEÐÝÞECEKTÝR.
	-- VE HER DEFASINDA GÜNCEL BÝLGÝYÝ GETÝRECEKTÝR.
sp_sumorder


------------------

CREATE PROC sp_wanted_dayorder (@DAY DATE)
AS
BEGIN

	SELECT COUNT (ORDER_ID)
	FROM ORDER_TBL
	WHERE ORDER_DATE = @DAY

END;

SELECT * FROM ORDER_TBL

EXEC sp_wanted_dayorder '2021-08-12' -- buraya bir tarih gireceðim ve procedure bana o güne ait order_id leri sayýsýný getirecek




--------------------------- SORGU PARAMETRELERÝ---------------

/* select ve set ile variable tanýmlayabiliyoruz. Ayrýca select ile tanýmladýðýmýz variable ý çaðýrabiliyoruz. 
set ya da select ile variable tanýmlarken "=" atama operatörünü kullanýyoruz.
@ ile deðiþken sql de yer alan terim olarak parametre tanýmlayacaðýmýzý deklare ediyoruz. 
Deðiþkeni tanýmlarken deðiþkenin veri tipini de belirtmemiz gerekiyor.
*/
	-- PARAMETRELERE DEÐER ATAMAK ÝÇÝN SET VEYEA SELECT DÝYORUZ
DECLARE @P1 INT, @P2 INT, @SUM INT

SET @P1 = 6

SELECT @P2  =4

SELECT @SUM = @P1 + @P2

SELECT @SUM  -- SELECT ÝLE YAZDIRDIÐINDA SONUÇ RESULT KISMINDA ÇIKAR.

PRINT @SUM  -- PRINT ÝLE YAZDIRDIÐINDA SONUÇ MESSSAGE KISMINDA ÇIKAR.
-- DEÐER ATAMAK ÝÇÝN SET VEYA SELECT, 
-- PARAMETREYÝ ÇAÐIRMAK ÝÇÝN SELECT




DECLARE @CUST_ID INT

SET @CUST_ID = 5  -- CUST parametresine 5 deðerini atýyorum. aþaðýda sorguda bunu kullanacaðým.

SELECT *
FROM ORDER_TBL
WHERE CUSTOMER_ID = @CUST_ID



----------------- IF-ELSE YAPILARINI KULLANMA--------------

-- Aþaðýdaki 3 þarta göre iþlem yapýp bize sonuç döndürecek bir sorgu yazacaðýz.

-- 3 TEN KÜÇÜKSE
-- 3'E EÞÝTSE
-- 3'TEN BÜYÜKSE

DECLARE @CUST_ID INT  -- CUST_ID ÝSMÝNDE INT TÝPÝNDE BÝR OBJECT OLUÞTURDUM

SET @CUST_ID = 4  -- BAÞTA CUST_ID'YE BÝR DEÐER ATADIM. AÞAÐIDA BUNU CONDITION'A SOKUP SONUÇ YAZDIRACAÐIM

IF @CUST_ID < 3

BEGIN   --- BEGIN KOYARSAN HEMEN ALTINDA END YAZ KÝ UNUTMA. 
	SELECT *
	FROM ORDER_TBL
	WHERE CUSTOMER_ID = @CUST_ID
END

-- IF YAPISINDA BEGIN ÝÇÝNE BÝR SATIR YAZACAKSAN END'E GEREK YOK AMA BÝRDEN FAZLA SATIR YAZACAKSAN END ÝLE KAPATMALISIN.

ELSE IF @CUST_ID > 3
BEGIN
	SELECT *
	FROM ORDER_TBL
	WHERE CUSTOMER_ID = @CUST_ID
END

ELSE
	PRINT 'CUSTOMER ID EQUAL TO 3'



-------------------------WHILE------------------------


-- BELÝRTÝLEN ÞART SAÐLANDIÐI SÜRECE ÝÞLEME DEVAM EDER.

-- DÝKKAT EDÝLMESÝ GEREKEN NOKTA: (ÝÇÝNDE PARAMETRE VAR ÝSE) BELÝRTTÝÐÝNÝZ PARAMETRENÝN BÝTECEÐÝ YERÝ SÖYLEMENÝZ GEREKÝYOR
	-- YOKSA SONSUZ DÖNGÜYE GÝRECEKTÝR.

DECLARE @NUM_OF_ITER INT = 50, @COUNTER INT = 0

WHILE @NUM_OF_ITER > @COUNTER --COUNTER 50'YE GELENE KADAR BEGIN-END KODUNU ÇALIÞTIRACAK.

BEGIN  -- WHILE ÝLE DE BEGIN KULLANIYORUM.
	SELECT @COUNTER
	SET @COUNTER += 1 --- DÖNGÜYÜ BU ÞEKÝLDE KONTROL EDÝYORUM. ÝTERASYONU SAÐLAYAN SATIR BU SATIR.

END 


------------------------ FUNCTION-----------------------
/* 
A function is a database object in SQL Server.
The function is a set of SQL statements that accept only input parameters,
perform actions and return the result. A function can return only a scalar value or a table.


-----TABLE-VALUED FUNCTIONS:

--Table-Valued Function is a function that returns a table, 
thus it can be used as a table in a query
BELÝRLÝ ÞARTA BAÐLI OLARAK ÇALIÞAN TABLO GÝBÝ DÜÞÜNEBÝLÝRSÝN.

---- SCALAR-VALUED FUNCTIONS:

It returns a single value or scalar value. 
In the following screenshot, the function is created.
*/


CREATE FUNCTION fn_uppertext  -- fn_uppertext adýnda fonksiyon oluþturduk. yazýlan ifadeleri büyük harfe çevirmesini istiyoruz.
(
	@inputtext VARCHAR(MAX)  -- bir parametre tanýmladým. inputtext içine bir text koyacaðým ve fonksiyon bana büyük harfe çevirecek
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	RETURN UPPER(@inputtext) -- EN SON DÖNDÜRMESÝNÝ ÝSTEDÝÐÝM ÝÞLEMÝ BURAYA YAZIYORUM. BUNU, EN SON ÜRETECEK DEÐERÝ DÖNDÜRMEK ÝÇÝN KULLANIYORUM

END

SELECT dbo.fn_uppertext('whatsapp')

SELECT dbo.fn_uppertext(customer_name) FROM ORDER_TBL 
-- ORDER_TBL TABLOSUNDAKÝ customer_name sütunundaki isimleri uppertext fonksiyonuna soktuk


-------TABLE VALUED FUNCTIONS-----------

CREATE FUNCTION fn_order_detail (@DATE DATE)
RETURNS TABLE
AS 
	RETURN SELECT * FROM ORDER_TBL WHERE ORDER_DATE = @DATE  --BURADA BÝR TABLO ÜRETÝLÝYOR.

-- !! TABLE VALUED FUNCTIONDA BEGIN-END KULLANILMIYOR !!

SELECT * FROM dbo.fn_order_detail('2021-08-17') 
-- TABLE-VALUED FUNCTION BÝR TABLO OLUÞTURDUÐU ÝÇÝN ,
	--ÇAÐIRIRKEN DE BÝR TABLO ÇAÐIRIR GÝBÝ "FROM" KULLANIYORUZ!!




------------ TRIGGER

/* INSERTED AND DELETED TABLES

After each DML operation, related records are temporarily kept in the following three tables.
These tables are used in trigger operations

DML event		INSERTED table holds		DELETED table holds
---------		---------------------		-------------------
INSERT			rows to be inserted			empty

UPDATE			new rows modified by		existing rows modified by

				the update					the update

DELETE			empty						rows to be deleted 
*/



------------- DDL TRIGGERS--------

CREATE TRIGGER  [schema_name.] trigger_name
ON DATABASE
FOR
{[drop_table],  [alter_table], [create_function], [create_procedure], ...}

AS
{sql_statements}