-- Popular & Revenue
-- Does the most popular category of movies make the highest revenue? 
-- Which category of movies have the best ratings and highest revenue?

SELECT * FROM rental_film_table LIMIT 10;

WITH Popular_category as (
	SELECT COUNT(*) as category_popularity, film_category
	FROM rental_film_table
	GROUP BY film_category
)
SELECT rft.film_category, 
       SUM(pc.category_popularity * rft.film_rental_rate) as revenue,
	   pc.category_popularity
FROM Popular_category pc
JOIN rental_film_table rft 
	ON pc.film_category = rft.film_category
GROUP BY rft.film_category, pc.category_popularity
ORDER BY REVENUE DESC;







-- Lateness
-- Do certain films or categories see more late returns? 

SELECT 
    film_id, 
    CASE 
        WHEN (DATE(return_date) - DATE(rental_date)) > (film_rental_duration) THEN 'Late'
        ELSE 'On Time'
    END AS return_status,
    COUNT(*) AS count_of_rentals
FROM rental_film_table
GROUP BY film_id, return_status
ORDER BY film_id, return_status;

---
ALTER TABLE rental_film_table
ADD COLUMN rental_status VARCHAR(10);

UPDATE rental_film_table
SET rental_status = CASE 
    WHEN (DATE(return_date) - DATE(rental_date)) > (film_rental_duration) THEN 'Late'
    ELSE 'On Time'
END;



---
SELECT 
    CASE 
        WHEN film_length < 86.43 THEN 'Short'
        WHEN film_length BETWEEN 86.43 AND 144.57 THEN 'Middle'
        ELSE 'Long'
    END AS length_category,
    COUNT(*) AS count_of_films,
	rental_status
FROM rental_film_table
GROUP BY length_category, rental_status
ORDER BY length_category, rental_status;




---
ALTER TABLE rental_film_table
ADD COLUMN length_category VARCHAR(10);

UPDATE rental_film_table
SET length_category = CASE 
    WHEN film_length < 86.43 THEN 'Short'
    WHEN film_length BETWEEN 86.43 AND 144.57 THEN 'Middle'
    ELSE 'Long'
END;
---
WITH length_category_totals AS (
	SELECT 
    	COUNT(*) AS total_count,
		length_category
	FROM rental_film_table
	GROUP BY length_category
)
SELECT
    rft.length_category,
    rft.rental_status,
    COUNT(*)::decimal / lct.total_count AS proportion
FROM rental_film_table rft
JOIN length_category_totals lct 
    ON rft.length_category = lct.length_category
GROUP BY rft.length_category, rft.rental_status, lct.total_count
ORDER BY rft.length_category, rft.rental_status;
---


WITH category_totals AS (
	SELECT 
    	COUNT(*) AS total_count,
		film_category
	FROM rental_film_table
	GROUP BY film_category
)
SELECT
    rft.film_category,
    rft.rental_status,
    COUNT(*)::decimal / ct.total_count AS proportion
FROM rental_film_table rft
JOIN category_totals ct 
    ON rft.film_category = ct.film_category
GROUP BY rft.film_category, rft.rental_status, ct.total_count
ORDER BY rft.film_category, rft.rental_status;
---


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






--Get the distribution of Category vs Rental_rate, Replacement_cost, Rental_duration...
SELECT category, COUNT(*),
       ROUND(AVG(rental_rate), 2) as avg_rental_rate, 
       ROUND(AVG(replacement_cost), 2) AS avg_replacement_cost, 
	   ROUND(AVG(rental_duration), 2) AS avg_rental_duration,
	   ROUND(AVG(length), 2) AS avg_length, 
	   ROUND(AVG(release_year), 2) AS avg_release_year 
FROM joined_film_table
GROUP BY category
ORDER BY avg_rental_rate desc;



-- ALL category statistics

WITH category_stats AS (
    SELECT 
        category, 
        COUNT(*) AS film_count,
        ROUND(AVG(rental_rate), 2) AS avg_rental_rate, 
        ROUND(AVG(replacement_cost), 2) AS avg_replacement_cost, 
        ROUND(AVG(rental_duration), 2) AS avg_rental_duration,
        ROUND(AVG(length), 2) AS avg_length, 
        ROUND(AVG(release_year), 2) AS avg_release_year 
    FROM 
        joined_film_table
    GROUP BY 
        category
    ORDER BY 
        avg_rental_rate DESC
)
SELECT 
    sfc.*, 
    cs.film_count, 
    cs.avg_rental_rate, 
    cs.avg_replacement_cost, 
    cs.avg_rental_duration, 
    cs.avg_length, 
    cs.avg_release_year
FROM 
    sales_by_film_category sfc
JOIN 
    category_stats cs ON sfc.category = cs.category;
