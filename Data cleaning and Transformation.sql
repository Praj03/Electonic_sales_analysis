-- to observ column and table content for further process --
SELECT * FROM electronic_sale.invoice;
SELECT * FROM electronic_sale.product;
SELECT * FROM electronic_sale.country;

-- Using Alter quert to add number of column in invoice table --
ALTER TABLE invoice
ADD COLUMN address VARCHAR(250),
ADD COLUMN City VARCHAR(100),
ADD COLUMN Country_id VARCHAR(10),
ADD COLUMN pin_code INT;

-- using update to add data in added column and using substring index to split shipping address --
-- and to get proper segrigation of data in different column --
UPDATE invoice
SET address = SUBSTRING_INDEX(shipping_address, ", ",1),
city = SUBSTRING_INDEX(SUBSTRING_INDEX(shipping_address, ", ",-2),", ",1),
country_id = SUBSTRING_INDEX(SUBSTRING_INDEX(shipping_address, ", ",-1)," ",1),
pin_code = SUBSTRING_INDEX(SUBSTRING_INDEX(shipping_address, ", ",-1)," ",-1);

-- To update date column from text to date format following query is used --
UPDATE invoice
SET date = STR_TO_DATE(date, "%d-%m-%Y %H:%i");

-- Getting data for visvalization using joins from all the 3 table and using some calculations --
SELECT 
i.order_id, -- order_id from Invoice --
i.product_id, -- product_id from Invoice -- 
i.product, -- product from Invoice --
i.date, -- order date from Invoice --
i.city, -- city from shipping_address in Invoice --
c.name AS country, -- Country from shipping_address in country table --
i.pin_code, -- pin_code from shipping_address in Invoice --
i.quantity, -- quantity from Invoice --
p.unit_price, -- unit price from Product --
i.quantity * p.unit_price AS total_price -- total price is multiplication of quantity and unit price from Invoice and product --
FROM invoice i 
JOIN product p ON i.product_id = p.product_id -- Joining Table Invoice and product on product_id key --
JOIN country c ON i.country_id = c.country_id -- Joining Table Invoice and Country on country_id key --
ORDER BY order_id ASC; -- order by order_id in assending order --

