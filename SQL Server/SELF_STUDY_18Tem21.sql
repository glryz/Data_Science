-- Soru1: ürünlerin kategori isimleriyle birlikte listeleyin--

select TOP 20 A.product_id, product_name, B.category_name
from production.products A
inner join production.categories B
on A.category_id = B.category_id


--Soru2: List employees of stores with their store information
-- select employee name, surname, store names

SELECT A.*, B.store_name
from sales.staffs A
inner join sales.stores B
on A.store_id = B.store_id

--farklý bir çözüm:
SELECT A.*, B.store_name
from sales.staffs A, sales.stores B
WHERE A.store_id=B.store_id

-- Soru3: Ürünleri kategori isimleriyle birlikte listeleyin, LEFT JOIN kullanýn.
select product_id, product_name, B.category_name
from production.products A
left join production.categories B
on A.category_id = B.category_id

-- Soru4: Report the stock status of the products that product id greater than 310 in the stores
-- Expected columns : Product_id, product_name, store_id, quantity

select A.product_id, product_name, B.store_id, quantity
from production.products A
left join production.stocks B
on A.product_id = B.product_id
where A.product_id > 310

-- Soru5: Report the stock status of the products that product id greater than 310 in the stores
-- Expected columns : Product_id, product_name, store_id, quantity (RIGHT JOIN ile)
select B.product_id, product_name, A.store_id, quantity
from production.stocks A
right join production.products B
on B.product_id = A.product_id
where B.product_id > 310

-- Soru6: Report the orders information made by all staffs.
-- Expected columns: Staff_id, first_name, last_name, all the information about orders

select COUNT(distinct staff_id)
from sales.orders

select staff_id
from sales.staffs
ORDER BY staff_id ASC

-- Soru7: Write a query that returns stock and order information together for all products (ürünlerin sipariþ ve stok bilgileri)
-- Expected columns: Product_id, store_id, quantity, order_id, list_price

SELECT A.product_id, A.product_name, B.quantity, C.order_id, C.list_price, C.discount
FROM production.products A, production.stocks B, sales.order_items C
where A.product_id = B.product_id 
and A.product_id = C.product_id

SELECT B.product_id, B.store_id, B.quantity, A.list_price, A.quantity
FROM sales.order_items AS A
FULL OUTER JOIN production.stocks AS B
ON A.product_id = B.product_id

