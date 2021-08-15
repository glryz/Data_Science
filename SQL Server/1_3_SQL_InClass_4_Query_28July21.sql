------------------------------ 28.07.2021 SQL InClass -------------


              --------------- VIEWS -------------------(Önceki derste iþlendi. tekrar mahiyetinde buraya alýndý)

-- Subquery'ler, CTE(Common Table Expression)'lar, VIEW'lar hep ayný amaca hizmet ediyor. Tablolarla daha rahat çalýþmamýzý saðlýyorlar. ,
	-- Diðer bir avantajý da performansý artýrmaktýr. Siz query'nizi joinlerle tek bir query içinde deðil, subery lerle, CTE'lerle,
	-- VIEW'larla daralta daralta (daraltýlmýþ tablolarla) sonuca gitmeye çalýþýyorsunuz.
				-----------AVANTAJLARI:-------------
	--        Performans + Simplicity + Security + Storage 
	
	-- VIEW : Tek bir tabloda yapacaðýmýz iþlemleri aþamalar bölerek yapmamýzý saðlýyor. Bu da hýzýmýzý arttýrýyor.
	-- VIEW ile ayný tablo gibi oluþturuyoruz ve bu VIEW'a kimleri eriþebileceðini belirleyebiliyoruz. bu da security saðlýyor.
	-- VIEW'larýn kullanýmý da oluþturmasý basittir. büyük tablonun içerisinde biz bir kýsým ilgilendimiz verileri alýp onlar üzerinden çalýþýyoruz.
	-- VIEW'lar çok az yer kaplar. çübkü asýl tablonun bir görüntüsüdür.


			-------------- CTE - COMMON TABLE ESPRESSIONS -------------

-- Subquery mantýðý ile ayný. Subquery'de içerde bir tablo ile ilgileniyorduk CTE'de yukarda yazýyoruz.

--(CTE), baþka bir SELECT, INSERT, DELETE veya UPDATE deyiminde baþvurabileceðiniz veya içinde kullanabileceðiniz geçici bir sonuç kümesidir. 
-- Baþka bir SQL sorgusu içinde tanýmlayabileceðiniz bir sorgudur. Bu nedenle, diðer sorgular CTE'yi bir tablo gibi kullanabilir. 
-- CTE, daha büyük bir sorguda kullanýlmak üzere yardýmcý ifadeler yazmamýzý saðlar.


--ORDINARY

	--subquery den hiç bir farký yok. subquery içerde kullanýlýyor, Ordinary CTE yukarda WITH ile oluþturuluyor.

WITH query_name [(column_name1, ....)] AS
	(SELECT ....)   -- CTE Definition

SQL_Statement

-- sadece WITH kýsmýný yazarsan tek baþýna çalýþmaz. WITH ile belirttiðim query'yi birazdan kullanacaðým demek bu. 
-- asýl SQL statement içinde bunu kullanýyoruz.

-- RECURSIVE

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



-- Question: List customers who have an order prior to the last order of a customer named Sharyn Hopkins 
	-- and are residents of the city of San Diego.
--(TR) Sharyn Hopkins adlý bir müþterinin son sipariþinden önce sipariþi olan ve 
	--San Diego þehrinde ikamet eden müþterileri listeleyin

-- bu isimli müþteriyi nerden bulacaðým? sales.customers tan.
-- son sipariþini nerden bulacaðým? sales.orders tan

SELECT MAX(B.order_date) --son sipariþ tarihini getirmek için MAX fonksiyonunu kullandým. ORDER BY DESC de yapabilirdim
FROM sales.customers A, sales.orders B
WHERE A.customer_id = B.customer_id
AND A.first_name = 'Sharyn'
AND A.last_name = 'Hopkins'

WITH T1 AS
(
SELECT MAX(B.order_date) LAST_ORDER 
FROM sales.customers A, sales.orders B
WHERE A.customer_id = B.customer_id
AND A.first_name = 'Sharyn'
AND A.last_name = 'Hopkins'
)

SELECT A.customer_id, A.first_name, last_name, city, order_date
FROM sales.customers A, sales.orders B, T1 C
WHERE A.customer_id = B.customer_id 
AND B.order_date < C.LAST_ORDER
AND A.city = 'San Diego'
-- WITH ile baþlayan CTE bloðu tek baþýna çalýþtýrýrsan hata verir. 
	-- ardýndan gelen içinde CTE yi kullandýðýn query ile beraber seçerek çalýþtýrmalýsýn.

-- SORU2: 0'dan 9'a kadar her bir rakam bir satýrda olacak þekilde bir tablo oluþturun

SELECT 0 number
UNION ALL
SELECT 1

SELECT 0 number
UNION ALL
SELECT 1
UNION ALL
SELECT 2

WITH T1 AS
(
SELECT 0 number
UNION ALL
SELECT 1
)

SELECT * 
FROM T1

-------her seferinde ayný tabloyu tekrar tekrar kullanmak istersem:
WITH T1 AS
(
SELECT 0 number
UNION ALL
SELECT number +1 
FROM T1
WHERE  number < 9 --sonsuza kadar yapmamasý için ve hata vermemesi için burada limitliyoruz.
)

SELECT * FROM T1


--- WITH ÝLE SADECE VAR OLAN DEÐERLERDEN BÝR TABLO OLUÞTURMAK DEÐÝL, 
	--YENÝ DEÐERLER EKLEYEREK BÝR TABLO DA OLUÞTURABÝLÝRÝZ


--------------------------- SET----------------------------------

				------- IMPORTANT----------

-- Her iki select statemen da ayný sayýda column içermeli.

-- INTERSECT VE EXCEPT çok önemli. UNION hayat kurtarmaz ama diðer ikisi çok önemli iþler yaparlar.

-- UNION ve INTERSECT'te positional ordering önemli deðil 
	-- yani hangi tablo önce hangisi sonra geleceðinin önemi yok. 
	-- ama EXCEPT te bu önemli!!!

-- Select statement ta birbirine karþýlýk gelen sütunlarýn data tipleri ayný olmalý.

-- ORDER BY ile bir sýralama yapmak istiyorsak, ORDER BY'ý son tablonun FROM'unun sonuna yazmalýsýn.
	-- diðer tabololarda bireysel olarak ORDER BY kullanamazsýn!!

-- UNION, dublikasyonlarý filtreleyip göstermediði için fazladan iþlem yapmaktadýr. 
	-- fakat UNION ALL bu iþlemi yapmadýðý (dublikasyonlarla beraber sonuçlarý getirdiði) için
	-- performans açýsýndan daha iyidir.

-- SÜTUN ÝSÝMLERÝ AYNI OLMAK ZORUNDA DEÐÝLDÝR. ÝKÝNCÝ TABLONUN SÜTUN ÝSÝMLERÝ FARKLI ÝSE; 
	-- UNION ÝLE YAPTIÐIMIZ SORGU SONUCU; SONUÇ TABLOSUNUN SÜTUN ÝSÝMLERÝ ÝLK TABLONUN SÜTUN ÝSÝMLERÝ OLUR!!



-- SET-SORU 1: Sacremento þehrindeki müþteriler ile Monroe þehrindeki müþterilerin soyisimlerini listeleyin

SELECT last_name
FROM sales.customers
WHERE city = 'Sacramento'
-- 6 tane satýr geldi.

SELECT last_name
FROM sales.customers
WHERE city = 'Monroe'
-- 11 satýr geldi. þimdi iki tabloyu birleþtirelim

SELECT last_name
FROM sales.customers
WHERE city = 'Sacramento'

UNION ALL

SELECT last_name
FROM sales.customers
WHERE city = 'Monroe'
-- 17 sonuç geldi. Rasmussen soyadý iki defa tekrar etmiþ. þimdi UNION ile yapacaðým ve tekrarý almayacak.

-- ayný iþlemi UNION ile yaparsak dublikasyonu göz önüne alarak iþlem yapacak ve:
SELECT last_name
FROM sales.customers
WHERE city = 'Sacramento'

UNION

SELECT last_name
FROM sales.customers
WHERE city = 'Monroe'
-- 16 satýr getirecektir.

-- soyisimle birlikte ismi de select satýrýnda getirirsek...
SELECT first_name, last_name
FROM sales.customers
WHERE city = 'Sacramento'

UNION

SELECT first_name, last_name
FROM sales.customers
WHERE city = 'Monroe'
-- iki Rasmussen soyadýnýn farklý isimleri olduðundan UNION'da da 17 satýr getirdi. çünkü artýk tekrar eden satýr yok.

-- Another Way 'OR' 'IN'
SELECT last_name
FROM sales.customers
WHERE city = 'Sacramento' or city = 'Monroe'

SELECT last_name
FROM sales.customers
WHERE city IN ('Sacramento', 'Monroe')


-------------------------
-------------------------

SELECT city
from sales.stores

UNION ALL

SELECT state
from sales.stores
-- sonuç tablosunda ilk tablonun sütun ismini aldýðýna dikkat et!!

SELECT city, 'STATE' AS STATE
from sales.stores

UNION ALL

SELECT state
from sales.stores
-- ilk tabloya select te bir sütun daha çaðýrdýk. þimdi ilk tablodan 2, ikinciden 1 sütun çaðýrmýþ olduk.
-- iki sorgunun da ayný sayýda sütun içermesi gerektiðinden bu hata verdi!!

SELECT city, 'STATE' AS STATE
from sales.stores

UNION ALL

SELECT state, 'BALDWIN' AS city
from sales.stores
-- iki tablonun isimleri ve içerikleri farklý olsa da ikisini de birleþtirdi.
-- çünkü önemli olan sütun sayýlarýnýn ayný olmasý. 
-- UNION ÝLE SORGU SONUCU; SONUÇ TABLOSUNUN SÜTUN ÝSÝMLERÝ ÝLK TABLONUN SÜTUN ÝSÝMLERÝ OLUR!!


SELECT city, 'STATE' AS STATE
from sales.stores

UNION ALL

SELECT state, 1 AS city
from sales.stores
-- iki tablonun data tipleri farklý olduðundan hata verdi!!!




-- SET- SORU 2: write a query that returns brands that have products for both 2016 and 2017

SELECT *
FROM production.products
WHERE model_year = 2016

INTERSECT

SELECT *
FROM production.products
WHERE model_year = 2017
-- SELECT * ÝLE TÜM SÜTUNLARI ÇAÐIRDIÐIMIZ ÝÇÝN BÜTÜN SÜTUNLARIN ÝÇÝNDEKÝ DEÐERLERÝ 
	--KESÝÞTÝRMEYE ÇALIÞIYOR AMA KESÝÞTÝREMÝYOR BU YÜZDEN BÝR DEÐER DÖNDÜREMÝYOR.

SELECT brand_id
FROM production.products
WHERE model_year = 2016

INTERSECT

SELECT brand_id
FROM production.products
WHERE model_year = 2017
-- gördüðün gibi brand_id sütunlarýný kesiþtirdi ve sonuç getirdi.

SELECT brand_id
FROM production.products
WHERE model_year = 2016

INTERSECT

SELECT brand_id
FROM production.products
WHERE model_year = 2017
ORDER BY brand_id DESC  -- ORDER BY SATIRINI BURADAKÝ GÝBÝ EN ALTTA KULLANMALIYIZ.


SELECT DISTINCT A.brand_name
FROM production.brands A, production.products B
WHERE A.brand_id = B.brand_id
AND B.model_year = 2016

INTERSECT

SELECT DISTINCT A.brand_name
FROM production.brands A, production.products B
WHERE A.brand_id = B.brand_id
AND B.model_year = 2017
-- INTERSECT TE DISTINCT KULLANMANA GEREK YOK!! O ZATEN DISTINCT YAPAR!!

-- Yukarda INTERSECT ile yaptýðýmýz SET operation'u þimdi de bir subquery olarak kullanalým.
	-- ve brands tablosunda brand_id'lerin bu operation sonucu gelen id'ler olmasýný saðlayalým.
SELECT *
FROM	production.brands
WHERE	brand_id IN (
					SELECT	brand_id
					FROM	production.products
					WHERE	model_year= 2016
					INTERSECT
					SELECT	brand_id
					FROM	production.products
					WHERE	model_year= 2017
					)
-- production.brands tablosunda yalnýzca brand_id ve brand_name olduðu için bir üstteki sorguya ilave olarak
	-- brand_name'i getirmiþ oldukk.



-- SET-SORU 4: write a query that returns customer who have orders for each 2016, 2017, and 2018
-- (TR) 2016, 2017 ve 2018 için sipariþleri olan müþteriyi döndüren bir sorgu yazýn.


SELECT customer_id
FROM sales.orders
WHERE order_date BETWEEN '2016-01-01' AND '2016-12-31' 

INTERSECT

SELECT customer_id
FROM sales.orders
WHERE order_date BETWEEN '2017-01-01' AND '2017-12-31' 

INTERSECT

SELECT customer_id
FROM sales.orders
WHERE order_date BETWEEN '2018-01-01' AND '2018-12-31'
-- buraya kadar sadece customer_id leri getirdik. ancak customer isimleri istiyordu.
	-- bunu sales.custormers tablosundan alacaðým. 

SELECT	first_name, last_name
FROM	sales.customers
WHERE	customer_id IN (
						SELECT	customer_id
						FROM	sales.orders
						WHERE	order_date BETWEEN '2016-01-01' AND '2016-12-31'
						INTERSECT
						SELECT	customer_id
						FROM	sales.orders
						WHERE	order_date BETWEEN '2017-01-01' AND '2017-12-31'
						INTERSECT
						SELECT	customer_id
						FROM	sales.orders
						WHERE	order_date BETWEEN '2018-01-01' AND '2018-12-31'
						)
-- az önceki INTERCEPT ettiðim (ve customer_id'leri getiren) tablolarý subquery yaptým ve 
	-- where de customer_id IN (subquery) kullanarak sales.customers tablosundan isim, soyisim sütunlarýný getirdim.



------------- EXCEPT------------
--TABLE A dan TABLE B'yi çýkartmak istiyorsan TABLE A'yý YUKARIYA yazmalýsýn.


-- SORU 5: Write a query that returns only products produced in 2016 (not ordered in 2017)

SELECT brand_id, model_year, product_name
FROM production.products
ORDER by 1
-- yýllara baktýðýmýda 2017 de olup diðer yýllarda üretilmeyen modelleri görebiliyoruz. bunlarýn peþindeyiz.

SELECT brand_id
FROM production.products 
WHERE model_year = 2016
-- bu brandlerden 2017 de de üretilenleri çýkartmak istiyorum.


SELECT brand_id
FROM production.products 
WHERE model_year = 2016

EXCEPT

SELECT brand_id
FROM production.products 
WHERE model_year = 2017
ORDER BY 1
-- 3, 4 ve 5 brand_id si olan markalarýn sadece 2017 yýlý üretimleri olduðunu gördüm.


-- peki bir EXCEPT daha kullanarak 2018 yýlýnda üretilenleri de çýkartabilir miyiz?:
SELECT brand_id
FROM production.products 
WHERE model_year = 2016

EXCEPT

SELECT brand_id
FROM production.products 
WHERE model_year = 2017

EXCEPT

SELECT brand_id
FROM production.products 
WHERE model_year = 2018
ORDER BY 1
-- iki EXCEPT kullanarak 2017 ve 2018 leri 2016'lardan çýkatmýþ olduk.

-- ikinci blokta 2017 ile 2018 yýllarýný beraber condition'a sokarsak:
SELECT brand_id
FROM production.products 
WHERE model_year = 2016

EXCEPT

SELECT brand_id
FROM production.products 
WHERE model_year = 2017 or model_year = 2018
ORDER BY 1


--þimdi brand isimlerini de getirelim. products tablosunda brand name yok. bunun için production.brands tablosuna gideceðiz.
SELECT	*
FROM	production.brands 
WHERE	brand_id IN (
					SELECT	brand_id
					FROM	production.products
					WHERE	model_year = 2016
					EXCEPT
					SELECT	brand_id
					FROM	production.products
					WHERE	model_year = 2017
					)
;


-- SORU 6 : write a query that returns only products ordered in 2017 (not ordered in other years)

SELECT *
FROM sales.orders A, sales.order_items B
WHERE A.order_id = B.order_id
AND A.order_date BETWEEN '2017-01-01' and '2017-12-31'
-- buraya kadar sadece 2017 de sipariþ verilen ürüleri getirdik. 
	--ama bu ürünlerden 2017 haricinde sipariþ edilen varsa bunlarý çýkartmamý istiyor

SELECT DISTINCT B.product_id --product_idlerin tekrarlarýný önledik. aþaðýdaki þartlarý saðlayan kaç farklý product_id var onu görmek için. 
FROM sales.orders A, sales.order_items B
WHERE A.order_id = B.order_id
AND A.order_date BETWEEN '2017-01-01' and '2017-12-31'

EXCEPT

SELECT DISTINCT B.product_id 
FROM sales.orders A, sales.order_items B
WHERE A.order_id = B.order_id
AND A.order_date NOT BETWEEN '2017-01-01' and '2017-12-31' --2017 dýþýndakiler için NOT BETWEEN DEDÝK!!!! 

--þimdi bu ürünlerin isimlerini de products tablosuna müracaat ederek getirelim.
SELECT	product_id, product_name
FROM	production.products
WHERE	product_id IN (
					SELECT	DISTINCT B.product_id
					FROM	sales.orders A, sales.order_items B
					WHERE	A.order_id= B.order_id
					AND		A.order_date BETWEEN '2017-01-01' AND '2017-12-31'
					EXCEPT
					SELECT	DISTINCT B.product_id
					FROM	sales.orders A, sales.order_items B
					WHERE	A.order_id= B.order_id
					AND		A.order_date NOT BETWEEN '2017-01-01' AND '2017-12-31'
					)


-- C8329 JOSEPH HOCANIN KODU:
select A.product_id, a.product_name
from production.products A, sales.orders B, sales.order_items C
where A.product_id = C.product_id
and B.order_id = C.order_id
and year(order_date) = 2017
except
select A.product_id, a.product_name
from production.products A, sales.orders B, sales.order_items C
where A.product_id = C.product_id
and B.order_id = C.order_id
and YEAR(order_date) <> 2017


-----------------------------------
-- NOT EXISTS YERÝNE EXCEPT KULLANABÝLÝYORUZ:

SELECT DISTINCT state
FROM sales.customers X
WHERE NOT EXISTS (
					SELECT DISTINCT D.STATE -- BURAYA HERHANGÝ BÝR RAKAM KOYABÝLÝRSÝN. SELECT SATIRINA BAKMIYOR
					FROM production.products A, sales.order_items B, sales.orders C, sales.customers D
					WHERE A.product_id = B.product_id
					and B.order_id = C.order_id
					and C.customer_id = D.customer_id 
					and A.product_name = 'Trek Remedy 9.8 - 2017'
					and X.state = D.state
					) 

-- ÖNCEKÝ DERS YAPILAN YUKARDAKÝ ÖRNEKTE NOT EXISTS YERÝNE EXCEPT KULLANIRSAK:

SELECT	D.STATE
FROM	sales.customers D

EXCEPT

SELECT	D.STATE
FROM	production.products A, sales.order_items B, sales.orders C, sales.customers D
WHERE	A.product_id = B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = 'Trek Remedy 9.8 - 2017'


-------------------------------------------------------------------------

-------------------CASE EXPRESSION-------------------

--CASE-SORU 1 : Generate a new column containing what the mean of the values in the Order_Status column
	-- 1= Pending; 2= Processing, 3 = Rejected, 4 = Completed

SELECT order_status,
		CASE order_status WHEN 1 THEN 'Pending'  -- order_status'u WHEN'in dýþýnda kullandýðýmýz için bu zaten eþittir anlamýna geliyor
							WHEN 2 THEN 'Processing' -- eðer WHEN'in içinde kullansaydýk yanýna = koymamýz gerekecekti.
							WHEN 3 THEN 'Rejected'
							WHEN 4 THEN 'Completed'
		END AS meanofstatus
FROM sales.orders


-- CASE-SORU 2: -- Create a new column containing the labels of the customers' email service providers
	-- ( "Gmail", "Hotmail", "Yahoo" or "Other" )

select email from sales.customers

SELECT email, 
	CASE	   WHEN email like '%gmail%' THEN 'GMAIL'
			   WHEN email like '%hotmail%' THEN 'HOTMAIL'
			   WHEN email like '%yahoo%' THEN 'YAHOO'
			   ELSE 'OTHER'
	END AS email_service_providers
FROM sales.customers

--- CASE'in WHERE'DE NASIL KULLANABÝLECEÐÝMÝZÝ ÇALIÞ. NE ÞEKÝLDE KULLANABÝLÝRÝZ?
