------------------------DAwSQL Lab3 (10.08.2021) -----------------------



-- SORU 1: Find the weekly order count for the city of Baldwin for the last 8 weeks earlier from '2016-08-18', 
	-- and also the cumulative total
	-- Desired output : [week_num, order_count, cuml_order_count]

	--(TR) --Baldwin þehrindeki '2016-08-18' tarihinden önceki 8 haftaya ait sipariþ sayýlarýný ve kümülatif sipariþ toplamlarýný getiriniz.

select DATEADD(WEEK, -8, '2016-08-18')
-- DATEPART(WEEK, order_date) fonksiyonu, içine girilen tarihe ait haftanýn, yýlýn kaçýncý haftasý olduðunu bulur.

SELECT *
FROM sales.orders AS A, sales.stores AS B
WHERE A.store_id = B.store_id
and B.city = 'Baldwin'
and A.order_date BETWEEN DATEADD(WEEK, -8, '2016-08-18') AND '2016-08-18'
	-- 2016-08-18 tarihininde yýla göre kaçýncý hafta ise ondan 8 çýkart ve order_date'in 
		-- belirtilen tarih ile bu tarih arasýnda olma condition'ýný uygula.
ORDER BY A.order_date ASC;

--
SELECT DATEPART(WEEK, order_date), order_date
from sales.orders


SELECT DISTINCT DATEPART(WEEK, order_date) AS week_num,
			COUNT(order_id) OVER(PARTITION BY DATEPART(WEEK, order_date)) AS order_count
FROM sales.orders AS A, sales.stores AS B
WHERE A.store_id = B.store_id
and B.city = 'Baldwin'
and A.order_date BETWEEN DATEADD(WEEK, -8, '2016-08-18') AND '2016-08-18'
ORDER BY A.order_date ASC;
-- order_date'i order by yaptýðýmýz için VE WINDOW FUNCTIONLAR ÝLE ORDER BY ÇALIÞMADIÐI ÝÇÝN ORDER BY'I KULLANMAMIZ HATA VERDÝ.
	-- (WINDOW FUNCTION ÝÇÝNDEKÝ ORDER BY ZATEN ORDER YAPIYOR)

SELECT DISTINCT DATEPART(WEEK, order_date) AS week_num,
			COUNT(order_id) OVER(PARTITION BY DATEPART(WEEK, order_date)) AS order_count
			-- order_date'in hafta numarasýna göre grupla ve bu gruba ait order_id'leri sayarak karþýsýna yaz.
FROM sales.orders AS A, sales.stores AS B
WHERE A.store_id = B.store_id
and B.city = 'Baldwin'
and A.order_date BETWEEN DATEADD(WEEK, -8, '2016-08-18') AND '2016-08-18';


-- BU KODUN ÝÇÝNDEKÝ AÇIKLAMALAR ÇOK ÖNEMLÝ!
SELECT DISTINCT DATEPART(WEEK, order_date) AS week_num,
			    COUNT(order_id) OVER(PARTITION BY DATEPART(WEEK, order_date)) AS order_count,
				--count iþlemini her partition (burada week numarasý) için ayrý yap ve yanýna yaz.
				COUNT(order_id) OVER(ORDER BY DATEPART(WEEK, order_date)) AS cuml_order_count
				-- count iþlemini order_date sýrasýna göre toplaya toplaya yazdýr. (partition girilmediði için;
					-- her hafta numarasýný ayrý bir window olarak görmeyecek ve 
					-- order_date sýrasýna göre order_id'lerin sayýsýný kendi içinde (window fonksiyonunun özelliði gereði) kümülatif olarak toplayarak verecek.
FROM sales.orders AS A, sales.stores AS B
WHERE A.store_id = B.store_id
and B.city = 'Baldwin'
and A.order_date BETWEEN DATEADD(WEEK, -8, '2016-08-18') AND '2016-08-18';

-- OVER'IN ÝÇÝNDE ORDER BY KULLANMADIÐIMDA DÝREKT WINDOW TOPLAMINI TÜM SATIRLARA YAZDIÐINI GÖRÜYORUZ:
SELECT DISTINCT DATEPART(WEEK, order_date) AS week_num,
			    COUNT(order_id) OVER(PARTITION BY DATEPART(WEEK, order_date)) AS order_count,
				COUNT(order_id) OVER() AS cuml_order_count
FROM sales.orders AS A, sales.stores AS B
WHERE A.store_id = B.store_id
and B.city = 'Baldwin'
and A.order_date BETWEEN DATEADD(WEEK, -8, '2016-08-18') AND '2016-08-18';


--#################################################################################################


---SORU 2: Write a query that returns customer who ordered the same product on two consecutive orders. 
	-- expected output: customer_id, product_id, previous order date, next order date

--(TR) Ayný ürünü iki ardýþýk sipariþte sipariþ eden müþterileri döndüren bir sorgu yazýn..

SELECT
	B.customer_id,
	A.product_id,
	B.order_date,
	B.order_id
FROM sales.order_items as A, sales.orders as B
WHERE A.order_id = B.order_id
ORDER BY B.customer_id, B.order_date;


SELECT
	B.customer_id,
	A.product_id,
	B.order_date,
	B.order_id,
	DENSE_RANK() OVER(PARTITION BY B.customer_id ORDER BY order_date) -- RANK, DENSE_RANK VB. SIRALAMA FONKSÝYONLARI OVER'IN ÝÇÝNDEKÝ ORDER BY ÝLE ÇALIÞIYOR.
FROM sales.order_items as A, sales.orders as B							-- NEYE GÖRE ORDER BY YAPILMIÞSA ONA GÖRE KENDÝ ÝÇÝNDE AYRI NUMARALAR VERÝYOR.
WHERE A.order_id = B.order_id											-- BU FONKSÝYONLAR ORDER BY OLMADAN ÇALIÞMIYOR.
ORDER BY B.customer_id, B.order_date;
--- customer_id gruplamasýna göre order_date lerimin sýrasýyla gelmesini istiyorum çünkü 
	-- peþ peþe iki order'ýn ayný sipariþ olup olmadýðýna bakmak istiyorum. 
	-- bu yüzden DENSE_RANK yapýp içinde order by'ý order_date e göre yaptým.

-- fakat ayný gün içinde art arda iki sipariþ verilmiþ olabileceðinden 
	--DENSE_RANK'teki order by'a bir de order_id'yi koydum.
SELECT
		B.customer_id,
		A.product_id,
		B.order_date,
		B.order_id,
		DENSE_RANK() OVER(PARTITION BY B.customer_id order by order_date, A.order_id) as historical_numerate
FROM sales.order_items as A, sales.orders as B
WHERE A.order_id = B.order_id
-- ayný customer'ýn farklý product_idlerine order_date ve order_id ler baz alýnarak sýra numarasý verildi.
	-- fakat istediðim her customer'ýn ayný product'ý art arda sipariþ ettiði tarihleri getirmekti!

---OWEN HOCA ÇÖZÜME BU ÞEKÝLDE DEVAM ETTÝ:

-- EN alttaki WHERE satýrýnda; T1 ile T2 customer_id lerini eþitlemediðimiz için prev ve next_order'larý customer_id bazýnda getirmedi
WITH T1 AS
(
SELECT	Customer_id, Order_Date, B.product_id, A.order_id,
		DENSE_RANK() OVER (PARTITION BY Customer_id ORDER BY Order_Date) historical_numerate
		-- customer_id'leri order_date e göre sýralayýp DENSE_RANK ile sýra numarasý verdik.
		-- customer_id lere göre gruplayýp, ORDER BY (Order_date) gereði bu gruplarýn içinde order_date'lere göre DENSE_RANK numaralarý verecek.
FROM	sales.orders A, 
		sales.order_items B
WHERE	A.order_id=B.order_id
), T2 AS
(
SELECT	Customer_id, Order_Date, B.product_id, A.order_id,
		DENSE_RANK() OVER (PARTITION BY Customer_id ORDER BY Order_Date) historical_numerate
	-- customer'larý gruplayýp gruplar içinde order_date'lere göre sýralama yaptýk ve DENSE_RANK ile sýra numarasý verdik.
	-- her müþterinin kendi order_date'lerine sýra numarasý vermiþ olduk.
FROM	sales.orders A, 
		sales.order_items B
WHERE	A.order_id=B.order_id
)
SELECT	T2.customer_id,
		T2.product_id,
		T1.order_date,
		T1.order_id,
		T1.historical_numerate PREV_ORD,
		T2.order_date,
		T2.historical_numerate NEXT_ORD
FROM	T1, T2
WHERE	T1.product_id = T2.product_id
AND		T1.historical_numerate + 1 = T2.historical_numerate 

-- T1.customer_id = T2.customer_id eþitlemesini yapalým:
WITH T1 AS
(
SELECT	Customer_id, Order_Date, B.product_id, A.order_id,
		DENSE_RANK() OVER (PARTITION BY Customer_id ORDER BY Order_Date) historical_numerate
	-- customer'larý gruplayýp gruplar içinde order_date'lere göre sýralama yaptýk ve DENSE_RANK ile sýra numarasý verdik.
	-- her müþterinin kendi order_date'lerine sýra numarasý vermiþ olduk.
FROM	sales.orders A, 
		sales.order_items B
WHERE	A.order_id=B.order_id
), T2 AS
(
SELECT	Customer_id, Order_Date, B.product_id, A.order_id,
		DENSE_RANK() OVER (PARTITION BY Customer_id ORDER BY Order_Date) historical_numerate 
FROM	sales.orders A, 
		sales.order_items B
WHERE	A.order_id=B.order_id
)
SELECT	T2.customer_id,
		T2.product_id,
		T1.order_date,
		T1.order_id,
		T1.historical_numerate PREV_ORD,
		T2.order_date,
		T2.historical_numerate NEXT_ORD
FROM	T1, T2
WHERE	T1.customer_id = T2.customer_id
AND		T1.product_id = T2.product_id
AND		T1.historical_numerate + 1 = T2.historical_numerate 
-- Burada AND ile baðlanmýþ üç condition var. 
	--1. customer_id'ler eþit mi (eþit olanlarý al)
	--2. product_id'ler eþit mi (eþit olanlarý al)
	--3. ilk iki condition saðlandýðýnda bir de ;
		-- birinci tablodan gelen DENCE_RANK'e 1 eklediðimde bu ikinci tablodaki DENCE_RANK'e eþit oluyor mu? 
			-- yani customer ve product_id leri ayný olan bu satýrlarýn DENCE_RANK'leri birbiri ardýna mý geliyor??
		-- Bu þartlar ancak customer ve productýn ayný fakat order_id'si birbiri ardýna geliyor ise saðlanýr (T1.historical_numerate + 1 dediðimiz için)

--AYRICA, DENSE_RANK satýrýnda ORDER BY içine Order_id yi de soksaydýk, ayný tarihte ayný ürün için verilen farklý bir 
	-- order_id(sipariþ numarasý) olmasý halinde de bunu yakalardý. çünkü bu sefer DENCE_RANK sadece order_date e göre deðil,
		-- order_id ler deðiþtiðinde de farklý numara verecektir. ve ayný ürün (tarihi ayný olsa da) ardýþýk iki order'da sipariþ edilmiþ olduðu ortaya çýkacaktýr.
		-- datamýzda böyle bir durum olmadýðýndan ORDER BY içinde Order_date'in yanýna order_id'yi eklesek de ayný sonucu verecektir.


--CONTROL

SELECT	Customer_id, Order_Date, B.product_id, A.order_id,
		DENSE_RANK() OVER (PARTITION BY Customer_id ORDER BY Order_Date) historical_numerate
FROM	sales.orders A, 
		sales.order_items B
WHERE	A.order_id=B.order_id
AND		customer_id = 24



--


SELECT	Customer_id, B.product_id,
		DENSE_RANK() OVER (PARTITION BY Customer_id ORDER BY Order_Date) +1 historical_numerate
FROM	sales.orders A, 
		sales.order_items B
WHERE	A.order_id=B.order_id

INTERSECT

SELECT	Customer_id, B.product_id,
		DENSE_RANK() OVER (PARTITION BY Customer_id ORDER BY Order_Date) historical_numerate
FROM	sales.orders A, 
		sales.order_items B
WHERE	A.order_id=B.order_id





