
--------------------------------------- Sales analysis  ---------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

-- 1. What are the gross annual and monthly sales and the absolute margin?


#Gross profit

SELECT
YEAR(created_at)as anyo,
MONTH (created_at) as mes,
FORMAT(SUM(items_purchased*Price_usd),2,'es_ES') as ventas
FROM ositofeliz.orders
GROUP BY mes,anyo
ORDER BY anyo ASC, mes;

#Absolute margin 

SELECT
YEAR(created_at)as anyo,
MONTH (created_at) as mes,
FORMAT(SUM(items_purchased*Price_usd),0,'es_ES') as ventas,
FORMAT(SUM(items_purchased*cogs_usd),0,'es_ES') as costo,
FORMAT(SUM(items_purchased*(Price_usd- cogs_usd)),0,'es_ES') as margen
FROM ositofeliz.orders
GROUP BY mes,anyo
ORDER BY anyo DESC,mes ;

-- 2. What are the average gross sales of each month and year, returns the TOP 10? 

SELECT
YEAR(created_at) as anyo,
MONTH(created_at) as mes,
FORMAT(AVG(Price_usd*items_purchased),1,'es_ES') as ventas_brutas
FROM ositofeliz.orders
GROUP BY mes, anyo
ORDER BY AVG(Price_usd*items_purchased) desc
LIMIT 10 ;


-- 3.What is the average monthly sales per month ? 



SELECT
	year(fecha) as anyo,
	MONTH(fecha) as mes,
   FORMAT( AVG(ventas_diarias),2,'es_ES') as promedio_mensual
FROM
(

   SELECT 
       DATE(created_at) as fecha,
       SUM(Price_usd*items_purchased) as ventas_diarias
       FROM ositofeliz.orders
       GROUP BY fecha) as ventas_diarias
GROUP BY anyo,mes
ORDER BY mes,promedio_mensual DESC ;


-- 4. What is the best selling product in monetary terms (gross sales)?



SELECT 
	p.product_name,
    FORMAT(SUM(o.items_purchased*o.Price_usd),2,'es_ES') as ventas
FROM orders o 
LEFT JOIN order_items oi ON o.order_id = oi.order_id 
LEFT JOIN products p ON p.product_id = oi.product_id
GROUP BY product_name
ORDER BY SUM(o.items_purchased*o.Price_usd) DESC 
LIMIT 1;


-- 5.What is the product with the greatest margin?

#margin absolute by sales 

SELECT 
	p.product_name,
    FORMAT(SUM(o.items_purchased*(o.Price_usd-o.cogs_usd)),2,'es_ES') as margen_absoluto
FROM orders o 
LEFT JOIN order_items oi ON o.order_id = oi.order_id 
LEFT JOIN products p ON p.product_id = oi.product_id
GROUP BY product_name
ORDER BY SUM(o.items_purchased*o.Price_usd) DESC ;

#margin absolute by product


SELECT 
	p.product_name,
     FORMAT(SUM(o.items_purchased*(o.Price_usd-o.cogs_usd)),2,'es_ES') as margen_absoluto,
    FORMAT(MAX(o.items_purchased*(o.Price_usd-o.cogs_usd)),2,'es_ES') as margen_absoluto_Max
FROM orders o 
LEFT JOIN order_items oi ON o.order_id = oi.order_id 
LEFT JOIN products p ON p.product_id = oi.product_id
GROUP BY product_name
ORDER BY MAX(o.items_purchased*o.Price_usd) DESC ;



-- 6. Can we know what  the release date of each product?


-- Considering that we are analysing the data of an e-commerce we can "interpret" that the 
-- question refers to: 1. Date on which the product was registered in the system.
-- 2. Date on which the first marketing year is created and from which the first sale comes.

-- We will analyse both approaches.


-- 1. Date on which the product was registered in the system

SELECT 
	p.product_name,
    MIN(o.created_at) as minima_fecha_creacion
FROM orders o 
LEFT JOIN order_items oi ON o.order_id = oi.order_id 
LEFT JOIN products p ON p.product_id = oi.product_id
GROUP BY p.product_name ;



-- 2. Date on which the first marketing year is created and from which the first sale comes.
 -- When is the first marketing year created ? What is the product that generates the first sale ?

SELECT 
	w.user_id,
	w.utm_campaign,
	p.product_name,
    w.created_at,
    MIN(w.created_at) as minima_fecha_creacion
 FROM orders o
 LEFT JOIN website_sessions w ON w.website_session_id=o.website_session_id
 LEFT JOIN order_items oi ON o.order_id=oi.order_id
 LEFT JOIN products p ON oi.product_id = p.product_id
 GROUP BY w.user_id,w.utm_campaign,w.created_at,oi.product_id
 ORDER BY minima_fecha_creacion
 LIMIT 1;
 
 
 
-- 7.Calculates gross sales per year as well as the numerical and percentage margin of each product and order it by product.



SELECT 
	p.product_name,
    year(o.created_at) as anyo,
SUM(o.items_purchased*o.Price_usd) as ventas_brutas,
SUM(o.items_purchased*(o.Price_usd-o.cogs_usd)) as margen_absoluto,
CONCAT((ROUND(SUM(o.items_purchased*(o.Price_usd-o.cogs_usd))/ SUM(o.items_purchased*o.Price_usd),2))*100,"%") as margen_porcentual
FROM orders o 
LEFT JOIN order_items oi ON oi.order_id = o.order_id 
LEFT JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name,anyo;


-- 8. Which are the months with the highest gross sales, returns the TOP 3?


 
SELECT 
    MONTH(o.created_at) as mes,
    YEAR(o.created_at) as anyo,
FORMAT(SUM(o.items_purchased*o.Price_usd),2) as ventas_brutas
FROM orders o 
GROUP BY mes,anyo
ORDER BY SUM(o.items_purchased*o.Price_usd) DESC     
LIMIT 3; 



 
