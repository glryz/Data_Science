-- 1.Answer the following questions according to bikestore database
- What is the sales quantity of product according to the brands and sort them highest-lowest
- Select the top 5 most expensive products
- What are the categories that each brand has
- Select the avg prices according to brands and categories
- Select the annual amount of product produced according to brands
- Select the least 3 products in stock according to stores.
- Select the store which has the most sales quantity in 2016
- Select the store which has the most sales amount in 2016
- Select the personnel which has the most sales amount in 2016
- Select the least 3 sold products in 2016 and 2017 according to city.



-- 1: What is the sales quantity of product according to the brands and sort them highest-lowest

SELECT *
FROM sales.order_items

CREATE VIEW BRAND_SALES AS
SELECT  B.brand_id, B.brand_name, C.order_id, C.item_id, C.quantity 
FROM production.products A, production.brands B, sales.order_items C
WHERE A.product_id = B.brand_id and A.product_id = C.product_id

SELECT brand_id, brand_name, COUNT(quantity) AS Sales_Quantitiy
FROM BRAND_SALES
GROUP BY brand_id, brand_name
ORDER BY 3 DESC
-- Ben sadece brand_name'leri gruplayýp her markanýn toplam kaç ürün sattýðýný buldum.

--- MENTOR ÇÖZÜMÜ:------
select b.brand_name, p.product_name, count(o.quantity) Sales_Quantitiy_of_Product
from production.brands b
inner join production.products p
on b.brand_id = p.brand_id
inner join sales.order_items o
on p.product_id = o.product_id
group by b.brand_name, p.product_name
order by Sales_Quantitiy_of_Product desc;
--Mentör, brand_name ile product_name'leri beraber gruplayarak markalarýn hangi product'tan kaçar tane sattýðýný buldu. Soru bunu istiyormuþ.


-- 2: Select the top 5 most expensive products

CREATE VIEW SALES_PRICE AS
SELECT A.product_id, A.product_name, A.list_price, ISNULL(B.discount, 0) AS discount
FROM production.products A
LEFT JOIN sales.order_items B
ON A.product_id = B.product_id
--son satýþ fiyatýný hesaplamak istediðimden ve baktýðýmda discount uygulanmayan ürünler olduðundan bulara NAN yerine 0 deðeri atadým.
	-- products ile (discount miktarlarýnýn yer aldýðý) order_items tablolarýný left join ile birleþtirdim.

SELECT product_id, product_name, list_price, (list_price - list_price * discount) AS last_price
FROM SALES_PRICE
ORDER BY 4 DESC

SELECT TOP 5 product_id, product_name, list_price, (list_price - list_price * discount) AS last_price
FROM SALES_PRICE
ORDER BY 4 DESC
-- tüm fiyatlarýn discount uygulanmýþ halini alarak ilk 5'i getirdim.
-- ancak left join yapmýþ olduðum için bazý ürünler tekrarlandý ve sonucumda ilk 5'te tekrarlar gözüktü.

 SELECT TOP 5 A.product_name, A.list_price, (A.list_price - A.list_price * B.discount) AS last_price
FROM production.products A, sales.order_items B
where A.product_id = B.product_id 
ORDER BY 3 DESC
-- inner join ile yaptým yine tekrarlayan ürün çýktý!!!! 
-- join yaptýðýmda ana tablodan gelen satýrlarda tekrarlar oluyor. 
-- çünkü product_id üzerinden join ettim ve sales_items tablosunda bu eþitlenen product_id'leri ayný olan farlý satýrlar mevcut. 
-- inner joinde kesiþim kümesi alýndýðýndan, product_id'ler kesiþtiði sürece sales_items'daki satýrlarý sonuç tablosuna ekleyecektir 
-- aþaðýda iki tablonun inner join edilmiþ hali var. tekrarlara dikkat!
SELECT  A.product_name, A.list_price, (A.list_price - A.list_price * B.discount) AS last_price
FROM production.products A, sales.order_items B
where A.product_id = B.product_id 
ORDER BY 3 DESC


--------MENTOR ÇÖZÜMÜ:-------------

select top 5 product_name, list_price
from production.products
order by list_price desc;



--3 : What are the categories that each brand has

select *
from production.brands A, production.categories B, production.products C
where A.brand_id = C.brand_id and B.category_id = C.category_id

select DISTINCT brand_name
FROM production.brands

SELECT COUNT(brand_name)
FROM production.brands
-- 9 adet brand ismi var!!

select category_name, count(DISTINCT(brand_name)) count_of_brands
from production.brands A, production.categories B, production.products C
where A.brand_id = C.brand_id and B.category_id = C.category_id
group by category_name
HAVING  count(DISTINCT(brand_name)) = 9   
-- 9 brand ismi var ama ayný kategoride en fazla 6 brand ismi geçiyor. 
	-- tüm brandlere sahip olan bir kategori yok!
-- Mountain Bikes kategorisinde 6 markanýn ürünü var.

---------SAM HOCANIN ÇÖZÜMÜ--------------
CREATE VIEW HÜSEYÝN_HOCA AS
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
	FROM	HÜSEYÝN_HOCA
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

-----------MENTOR ÇÖZÜMÜ-----------------

select b.[brand_name], c.[category_name]
from [production].[brands] b
inner join [production].[products] p
on b.brand_id = p.brand_id
inner join [production].[categories] c
on p.category_id = c.category_id
group by b.brand_name, c.category_name




--4: Select the avg prices according to brands and categories

select A.brand_name, B.category_name, avg(list_price) average_price
from production.brands A, production.categories B, production.products C
where A.brand_id = C.brand_id and B.category_id = C.category_id
group by A.brand_name, B.category_name

select A.brand_name, B.category_name, avg(list_price) average_price
from production.brands A, production.categories B, production.products C
where A.brand_id = C.brand_id and B.category_id = C.category_id
group by 
grouping sets (
				(A.brand_name),
				(B.category_name),
				(A.brand_name, B.category_name)
				)

--grouping sets'in satýrlarýný daha iyi yorumlayabilmek için avg deðil, sum aggregate i kullanalým.
select A.brand_name, B.category_name, sum(list_price) total_price
from production.brands A, production.categories B, production.products C
where A.brand_id = C.brand_id and B.category_id = C.category_id
group by 
grouping sets (
				(A.brand_name),
				(B.category_name),
				(A.brand_name, B.category_name)
				)

----------MENTOR ÇÖZÜMÜ-----------
select b.[brand_name], c.[category_name], avg(p.[list_price]) as [Avg Price]
from [production].[brands] b
inner join [production].[products] p
on b.brand_id = p.brand_id
inner join [production].[categories] c
on p.category_id = c.category_id
group by b.brand_name, c.category_name




-- 5: Select the annual amount of product produced according to brands

select product_id, quantity
from production.stocks

select product_id, sum(quantity) quantity_sales
from sales.order_items
group by product_id
order by 1

select A.model_year, A.product_name, B.brand_name, C.quantity stock_quantity, D.quantity sales_quantity 
from production.products A, production.brands B, production.stocks C, sales.order_items D
where A.brand_id = B.brand_id and A.product_id = C.product_id and A.product_id = D.product_id


select A.model_year, B.brand_name, (sum(C.quantity) + sum(D.quantity)) as CountOfProduct
from production.products A, production.brands B, production.stocks C, sales.order_items D
where A.brand_id = B.brand_id and A.product_id = C.product_id and A.product_id = D.product_id
group by A.model_year, B.brand_name
order by 1

------------MENTOR ÇÖZÜMÜ----------
select p.[model_year],b.[brand_name], count(p.[product_name])
from [production].[brands] b
inner join [production].[products] p
on b.brand_id = p.brand_id
group by p.[model_year],b.[brand_name]
order by p.[model_year]
-- üretilen ürün miktarý için product_name'i count etmiþ.

-- bu da diðer bir çözüm (brand_name'i group by yaparak deðil de distinct brand_name yaparak çözmüþ)
select distinct b.brand_name, p.model_year,
	count(p.[product_id]) over (PARTITION BY  b.brand_name, p.model_year) as annual_amount_brands
from [production].[brands] b
inner join [production].[products] p
on b.brand_id=p.brand_id
order by b.brand_name, p.model_year



--6: Select the least 3 products in stock according to stores.

-------MENTOR ÇÖZÜMÜ ----------
select  d.store_id, c.product_id, c.product_name, sum(c.toplam) top_stok
from
[production].[stocks] d
cross apply
		(
		select top(3) b.product_id, b.product_name, sum(a.quantity) toplam
		from
		[production].[stocks] a, [production].[products] b
		where
		a.product_id=b.product_id
	    and
		a.store_id= d.store_id
		group by
		b.product_id, b.product_name
		order by
		toplam
		) c
group by
d.store_id, c.product_id, c.product_name
order by
store_id, top_stok



SELECT	*
FROM	(
		select ss.store_name, p.product_name, SUM(s.quantity) product_quantity,
		row_number() over(partition by ss.store_name order by SUM(s.quantity) ASC) least_3
		from [sales].[stores] ss
		inner join [production].[stocks] s
		on ss.store_id=s.store_id
		inner join [production].[products] p
		on s.product_id=p.product_id
		GROUP BY ss.store_name, p.product_name
		HAVING SUM(s.quantity) > 0
		) A
WHERE	A.least_3 < 4


;with temp_cte
as (
	select ss.[store_name], pp.[product_name],
	row_number() over(partition by ss.[store_name] order by ss.[store_name]) as [row number]
	from [production].[products] pp
	inner join [production].[stocks] ps
	on pp.product_id = ps.product_id
	inner join [sales].[stores] ss
	on ps.store_id = ss.store_id
	)
select * from temp_cte
where [row number] < 4


--- çözüm için benim baþlangýcým:
select C.product_name, store_id, sum(A.quantity) total_quantity
from production.stocks A, production.products C
where A.product_id = C.product_id 
group by C.product_name, store_id
order by 3

select TOP 3 B.store_name, C.product_name, sum(A.quantity) total_quantity
from production.stocks A, sales.stores B, production.products C
where A.product_id = C.product_id and B.store_id = A.store_id
and A.store_id = 1
group by B.store_name, C.product_name
having sum(A.quantity) <> 0
order by 3
-- 0 olanlarý en az olarak almadým. 0 olanlar hiç olmayanlar. en az olanlar 1 den baþlamalý diye düþündüm. 

 
--Select the store which has the most sales quantity in 2016

select top 1 s.[store_name], o.[order_date], sum(i.[quantity])
from [sales].[stores] s
inner join [sales].[orders] o
on s.store_id = o.store_id
inner join [sales].[order_items] i
on o.order_id = i.order_id
where  datename(year, o.[order_date]) = '2016' -- year(o.[order_date])
group by s.[store_name], o.[order_date] 
order by sum(i.[quantity]) desc;

--Select the store which has the most sales amount in 2016

select * from [sales].[order_items]

select top 1 s.[store_name], sum(i.[list_price]) as sales_amount_2016
from [sales].[stores] s
inner join [sales].[orders] o
on s.store_id = o.store_id
inner join [sales].[order_items] i
on o.order_id = i.order_id
where  datename(year, o.[order_date]) = '2016' -- year(o.[order_date])
group by s.[store_name] 
order by sum(i.[list_price]) desc;

--Select the personnel which has the most sales amount in 2016

select top 1 s.[first_name], s.[last_name], sum(i.[list_price]) as sales_amount_2016
from [sales].[staffs] s
inner join [sales].[orders] o
on s.staff_id = o.staff_id
inner join [sales].[order_items] i
on o.order_id = i.order_id
where  datename(year, o.[order_date]) = '2016'
group by s.[first_name], s.[last_name] 
order by sum(i.[list_price]) desc;


--Select the least 3 sold products in 2016 and 2017 according to city. (Çözümü tam deðil)

;with temp2_cte
as(
select p.[product_name], datename(year, o.[order_date]) as order_date,
row_number() over(partition by datename(year, o.[order_date]) order by datename(year, o.[order_date])) as [row number]
from [production].[products] p
inner join [sales].[order_items] i
on p.product_id = i.product_id
inner join [sales].[orders] o
on o.order_id = i.order_id
where  datename(year, o.[order_date]) in ('2016', '2017')
)
select * from temp2_cte
where [row number] < 4

--Select the least 3 sold products in 2016 and 2017 according to city. 

select e.city, d.product_id, d.product_name, sum(d.top_sat) toplam_satis
from
[sales].[stores] e
cross apply
		(
		select top (3) c.product_id, c.product_name, sum(b.quantity) top_sat
		from
		[sales].[orders] a, [sales].[order_items] b, [production].[products] c
		where
		a.order_id=b.order_id
		and
		b.product_id= c.product_id
		and
		a.store_id=e.store_id
		and
		(a.order_date LIKE '__16______' or a.order_date LIKE '__17______')
		group by
		c.product_id, c.product_name
		order by
		top_sat
		) d
group by
e.city, d.product_id, d.product_name
order by
e.city, toplam_satis

---------------------------------------------------------------------------------------------------
---- Select the least 3 products in stock according to stores.

----Method 1---

SELECT	*
FROM	(
		select ss.store_name, p.product_name, SUM(s.quantity) product_quantity,
		row_number() over(partition by ss.store_name order by SUM(s.quantity) ASC) least_3
		from [sales].[stores] ss
		inner join [production].[stocks] s
		on ss.store_id=s.store_id
		inner join [production].[products] p
		on s.product_id=p.product_id
		GROUP BY ss.store_name, p.product_name
		HAVING SUM(s.quantity) > 0
		) A
WHERE	A.least_3 < 4


----Method 2---

with temp_cte
as (
	select ss.[store_name], pp.[product_name],
	row_number() over(partition by ss.[store_name] order by ss.[store_name]) as [row number]
	from [production].[products] pp
	inner join [production].[stocks] ps
	on pp.product_id = ps.product_id
	inner join [sales].[stores] ss
	on ps.store_id = ss.store_id
	)
select * 
from temp_cte
where [row number] < 4

---- Select the store which has the most sales quantity in 2016

select s.[store_name], o.[order_date], sum(i.[quantity])
from [sales].[stores] s
inner join [sales].[orders] o
on s.store_id = o.store_id
inner join [sales].[order_items] i
on o.order_id = i.order_id
where  datename(year, o.[order_date]) = '2016' -- year(o.[order_date])
group by s.[store_name], o.[order_date] 
order by sum(i.[quantity]) desc;

select top 1 s.[store_name], o.[order_date], sum(i.[quantity])
from [sales].[stores] s
inner join [sales].[orders] o
on s.store_id = o.store_id
inner join [sales].[order_items] i
on o.order_id = i.order_id
where  datename(year, o.[order_date]) = '2016' -- year(o.[order_date])
group by s.[store_name], o.[order_date] 
order by sum(i.[quantity]) desc;

---- Select the store which has the most sales amount in 2016

select * from [sales].[order_items]

select top 1 s.[store_name], sum(i.[list_price]) as sales_amount_2016
from [sales].[stores] s
inner join [sales].[orders] o
on s.store_id = o.store_id
inner join [sales].[order_items] i
on o.order_id = i.order_id
where  datename(year, o.[order_date]) = '2016' -- year(o.[order_date])
group by s.[store_name] 
order by sum(i.[list_price]) desc;


---- Select the personnel which has the most sales amount in 2016

select top 1 s.[store_name], sum(i.[list_price]) as sales_amount_2016, 
		sum(i.[list_price]-(i.[list_price]*discount)) as discounted_total_sale
from [sales].[stores] s
inner join [sales].[orders] o
on s.store_id = o.store_id
inner join [sales].[order_items] i
on o.order_id = i.order_id
where  datename(year, o.[order_date]) = '2016' -- year(o.[order_date])
group by s.[store_name] 
order by sum(i.[list_price]) desc;

select top 1 s.[store_name], sum(i.[list_price]) as sales_amount_2016
from [sales].[stores] s
inner join [sales].[orders] o
on s.store_id = o.store_id
inner join [sales].[order_items] i
on o.order_id = i.order_id
where  datename(year, o.[order_date]) = '2016' -- year(o.[order_date])
group by s.[store_name] 
order by sum(i.[list_price]) desc;

---- Select the least 3 sold products in 2016 and 2017 according to city.


select *
from sales.stores

select *
from sales.customers

with temp2_cte
			as(
			select p.[product_name], c.city as order_city, datename(year, o.[order_date]) as order_date,  
			row_number() over(partition by c.city, datename(year, o.[order_date]) order by datename(year, o.[order_date])) as [row number]
			from [production].[products] p
			inner join [sales].[order_items] i
			on p.product_id = i.product_id
			inner join [sales].[orders] o
			on o.order_id = i.order_id
			inner join sales.customers c
			on c.customer_id = o.customer_id
			where  datename(year, o.[order_date]) in ('2016', '2017')
			)
select * from temp2_cte
where [row number] < 4




