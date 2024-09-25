-- Customer
-- How many/what type of customers are loyal visitors vs not? 
-- By store 1 vs store 2

SELECT * FROM customer limit 10;
SELECT email, COUNT(*) FROM customer GROUP BY email HAVING COUNT(*) > 1;
SELECT * FROM rental_film_table LIMIT 10;


WITH customer_store AS (
    SELECT 
        c.store_id as store, 
        COUNT(*) AS rental_counts, 
        COUNT(DISTINCT c.customer_id) AS unique_customers
    FROM rental_film_table rft
    JOIN customer c ON rft.customer_id = c.customer_id
    GROUP BY c.store_id
),
inventory_store AS (
    SELECT 
        rft.inventory_store AS store, 
        COUNT(*) AS rental_counts, 
        COUNT(DISTINCT c.customer_id) AS unique_customers
    FROM rental_film_table rft
    JOIN customer c ON rft.customer_id = c.customer_id
    GROUP BY rft.inventory_store
)
SELECT 
    cs.store AS store,
    cs.rental_counts AS customer_rentals,
    cs.unique_customers AS customer_unique_customers,
    isr.rental_counts AS inventory_rentals,
    isr.unique_customers AS inventory_unique_customers
FROM customer_store cs
FULL OUTER JOIN inventory_store isr
ON cs.store = isr.store;


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


-- Where are our customers located, by country?; Active customers in each region
select coalesce(country, 'Overall') as country,
		round(sum(active)::numeric/count(customer_id)::numeric, 2) as active_proportion,
		sum(active) as active_customers,
		count(customer_id) as total_customers
	from customer c, address a, city ci, country co
	where c.address_id = a.address_id
	and a.city_id = ci.city_id
	and ci.country_id = co.country_id
	group by rollup(country)
	order by country asc;

select coalesce(country, 'Overall') as country, coalesce(store_id::text, 'Overall') as store,
		round(sum(active)::numeric/count(distinct customer_id)::numeric, 2) as active_proportion,
		sum(active) as active_customers,
		count(distinct customer_id) as total_customers
	from customer c, address a, city ci, country co
	where c.address_id = a.address_id
	and a.city_id = ci.city_id
	and ci.country_id = co.country_id
	group by cube(country, store_id)
	order by country asc, store asc;


-- Rental volume and revenue by country and store
select coalesce(co.country, 'Overall') as country,
		count(r.rental_id) as rental_volume,
		sum(p.amount) as total_revenue
	from payment p, rental r, customer c, address a, city ci, country co
	where p.rental_id = r.rental_id 
	and r.customer_id = c.customer_id
	and c.address_id = a.address_id
	and a.city_id = ci.city_id
	and ci.country_id = co.country_id
	group by rollup(co.country)
	order by co.country asc;

select coalesce(co.country, 'Overall') as country, coalesce(c.store_id::text, 'Overall') as store,
		count(r.rental_id) as rental_volume,
		sum(p.amount) as total_revenue
	from payment p, rental r, customer c, address a, city ci, country co
	where p.rental_id = r.rental_id 
	and r.customer_id = c.customer_id
	and c.address_id = a.address_id
	and a.city_id = ci.city_id
	and ci.country_id = co.country_id
	group by cube(co.country, c.store_id)
	order by co.country, store;
