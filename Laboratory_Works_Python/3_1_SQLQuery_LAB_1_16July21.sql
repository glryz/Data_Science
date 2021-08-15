-------------16.07.2021 DAwSQL LAb 1 ---------------

-- Soru 1: Write a query that returns the average prices according to brands and categories.
-- (TR) Marka ve kategorilere göre ortalama fiyatlarý döndüren bir sorgu yazýnýz.

-- brand ve category tablolarýný join yapamýyoruz. bu ikisini products tablosu üzerinden baðlayacaðýz.

SELECT A.brand_name, B.category_name, AVG(C.list_price) AVG_PRICE
FROM production.brands A, production.categories B, production.products C
-- INNER JOIN yapýyorsan yukardaki sýralama önemli deðil ama LEFT/RIGHT JOIN yapýyorsan bu sýralama önemli.
WHERE A.brand_id = C.brand_id  --categories de brand id yok products ta var.
AND B.category_id = C.category_id -- burada da B.categories'i eklemiþ oldum.
GROUP BY
		A.brand_name, B.category_name
ORDER BY
		3 DESC -- AVG_PRICE sütununa göre order yap
-- Trek marka bisikletin ilk 3 kategoride en pahalý marka olduðunu sonra Electra geldiðini görüyorum.

SELECT A.brand_name, B.category_name, AVG(C.list_price) AVG_PRICE
FROM production.brands A, production.categories B, production.products C
-- INNER JOIN yapýyorsan yukardaki sýralama önemli deðil ama LEFT/RIGHT JOIN yapýyorsan bu sýralama önemli.
WHERE A.brand_id = C.brand_id  --categories de brand id yok products ta var.
AND B.category_id = C.category_id -- burada da B.categories'i eklemiþ oldum.
GROUP BY
		A.brand_name, B.category_name
ORDER BY
		1,2 DESC -- sýralamaya göre aþaðýdaki okuma deðiþiyor.


-- Soru 2: Write a query that returns the store which has the most sales quantitiy in 2016
-- (TR) 2016 yýlýnda en çok satýþ adetine sahip maðazayý döndüren bir sorgu yazýnýz.

SELECT TOP 20*
FROM sales.orders
-- orders tablosauna gitme nedenim store_id yi tespit etmek. diðer nedenim yýlý seçmek.

SELECT TOP 20*
FROM sales.order_items

-- Aggregate olarak SUM ile kullanacaðým. SUM deðerleri sayar. COUNT yapsaydým satýrlarý sayacaktý!!!
SELECT C.store_id, C.store_name, SUM(B.quantity) TOTAL_PRODUCT --satýþ miktarýný bulmam için order itemslara göre quantity i toplamam gerek
FROM sales.orders A, sales.order_items B, sales.stores C
--order tablosuyla order_items tablosunu neye göre join yapacaðým? Order_id lere göre..
WHERE A.order_id = B.order_id
AND A.store_id = C.store_id   -- bunu stores ile neyle birleþtireceðim ? store_id ile
GROUP BY
		C.store_id, C.store_name
-- 3 maðaza var zaten. 3 maðazaya göre miktarlar geldi. þimdi 2016 yýlý kriterini girmeliyim

-- ana tablolarda filtreleme yapmak için HAVING deðil WHERE i kullanmam gerek.
SELECT C.store_id, C.store_name, SUM(B.quantity) TOTAL_PRODUCT --satýþ miktarýný bulmam için order itemslara göre quantity i toplamam gerek
FROM sales.orders A, sales.order_items B, sales.stores C
--order tablosuyla order_items tablosunu neye göre join yapacaðým? Order_id lere göre..
WHERE A.order_id = B.order_id
AND A.store_id = C.store_id   -- bunu stores ile neyle birleþtireceðim ? store_id ile
AND A.order_date BETWEEN '2016-01-01' AND '2016-12-31'
GROUP BY
		C.store_id, C.store_name

-- þimdi bunlardan en yüksek olaný seçmem gerek.
-- bunun için ORDER BY ve select satýrýnda TOP 1 yapacaðým
SELECT TOP 1 C.store_id, C.store_name, SUM(B.quantity) TOTAL_PRODUCT --satýþ miktarýný bulmam için order itemslara göre quantity i toplamam gerek
FROM sales.orders A, sales.order_items B, sales.stores C
WHERE A.order_id = B.order_id
AND A.store_id = C.store_id   -- bunu stores ile neyle birleþtireceðim ? store_id ile
AND A.order_date BETWEEN '2016-01-01' AND '2016-12-31'
GROUP BY
		C.store_id, C.store_name
ORDER BY 
		TOTAL_PRODUCT DESC
	
	-- yýl sýnýrlamasýný LIKE ile nasýl yaparým
SELECT TOP 1 C.store_id, C.store_name, SUM(B.quantity) TOTAL_PRODUCT --satýþ miktarýný bulmam için order itemslara göre quantity i toplamam gerek
FROM sales.orders A, sales.order_items B, sales.stores C
WHERE A.order_id = B.order_id
AND A.store_id = C.store_id   -- bunu stores ile neyle birleþtireceðim ? store_id ile
AND A.order_date LIKE '%16%'
GROUP BY
		C.store_id, C.store_name
ORDER BY 
		TOTAL_PRODUCT DESC

-- Soru 3: --Write a query that returns state(s) where ‘Trek Remedy 9.8 - 2017’ product  is not ordered
-- bu üründen sipariþ verilmeyen STATE leri getir.

-- hangi state te bu üründen kaç tane sipariþ verilmiþ. benim önce bunu bulmam gerekiyor
-- dolayýsýyla hiç sipariþ verilmeyen state te bu deðer 0 gözükecek.
-- state bilgisi --> customers tablosunda
-- product isimleri --> products tablosunda
-- bu iki tablo birbirien orders veya order_items tablosuyla baðlanýyor!
SELECT *
FROM sales.customers 

SELECT C.order_id, C.customer_id, A.product_id, product_name
FROM production.products A, sales.order_items B, sales.orders C
-- orders ile product tablosunu join yapamýyorum. bunun için order_items tablosundan geçmem gerekiyor
WHERE A. product_id = B.product_id
AND B.order_id = C.order_id
AND A.product_name = 'Trek Remedy 9.8 - 2017'
-- costumer bilgilerine ulaþtým

-- þimdi bu ürünlerin hangi statelerde satýldýðýna ulaþmalýyým. bunun için D tablosundan state i getireceðim
SELECT C.order_id, C.customer_id, A.product_id, product_name, D.state
FROM production.products A, sales.order_items B, sales.orders C, sales.customers D
-- orders ile product tablosunu join yapamýyorum. bunun için order_items tablosundan geçmem gerekiyor
WHERE A. product_id = B.product_id
AND B.order_id = C.order_id
AND C.customer_id = D.customer_id
AND A.product_name = 'Trek Remedy 9.8 - 2017'
-- þimdi stateleri de getirttim. 14 state te bu ürün satýldýðýný görebiliyorum. 
-- ama hangi state de hiç satýlmamýþ?


-- Þimdi yukardaki kodda oluþturduðum tabloyu parantezlerin içine alarak yeni bir SELECT-FROM'da kullanýyorum.
-- ve bu tabloyu sales.customers tablosu ile RIGHT JOIN yapýp sales.customers tablosundaki state sütununa göre gruplayacaðým.
SELECT E.state, COUNT(product_id) CNT_PRODUCT 
-- state'e göre GROUP BY yapýp aggregate olarak 47 no.lu product idlerin satýrlarýný sayacak COUNT kodunu kullandým.
-- böylece state isimlerinin karþýsýnda bu ürünün satýlma miktarlarýný getirttim. þimdi tablom 3 satýra indi.
-- 1. satýr bu üründen hiç satýlmayan state.
FROM
(
SELECT C.order_id, C.customer_id, A.product_id, product_name
FROM production.products A, sales.order_items B, sales.orders C
WHERE A. product_id = B.product_id
AND B.order_id = C.order_id
AND A.product_name = 'Trek Remedy 9.8 - 2017'
) D
RIGHT JOIN sales.customers E 
ON D.customer_id = E.customer_id
GROUP BY
		E.state

-- fakat ben satýlmayan state i görmek istiyorum. bunun için HAVING kullanacaðým.
SELECT E.state, COUNT(product_id) CNT_PRODUCT 
FROM
(
SELECT C.order_id, C.customer_id, A.product_id, product_name
FROM production.products A, 
	sales.order_items B, 
	sales.orders C
WHERE A. product_id = B.product_id
AND B.order_id = C.order_id
AND A.product_name = 'Trek Remedy 9.8 - 2017'
) D
RIGHT JOIN sales.customers E --
ON D.customer_id = E.customer_id
GROUP BY
		E.state
HAVING COUNT(product_id) = 0




----------TABLO CREATE ETMEK-------
CREATE TABLE TABLE_NAME
(
ELAM INT
LEAK INT
ELÝM INT
CURRE_DATE DATE
)
INSERT INTO TABLE_NAME ()
VALUES ()

