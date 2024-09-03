-- Customer
-- How many/what type of customers are loyal visitors vs not? 
-- By store 1 vs store 2

SELECT * FROM customer limit 10;
SELECT email, COUNT(*) FROM customer GROUP BY email HAVING COUNT(*) > 1;
SELECT * FROM rental_film_table LIMIT 10;

SELECT customer_id, store_id, count(*) as rental_counts
FROM rental_film_table
GROUP BY customer_id, store_id
ORDER BY customer_id;


SELECT store_id, COUNT(*) AS rental_counts, COUNT(DISTINCT customer_id) AS unique_customers
FROM rental_film_table
GROUP BY store_id
ORDER BY rental_counts DESC;


SELECT customer_id,count(*) as rental_counts
FROM rental_film_table
GROUP BY customer_id
ORDER BY rental_counts DESC;



-- Business questions 2: Loyal customers (which store has higher volume)

WITH loyal_customer AS (
	SELECT customer_id as loyal_customer, store_id, COUNT(*) AS loyalty_level FROM rental_film_table GROUP BY customer_id, store_id HAVING COUNT(*) > 20
) 
SELECT rft.store_id, COUNT(*) AS rental_counts, COUNT(DISTINCT loyal_customer) AS loyal_customer_count
FROM rental_film_table as rft
LEFT JOIN 
    loyal_customer lc 
    ON rft.customer_id = lc.loyal_customer 
    AND rft.store_id = lc.store_id
GROUP BY rft.store_id
ORDER BY rental_counts DESC;


