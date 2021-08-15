-- 15.07.2021 DawSQL Sessinon 2    (###########  GENÝÞ AÇIKLAMALI  ##############)

------------------ CROSS JOIN
-- Write a query that returns the table to be used to add products that are in the Products table 
-- but not in the stocks table to the stocks table with quantity = 0. 
-- (Do not forget to add products to all stores.)
-- Expected columns: store_id, product_id, quantity
-- (TR) Ürünler tablosundaki ürünleri eklemek için kullanýlacak tabloyu döndüren bir sorgu yazýn
-- ancak stok tablosunda deðil, miktar = 0 olan stok tablosuna
-- Tüm maðazalara ürün eklemeyi unutmayýn

SELECT B.store_id, A.product_id, A.product_name, 0 quantity -- quantity adýnda sütun oluþturup içine 0 giriyor. çünkü stokta olmayan ürünlerin id leri ile cross join yapacaðýz.
FROM production.products AS A
CROSS JOIN sales.stores AS B
-- böyle yaparsak production.products tablosundaki tüm product_id leri kullanmýþ oluruz. 
-- ama bizden stokta olmayan product'larý maðazalarla cross join yapmamýzý istiyor.
-- yani stoðu 0 olan hangi ürünler hangi maðazada bunu görmek istiyoruz!!

-- þimdi product_id'si prodcution.stocks tablosunda olmayan ürünleri seçerek bu iþlemi yapalým.
SELECT B.store_id, A.product_id, A.product_name, 0 quantity -- quantity adýnda sütun oluþturup içine 0 giriyor. çünkü stokta olmayan ürünlerin id leri ile cross join yapacaðýz.
FROM production.products AS A
CROSS JOIN sales.stores AS B
WHERE A.product_id NOT IN (SELECT product_id FROM production.stocks) -- product_id'si stoklarda olmayan ürünlerin product_id'lerini seç.
ORDER BY A.product_id, B.store_id                                    -- ve böylece products tablosunu stores ile cross join ederken stokta olmayan bu product_id leri kullan.
-- CROSS JOIN EDECEÐÝMÝZ BU ÝKÝ TABLO ARASINDA ORTAK SÜTUN OLMADIÐINA DÝKKAT ETTÝN MÝ!!!





------------------------ CROSS JOIN------------------------

-- Soru1: Hangi markada hangi kategoride kaçar ürün olduðu bilgisine ihtiyaç duyuluyor
-- Ürün sayýsý hesaplamadan sadece marka * kategori ihtimallerinin hepsini içeren bir tablo oluþturun
-- Çýkan sonucu daha kolay yorumlamak için brand_id ve category_id alanlarýna göre sýralayýn.

-- kaç farklý kategori * marka kombinasyonu yapabilirim bunu istiyor. bu tür durumlarda CROSS JOIN kullanýyoruz.
-- yani benden A tablosundaki her (gözlemi) satýrý B tablosundaki her bir satýrla eþleþtirmemi bekliyor

SELECT *
FROM production.brands
-- 9 marka olduðunu gördüm

SELECT *
FROM production.categories
-- 7 kategori var.

-- kartezyen çarpým yaparak her brand için 7 kategoriyi eþleþtirecek. 9 x 7 = 63 satýr sonuç çýkacak.

SELECT *
FROM production.brands
CROSS JOIN production.categories
order by
brand_id, category_id -- buraya sadece A.brand_id yazsak da category_id'lerini de kendi içinde sýralýyor.
-- iki tablodan yalnýzca brands tablosunda brand_id olduðundan production.brands.brand_id olarak uzun yazmaya gerek yok!


----- SELF JOIN------
-- ayný INNER JOIN gibidir. ayný tabloyu tekrar kendisi ile join ederek kendi içerisinde bilgiye ulaþmaya çalýþýyoruz.


-- Soru2: Write a query that returns the staff with their managers.
-- Expected columns: staff first name, staff last name, manager name
--(TR) Personeli yöneticileriyle birlikte döndüren bir sorgu yazýn.

--hem staff'ler hem manager'ler ayný sales.staffs tablosu içindeler. 
   --bu tablo kendi kendine iliþki içerisinde. bu tabloda iki tane sütun birbiri ile ayný bilgiyi taþýyor.
    -- burda staff_id ile manager_id birbiri ile iliþki içinde. her staff'in bir manageri var ve bu manager ayný zamanda bir staff..
     -- mesela staff_id si 2 olan Mireya'nýn manager_id'si 1.,  yani staff_id'si 1 olan kiþi Mireya'nýn manageri

--ayný tabloyu kendisi ile join edeceðim.
SELECT *
FROM sales.staffs

SELECT *
FROM sales.staffs AS A 
JOIN sales.staffs AS B
ON A.manager_id = B.staff_id --A tablosundan gelecek manager (manager_id), B tablsundaki staff olacak!

-- JOIN'i FROM-WHERE ile de yapabiliyoruz!! From'da tablolarý virgülle ayýrýp ON satýrýndaki eþleþmeyi WHERE ile yapabiliyoruz.
SELECT A.first_name AS Staff_Name, A.last_name AS Staff_Last, B.first_name AS Manager
FROM sales.staffs A, sales.staffs B
WHERE  A.manager_id = B.staff_id





------------------------ GROUPBY / HAVING ---------------

-- SQL'in kendi içindeki iþlem sýrasý:
   -- FROM		: hangi tablolara gitmem gerekiyor?
   -- WHERE		: o tablolardan hangi verileri çekmem gerekiyor?
   -- GROUP BY	: bu bilgileri ne þekilde gruplayayým?
   -- SELECT	: neleri getireyim ve hangi aggragate iþlemine tabi tutayým.
   -- HAVING	: yukardaki sorgu sonucu çýkan tablo üzerinden nasýl bir filtreleme yapayým
				 -- (mesela list_price>1000) 
				 -- gruplama yaptýðýmýz ayný sorgu içinde bir filtreleme yapmak istiyorsak HAVING kullanacaðýz
				 -- HAVING kullanmadan; 
				 -- HAVING'ten yukarýsýný alýp baþka bir SELECT sorgusunda WHERE þartý ile de bu filtrelemeyi yapabiliriz.
   -- ORDER BY	: çýkan sonucu hangi sýralama ile getireyim?


-- bu kod sadece üzerinde açýklama yapmak için yazýldý, çalýþtýrmayýnýz.
SELECT dept_name, AVG(salary) AS avg_salary -- grupladýðýmýz satýrlarýn karþýsýna ortalama salary bilgilerini koy.
FROM department
GROUP BY dept_name   -- dept_name'in satýrlarýný kendi içinde grupla (unique deðerlerini al)
HAVING avg_salary > 50000; --groupby ve aggregation sonucu ortaya çýkan tabloya sýnýrlama getir.

---DÝKKAT! HAVING ÝLE SADECE AGGREGATE ETTÝÐÝMÝZ SÜTUNA KOÞUL VEREBÝLÝRÝZ! 





--GROUPING OPERATION SORU 1: 
--Write a query that checks if any product id is repeated in more than one row in the products table.
--(TR) Ürünler tablosunda herhangi bir ürün kimliðinin birden fazla satýrda tekrarlanýp tekrarlanmadýðýný kontrol eden bir sorgu yazýn

SELECT product_name, COUNT(product_name)
FROM production.products
GROUP BY product_name
HAVING COUNT(product_name) > 1; ----HAVING’DE KULLANDIÐIN SÜTUN, AGGREGATE TE KULLANDIÐIN SÜTUN ÝSMÝYLE AYNI OLMALI!!. 
-- yukardaki çözüm product isimlerinin tekrar edip etmediðini verdi. 
-- oysa bizden istenen product_id lerden tekrar eden ar mý? yani product_id ler üzerinden iþlem yapmalýyýz!

-- hocanýn çözümü:
-- önce products larý görelim.
SELECT TOP 20* 
FROM production.products

SELECT product_id, COUNT(*) AS CNT_PRODUCT   
-- count(*) tüm rowlarý say demek. tablomuzda row'lar product_id lerden oluþtuðu için burada count(product_id) de ayný iþi görür.
FROM production.products					   
GROUP BY product_id 
-- bütün product_id lerin product tablosunda birer kere geçtiðini gördüm.


SELECT product_id, COUNT(*) AS CNT_PRODUCT 
FROM production.products
GROUP BY product_id		
HAVING COUNT(*) > 1  --satýr( product_id) sayýsý 1'den fazla olan sonuçlarý getir.            
--HAVING’DE KULLANDIÐIN SÜTUN, AGGREGATE TE KULLANDIÐIN SÜTUN ÝSMÝYLE AYNI OLMALI!! 

-- product_name e göre yapalým:
SELECT product_name, COUNT(*) AS CNT_PRODUCT  -- count(*) tüm rowlarý say demek. Burda count(product_id) de ayný iþi görür.
FROM production.products
GROUP BY product_name 
HAVING COUNT (*) > 1
--29 satýr sonuç çýktý. demek ki ayný product_name'den 1'den fazla olan 29 adet var.

-- aþaðýdaki gibi de kullanabiliriz.
SELECT product_name, COUNT(product_id) AS CNT_PRODUCT 
FROM production.products
GROUP BY product_name		
HAVING COUNT (product_id) > 1  --SQLite HAVING'te takma ad kullanmana izin veriyor ancak SQL Server izin vermiyor!
		
-- BÝR SAYMA ÝÞLEMÝ, BÝR GRUPLANDIRMA BÝR AGGREGATE ÝÞLEMÝ YAPIYORSAN ÝSÝMLE DEÐÝL ID ÝLE YAP.
-- ID'LER HER ZAMAN BÝRER DEFA GEÇER, ÝSÝMLER TEKRAR EDEBÝLÝR (ÖR:BÝR KAÇ PRODUCT'A AYNI ÝSÝM VERÝLMÝÞ OLABÝLÝR)!

SELECT product_id, product_name, COUNT (*) CNT_PRODUCT
FROM production.products
GROUP BY product_name   --BU SATIRA DÝKKAT!
HAVING COUNT (*) > 1
-- SELECT SATIRINDA YAZDIÐIN SÜTUNLARIN HEPSÝ GROUP BY'DA OLMASI GEREKÝYOR! 
-- production_id GROUP BY SATIRINDA OLMADIÐI ÝÇÝN HATA VERDÝ!

--doðru hali aþaðýdaki gibidir:
SELECT product_id, product_name, COUNT (*) CNT_PRODUCT
FROM production.products
GROUP BY product_name, product_id
HAVING COUNT (*) > 1





--GROUPING OPERATION SORU 2: 
-- Write a query that returns category ids with a maximum list price above 4000 or a minimum list price below 500
-- (TR) Maksimum liste fiyatý 4000'in üzerinde veya minimum liste fiyatý 500'ün altýnda olan kategori kimliklerini döndüren bir sorgu yazýn

SELECT category_id, MIN(list_price) AS min_price, MAX(list_price) AS max_price -- grupladýðýmýz þey category_id olduðu için SELECT'te onu getiriyoruz
FROM production.products
-- ana tablo içinde herhangi bir kýsýtlamam var mý yani where iþlemi var mý? yok. O zaman devam ediyorum
-- ANA TABLO ÝÇÝNDE HERHANGÝ BÝR KISITLAMA YAPMACAKSAN "WHERE" SATIRI KULLANMAYACAKSIN DEMEKTÝR.
GROUP BY
		category_id
HAVING
		MIN(list_price) < 500 OR MAX(list_price) > 4000
		--group by ve agg. neticesinde çýkan tabloyu bu conditionlara göre filtreleyip getirdik.
		-- Dikkat! soruyu iyi okumalýsýn. soruda veya dediði için OR kullandýk




--GROUPING OPERATION SORU 3-- 
-- Find the average product prices of the brands. 
-- As a result of the query, the average prices should be displayed in descending order.
-- (TR) Markalarýn ortalama ürün fiyatlarýný bulun. Sorgu sonucunda ortalama fiyatlar azalan sýrada görüntülenmelidir.

-- Bir kere AVERAGE istediði için GROUP BY kullanmam gerektiðini anlýyorum!
-- SORUDA AVERAGE VEYA TOPLAM GÝBÝ AGGREGATE ÝÞLEMÝ GEREKTÝRECEK BÝR ÝSTEK VARSA HEMEN "GROUP BY" KULLANMAM GEREKTÝÐÝNÝ ANLAMALIYIM.
SELECT brand_id, AVG(list_price) AS AVG_PRICE
FROM production.products
GROUP BY brand_id
ORDER BY AVG_PRICE DESC
-- brand_id lere göre yaptýðýmýz için ayný products tablosu yetti. 
-- fakat brand_name'lere göre gruplamak istersek tablo birleþtirmeliyiz.

--brands tablosundan brand_name leri çekip gruplayacaðýz, karþýlarýna products tablosundan çektiðimiz list_price'larýn ortalamasýný koyacaðýz.
SELECT A.brand_name, AVG(B.list_price) AS AVG_PRICE
FROM production.brands A, production.products B  -- buradaki virgül INNER JOIN ile ayný iþi yapýyor! virgülle beraber WHERE kullanýyoruz.
WHERE A.brand_id = B.brand_id
GROUP BY 
		A.brand_name
ORDER BY
		AVG_PRICE DESC -- ORDER BY 2 DESC olarak da yazabilirdik. Burada 2 --> SELECT satýrýndaki 2. veriyi temsil ediyor.

-- (virgül + WHERE yerine--> INNER JOIN ile çözüm)
SELECT A.brand_name, AVG(B.list_price) AS AVG_PRICE
FROM production.brands AS A
INNER JOIN production.products AS B
ON A.brand_id = B.brand_id
GROUP BY 
		A.brand_name
ORDER BY 
		AVG_PRICE DESC
-- ORDER BY 2 DESC olarak da yazabilirdik. Burada 2 --> SELECT satýrýndaki 2. veriyi temsil ediyor.




--GROUPING OPERATION SORU 4: 
-- Write a query that returns BRANDS with an average product price more than 1000
-- (TR) Ortalama ürün fiyatý 1000'den fazla olan MARKALARI döndüren bir sorgu yazýn.

-- Virgül + WHERE kullanarak çözümü:
SELECT A.brand_name, AVG(B.list_price) AS AVG_PRICE
FROM production.brands A, production.products B  
WHERE A.brand_id = B.brand_id
GROUP BY 
		A.brand_name
HAVING AVG(B.list_price) > 1000
ORDER BY
		2 DESC

-- INNER JOIN ile çözümü:
SELECT B.brand_name, AVG(list_price) as avg_price
FROM production.products as A
INNER JOIN production.brands as B
ON A.brand_id = B.brand_id
GROUP BY brand_name
HAVING AVG (list_price) > 1000
ORDER BY avg_price ASC;



--GROUPING OPERATION SORU 5: 
--Write a query that returns the net price paid by the customer for each order. (Don't neglect discounts and quantities)
--(TR) Her sipariþ için müþterinin ödediði net fiyatý döndüren bir sorgu yazýn. (Ýndirimleri ve miktarlarý ihmal etmeyin)

SELECT *, (quantity * list_price * (1-discount)) as net_price -- (list_price-list_price*discount) olarak da yazýlabilirdi.
FROM sales.order_items
-- bu query ile önce her bir item için list_price ve indirim uygulanmýþ net_price larý görüyoruz.
-- bazý order'larda birden fazla ürün sipariþ verildiðini görüyoruz. (Ör: 1 no. lu order_id'nin 5 adet item_id'si var.)
-- O yüzden ürünleri order_id olarak gruplandýrýp her grup için toplama (SUM) yaparsak her order için ödenen toplam item fiyatýný buluruz.
	-- yani her order_id için TOPLAM net_price'ý görmüþ olacaðým. (zaten soru "for each order" þeklinde bitiyordu)

SELECT order_id, SUM(quantity * list_price * (1-discount)) as net_price
FROM sales.order_items
GROUP BY 
		order_id

-- ayný soruyu customer'larý esas alarak çözersek :
	--order_items tablosunda customer bilgileri olmadýðýndan sales_orders tablosunu birleþtireceðim.
SELECT B.customer_id, SUM(quantity * (list_price - (list_price*A.discount))) AS TOTAL_NET_PRICE
FROM sales.order_items A, sales.orders B
where A.order_id = B.order_id
group by B.customer_id





--------------------- GROUPING SETS -----------------

-- BÝRDEN FAZLA GRUPLAMA KOMBÝNASYONU YAPMAMA ÝMKAN SAÐLIYOR. 
-- GROUP BY'dan farký : GROUP BY sadece bir sütunun verilerini grupluyordu. GROUPING SET ile ise birden fazla gruplama varyasyonu yapabiliyoruz

GROUP BY
GROUPING SETS 
(
(Product),
(Product, Size)
)
-- BURDA ÝKÝ SET HALÝNDE GRUPLUYOR. þöyle ki: Mesela Product sütunu "jean", "tshirt" ve "jacket" unique verilerinden oluþsun.
	-- önce gruplamanýn 1. setinin (Product) ilk verisini ("jean") alýp karþýlýðýný birinci satýra yazýyor, 
		-- sonra 2. setin (Product, Size gruplandýrmasýnýn) ilk verilerini yani jean'in "size" gruplarýnýn karþýlýklarýný sýrayla altýna yazýyor. 
		-- bu bitince tekrar 1. setin (Product) ikinci verisi olan "tshir"ü alýp karþýlýðýndaki deðeri altýna yazýyor.
		-- sonra 2. setin (Product, Size gruplandýrmasýnýn) ikinci verilerini yani tshirt'ün "size" gruplarýnýn karþýlýklarýný sýrayla yazýyor 
		-- ve böylece product verileri bitene kadar devam ediyor.





-------------- CREATING SUMMARY TABLE INTO OUR EXISTING TABLE -----------

SELECT *
INTO NEW_TABLE     -- INTO SATIRINDAKÝ TABLO ÝSMÝ ÝLE YENÝ BÝR TABLO OLUÞTURUYORUZ.
FROM SOURCE_TABLE  -- FROM'DAN SONRASI KAYNAK TABLOMUZ
WHERE ...
-- SELECT INTO kalýbý bize þunu saðlýyor: 
	-- yeni bir tablo oluþturmak istediðimde, diðer tablolardan ortaya çýkarttýðým yeni deðerlerden oluþan tabloyu 
	-- hýzlý bir þekilde yeni bir tabloya kopyalamayý saðlýyor.

	-- ÞÝMDÝ YENÝ BÝR TABLO OLUÞTURALIM.

-- brands tablosundan brand_name, categories tablosundan category_name, products tablosundan model_year
	-- sütunlarýný seçiyorum, indirim uygulanmýþ net fiyatlarý yuvarlayarak oluþturduðum sütunu da total_sales_price ismi vererek seçiyorum.
	-- bu sütunlardan gruplandýrýlmýþ haliyle sales_summary adýnda yeni bir tablo oluþturuyorum

SELECT C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year,
ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price --gruplarýn toplam net satýþ fiyatlarýndan oluþan sütun.
-- SELECT satýrýnda yeni oluþturacaðým tabloda bulunmasýný istediðim sütunlarý yazdýktan sonra
	-- bunlarý gönderececðim yeni tablonun ismini INTO satýrýnda belirliyorum : sales.sales_summary tablosu..
INTO sales.sales_summary  -- sütunlarýný SELECT satýrýnda belirlediðim yeni tablonun ismini burada belirliyorum.
FROM sales.order_items A, production.products B, production.brands C, production.categories D  --SELECT satýrýnda seçtiðimiz sütunlara ait tablolar.
WHERE A.product_id = B.product_id --A ile B tablolarýný product_id ile birleþtirdik.
AND B.brand_id = C.brand_id  -- B ile C tablolarýný brand_id ile birleþtirdik
AND B.category_id = D.category_id --B ile D'yi categroy_id ile birleþtirdik. hepsini birleþtirmiþ olduk.
GROUP BY
C.brand_name, D.category_name, B.model_year  --group by satýrýnda gruplandýrdýðýmýz sütunlar SELECT'te aynen olmalý!!

--!!!! DÝKKAT.. DAHA ÖNCE BU KOD ÇALIÞTIRILDIÐI VE sales_summary ÝSMÝNDE TABLO OLUÞTURULDUÐU ÝÇÝN TEKRAR ÇALIÞTIRIRSAN HATA ALIRSIN!

SELECT *
FROM sales.sales_summary
ORDER BY 1,2,3




----- BUNDAN SONRAKÝ SORULARDA BU TABLOYU KULLANACAÐIM!


-- 1. Toplam satýþ miktarýný hesaplayýnýz.
SELECT SUM(total_sales_price)
FROM sales.sales_summary

-- 2. Markalarýn toplam satýþ miktarýný hesaplayýnýz.

SELECT Brand, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY 
		Brand

-- 3. Kategori bazýnda toplam satýþ miktarýný hesaplayýnýz
SELECT Category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY 
		Category

-- 4. Marka ve kategori kýrýlýmlarýndaki toplam sales miktarlarýný hesaplayýnýz
SELECT Brand, Category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY 
		Brand, Category





---------------- Þimdi bu iþlemleri GROUPING SETS yöntemi ile yapalým :---------

SELECT Brand, Category, SUM(total_sales_price) TOTAL_SALES_PRICE
FROM sales.sales_summary
GROUP BY
		GROUPING SETS(
						(Brand),
						(Category),
						(Brand, Category),
						()    -- boþ parantez gruplandýrma olmayan durumlarý getirir. 
						)
ORDER BY
		1, 2

-- Öncelikle þunu söyleyim; grouping sets satýrýndaki sýralama önemli deðil, burada setleri parantez içinde göstermek yeterli.
	-- SQL sonuç tablosunu, SELECT satýrýndaki sýralamaya göre oluþturuyor. bunu asla unutmayalým.

-- !! Ayrýca bu satýrda hangi sütunun önce yazýldýðý önem arzediyor. 
	-- Çünkü ilk yazýlan sütunun elemanlarý tek tek sýra ile ikinci sütunun gruplandýrmasýna tabi oluyor!

-- Gelelim sonuç tablosunun açýklamasýna:
-- Birinci satýrda boþ parantezin sonucu sergilendi. 
	-- Bu satýrda gruplandýrma olmadýðýndan karþýlýðýna tüm satýrlarýn toplamý olan TOTAL_SALES_PRICE deðeri geldi.

-- 2. satýrdan 8.satýr dahil, yalnýzca Category'e göre gruplandýrdý ve category'nin (ikinci sýradaki sütunun) tek baþýna gruplandýrma iþi burada bitti. 
	-- Burada category'nin her grubunun toplamýný TOTAL_SALES_PRICE sütununa yazdý. Brand sütunda karþýlýðý olmadýðýndan buralara komple NULL geldi.

-- 9. satýrdan itibaren þöyle bir gruplandýrma döngüsünün iþlediðini görüyoruz: 
	-- (Brand 1.elemaný) --> (Brand 1.elemaný, Category) --> (Brand 2.elamaný) --> (Brand 2.elamaný, Category) -->-->--> böylece devam ediyor.
	--  yani 9, 14, 17, 19, 21, 23, 25, 31 ve 35. satýrlarda Brand'in tek baþýna gruplanmýþ satýrlarýdýr. 
	-- aralarýndaki satýrlar ise göreceðiniz üzere (Brand, Category) ikili gruplandýrmasýna aittir.
	-- Bu demektir ki Örneðin Elektra markasýnýn kategorilerinin sýralandýðý 10-13 satýrlarýndaki value'larýn toplamý, Elektra markasýnýn tek baþýna gruplandýðý 9.satýrdaki value'ya eþittir.

-- Böylece GROUPING SETS de belirttiðimiz gruplandýrma setlerini alt alta gelecek þekilde return etmiþ oluyor.

					----- Marie Curie hocama binlerce teþekkür -----




----------------- ROLLUP VE CUBE ile GRUPLAMA------------------

-- ROLLUP, en ayrýntýlýdan genel toplama kadar ihtiyaç duyulan herhangi bir toplama düzeyinde alt toplamlar oluþturur.
-- CUBE, ROLLUP’a benzer ama tek bir ifadenin tüm olasý alt toplam kombinasyonlarýný hesaplamasýný saðlar
 



-------------- ROLLUP GRUPLAMA-------------

--SYNTAX:
SELECT
		d1,
		d2,
		d3, 
		aggregate_function
FROM
		table_name
GROUP BY
		ROLLUP (d1,d2,d3);

	-- önce tüm sütunlarý alýp grupluyor, sonra saðdan baþlayarak teker teker sütun silerek her defasýnda yeniden bir gruplama yapýyor;
		-- önce üç sütuna göre grupluyor, sonra sondakini atýp ilk 2 sütuna göre grupluyor,
		-- sonra sondakini yine atýp ilk sütuna göre grupluyor
		-- sonra hiç gruplamýyor.-- 

SELECT brand, category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY
		ROLLUP (Brand, Category)
ORDER BY
		1,2;
-- sonuç tablosunu GROUPING SETS te olduðu gibi ayný mantýkla sýralýyor. (brand-1) + (brand-1,category) + (brand-2) + (brand-2, category) + .....




------------------- CUBE GRUPLAMA----------------------
SELECT
		d1,
		d2,
		d3, 
		aggregate_function
FROM
		table_name
GROUP BY
		CUBE (d1,d2,d3);

--- önce önce üç sütunu birden grupluyor.               (d1,d2,d3)
-- sonra kalanlarý 2'þer 2'þer 3 defa gruplama yapýyor. (d1,d2) + (d1,d3) + (d2,d3)
-- sonra kalanlarý teker teker grupluyor.               (d1) + (d2) + (d3)   
-- en son gruplamýyor.                                  ()

SELECT brand, category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY
		CUBE (Brand, Category)
ORDER BY
		1,2;



------------------------ BU NOTEBOOK'TA GEÇEN ÖNEMLÝ NOTLAR-----------------------------------

-- SQL'ÝN KENDÝ ÝÇÝNDEKÝ ÝÞLEM SIRASI:
   -- FROM		: hangi tablolara gitmem gerekiyor?
   -- WHERE		: o tablolardan hangi verileri çekmem gerekiyor?
   -- GROUP BY	: bu bilgileri ne þekilde gruplayayým?
   -- SELECT	: neleri getireyim ve hangi aggragate iþlemine tabi tutayým.
   -- HAVING	: yukardaki sorgu sonucu çýkan tablo üzerinden nasýl bir filtreleme yapayým
				 -- (mesela list_price>1000) 
				 -- gruplama yaptýðýmýz ayný sorgu içinde bir filtreleme yapmak istiyorsak HAVING kullanacaðýz
				 -- HAVING kullanmadan; 
				 -- HAVING'ten yukarýsýný alýp baþka bir SELECT sorgusunda WHERE þartý ile de bu filtrelemeyi yapabiliriz.
   -- ORDER BY	: çýkan sonucu hangi sýralama ile getireyim?

-- ANA TABLO ÝÇÝNDE HERHANGÝ BÝR KISITLAMA YAPMACAKSAN "WHERE" SATIRI KULLANMAYACAKSIN DEMEKTÝR.

-- ORDER BY, SELECT'TEN SONRA ÇALIÞIYOR DOLAYISIYLA SELECT'TE YAZDIÐIM ALLIAS'I KABUL EDER.

-- CROSS JOIN EDECEÐÝMÝZ ÝKÝ TABLO ARASINDA ORTAK SÜTUN OLMASI GEREKMÝYOR.

-- ÝKÝ VERÝNÝN KOMBÝNASYONDAN BAHSEDÝYORSAK CROSS JOIN KULLANIYORUZ.

-- CROSS JOIN A tablosundaki her (gözlemi) satýrý B tablosundaki her bir satýrla eþleþtiriyor.

-- SELF JOIN: INNER JOIN GÝBÝDÝR. AYNI TABLOYU TEKRAR KENDÝSÝYLE JOIN EDEREK KENDÝ ÝÇERÝSÝNDE BÝR BÝLGÝYE ULAÞMAYA ÇALIÞIYORUZ.

-- JOIN'i FROM-WHERE ÝLE DE YAPABÝLÝYORUZ! BUNUN ÝÇÝN BÝRLEÞTÝRECEÐÝMÝZ TABLOLARI FROM SATIRINDA VÝRGÜLLE YAN YANA YAZIP, 
	-- ON SATIRINDAKÝ EÞLEÞMEYÝ WHERE SATIRINDA YAPIYORUZ.

-- SORUDA AVERAGE VEYA TOPLAM GÝBÝ AGGREGATE ÝÞLEMÝ GEREKTÝRECEK BÝR ÝSTEK VARSA HEMEN "GROUP BY" KULLANMAM GEREKTÝÐÝNÝ ANLAMALIYIM.

-- BÝR SAYMA ÝÞLEMÝ, BÝR GRUPLANDIRMA BÝR AGGREGATE ÝÞLEMÝ YAPIYORSAN ÝSÝMLE DEÐÝL ID ÝLE YAP.
	-- ID'LER HER ZAMAN BÝRER DEFA GEÇER, ÝSÝMLER TEKRAR EDEBÝLÝR (ÖR:BÝR KAÇ PRODUCT'A AYNI ÝSÝM VERÝLMÝÞ OLABÝLÝR)!

-- SELECT SATIRINDA YAZDIÐIN SÜTUNLARIN HEPSÝ GROUP BY'DA OLMASI GEREKÝYOR!

-- HAVING ÝLE SADECE AGGREGATE ETTÝÐÝMÝZ SÜTUNA KOÞUL VEREBÝLÝRÝZ! . 
	--HAVING’DE KULLANDIÐIN SÜTUN, AGGREGATE TE KULLANDIÐIN SÜTUNLA AYNI OLMALI.

-- SQLite HAVING SATIRINDA TAKMA AD KULLANMANA ÝZÝN VERÝYOR ANCAK SQL Server ÝZÝN VERMÝYOR!

-- ORDER BY SATIRINDAKÝ ÝLK PARAMETRE (ÖRNEÐÝN) 2 ÝSE BU SELECT SATIRINDAKÝ 2. VERÝYE GÖRE SIRALA DEMEKTÝR.
	-- ORNEÐÝN: ORDER BY AVG_PRICE DESC -- YERÝNE--  ORDER BY 2 DESC -- DE YAZABÝLÝRÝZ.

-- CREATING SUMMARY TABLE INTO OUR EXISTING TABLE 

SELECT *
INTO NEW_TABLE     -- INTO SATIRINDAKÝ TABLO ÝSMÝ ÝLE YENÝ BÝR TABLO OLUÞTURUYORUZ.
FROM SOURCE_TABLE  -- FROM'DAN SONRASI KAYNAK TABLOMUZ
WHERE ...

-- SELECT INTO kalýbý bize þunu saðlýyor: 
	-- yeni bir tablo oluþturmak istediðimde, diðer tablolardan ortaya çýkarttýðým yeni deðerlerden oluþan tabloyu 
	-- hýzlý bir þekilde yeni bir tabloya kopyalamayý saðlýyor.

-- GROUPING SETS :

-- BÝRDEN FAZLA GRUPLAMA KOMBÝNASYONU YAPMAMA ÝMKAN SAÐLIYOR. 
	-- GROUP BY'dan farký : GROUP BY sadece bir sütunun verilerini grupluyordu. 
	-- GROUPING SET ile ise birden fazla gruplama varyasyonu yapabiliyoruz

-- GROUPING SETS SATIRINDAKÝ SIRALAMA ÖNEMLÝ DEÐÝL, BURADA SETLERÝ PARANTEZ ÝÇÝNDE GÖSTERMEK YETERLÝ.
	-- SQL, SONUÇ TABLOSUNU "SELECT" SATIRINDAKÝ SIRALAMAYA GÖRE OLUÞTURUYOR. 
	-- BU YÜZDEN BU SATIRA HANGÝ SÜTUNUN ÖNCE YAZILDIÐI ÖNEM ARZ EDÝYOR. 
	-- ÇÜNKÜ ÝLK YAZILAN SÜTUNUN ELEMANLARI RESULT TABLOSUNDA TEK TEK SIRA ÝLE ÝKÝNCÝ SÜTUNUN GRUPLANDIRMASINA TABÝ OLUYOR!

-- ROLLUP GRUPLAMA:
	-- önce tüm sütunlarý alýp grupluyor, sonra saðdan baþlayarak teker teker sütun silerek her defasýnda yeniden bir gruplama yapýyor;
	-- önce üç sütuna göre grupluyor, sonra sondakini atýp ilk 2 sütuna göre grupluyor,
	-- sonra sondakini yine atýp ilk sütuna göre grupluyor
	-- sonra hiç gruplamýyor.

-- CUBE GRUPLAMA:
	-- önce önce üç sütunu birden grupluyor.                (d1,d2,d3)
	-- sonra kalanlarý 2'þer 2'þer 3 defa gruplama yapýyor. (d1,d2) + (d1,d3) + (d2,d3)
	-- sonra kalanlarý teker teker grupluyor.               (d1) + (d2) + (d3)   
	-- en son gruplamýyor.                                  ()
