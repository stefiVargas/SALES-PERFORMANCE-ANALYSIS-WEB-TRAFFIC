
-- Create the data base 

CREATE SCHEMA ositofeliz ;

CREATE TABLE ositofeliz.orders(

order_id BIGINT,
created_at DATETIME,
website_session_id BIGINT,
user_id BIGINT,
primary_product_id SMALLINT,
items_purchased SMALLINT,
price_usd DECIMAL(6,2),
cogs_usd DECIMAL(6,2),
PRIMARY KEY (order_id)
);
 

CREATE TABLE ositofeliz.products(

product_id BIGINT,
created_at DATETIME,
product_name VARCHAR (50),
PRIMARY KEY (product_id)
);

CREATE TABLE ositofeliz.order_items (

order_item_id BIGINT,
created_at  DATETIME,
order_id BIGINT,
product_id BIGINT,
is_primary_item SMALLINT,
price_usd DECIMAL(6,2),
cogs_usd DECIMAL (6,2),
PRIMARY KEY (order_item_id)
);

CREATE TABLE ositofeliz.website_sessions (


website_session_id BIGINT,
created_at DATETIME,
user_id BIGINT,
is_repeat_session SMALLINT,
utm_source VARCHAR (20),
utm_campaign VARCHAR(20),
utm_content VARCHAR (15),
device_type VARCHAR (15),
http_referer VARCHAR (35),
PRIMARY KEY (website_session_id)
 ); 
 
 
ALTER TABLE ositofeliz.orders
ADD FOREIGN KEY (website_session_id) REFERENCES website_sessions (website_session_id) ;

ALTER TABLE ositofeliz.order_items
ADD FOREIGN KEY (order_id ) REFERENCES order_items (order_id ),
ADD FOREIGN KEY (product_id ) REFERENCES products (product_id );

