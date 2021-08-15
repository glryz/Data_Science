------DAwSQL 17.07.2021 Session 3 (Organize Complex Queries)-------

-- Bir tabloda meydana gelen sonucu baþka bir tablo veya iþlem için kullanmak için 3 yöntem:
	-- Subqueries
	-- Views
	-- Common Table Expression (CTE's)

-- subqueries, SELECT, FROM ve WHERE satýrlarýnda kullanýlabiliyor.
	-- WHERE'de subquery sonucunda dönen ifadelere göre ana tablo üzerinden bir filtreleme yapacaðýn anlamýna geliyor.
		--WHERE'in her zaman ana tablo üzerinde filtreleme yaptýðýný unutma!
	-- SELECT'te subquery içindeki deðeri SELECT satýrýnda döndürmek için kullanýlýyor
	-- SELECT satýrýndaki subquery TEK BÝR SÜTUN VEYA SATIR DÖNDÜRMEK ZORUNDA! (sadece bir deðer döndürmeli)
	-- FROM da subquery bir tablo getirmesi lazým. baþka kýstaslara göre bir tablo oluþuruyor ve bunu Fromda kullanmak üzere getiriyor.

	-- SUBQUERY ÇEÞÝTLERÝ
		-- Single-row  : Tek bir satýr döndürür. SELECT'te kullanýlan gibi. 
		-- Multiple-row: Birden fazla deðer döndüren subquery
		-- Correlated : üstteki sorgu ile alltaki sorgunun birbiri ile eþlenerek baðlantý kurulduðu subquery

	-- SINGLE-ROW SUBQUERY
		-- =, <, >, >=, <=, <>, != operatörleri ile özellikle WHERE satýrýnda kullanýlan subquerylerdir.


-------------- PIVOT -----------

-- Pivot, satýr bazlý analiz sonucunu sütun bazýna dönüþtürülmesini saðlýyor. 
	-- group by gibi bir gruplama yapýyor. dolayýsýla group by kullanmýyoruz, pivota özel bir syntax kullanýyoruz
	-- bu syntax içerisinde aggregate iþlemi yapýp ilgili sütunlardaki kategorilere göre bir pivot table oluþturuyor.
	-- ve o sütunun satýrlarýný oluþturan her bir kategoriyi birer sütuna dönüþtürüyor. yani satýrlardaki value'lar sütunlarda sergileniyor

-- Pivot tablosunda sütun ve value olarak gözükmesini istediðim sütunlarý (feature'larý) Pivot'un üstündeki SELECT satýrýna ekliyorum.
	--Bunlardan VALUE olacak olan sütununa Pivot ile baþlayan kod bloðunda AGGRAGATE iþlemi uyguluyorum.
	-- Unutmayalým ki pivot table, group by iþleminin aynýsýný yapýyor. Aggregate iþlemi de oradan geliyor.

-- Eðer kaynak tablomdaki bir sütun hem value'lar için kullanýlacak (aggregate yapýlacak) hem de ayrý bir boyut olarak kullanýlacak ise;
	-- SELECT satýrýnda bu sütun iki kere yazýlmalý (biri ilave boyut için diðeri value'larý oluþturmak için)
	-- Fakat "The column 'xxxxxx' was specified multiple times" hatasý almamak için birine "Alias" (takma ad) verilmeli!!! Örneði aþaðýda 

--SYNTAX
SELECT [column_name], [pivot_value1], [pivot_value2], ...[pivot_value_n]
FROM
table_name
PIVOT
(
aggregate_function(aggregate_column)
FOR pivot_column
IN ([pivot_value1], [pivot_value2], ... [pivot_value_n])
) AS pivot_table_name;


--ÖRNEK:

SELECT *
FROM sales.sales_summary

-- önce kaynak tabloyu oluþturuyoruz. ben pivot table'ý veya aggregate iþlemini hangi tablodan oluþturmak istiyorum?
-- ben kategorilere göre toplam fiyatlarý bulmak istiyorum.
SELECT category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY Category

-- þimdi category sütununun satýrlarýný (bisiklet kategorilerini) sütunlara alacak 
-- ve total_sales_price'larý value olarak satýrlara getirecek þekilde pivot table yapalým
SELECT *
FROM sales.sales_summary
PIVOT
(
	SUM(total_sales_price)
	FOR category IN  -- burada belirlediðimiz pivot column'un, grupladýðýmýz column olduðuna dikkat et.
	(
	[Children Bicycles], -- category sütunu altýnda bu kategoriler vardý. bunlar pivot table ýn sütunlarý olacak.
    [Comfort Bicycles], 
    [Cruisers Bicycles], 
    [Cyclocross Bicycles], 
    [Electric Bikes], 
    [Mountain Bikes], 
    [Road Bikes])
	) AS PIVOT_TABLE  -- pivot table'a bir isim vermemiz gerekiyor.

-- þimdi son dokunuþlarla bu kodu biraz daha spesifik hale getirelim.

-- önce kaynak tabloyu belirtiyoruz. kaynak tablom bu query:
SELECT Category, total_sales_price
FROM sales.sales_summary

--- þimdi Pivot iþlemi sonucunda ortaya çýkacak tablo için  bir SELECT iþlemi daha yapmam gerekiyor.
SELECT *  
FROM 
(SELECT Category, total_sales_price  -- bu parantezin içi kaynak tablom.
FROM sales.sales_summary
) A
PIVOT
(
	SUM(total_sales_price)
	FOR category	-- pivot sütunumuz category, ve value'larýmýz bu sütundaki bisiklet modelleri olacak
	IN(
	[Children Bicycles], 
    [Comfort Bicycles], 
    [Cruisers Bicycles], 
    [Cyclocross Bicycles], 
    [Electric Bikes], 
    [Mountain Bikes], 
    [Road Bikes])
	) AS PIVOT_TABLE

-- ben buna bir boyut daha eklemek istersem..
	-- category sütununa göre gruplamýþtýk. bir de model_year gruplamasý olsun.
SELECT category, model_year, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY Category, Model_Year
ORDER BY 1  -- bir de order by ekleyelim güzel gözüksün.
--- þimdi bir kýrýlma daha bir boyut daha eklemiþ olduk. önceden sadecec kategorilere göre ayýrým yapýyordu
	-- þimdi ise kategorilerin içinde model yýllara göre de ayýrým yaptýk.

-- model_year boyutunu pivot table'a ekleyip görelim.
	-- kaynak tablomun SELECT satýrýna model_year sütununu eklemeliyim.
SELECT category, Model_Year, total_sales_price 
			FROM SALES.sales_summary

SELECT *
FROM
			(
			SELECT category, Model_Year, total_sales_price --model_year eklendi.
			FROM SALES.sales_summary
			) A
PIVOT
(
	SUM(total_sales_price)
	FOR category IN
	(
	[Children Bicycles], 
    [Comfort Bicycles], 
    [Cruisers Bicycles], 
    [Cyclocross Bicycles], 
    [Electric Bikes], 
    [Mountain Bikes], 
    [Road Bikes])
	) AS PIVOT_TABLE
-- görüldüðü gibi görsel olarak çok rahat okunan bir tablo elde ettik.


-- -------------------
CREATE VIEW Brands_Categories AS
SELECT	category_name, brand_name
FROM
	(
	SELECT
		C.category_name AS category_name,
		A.brand_name AS brand_name
	FROM production.brands A, production.products B, production.categories C
	WHERE A.brand_id = B.brand_id AND B.category_id = c.category_id
	GROUP BY C.category_name, A.brand_name
	) A
;

SELECT *
FROM
	(
	SELECT	category_name, brand_name
	FROM	Brands_Categories
	) A
PIVOT
(
COUNT(brand_name)
FOR	category_name
IN	(
	[Children Bicycles],
        [Comfort Bicycles],
        [Cruisers Bicycles],
        [Cyclocross Bicycles],
        [Electric Bikes],
        [Mountain Bikes],
        [Road Bikes]
	)
) AS PIVOT_TABLE

-- BU PÝVOT TABLOSUNDA MARKA ÝSÝMLERÝNÝ DE AYRI BÝR BOYUT OLARAK KATALIM.
	-- Bunun için brand_name'i SELECT'te eklemem yeterli. ancak orada brand_name aggregate iþlemi için yani
	-- value'ler için kullanýldýðý için ikinci kez eklediðimde buna Alias vermem gerekiyor!!
SELECT *
FROM
	(
	SELECT	category_name, brand_name AS BRAND_NAMES, brand_name -- 2. kere kullandýðýmda brand_name'e alias verdim.
	FROM	Brands_Categories
	) A
PIVOT
(
COUNT(brand_name)
FOR	category_name
IN	(
	[Children Bicycles],
        [Comfort Bicycles],
        [Cruisers Bicycles],
        [Cyclocross Bicycles],
        [Electric Bikes],
        [Mountain Bikes],
        [Road Bikes]
	)
) AS PIVOT_TABLE





----------------------- KONU: SUBQUERY -----------------

-- SORU 1 : Bring all the personnels from the store that Kali Vargas works.
-- (TR) Kali Vargas'ýn çalýþtýðý maðazadan tüm personeli getirin.

------------SINGLE ROW SUBQUERIES----------------

SELECT *
FROM sales.staffs --tüm çalýþanlarý ve çalýþtýklarý maðazalarý getirdim. 8.satýrda Kali Vargasý ve çalýþtýðý store'un id sini görebiliyorum.

SELECT *
FROM sales.staffs
WHERE first_name = 'Kali' AND last_name = 'Vargas' 
-- staffs tablosunda first_name Kali ve last_name Vargas olan satýrý getir dedik.
-- ve store_id sinin 3 olduðunu gördük. Aþaðýda WHERE store_id=3 d e diyebiliriz.

-- staffs tablosunda store_id= (subquery'den gelen store_id) þeklinde bir query kuracaðýz.
SELECT *
FROM sales.staffs
WHERE store_id = (SELECT store_id
				  FROM sales.staffs
				  WHERE first_name = 'Kali' and last_name = 'Vargas')




-- SORU 2: List the staff what Venita Daniel is the manager of.
-- (Tr) Venita Daniel'in yöneticisi olduðu personeli listeleyin.

-- Venita Daniel'in staff_id si kimin manager_id'si ise onlarý listeleyeceðiz.
SELECT *
FROM sales.staffs
WHERE manager_id = (                -- Venita'nýn staff id sinin manager_id si olan personeli tanýmladýk.
					SELECT staff_id		
					FROM sales.staffs
					WHERE first_name = 'Venita' AND last_name = 'Daniel' -- subquery'de Venita'nýn staff id sini çektik.
					)

-- alternatif çözüm (self join ile):
SELECT A.*
FROM sales.staffs A, sales.staffs B
WHERE A.manager_id = B.staff_id
AND B.first_name = 'Venita' AND B.last_name = 'Daniel'
-- burada A.manager_id = B.staff_id dediðimiz için (yani A'nin manager_id'si B'nin staff_id'si olanlara eþit olma durumu) B.first_name='Venita' yaptýk. 
	-- eðer A.first_name='Venita' deseydik (yani A'daki first_name Venita olsun deseydik) Venita'nýn manager'ýný getirirdi bize.



-- SORU 3: Write a query that returns customer in the city where the 'Rowlett Bikes' store is located.
-- (TR) 'Rowlett Bikes' maðazasýnýn bulunduðu þehirde müþteriyi döndüren bir sorgu yazýn.

-- önce Rowlet Bikes store'un bulunduðu city'i bulalým. (sales.stores tablosunda city isimleri var)
SELECT city
FROM sales.stores
WHERE store_name = 'Rowlett Bikes' 
-- Rowlet þehrinde olduðunu gördük. bu query aþaðýda ana query'mizin subquery'si olacak.

-- þimdi sales.custormers tablosunda city=Rowlet olan verileri görelim.
SELECT *
FROM sales.customers
WHERE city= (
			SELECT city
			FROM sales.stores
			WHERE store_name = 'Rowlett Bikes'
			)



-- SORU 4: List bikes that are more expensive than the 'Trek CrossRip+ - 2018' bike
-- TR: 'Trek CrossRip - 2018' bisikletinden daha pahalý olan bisikletleri listeleyin

--önce subquery'i belirlemekle baþlayalým. bahsedilen bisikletin fiyatýný çekelim.
select list_price
from production.products 
where product_name = 'Trek CrossRip+ - 2018',

-- þimdi listenmesi istenen sütunlarýn hangi listelerde olduðuna bakarak o listeleri join edeceðim 
	-- ve subquery'i WHERE satýrýnda yerine koyarak query'mi oluþturacaðým.
	-- istenen sütunlar: product_id, product_name, model_year, list_price, brand_name, category_name
SELECT DISTINCT A.product_id, A.product_name, A.model_year, A.list_price, B.brand_name, C.category_name
FROM production.products AS A, production.brands AS B, production.categories AS C
WHERE A.brand_id = B.brand_id AND A.category_id = C.category_id
AND list_price > (SELECT list_price
					FROM production.products
					WHERE product_name= 'Trek CrossRip+ - 2018')
-- WHERE satýrýmda hem listelerimi join ettim hem de SUBQUERY kullanarak filtreleme þartýmý ekledim.
-- DISTICT attým ki tekrarlayan sütunlar gelmesin. 
	-- Ancak burda DISTINCT atmadan da ayný sonuca ulaþýyorum, çünkü tekrar yok. 
	-- DISTINCT maliyetli bir iþ, SQL e ekstra iþlem ve yük getiren bir iþ bu yüzden burda DISTINCT kullanmamam lazým. 
	-- Genelde DISTINCT'i bir aggregation iþlemi yapmýyorsak en son sonuç tablosunda, sonuç select'in de kullanýrýz. 
	-- önceki select lerde kullanmayýz.





-- SORU 5: List customers who orders previous dates than Arla Ellis.
-- (TR) Arla Ellis'ten önceki tarihlerde sipariþ veren müþterileri listeleyin.

-- önce Arla Ellis'in sipariþ verdiði tarihi bulalým ki onu ana query de subquery olarak kullanabilelim. 
	-- tarihler orders tablosunda, isimler customers tablosunda olduðu için orders ve customers tablolarýný birleþtirmem gerekiyor.
SELECT *
FROM sales.customers A, sales.orders B
WHERE A.customer_id = B.customer_id
and A.first_name = 'Arla' and A.last_name='Ellis'
-- bu isimle tek bir customer var ve bir order var
-- bu sorgunun sonuçlarýndan order_date i alacaðým ve bu sonucu da subquery yapýp 
-- aradýðýmýz order_date'in bu subquery'den gelen date'ten önce olma durumunu < operatörü ile sorgulayacaðýz.


-- þimdi istenen sütunlarla birlikte query'mizi yazalým ve WHERE satýrýndaki condition'da yukardaki subquery'i kullanalým.
SELECT A.customer_id, A.first_name, A.last_name, B.order_date
FROM sales.customers A, sales.orders B
WHERE order_date < (
					SELECT B.order_date
					FROM sales.customers A, sales.orders B
					where A.customer_id = B.customer_id
					and A.first_name = 'Arla' and A.last_name='Ellis'
					)

--------------- MULTIPLE ROW SUBQUERIES -------------------
	--Birden çok deðer döndüren subquerylerdir.
	-- Birçok deðer içerisinden bir deðer arýyor ve onlar içerisinde bir filtreleme yapacaksam IN, NOT IN, ANY ve ALL operatörlerini kullanýyorum.

					

-- SORU 6 : List order dates for customers residing in the Holbrook city.
-- (TR) Holbrook þehrinde oturan müþterilerin sipariþ tarihlerini listeleyin.

-- bunu JOIN ile de yapabiliriz ama buda subquery ile yapacaðýz.

-- önce Holbrook þehrindeki customer id leri görelim.
select customer_id
from sales.customers 
where city='Holbrook'

-- orders tablosunda 1615 order_date var.
SELECT order_date
FROM sales.orders

-- yukardaki query'i subquery yaparak order_date'i filtreleyelim 
	--ve sadece Holbrook þehrinde yaþayan customer'larýn order_date lerini getirsin.
SELECT order_date
FROM sales.orders
WHERE customer_id IN (
					SELECT customer_id
					FROM sales.customers 
					WHERE city='Holbrook'
					)
-- Holbrook þehrinde yaþayan müþterilere ait 3 order_date olduðunu gördüm.

-- NOT IN ile yaparsak Holbrook dýþýnda yaþayanlarýn tarihlerini getirecektir.
SELECT order_date
FROM sales.orders
WHERE customer_id NOT IN (
					  SELECT customer_id
					  FROM sales.customers
					  WHERE city = 'Holbrook'
					  )




-- SORU 7: List products in categories other than Cruisers Bicycles, Mountain Bikes, or Road Bikes.
-- (TR) Ürünleri Cruisers Bicycles, Mountain BikeS veya Road Bikes DIÞINDAKÝ kategorilerde listeleyin.


SELECT category_id
FROM	production.categories
WHERE	category_name IN ('Cruisers Bicycles', 'Mountain Bikes', 'Road Bikes')
-- bu kategorilerin categori id lerini çektim. bunu ana query de WHERE satýrýnda kullanacaðým.

SELECT *
FROM production.products A, production.categories B
WHERE A.category_id = B.category_id and category_name IN (
							SELECT category_name
							FROM production.categories
							WHERE category_name NOT IN ('Cruisers Bicycles', 'Mountain Bikes', 'Road Bikes')
							)
order by product_id --buna gerek yoktu, sýralý olmasý için kullandým.
-- aslýnda benden sadece product larý istediði için burada category_id ve category_name sütunlarýný getirmeme gerek yoktu. 
	-- bu durumda fazladan bir join iþlemi yapmýþ oldum. 
	-- joinsiz olarak çözüm daha az maliyetli olacaktýr ve kesinlikle o þekilde tercih edilmelidir.

-- JOIN yapmaksýzýn sadece products tablosu ile çözüme ulaþalým
SELECT	product_name, list_price, model_year --bu sütunlar yeterli olacaktýr.
FROM	production.products
WHERE	category_id NOT IN (       
							SELECT category_id
							FROM	production.categories
							WHERE	category_name IN ('Cruisers Bicycles', 'Mountain Bikes', 'Road Bikes')
							)
-- dikkat edersen önceki çözümde subquery'de NOT IN kullandým WHERE satýrýnda IN kullandým. 
	--burada ise tam tersini yaptým.

-- ayrýca subquery deki SELECT satýrýnda * veya birden fazla sütun belirtemeyiz hata verir.
	-- çünkü bu subquery ile ana query'nin WHERE satýrýnda category_id lere bir condition saðlayacaðýmdan,
	-- subquery sadece category_id sütunu döndürmelidir.


-- sadece 2016 yýlýna ait sonuçlarý getirmek istersek:
SELECT	product_name, list_price, model_year
FROM	production.products
WHERE	category_id NOT IN (
						SELECT category_id
						FROM	production.categories
						WHERE	category_name IN ('Cruisers Bicycles', 'Mountain Bikes', 'Road Bikes')
							)
AND model_year = '2016'  -- WHERE satýrýnda bir filtreleme daha yaptým. AND ile istediðim kadar filtreleme yapabilirim.





-- SORU 8: Elektrikli bisikletlerden daha pahalý olan bisikletleri listeleyin.

-- önce subquery'mizi yazalým. electric bikes'larýn fiyatlarýný getirelim.
SELECT A.*, B.product_name, B.list_price
FROM production.categories A, production.products B
WHERE A.category_id = B.category_id 
AND A.category_name = 'Electric Bikes'

-- benim ilgilendiðim list_price'lar olduðundan list_price sütununu çekiyorum.
SELECT B.list_price
FROM production.categories A, production.products B
WHERE A.category_id = B.category_id 
AND A.category_name = 'Electric Bikes'

-- þimdi asýl sorgumuzu yazalým:
SELECT	product_name, model_year, list_price
FROM	production.products
WHERE	list_price > (           
					SELECT	B.list_price
					FROM	production.categories A, production.products B
					WHERE	A.category_id = B.category_id
					AND		A.category_name = 'Electric Bikes'
					)
-- "subquery returned more than 1 value" hatasý verdi. çünkü > operatörü karþýsýnda bir tek value ister.
	-- Aþaðýdaki queryde "ALL" komutu ile bunu çözüyoruz.

SELECT	product_name, model_year, list_price
FROM	production.products
WHERE	list_price > ALL (               -- elektrikli bisikletlerin tümünden daha pahalý olanlarý getir.
					SELECT	B.list_price  -- yani en pahalý elektrikli bisikletten daha pahalý olanlarý getiriyor.
					FROM	production.categories A, production.products B
					WHERE	A.category_id = B.category_id
					AND		A.category_name = 'Electric Bikes'
					)
-- ALL yazarak, subquery deki BÜTÜN fiyatlardan daha yüksek olanlarýnkini filtreliyoruz. 
	-- Dolayýsýyla tek bir value olmasa da bu subquery'i kabul ediyor.

-- elektriklik bisikletlerden herhangi birinden daha pahalý olan bisikletleri listeleyin
SELECT	product_name, model_year, list_price
FROM	production.products
WHERE	list_price >  ANY (             -- elektrikli bisikletlerin herhangi birinden daha pahalý olanlarý getir.
					SELECT	B.list_price  --her bir elektrikli bisikletten daha pahalý olanlarý getiriyor.
					FROM	production.categories A, production.products B
					WHERE	A.category_id = B.category_id
					AND		A.category_name = 'Electric Bikes'
					)
--Elektrikli bisiklet kategorisindeki herhangi birinden daha yüksek fiyatlý olanlarý getiriyor.

-- Aslýnda ALL dediðimizde maksimum fiyatlý olandan daha yüksek fiyatlý olanlarý, 
-- ANY dediðimizde ise minimum fiyatlý olandan daha yüksek fiyiatlý olanlarý getirmiþ oldu.


,

		--------------- CORRELATED SUBQUERIES ------------------

		-----------------EXISTS & NOT EXISTS -------------------

		-- SUBQERY ile ana QUERY tablolarýnýn birbiri ile join edilmesi, birbirine baðlanmasýdýr.

--- Bunlar genelde EXISTS ve NOT EXISTS ile kullanýlýyor.

-- EXIST kullandýðýn zaman; subquery herhangi bir sonuç döndürürse üstteki query'i ÇALIÞTIR anlamýna geliyor
-- NOT EXIST ; subquery herhangi bir sonuç döndürürse üstteki query'i ÇALIÞTIRMA anlamýna geliyor



-- SORU : Write a query that returns State where 'Trek Remedy 9.8 - 2017' product is not ordered.
-- (TR) 'Trek Remedy 9.8 - 2017' ürününün sipariþ edilmediði State'leri getir.


-- bu ürünün product_name'i elimde. yani products tablosunu kullanacaðým. 
	--istenen ise bunun State'i, o da sales.customers tablosunda,
	-- bu iki tabloyu sales.order_items ve sales_orders tablolarý üzerinden birbirine baðlayacaðým.
SELECT D.state
FROM production.products A, sales.order_items B, sales.orders C, sales.customers D
WHERE A.product_id = B.product_id and B.order_id = C.order_id and C.customer_id = D.customer_id
and A.product_name = 'Trek Remedy 9.8 - 2017'
-- 14 state var ama birbirini tekrar edenler de var. Bu yüzden DISTINCT çekiyorum

SELECT DISTINCT D.state
FROM production.products A, sales.order_items B, sales.orders C, sales.customers D
WHERE A.product_id = B.product_id 
and B.order_id = C.order_id 
and C.customer_id = D.customer_id
and A.product_name = 'Trek Remedy 9.8 - 2017'
-- þimdi bu product ismiyle 2 state'ten sipariþ verildiðini gördüm.


SELECT DISTINCT state
FROM sales.customers
WHERE state NOT IN (
					SELECT DISTINCT D.STATE -- BURADA DISTINCT'e gerek yok.
					FROM production.products A, sales.order_items B, sales.orders C, sales.customers D
					WHERE A.product_id = B.product_id
					and B.order_id = C.order_id
					and C.customer_id = D.customer_id 
					and A.product_name = 'Trek Remedy 9.8 - 2017')					
-- NOT IN ile bu product'ýn sipariþinin verildiði (çünkü state'i sales.customers tablosundan çekiyoruz) state'lerin dýþýnda kalan state'leri getir demiþ olduk.


----- Ya NOT IN yerine NOT EXISTS kullanýrsam:

SELECT DISTINCT state
FROM sales.customers
WHERE NOT EXISTS (
					SELECT DISTINCT D.STATE
					FROM production.products A, sales.order_items B, sales.orders C, sales.customers D
					WHERE A.product_id = B.product_id
					and B.order_id = C.order_id
					and C.customer_id = D.customer_id 
					and A.product_name = 'Trek Remedy 9.8 - 2017'	
					)
-- Hata verdi. çünkü EXISTS kullanýrsan subquery ile query'i join yapmanýz gerekir

--query'leri sales.customer üzerinden joinleyelim:
SELECT DISTINCT state
FROM sales.customers X
WHERE EXISTS (
					SELECT DISTINCT D.STATE
					FROM production.products A, sales.order_items B, sales.orders C, sales.customers D
					WHERE A.product_id = B.product_id
					and B.order_id = C.order_id
					and C.customer_id = D.customer_id 
					and A.product_name = 'Trek Remedy 9.8 - 2017'
					and X.state = D.state
					) 
-- EXISTS ile demiþ olduk ki: Subquery ile yukardaki ana tablonun ilgili deðerleri eþleþiyorsa bu EXISTS bir deðer döndürüyor.
	-- Yukardaki customer tablosunun state i ile subquery deki state eþitse bana onlarý getir diyorum
	
-- NOT EXISTS deseydik : eðer eþitlenenler varsa bunlarý getirme, bunlar olmasýn diyorum. Yani burda NOT IN gibi davranýyor.
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

--Bakýn aþaðýda subquery'nin SELECT satýrýna 1 yazdým. yine ayný sonucu verdi.
-- Çünkü EXISTS, subquery'nin SELECT ifadesinde çaðýrdýðýnýz deðerlerle ilgilenmiyor,
-- sadece buranýn sonuç döndürüp döndürmediðiyle ile ilgileniyor.
-- yani sonda yazdýðýmýz X.state=D.state joini ile ilgileniyor.
-- Aþaðýdaki query de:
-- NOT EXISTS --> X.state = D.state ile eþitlenenleri getirme diyor.
-- EXIST -------> eþitlenenlerý getirebilirsin.
SELECT	DISTINCT STATE
FROM	sales.customers X
WHERE NOT EXISTS 	(
						SELECT	1
						FROM	production.products A, sales.order_items B, sales.orders C, sales.customers D
						WHERE	A.product_id = B.product_id
						AND		B.order_id = C.order_id
						AND		C.customer_id = D.customer_id
						AND		A.product_name = 'Trek Remedy 9.8 - 2017'
						AND		X.state = D.state
						)



              --------------- VIEWS -------------------

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
WITH query_name [(column_name1, ....)] AS
	(SELECT ....)   -- CTE Definition

SQL_Statement
-- sadece WITH kýsmýný yazarsan tek baþýna çalýþmaz. WITH ile belirttiðim query'yi birazdan kullanacaðým demek bu. 
-- asýl SQL statement içinde bunu kullanýyoruz.

-- RECURSIVE
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



-- SORU (VIEW): Sipariþ detaylarý ile ilgili bir VIEW oluþturun ve birkaç sorgu içinde kullanýn.

-- Müþteri adý soyadý, order_date, product_name, model_year, quantity, list_price, final_price (indirimli fiyat)
-- yukardaki bu bilgileri farklý tablolardan alabiliriz. farklý tablolardan her seferinde ayný sorguyu çalýþtýrýp bir sonuç almaktansa;
-- bunlarý ben bir kere kaydedeyim ve tablo güncellendikçe bunlar da güncellensin dediðimde VIEW kullanýyorum.

SELECT	A.first_name, A.last_name, B.order_date, D.product_name, D.model_year,
		C.quantity, C.list_price, C.list_price * (1-C.discount) final_price
FROM	sales.customers A, sales.orders B, sales.order_items C, production.products D
WHERE	A.customer_id = B.customer_id AND
		B.order_id = C.order_id AND
		C.product_id = D.product_id
-- ben her defasýnda bu query'i çalýþtýrmam gerekiyor. Bu da her seferinde arka tarafta ayný iþlemlerin yapýlmasý anlamýna geliyor.

-- ben bu tabloyu VIEW olarak CREATE etmek istiyorum:

CREATE VIEW SUMMARY_VIEW AS 
SELECT	A.first_name, A.last_name, B.order_date, D.product_name, D.model_year,
		C.quantity, C.list_price, C.list_price * (1-C.discount) final_price
FROM	sales.customers A, sales.orders B, sales.order_items C, production.products D
WHERE	A.customer_id = B.customer_id AND
		B.order_id = C.order_id AND
		C.product_id = D.product_id

-- istediðim zaman VIEW'ý çaðýrarak kullanabilirim. 
SELECT *
FROM SUMMARY_VIEW

-- ana tablo güncellendikçe VIEW' da otomatik olarak güncellenir.
-- bu tablo olarak create edildiðinde ana tablodan verileri çekip ekstradan kaydetmiþ olacaktým.
	-- ve ana tablodaki deðerler güncellendiðinde bu tablo güncellenmemiþ olacaktý. 
	-- yani tablo create etmek maliyetli bir iþlemdir.


-- Eðer sadece bu session da tablonun create edilmesini istiyorum, session sonunda da tablonun gitmesini istiyorum dersen:

SELECT	A.first_name, A.last_name, B.order_date, D.product_name, D.model_year,
		C.quantity, C.list_price, C.list_price * (1-C.discount) final_price
INTO #SUMMARY_TABLE
FROM	sales.customers A, sales.orders B, sales.order_items C, production.products D
WHERE	A.customer_id = B.customer_id AND
		B.order_id = C.order_id AND
		C.product_id = D.product_id
	
SELECT *
FROM #SUMMARY_TABLE



--------------------- BU NOTEBOOK DA GEÇEN ÖNEMLÝ AÇIKLAMALAR--------------------

-- Bir tabloda meydana gelen sonucu baþka bir tablo veya iþlem için kullanmak için 3 yöntem:
	-- Subqueries
	-- Views
	-- Common Table Expression (CTE's)

-- subqueries, SELECT, FROM ve WHERE satýrlarýnda kullanýlabiliyor.
	-- WHERE'de subquery sonucunda dönen ifadelere göre ana tablo üzerinden bir filtreleme yapacaðýn anlamýna geliyor.
		--WHERE'in her zaman ana tablo üzerinde filtreleme yaptýðýný unutma!
	-- SELECT'te subquery içindeki deðeri SELECT satýrýnda döndürmek için kullanýlýyor
	-- SELECT satýrýndaki subquery TEK BÝR SÜTUN VEYA SATIR DÖNDÜRMEK ZORUNDA! (sadece bir deðer döndürmeli)
	-- FROM da subquery bir tablo getirmesi lazým. baþka kýstaslara göre bir tablo oluþuruyor ve bunu Fromda kullanmak üzere getiriyor.

	-- SUBQUERY ÇEÞÝTLERÝ
		-- Single-row  : Tek bir satýr döndürür. SELECT'te kullanýlan gibi. 
		-- Multiple-row: Birden fazla deðer döndüren subquery
		-- Correlated : üstteki sorgu ile alltaki sorgunun birbiri ile eþlenerek baðlantý kurulduðu subquery

	-- SINGLE-ROW SUBQUERY
		-- =, <, >, >=, <=, <>, != operatörleri ile özellikle WHERE satýrýnda kullanýlan subquerylerdir.


-------------- PIVOT -----------

-- Pivot, satýr bazlý analiz sonucunu sütun bazýna dönüþtürülmesini saðlýyor. 
	-- group by gibi bir gruplama yapýyor. dolayýsýla group by kullanmýyoruz, pivota özel bir syntax kullanýyoruz
	-- bu syntax içerisinde aggregate iþlemi yapýp ilgili sütunlardaki kategorilere göre bir pivot table oluþturuyor.
	-- ve o sütunun satýrlarýný oluþturan her bir kategoriyi birer sütuna dönüþtürüyor. yani satýrlardaki value'lar sütunlarda sergileniyor


	-- Eðer DISTINCT atmadan da ayný sonuca ulaþýyorsak 
	-- DISTINCT maliyetli bir iþ olduðundan ve SQL e ekstra iþlem ve yük getirdiðinden DISTINCT kullanmamam lazým. 
	-- Genelde DISTINCT'i bir aggregation iþlemi yapmýyorsak en son sonuç tablosunda, sonuç select'in de kullanýrýz. 
	-- önceki select lerde kullanmayýz.


--------------- MULTIPLE ROW SUBQUERIES -------------------
	--Birden çok deðer döndüren subquerylerdir.
	-- Birçok deðer içerisinden bir deðer arýyor ve onlar içerisinde bir filtreleme yapacaksam IN, NOT IN, ANY ve ALL operatörlerini kullanýyorum.


		--------------- CORRELATED SUBQUERIES ------------------

		-----------------EXISTS & NOT EXISTS -------------------

		-- SUBQERY ile ana QUERY tablolarýnýn birbiri ile join edilmesi, birbirine baðlanmasýdýr.

--- Bunlar genelde EXISTS ve NOT EXISTS ile kullanýlýyor.

-- EXIST kullandýðýn zaman; subquery herhangi bir sonuç döndürürse üstteki query'i ÇALIÞTIR anlamýna geliyor
-- NOT EXIST ; subquery herhangi bir sonuç döndürürse üstteki query'i ÇALIÞTIRMA anlamýna geliyor

--Subquery'nin SELECT satýrýna 1 yazdým. yine ayný sonucu verdi.
	-- Çünkü EXISTS, subquery'nin SELECT ifadesinde çaðýrdýðýnýz deðerlerle ilgilenmiyor,
	-- sadece buranýn sonuç döndürüp döndürmediðiyle ile ilgileniyor.

	             --------------- VIEWS -------------------

-- Subquery'ler, CTE(Common Table Expression)'lar, VIEW'lar hep ayný amaca hizmet ediyor. Tablolarla daha rahat çalýþmamýzý saðlýyorlar. ,
	-- Diðer bir avantajý da performansý artýrmaktýr. Siz query'nizi joinlerle tek bir query içinde deðil, subery lerle, CTE'lerle,
	-- VIEW'larla daralta daralta (daraltýlmýþ tablolarla) sonuca gitmeye çalýþýyorsunuz.
				-----------AVANTAJLARI:-------------
	--        Performans + Simplicity + Security + Storage 
	
	-- VIEW : Tek bir tabloda yapacaðýmýz iþlemleri aþamalar bölerek yapmamýzý saðlýyor. Bu da hýzýmýzý arttýrýyor.
	-- VIEW ile ayný tablo gibi oluþturuyoruz ve bu VIEW'a kimleri eriþebileceðini belirleyebiliyoruz. bu da security saðlýyor.
	-- VIEW'larýn kullanýmý da oluþturmasý basittir. büyük tablonun içerisinde biz bir kýsým ilgilendimiz verileri alýp onlar üzerinden çalýþýyoruz.
	-- VIEW'lar çok az yer kaplar. çübkü asýl tablonun bir görüntüsüdür.

	-- ana tablo güncellendikçe VIEW' da otomatik olarak güncellenir.
		-- bu tablo olarak create edildiðinde ana tablodan verileri çekip ekstradan kaydetmiþ olacaktým.
		-- ve ana tablodaki deðerler güncellendiðinde bu tablo güncellenmemiþ olacaktý. 
		-- yani tablo create etmek maliyetli bir iþlemdir.


	-- Müþteri adý soyadý, order_date, product_name, model_year, quantity, list_price, final_price (indirimli fiyat)
	-- yukardaki bu bilgileri farklý tablolardan alabiliriz. farklý tablolardan her seferinde ayný sorguyu çalýþtýrýp bir sonuç almaktansa;
	-- bunlarý ben bir kere kaydedeyim ve tablo güncellendikçe bunlar da güncellensin dediðimde VIEW kullanýyorum.



			-------------- CTE - COMMON TABLE ESPRESSIONS -------------

-- Subquery mantýðý ile ayný. Subquery'de içerde bir tablo ile ilgileniyorduk CTE'de yukarda yazýyoruz.

--(CTE), baþka bir SELECT, INSERT, DELETE veya UPDATE deyiminde baþvurabileceðiniz veya içinde kullanabileceðiniz geçici bir sonuç kümesidir. 
-- Baþka bir SQL sorgusu içinde tanýmlayabileceðiniz bir sorgudur. Bu nedenle, diðer sorgular CTE'yi bir tablo gibi kullanabilir. 
-- CTE, daha büyük bir sorguda kullanýlmak üzere yardýmcý ifadeler yazmamýzý saðlar.

