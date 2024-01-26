---------------------------------------- Web traffic analysis -------------------------------------------------------
------------------------------------------------------------------------------------------------------------------


-- 1. Which ads (ads) or content have attracted more sessions?


SELECT 
utm_content,
utm_campaign,
FORMAT(COUNT(website_session_id),0) as cantidad_sesiones
FROM ositofeliz.website_sessions
GROUP BY  utm_content,utm_campaign ;

 -- 2. How many logins and sales has each ad generated per year?

SELECT
YEAR(o.created_at)as anyo,
w.utm_content,
w.utm_campaign,
FORMAT(SUM(o.items_purchased*o.Price_usd),2,'es_ES') as ventas,
COUNT(w.website_session_id) as cantidad_sesiones
FROM ositofeliz.orders o
LEFT JOIN website_sessions w ON o.website_session_id=w.website_session_id
GROUP BY  w.utm_content,w.utm_campaign, anyo 
ORDER BY anyo ASC ;

-- 3. Is it the same sessions as users? How many individual users do we have?

SELECT
FORMAT(COUNT(DISTINCT user_id),0) as cantidad_usuarios_unicos
FROM ositofeliz.website_sessions ;


-- 4. Continuing with previous question, And by source? Number of users and sessions?


SELECT
utm_source,
FORMAT(COUNT(DISTINCT user_id),0) as cantidad_usuarios_unicos,
FORMAT(COUNT(DISTINCT website_session_id),0) as cantidad_sesiones
FROM ositofeliz.website_sessions
GROUP BY utm_source ;

-- 5. What are the sources that have given more sales?


SELECT
w.utm_source,
FORMAT(SUM(o.items_purchased*o.Price_usd),2,'es_ES') as ventas_brutas
FROM ositofeliz.orders o
LEFT JOIN website_sessions w ON o.website_session_id=w.website_session_id
GROUP BY  w.utm_source
ORDER  BY SUM(o.items_purchased*o.Price_usd) DESC;



-- 6. What are the months that have attracted more traffic?


SELECT
MONTH(created_at) as mes_sesion,
	COUNT(website_session_id) as cantidad_sesiones
FROM ositofeliz.website_sessions
GROUP BY mes_sesion
ORDER BY COUNT(website_session_id) DESC; 


-- 7 .Since we saw the month that has had more traffic. Could you see from that month the number of sessions 
-- that came by mobile, and, how many came by computer?


SELECT
device_type,
	COUNT(website_session_id) as cantidad_sesiones
FROM ositofeliz.website_sessions
WHERE MONTH(created_at) ="11"
GROUP BY device_type
ORDER BY COUNT(website_session_id) DESC;


-- 8.Which campaigns have given more margin for products?


SELECT 
	p.product_name,
	w.utm_campaign,
    FORMAT(SUM(o.items_purchased*(o.Price_usd-o.cogs_usd)),1,'es_ES') as margen_absoluto
 FROM orders o
 LEFT JOIN website_sessions w ON w.website_session_id=o.website_session_id
 LEFT JOIN order_items oi ON o.order_id=oi.order_id
 LEFT JOIN products p ON oi.product_id = p.product_id
 GROUP BY p.product_name,w.utm_campaign ;
