-- Customer
-- How many/what type of customers are loyal visitors vs not? 
-- By store 1 vs store 2

SELECT * FROM customer limit 10;
SELECT email, COUNT(*) FROM customer GROUP BY email HAVING COUNT(*) > 1;
SELECT * FROM rental_film_table LIMIT 10;


SELECT c.store_id as store_customer, COUNT(*) AS rental_counts, COUNT(DISTINCT c.customer_id) AS unique_customers
FROM rental_film_table rft
JOIN customer c ON rft.customer_id = c.customer_id
GROUP BY store_customer
ORDER BY rental_counts DESC;


SELECT rft.inventory_store, COUNT(*) AS rental_counts, COUNT(DISTINCT c.customer_id) AS customers
FROM rental_film_table rft
JOIN customer c ON rft.customer_id = c.customer_id
GROUP BY inventory_store;

-- Store 2 has a more sufficient inventory level (collection), while store 1 has a larger number of total customers.

SELECT customer_id, inventory_store, count(*) as rental_counts
FROM rental_film_table
GROUP BY customer_id, inventory_store
ORDER BY customer_id;


WITH customer_loyalty AS (
    SELECT customer_id, COUNT(*) AS loyalty_level
    FROM rental_film_table
    GROUP BY customer_id
)
SELECT AVG(loyalty_level) AS loyalty_level_avg, MIN(loyalty_level), MAX(loyalty_level) 
FROM customer_loyalty;



-- Business questions 2: Loyal customers (which store has higher volume)

-- Step 1: In order to set the threshold, caculate the average-loyal-level of customers first
-- Step 2: Count the number of about average loyal customers of 2 stores

WITH loyal_customer AS (
	SELECT customer_id as loyal_customer, COUNT(*) AS loyalty_level 
	FROM rental_film_table 
	GROUP BY customer_id HAVING COUNT(*) > 26.8
) 
SELECT c.store_id as store_customer, COUNT(DISTINCT loyal_customer) AS loyal_customer_count
FROM loyal_customer lc
LEFT JOIN customer c ON c.customer_id = lc.loyal_customer 
GROUP BY c.store_id;

