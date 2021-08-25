-------------03.08.2021 DAwSQL LAb 2 ---------------



--SORU1: Select the customers who have purchased both Children Bicycles and Comfort Bicycles in a single order. 
--expected columns: Customer id, first name, last name, ordoer id
-- (TR) Hem Çocuk Bisikleti hem de Konfor Bisikleti'ni tek sipariþte satýn alan müþterileri seçin.

-- önce kategory tablosuna gitmem gerekiyor
SELECT E.customer_id, first_name, last_name, D.order_id, A.category_name
FROM production.categories A,
	 production.products B,
	 sales.order_items C,
	 sales.orders D,
	 sales.customers E
WHERE A.category_id=B.category_id AND
	  B.product_id=C.product_id AND
	  C.order_id=D.order_id AND
	  D.customer_id=E.customer_id
AND	  A.category_name IN ('Children Bicycles','Comfort Bicycles')
ORDER BY 4

-- Buraya kadar hem children hem comfort bicycles kategorisinde olanlarý union gibi birleþtirip getiriyor
-- order_id = 29 olan 16 ve 17 no lu satýrlara bakarsak Laureen Barry, hem children hem comfort sipariþ etmiþ.
-- biz bunlarý peþindeyiz.

SELECT E.customer_id, first_name, last_name, D.order_id, A.category_name,

	  CASE WHEN A.category_name = 'Children Bicycles' THEN 1 ELSE 0 END AS CHILDREN_BICYCLES,
	  CASE WHEN A.category_name = 'Comfort Bicycles' THEN 1 ELSE 0 END AS COMFORT_BICYCLES 

FROM production.categories A,
	 production.products B,
	 sales.order_items C,
	 sales.orders D,
	 sales.customers E
WHERE A.category_id=B.category_id AND
	  B.product_id=C.product_id AND
	  C.order_id=D.order_id AND
	  D.customer_id=E.customer_id
AND	  A.category_name IN ('Children Bicycles','Comfort Bicycles')
ORDER BY 4

-- þimdi order_id, customer_id, firtname, lastname e göre gruplarsam
	-- ve group by ý bozacaðý için category_name'i select'ten kaldýrýrsam:

SELECT E.customer_id, first_name, last_name, D.order_id,

	  SUM(CASE WHEN A.category_name = 'Children Bicycles' THEN 1 ELSE 0 END) AS CHILDREN_BICYCLES,
	  SUM(CASE WHEN A.category_name = 'Comfort Bicycles' THEN 1 ELSE 0 END) AS COMFORT_BICYCLES 

FROM production.categories A,
	 production.products B,
	 sales.order_items C,
	 sales.orders D,
	 sales.customers E
WHERE A.category_id=B.category_id AND
	  B.product_id=C.product_id AND
	  C.order_id=D.order_id AND
	  D.customer_id=E.customer_id
AND	  A.category_name IN ('Children Bicycles','Comfort Bicycles')
GROUP BY E.customer_id, first_name, last_name, D.order_id
ORDER BY 4 

-- þimdi her ikisinden birden sipariþ eden kiþilerin karþýsýnda her iki kategori için de 1-1 yazýyor

-- bu seçimi HAVING ile daraltýrsam:
SELECT E.customer_id, first_name, last_name, D.order_id,

	  SUM(CASE WHEN A.category_name = 'Children Bicycles' THEN 1 ELSE 0 END) AS CHILDREN_BICYCLES,
	  SUM(CASE WHEN A.category_name = 'Comfort Bicycles' THEN 1 ELSE 0 END) AS COMFORT_BICYCLES 

FROM production.categories A,
	 production.products B,
	 sales.order_items C,
	 sales.orders D,
	 sales.customers E
WHERE A.category_id=B.category_id AND
	  B.product_id=C.product_id AND
	  C.order_id=D.order_id AND
	  D.customer_id=E.customer_id
AND	  A.category_name IN ('Children Bicycles','Comfort Bicycles')
GROUP BY E.customer_id, first_name, last_name, D.order_id
HAVING 
	 SUM(CASE WHEN A.category_name = 'Children Bicycles' THEN 1 ELSE 0 END) >= 1 AND
	 SUM(CASE WHEN A.category_name = 'Comfort Bicycles' THEN 1 ELSE 0 END) >= 1
ORDER BY 4
-- þimdi sadece bu kategorilerden (her ikisinden birden) sipariþ verilenleri getirdi.

-- EMÝR HOCANIN CTE ÝLE ÇÖZÜMÜ:
WITH CTE AS(
SELECT E.customer_id, E.first_name, E.last_name, D.order_id, A.category_name,
	   CASE WHEN A.category_name = 'Children Bicycles' THEN 1 ELSE 0 END AS is_children,
	   CASE WHEN A.category_name = 'Comfort Bicycles' THEN 1 ELSE 0 END AS is_comfort,
	   	   CASE WHEN A.category_name IN ('Children Bicycles', 'Comfort Bicycles') THEN 1 ELSE 0 END AS is_both
FROM production.categories AS A,
	 production.products AS B,
	 sales.order_items AS C,
	 sales.orders AS D,
	 sales.customers AS E
WHERE A.category_id = B.category_id AND
	  B.product_id = C.product_id AND
	  C.order_id = D.order_id AND
	  D.customer_id = E.customer_id
AND   A.category_name IN ('Children Bicycles', 'Comfort Bicycles')
)

SELECT CTE.customer_id, CTE.first_name, CTE.last_name, CTE.order_id
FROM CTE
WHERE is_both = 1


--- OWEN HOCANIN INTERSECT ÝLE ÇÖZÜMÜ:,

SELECT	E.customer_id, E.first_name,E.last_name, D.order_id
FROM	production.categories A,
		production.products B,
		sales.order_items C,
		sales.orders D,
		sales.customers E
WHERE	A.category_id = B.category_id AND
		B.product_id = C.product_id AND
		C.order_id = D.order_id AND
		D.customer_id = E.customer_id
AND		A.category_name = 'Children Bicycles'

INTERSECT

SELECT	E.customer_id, E.first_name,E.last_name, D.order_id
FROM	production.categories A,
		production.products B,
		sales.order_items C,
		sales.orders D,
		sales.customers E
WHERE	A.category_id = B.category_id AND
		B.product_id = C.product_id AND
		C.order_id = D.order_id AND
		D.customer_id = E.customer_id
AND		A.category_name = 'Comfort Bicycles'


------------------------------------------------

-- SORU: ADRESLERÝNDEKÝ STREET NUMARALARINDA ALFABETÝK KARAKTER GEÇEN MÜÞTERÝLERÝ GETÝR.

--RAÝFE HOCANIN KODU:

select street,
			(case when isnumeric(right(left(street, CHARINDEX(' ',street)-1), 1))=0
			then replace(street,right(left(street, CHARINDEX(' ',street)-1), 1),'')
			else street end) as modified_street
from sales.customers



select street,right(left(street, CHARINDEX(' ',street)-1), 1),
			  isnumeric(right(left(street, CHARINDEX(' ',street)-1), 1)),
			(
			case when isnumeric(right(left(street, CHARINDEX(' ',street)-1), 1))=0
			then replace(street,right(left(street, CHARINDEX(' ',street)-1), 1),'')
			else street end) as modified_street
from sales.customers


-- ZEHRA HOCANIN KODU:

SELECT street,
		LEFT(street,CHARINDEX(' ',street)-1),
		RIGHT(street,LEN(street)-CHARINDEX(' ',street)+1),
		LEFT(street,CHARINDEX(' ',street)-2)+ ' ' + RIGHT(street,LEN(street)-CHARINDEX(' ',street)+1) as new_street
FROM sales.customers
WHERE ISNUMERIC(LEFT(street,CHARINDEX(' ',street)-1))=0


-- C8316 SÜLEYMAN HOCANIN ÇÖZÜMÜ:

select
	street,
	replace(street,
	substring(left(street,
	charindex(' ', street)-1), 1,
	charindex(' ', street)-1),
	substring(left(street,
	charindex(' ', street)-1), 1,
	charindex(' ', street)-2))
from sales.customers
where ISNUMERIC(LEFT(street,CHARINDEX(' ',street)-1))=0