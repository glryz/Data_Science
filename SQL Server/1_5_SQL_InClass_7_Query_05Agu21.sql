-----------------SQL INCLASS SESSION-7 05 AGU 21 ------------------------------

---------------------------WINDOS FUNCTION----------------------------------------

--GROUP BY--> distinct kullanmýyoruz, distinct'i zaten kendi içinde yapýyor
--WF--> optioanal olarak yapabiliyoruz.

--GROUP BY -->  aggregate mutlaka gerekli, 
--WF--> aggregate optional

--GROUP BY --> Ordering invalid
--WF--> ordering valid

--GROUP BY --> performansý düþük
--WF --> performanslý



-- SYNTAX

SELECT {columns}
FUNCTION OVER (PARTITION BY...ORDER BY...WINDOW FRAME)
FROM table1

select *,
AVG(time) OVER(
				PARTITION BY id ORDER BY date
				ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
				) as avg_time
FROM time_of_sales


 
-- UNBOUNDED PRECEDING --> ÖNCEKÝ SATIRLARIN HEPSÝNE BAK (kendi partition içinde)
-- UNBOUNDED FOLLOWING--> SONRAKÝ SATIRLARIN HEPSÝNE BAK (kendi partition içinde)

-- N PRECEDING --> BELÝRTÝLEN N DEÐERÝNE KADAR ÖNCESÝNE GÝDÝP BAK
-- M FOLLOWING --> BELÝRTÝLEN M DEÐERÝNE KADAR SONRASINA BAK


-------------------------------------------------------------------------------
-- SORU 1: ürünlerin stock sayýlarýný bulunuz

SELECT product_id, SUM(quantity)
FROM production.stocks
GROUP BY product_id


SELECT product_id
FROM production.stocks
GROUP BY product_id
ORDER BY 1

-- window function ile yazalým
SELECT SUM(quantity) OVER (PARTITION BY product_id)
FROM production.stocks
-- YENÝ BÝR SÜTUN OLARAK sonuç geldi ama tek sütun olduðu için anlamak zor. yanýna diðer sütunlarý da getirelim

SELECT *, SUM(quantity) OVER (PARTITION BY product_id)
FROM production.stocks

--sadece product_id sütunu iþimizi görür
SELECT product_id, SUM(quantity) OVER (PARTITION BY product_id)
FROM production.stocks

-- Distint atarak productÜ_id leri teke düþürürüm
SELECT DISTINCT product_id, SUM(quantity) OVER (PARTITION BY product_id)
FROM production.stocks


-- SORU 2: Markalara göre ortalama bisiklet fiyatlarýný hem GROUP BY hem de WINDOW Function ile hesaplayýnýz

-- GROUP BY ile :
SELECT brand_id, AVG(list_price) avg_price
FROM production.products
GROUP BY brand_id

-- window function ile:
SELECT brand_id, AVG(list_price) OVER (PARTITION BY brand_id) avg_price
FROM production.products


-----------------------------1. ANALYTIC AGGREGATE FUNCTIONS -----------------------------------------------------------------

--MIN()  --MAX()   --AVG()  --SUM()  -- COUNT()




--SORU 1: Tüm bisikletler arasýnda en ucuz bisikletin fiyatý

-- Minimum list_price istiyor. herhangi bir gruplamaya yani PARTITION a gerek yok!
SELECT DISTINCT MIN (list_price) OVER ()
FROM production.products



--SORU 2: Her bir kategorideki en ucuz bisikletin fiyatý?

-- kategoriye göre gruplama yapmak zorundayým yani PARTITION gerekli
SELECT DISTINCT category_id, MIN (list_price) OVER (PARTITION BY category_id)
FROM production.products



--SORU 3: product tablosunda toplam kaç farklý bisiklet var?

SELECT DISTINCT COUNT (product_id) OVER () NUM_OF_BIKE
FROM production.products
-- sadece product_id leri unique olarak saydýrdým. PARTITION (gruplamaya gerek yok)
-- product tablosunda 321 adet farklý bisiklet olduðunu gördüm.



--SORU 4: Order_items tablosunda kaç farklý bisiklet var?
SELECT DISTINCT COUNT(product_id) OVER() order_num_of_bike
FROM sales.order_items
-- ürün sayýsý : 4722

-- Bu hata verir!!
SELECT COUNT(DISTINCT product_id) OVER() order_num_of_bike
FROM sales.order_items
-- COUNT WINDOW fonksiyonunda yukardaki gibi içinde DISTINC'e izin vermiyor! Onun yerine,

SELECT COUNT(DISTINCT product_id)
FROM sales.order_items
--307 product_id geldi. bunun üzerinden bir sayma iþlemi yaparsam

-- yukardaki query'i window fonksiyonunu kullandýðým query'nin subquerysi yapacaðým.
SELECT DISTINCT COUNT(product_id) OVER() order_num_of_bike
FROM (
		SELECT DISTINCT product_id  -- buradan 307 row deðer gelecek
		FROM sales.order_items
	) A


-- SORU 4: her bir kategoride toplam kaç farklý bisiklet var?

SELECT DISTINCT category_id, COUNT(product_id) OVER(PARTITION BY category_id)
FROM production.products
-- product_id zaten unique olduðu için ayrýca bir distinct e gerek kalmadý.


--SORU 5: Herbir kategorideki herbir  markada kaç farklý bisikletin bulunduðu
SELECT DISTINCT category_id, brand_id, COUNT(product_id) OVER(PARTITION BY category_id, brand_id)
FROM production.products



--SORU 6 : WF ile tek select'te herbir kategoride kaç farklý marka olduðunu hesaplayabilir miyiz?

SELECT DISTINCT category_id, COUNT(brand_id) OVER (PARTITION BY category_id) 
FROM production.products
-- burada her bir kategorideki satýr sayýsýný getiriyor. bunu istemiyoruz!!

SELECT DISTINCT category_id, COUNT(brand_id) OVER (PARTITION BY category_id) 
FROM 
(
SELECT DISTINCT category_id, brand_id  -- ÖNCE DISTINCT ÝLE BRAND_ID LERÝ GETÝRDÝM.
FROM production.products 
) A
-- görüldüðü gibi WF  ile tek bir SELECT satýrý ile bu soru yapýlamýyor.

SELECT	category_id, count (DISTINCT brand_id)
FROM	production.products
GROUP BY category_id

--Sonuç: iþin içinde DISTINCT varsa GROUP BY ile daha kolayca çözüme ulaþýlýyor!!!




--------------------------- 2. ANALYTIC NAVIGATION FUNCTIONS ------------------------------------------------------------

-- FIRST_VALUE()  -- LAST_VALUE() -- LEAD() -- LAG()



-- SORU 1 : Order tablosuna aþaðýdaki gibi yeni bir sütun ekleyiniz:
	-- Her bir personelin bir önceki satýþýnýn sipariþ tarihini yazdýrýnýz (LAG Fonksiyonunu kullanýnýz)

SELECT *, 
LAG(order_date, 1) OVER (PARTITION BY staff_id ORDER BY order_date, order_id) prev_ord_date
-- HER BÝR PERSONELÝN DEDÝÐÝ ÝÇÝN PARTITION BY a staff_id koyuyoruz. (staff_id lere göre grupluyoruz)
-- bir önceki sipariþ tarihini sorduðu için ORDER BY da order date'e (ve order_id'ye) göre sýralama yaptýrdým
FROM sales.orders

-- LAG, current row'dan belirtilen argümandaki rakam kadar önceki deðeri getiriyor..
-- query sonucu incelediðinde LAG fonksiyonu, prev_ord_date sütununda her satýra o satýrýn bir önceki satýrýndaki tarihi yazdýðýný görebilirsin.
	--yani her satýr bir önceki order_date'i yazdýrmýþ olduk

--staff_id'nin 2 den 3'e geçtiði 165. satýra dikkat et. o satýrdan itibaren yeni bir pencere açtý ve 
	-- LAG() fonksiyonunu o pencereye ayrýca uyguladý. (165. satýrda bir önceki tarih olmadýðý için NULL yazdýrdý.)




-- SORU 2: Order tablosuna aþaðýdaki gibi yeni bir sütun ekleyiniz:
	--2. Herbir personelin bir sonraki satýþýnýn sipariþ tarihini yazdýrýnýz (LEAD fonksiyonunu kullanýnýz)

SELECT	*,
		LEAD(order_date, 1) OVER (PARTITION BY staff_id ORDER BY Order_date, order_id) next_ord_date
FROM	sales.orders

-- LEAD, current row'dan belirtilen argümandaki rakam kadar sonraki deðeri getiriyor
-- Niye iki sütunu order by yaptýk? çünkü ayýn ayný gününde birden fazla sipariþ verilmiþ olabilir.
	-- o yüzden tarihe ilave olarak bir de order_id ye göre sýralama yaptýrdýk

--GENELLÝKLE LEAD VE LAG FONKSÝYONLARI SIRALANMIÞ BÝR LÝSTEYE UYGULANIR!!! O YÜZDEN ORDER BY KULLANILMALIDIR!!




---------------------------------WINDOWS FRAME ----------------------------------------


SELECT category_id, product_id,
	COUNT (*) OVER () TOTAL_ROW  -- bunun bize toplam satýr sayýsýný getirmesini bekliyoruz
FROM production.products


SELECT DISTINCT category_id,
	COUNT (*) OVER () TOTAL_ROW,
	COUNT(*) OVER (PARTITION BY category_id ORDER BY product_id) num_of_row
FROM production.products
-- son elde ettiðimiz sütunda category_id lerin satýr sayýsýný kümülatif olarak toplayarak getirdi.
	-- category_id :1 olan pencerenin sonuna baktýðýmýzda o kategoriye ait kaç satýr olduðunu (59) anlýyoruz
	-- product_id ye göre order by yaptýðýmýz için her bir categroy_id gruplamasý içinde product_id leri sýralýyor
		-- ve bu sýralamanýn her satýrýnda kümülatif olarak toplama yapýyor.

-- ORDER BY yapmazsak:
SELECT DISTINCT category_id,
	COUNT (*) OVER () TOTAL_ROW,
	COUNT(*) OVER (PARTITION BY category_id) total_num_of_row,
	COUNT(*) OVER (PARTITION BY category_id ORDER BY product_id) num_of_row
FROM production.products
-- 2.COUNT'tan ORDER BY'ý kaldýrýnca product_id ye göre order by ý kaldýrdýðýmýz için, 
	-- gruplanan categoru_id ye göre COUNT(*) sonucunu yani toplam row sayýsýný her bir category_id satýrýnýn yanýna yazdýrdý!


SELECT category_id,
COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current
from production.products

-- Grupladýðýmýz category_id satýrlarýný bu sefer ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ile saydýrdýk.
	-- Bulunduðu satýrda o satýrdan önceki tüm satýrlarý ve o satýrý iþleme sokarak toplama yapýyor.
	-- dolayýsýyla bir önceki query deki gibi kümülatif bir toplama iþlemi yapmýþ oluyor.



SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id
-- OVER iþlemi içindeki order by --> window fonksiyonu uygularken dikkate alacaðý order by
-- Sondaki order by --> select iþlemi sonundaki sonucun order by ý


SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id


SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id



SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1  PRECEDING AND 1 FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id
-- her satýr için kendinden önceki 1 satýrý ve sonraki 1 satýrý hesap ederek count iþlemi yap
	-- mesela 5. satýr için; önceki 1 satýra gitti, bu 4.satýrdýr... sonra kendinden sonraki 1.satýra gitti, bu 6. satýrdýr.
		-- bu iki satýr (4. ve 6. satýrlar) arasýnda 3 satýr olduðundan COUNT fonk. return olarak 3 getirdi.

SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id
-- her satýr için kendinden önceki 2 satýrý ve sonraki 3 satýrý hesap ederek count iþlemi yap
	-- mesela 5. satýr için; önceki 2 satýra gitti, bu 3.satýrdýr... sonra kendinden sonraki 3.satýra gitti, bu 8. satýrdýr.
		-- bu iki satýr (3. ve 8. satýrlar) arasýnda 6 satýr olduðundan COUNT fonk. return olarak 6 getirdi.


-- SORU 1: Tüm bisikletler arasýnda en ucuz bisikletin adý (FIRST_VALUE fonksiyonunu kullanýnýz)

-- First_value içine argüman olarak hangi sütundaki ilk deðeri istiyorsam onu alýyorum
SELECT *, FIRST_VALUE(product_name) OVER (ORDER BY list_price) 
FROM production.products


-- SORU 2: yukardaki sonucun yanýna list price nasýl yazdýrýrýz?

SELECT DISTINCT FIRST_VALUE(product_name) OVER (ORDER BY list_price), min(list_price) OVER() 
FROM production.products


-- SORU 3: Herbir kategorideki en ucuz bisikletin adý (FIRST_VALUE fonksiyonunu kullanýnýz)

SELECT DISTINCT category_id, FIRST_VALUE (product_name) OVER (partition by category_id  ORDER BY list_price)
FROM production.products
-- her kategorinin en ucuzunu sorduðu için category_id yi partition ile grupladýk. 



-- SORU 4: Tüm bisikletler arasýnda en ucuz bisikletin adý (LAST_VALUE fonksiyonunu kullanýnýz)

SELECT DISTINCT	
		FIRST_VALUE(product_name) OVER (ORDER BY list_price)
FROM production.products
-- tek satýrlýk first_value deðerini gördüm

SELECT DISTINCT	
		FIRST_VALUE(product_name) OVER (ORDER BY list_price),
		LAST_VALUE(product_name) OVER (ORDER BY list_price desc)
FROM production.products
-- LAST_VALUE satýrýný da girince birden fazla satýr getirdi!! 
-- LAST_VALUE'da FIRST_VALUE'dan farklý olarak ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING girmem gerek.

SELECT	DISTINCT
		FIRST_VALUE(product_name) OVER ( ORDER BY list_price),
		LAST_VALUE(product_name) OVER (	ORDER BY list_price desc ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM	production.products





---------------------------3. ANALYTIC NUMBERING FUNCTIONS -------------------------------

--ROW_NUMBER() - RANK() - DENSE_RANK() - CUME_DIST() - PERCENT_RANK() - NTILE()



-- SORU 1 : Herbir kategori içinde bisikletlerin fiyat sýralamasýný yapýnýz (artan fiyata göre 1'den baþlayýp birer birer artacak)

-- ROW_NUMBER baþtan aþaðýya numara verir. Sýralanmýþ bir liste üzerinden bir deðer seçebilmem için kullanýyoruz
	-- list_price sýralamasýnda 10 numaralý sýradaki ürünü getir dediðimde bu iþe yarar.
SELECT category_id, list_price,
	   ROW_NUMBER () OVER(PARTITION BY category_id ORDER BY list_price) AS ROW_NUM
FROM production.products
-- list price'ý niye sýraladýk, artan fiyata göre 1 den baþlayýp birer birer artacak dediði için..



-- SORU 2: Ayný soruyu ayný fiyatlý bisikletler ayný sýra numarasýný alacak þekilde yapýnýz 
	--(RANK fonksiyonunu kullanýnýz)

SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM
FROM	production.products
-- AYNI rank'te olan ikinci deðerin ranknumarasýný ilkinin numarasý ile deðiþtiriyor
	-- yani rank numrasý önceki ile ayný oluyor ve sonraki gelen için numara bir atlayarak kendi numarasý ile sýralanýyor.


-- SORU 3: Ayný soruyu ayný fiyatlý bisikletler ayný sýra numarasýný alacak þekilde yapýnýz 
	--(DENSE_RANK fonksiyonunu kullanýnýz)

SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM
FROM	production.products
-- DENSE_RANK'te RANK'ten farklý olarak; ayný rank'te olanlara ayný numarayý vermesine raðmen sýra numaralarý atlamýyor.



--SORU 4: Herbir kategori içinde bisikletlerin fiyatlarýna göre bulunduklarý yüzdelik dilimleri yazdýrýnýz. 
	-- PERCENT_RANK fonksiyonunu kullanýnýz.

SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,
		ROUND (PERCENT_RANK () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) PERCENT_RNK
FROM	production.products
-- Bu fonksiyon da ORDER BY'a baðlý!! Mutlaka ORDER BY kullanýlmalý!!!


--SORU 5: Ayný soruyu CUM_DIST ile yapýnýz:

SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,
		ROUND (PERCENT_RANK () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) PERCENT_RNK,
		ROUND (CUME_DIST () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) CUM_DIST
FROM	production.products



----------------- CUME_DIST ÝLE PERCENT_RANK ARASINDAKÝ FARKLAR---------------------

-- CUME_DIST: 

	-- Bir grup içindeki bir deðerin kümülatif daðýlýmýný döndürür; 
	-- yani, geçerli satýrdaki deðerden küçük veya ona eþit partition deðerlerinin yüzdesidir. 
	-- Bu, partition'un sýralamasýndaki current row'dan önceki veya eþ olan SATIR SAYISINI, 
		-- partitiondaki TOPLAM SATIR SAYISINA BÖLEREK temsil eder. 
		-- 0 ile 1 arasýnda deðiþen sonuçlar return eder ve partition'daki en büyük deðer 1 dir.

-- PERCENT_RANK:

-- En yüksek deðer hariç, geçerli satýrdaki deðerden küçük partition deðerlerinin yüzdesini döndürür. 
	--Return deðerleri 0 ile 1 arasýndadýr. 
	--Formülü þudur: (rank - 1) / (rows - 1) burada rank, o satýrýn rank'i; rows, partition satýrlarýnýn sayýsýdýr. 

-- ARALARINDAKÝ FARKI ÞU ÞEKÝLDE ÝZAH EDEBÝLÝRÝZ:

	-- PERCENT_RANK, current score'dan (o row'dan) daha düþük deðerlerin yüzdesini döndürür. 
	-- Kümülatif daðýlým anlamýna gelen CUME_DIST ise current skorun actual position'unu döndürür. 

	-- Yani bir partition'da (yukardaki örnekte category_id'leri gruplamýþtým) 100 score (deðer) varsa 
		--ve PERCENT_RANK 90 ise, bu score'un 90 score'dan yüksek olduðu anlamýna gelir. 
		-- CUME_DIST 90 ise, bu, score'un listedeki 90. olduðu anlamýna gelir.

-- CUME_DIST tekrar eden deðerleri iki kere hesaba katýyor. ama PERCENT_RANK bir kere katýyor.



--6. Her bir kategorideki bisikletleri artan fiyata göre 4 gruba ayýrýn. Mümkünse her grupta ayný sayýda bisiklet olacak.
	--(NTILE fonksiyonunu kullanýnýz)

SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,
		ROUND (CUME_DIST () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) CUM_DIST,
		ROUND (PERCENT_RANK () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) PERCENT_RNK,
		NTILE(4) OVER (PARTITION BY category_id ORDER BY list_price) ntil
FROM	production.products

-- NTILE : bir partition içindeki deðerleri belirlediðimiz paremetre sayýsýna (burada 4) bölüyor ve her bölüme numara atýyor
	-- kategory_id ye göre grupladýk. list_price a göre sýraladýk.
	-- 59 deðer var. NTILE bunlarý 4'e bölüyor (parametre olarak 4 girdiðimiz için)
	-- 15'er 15'er bunlara sýra numarasý veriyor. ilk 15'e 1 diyor, sonraki 15'e 2 diyor.... son gruba da 4 diyor



	--ÖDEV OLARAK BIRAKILAN SORULAR:

--SORU 7: maðazalarýn 2016 yýlýna ait haftalýk hareketli sipariþ sayýlarýný hesaplayýnýz


--SORU 8: '2016-03-12' ve '2016-04-12' arasýnda satýlan ürün sayýsýnýn 7 günlük hareketli ortalamasýný hesaplayýn.
