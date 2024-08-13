-- check the amount of actors for one film 
SELECT 
    f.film_id, 
    COUNT(f_a.actor_id) AS actor_count
FROM 
    film AS f
JOIN 
    film_actor AS f_a ON f.film_id = f_a.film_id
GROUP BY 
    f.film_id
HAVING 
    COUNT(f_a.actor_id) > 1;

-- check the amount of categories for one film 
SELECT 
    f.film_id, 
    COUNT(f_c.category_id) AS category_count
FROM 
    film AS f
JOIN 
    film_category AS f_c ON f.film_id = f_c.film_id
GROUP BY 
    f.film_id
HAVING 
    COUNT(f_c.category_id) > 1;
	


--- CREATE TABLE: Full_film_table_except_actor --

CREATE TEMP TABLE Full_film_table_except_actor AS
SELECT 
    f.film_id, 
    f.title, 
    f.description, 
    f.release_year, 
	f.language_id, 
    f.rental_duration, 
    f.rental_rate,
	f.length, 
    f.replacement_cost, 
	f.rating, 
	f.last_update, 
	f.special_features, 
	f.fulltext, 
    f_c.category_id,
	l.name as language_name, 
	c.name as category
FROM 
    film as f
JOIN 
    film_category as f_c ON f.film_id = f_c.film_id
JOIN 
    language as l ON f.language_id = l.language_id
JOIN 
    category as c ON f_c.category_id = c.category_id;

---
SELECT * FROM Full_film_table_except_actor LIMIT 10;
SELECT count(*) FROM Full_film_table_except_actor;
SELECT count(*) FROM film;
SELECT * FROM film_actor LIMIT 100;
SELECT language_name FROM Full_film_table;
---


-- Popularity & Revenue


--- Create the table "Full_film_table" using left join
CREATE TEMP TABLE Full_film_table AS
SELECT 
    f.film_id, 
    f.title, 
    f.description, 
    f.release_year, 
    f.language_id, 
    f.rental_duration, 
    f.rental_rate,
    f.length, 
    f.replacement_cost, 
    f.rating, 
    f.last_update, 
    f.special_features, 
    f.fulltext, 
    f_c.category_id,
    l.name as language_name, 
    c.name as category_name,
    ARRAY_AGG(DISTINCT a.actor_id) FILTER (WHERE a.actor_id IS NOT NULL) AS actor_ids,
    ARRAY_AGG(DISTINCT a.first_name || ' ' || a.last_name) FILTER (WHERE a.actor_id IS NOT NULL) AS actor_names
FROM 
    film as f
LEFT JOIN 
    film_actor as f_a ON f.film_id = f_a.film_id
LEFT JOIN 
    film_category as f_c ON f.film_id = f_c.film_id
LEFT JOIN 
    language as l ON f.language_id = l.language_id
LEFT JOIN 
    category as c ON f_c.category_id = c.category_id
LEFT JOIN 
    actor as a ON f_a.actor_id = a.actor_id
GROUP BY 
    f.film_id, 
    f.title, 
    f.description, 
    f.release_year, 
    f.language_id, 
    l.name, 
    f.rental_duration, 
    f.rental_rate,
    f.length, 
    f.replacement_cost, 
    f.rating, 
    f.last_update, 
    f.special_features, 
    f.fulltext, 
    f_c.category_id, 
    c.name;


---
SELECT * FROM Full_film_table LIMIT 10;
SELECT count(*) FROM Full_film_table;
SELECT count(*) FROM film;
SELECT min(film_id) FROM Full_film_table;
SELECT * FROM film_actor LIMIT 100;
SELECT language_name FROM Full_film_table;
---


--- Replace the table "Full_film_table_new_2" using inner join ---

CREATE TEMP TABLE Full_film_table_2 AS
SELECT 
    f.film_id, 
    f.title, 
    f.description, 
    f.release_year, 
    f.language_id, 
    f.rental_duration, 
    f.rental_rate,
    f.length, 
    f.replacement_cost, 
    f.rating, 
    f.last_update, 
    f.special_features, 
    f.fulltext, 
    f_c.category_id,
    l.name as language_name, 
    c.name as category_name,
    ARRAY_AGG(DISTINCT a.actor_id) FILTER (WHERE a.actor_id IS NOT NULL) AS actor_ids,
    ARRAY_AGG(DISTINCT a.first_name || ' ' || a.last_name) FILTER (WHERE a.actor_id IS NOT NULL) AS actor_names
FROM 
    film as f
JOIN 
    film_actor as f_a ON f.film_id = f_a.film_id
JOIN 
    film_category as f_c ON f.film_id = f_c.film_id
JOIN 
    language as l ON f.language_id = l.language_id
JOIN 
    category as c ON f_c.category_id = c.category_id
JOIN 
    actor as a ON f_a.actor_id = a.actor_id
GROUP BY 
    f.film_id, 
    f.title, 
    f.description, 
    f.release_year, 
    f.language_id, 
    l.name, 
    f.rental_duration, 
    f.rental_rate,
    f.length, 
    f.replacement_cost, 
    f.rating, 
    f.last_update, 
    f.special_features, 
    f.fulltext, 
    f_c.category_id, 
    c.name;

---
SELECT * FROM Full_film_table_2 LIMIT 10;
SELECT count(*) FROM Full_film_table_2;
SELECT count(*) FROM film;
---




--- Create the full rental-film table ---
SELECT * FROM rental;
SELECT * FROM inventory;
SELECT * FROM customer;

CREATE TEMP TABLE rental_film_table AS
SELECT 
    r.rental_id, 
    r.rental_date, 
    r.inventory_id, 
    r.customer_id, 
    r.return_date, 
	r.staff_id, 
    r.last_update, 
    i.film_id, 
	i.store_id, 
	F_f_2.title as film_title,
	F_f_2.description as film_description, 
	F_f_2.release_year as film_release_year,
	F_f_2.rental_duration as film_rental_duration,
	F_f_2.rental_rate as film_rental_rate,
	F_f_2.length as film_length,
	F_f_2.replacement_cost as film_replacement_cost,
	F_f_2.rating as film_rating,
	F_f_2.special_features as film_special_features, 
	F_f_2.language_name as film_language, 
	F_f_2.category_name as film_category, 
	F_f_2.actor_ids as film_actors, 
	F_f_2.actor_names as film_actor_names
FROM 
    rental as r
JOIN 
    inventory as i ON i.inventory_id = r.inventory_id
JOIN 
    Full_film_table_2 as F_f_2 ON F_f_2.film_id = i.film_id;

SELECT * FROM rental_film_table LIMIT 10;
SELECT count(*) FROM rental_film_table;
SELECT count(*) FROM rental;
---

-- Business Questions [Popularity & Revenue]
-- Any correlation between the length of a movie and the popularity?
-- Or does it mostly depend on the rental rate?


--- Length (film_length) vs Popularity ---
SELECT 
    CASE 
        WHEN film_length < 86.43 THEN 'Short'
        WHEN film_length BETWEEN 86.43 AND 144.57 THEN 'Middle'
        ELSE 'Long'
    END AS length_category,
    COUNT(*) AS rental_count
FROM rental_film_table
GROUP BY length_category
ORDER BY rental_count DESC;


--- Rating (film_rating) vs Popularity ---
SELECT 
    film_rating, 
    COUNT(rental_id) AS rental_count
FROM 
    rental_film_table
GROUP BY 
    film_rating
ORDER BY 
    rental_count DESC;

--- Category (film_category) vs Popularity ---
SELECT 
    film_category, 
    COUNT(rental_id) AS rental_count
FROM 
    rental_film_table
GROUP BY 
    film_category
ORDER BY 
    rental_count DESC;

--- Rental (film_rental_rate) vs Popularity ---
SELECT 
    film_rental_rate, 
    COUNT(*) AS rental_count
FROM 
    rental_film_table
GROUP BY 
    film_rental_rate
ORDER BY 
    rental_count DESC;


--- Replacement (film_replacement_cost) vs Popularity ---
SELECT 
    film_replacement_cost, 
    COUNT(*) AS rental_count
FROM 
    rental_film_table
GROUP BY 
    film_replacement_cost
ORDER BY 
    rental_count DESC;




-- Step 1: Create a Table with Rental Counts

CREATE TEMP TABLE film_popularity AS
SELECT 
    film_id,
    COUNT(rental_id) AS rental_count
FROM 
    rental_film_table
GROUP BY 
    film_id;


-- Step 2: Join Film Attributes with Rental Counts

CREATE TEMP TABLE film_analysis_data AS
SELECT 
    fpt.film_id,
    fpt.film_title,
    fpt.film_release_year,
    fpt.film_rental_duration,
	fpt.film_rental_rate,
    fpt.film_length,
    fpt.film_replacement_cost,
    fpt.film_rating,
    fpt.film_special_features,
    fpt.film_language,
	fpt.film_category,
    fp.rental_count
FROM 
    rental_film_table fpt
JOIN 
    film_popularity fp ON fpt.film_id = fp.film_id;

--- Step 3: Perform Correlation Analysis


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

SELECT * FROM customer LIMIT 10;
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
