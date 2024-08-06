--Examine the Database Schema
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';

--Perform Basic Table Inspection
SELECT * FROM actor LIMIT 10;
SELECT * FROM film LIMIT 10;

--SELECT * FROM actor_info LIMIT 10;
--SELECT * FROM customer_list LIMIT 10;
--SELECT * FROM film_list LIMIT 10;

--SELECT COUNT(*) FROM film_list;
SELECT COUNT(*) FROM film;

--SELECT * FROM nicer_but_slower_film_list LIMIT 10;
SELECT * FROM sales_by_film_category LIMIT 10;
-- only two stores
--SELECT * FROM sales_by_store LIMIT 10;
--SELECT * FROM staff_list LIMIT 10;
SELECT * FROM address LIMIT 10;
SELECT * FROM category LIMIT 10;
SELECT * FROM city LIMIT 10;

SELECT * FROM country LIMIT 10;
SELECT * FROM customer LIMIT 10;

--- the same count for customer
--SELECT COUNT(*) FROM customer_list;
SELECT COUNT(*) FROM customer;

SELECT * FROM film_actor LIMIT 10;
SELECT * FROM film_category LIMIT 10;
SELECT * FROM inventory LIMIT 10;
SELECT * FROM language LIMIT 10;

SELECT * FROM rental LIMIT 10;
SELECT * FROM staff LIMIT 10;
SELECT * FROM store LIMIT 10;
SELECT * FROM payment LIMIT 10;
SELECT * FROM payment_p2007_01 LIMIT 10;
SELECT * FROM payment_p2007_02 LIMIT 10;


-- Summary Statistics for film 
SELECT
  ROUND(MIN(length), 2) AS min_length,
  ROUND(MAX(length), 2) AS max_length,
  ROUND(AVG(length), 2) AS avg_length,
  ROUND(STDDEV(length), 2) AS stddev_length,
  ROUND(MIN(rental_rate), 2) AS min_rental_rate,
  ROUND(MAX(rental_rate), 2) AS max_rental_rate,
  ROUND(AVG(rental_rate), 2) AS avg_rental_rate,
  ROUND(STDDEV(rental_rate), 2) AS stddev_rental_rate,
  ROUND(MIN(replacement_cost), 2) AS min_replacement_cost,
  ROUND(MAX(replacement_cost), 2) AS max_replacement_cost,
  ROUND(AVG(replacement_cost), 2) AS avg_replacement_cost,
  ROUND(STDDEV(replacement_cost), 2) AS stddev_replacement_cost,
  COUNT(*) AS total_count
FROM film;


--Get the distribution of categorical data (Rating)
SELECT rating, COUNT(*)
FROM film
GROUP BY rating
ORDER BY count desc;

--Get the distribution of Rating vs Rental
SELECT rating, COUNT(*),
       ROUND(AVG(rental_rate), 2) as avg_rental_rate, 
       ROUND(AVG(replacement_cost), 2) AS avg_replacement_cost, 
	   ROUND(AVG(rental_duration), 2) AS avg_rental_duration
FROM film
GROUP BY rating
ORDER BY count desc;


--- CREATE TABLE: JOIN film & film_actor & film_category --

CREATE TABLE Three_film_table AS
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
    f_a.actor_id, 
    f_c.category_id
FROM 
    film as f
JOIN 
    film_actor as f_a ON f.film_id = f_a.film_id
JOIN 
    film_category as f_c ON f.film_id = f_c.film_id;

----
SELECT * FROM Three_film_table LIMIT 10;
SELECT count(*) FROM Three_film_table;

SELECT count(*) FROM film_actor;
SELECT count(*) FROM film_category;
SELECT * FROM film_actor LIMIT 100;

SELECT film_id, actor_id FROM film_actor WHERE film_id = 1;


--- CREATE TABLE: Full_film_table --

CREATE TABLE Full_film_table AS
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
    f_a.actor_id, 
    f_c.category_id,
	l.name as language_name, 
	c.name as category,
	a.first_name as actor_first_name,
	a.last_name as actor_last_name
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
    actor as a ON f_a.actor_id = a.actor_id;

---
SELECT * FROM Full_film_table LIMIT 10;
SELECT count(*) FROM Full_film_table;
SELECT count(*) FROM film;
SELECT * FROM film_actor LIMIT 100;
SELECT language_name FROM Full_film_table;
---

--- check the multiple actors for one film 

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

--- check the multiple category for one film 
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

----



--- CREATE TABLE: Full_film_table_except_actor --

CREATE TABLE Full_film_table_except_actor AS
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

--- Replace the table "Full_film_table_new" using left join ---

DROP TABLE IF EXISTS Full_film_table_new;

CREATE TABLE Full_film_table_new AS
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
SELECT * FROM Full_film_table_new LIMIT 10;
SELECT count(*) FROM Full_film_table_new;
SELECT count(*) FROM film;
SELECT min(film_id) FROM Full_film_table_new;
SELECT * FROM film_actor LIMIT 100;
SELECT language_name FROM Full_film_table;
---


--- Replace the table "Full_film_table_new_2" using inner join ---

CREATE TABLE Full_film_table_new_2 AS
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
SELECT * FROM Full_film_table_new_2 LIMIT 10;
SELECT count(*) FROM Full_film_table_new_2;
SELECT count(*) FROM film;
SELECT min(film_id) FROM Full_film_table_new;
SELECT * FROM film_actor LIMIT 100;
SELECT language_name FROM Full_film_table;
---




--- Create the full rental-film table ---
SELECT * FROM rental;
SELECT * FROM inventory;
SELECT * FROM customer;

--DROP TABLE IF EXISTS rental_film_table;

CREATE TABLE rental_film_table AS
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
    Full_film_table_new_2 as F_f_2 ON F_f_2.film_id = i.film_id;

SELECT * FROM rental_film_table LIMIT 10;
SELECT count(*) FROM rental_film_table;
SELECT count(*) FROM rental;

---

--- Basic Analysis ---

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

-- Step 1: Create a Table with Rental Counts

CREATE TABLE film_popularity AS
SELECT 
    film_id,
    COUNT(rental_id) AS rental_count
FROM 
    rental_film_table
GROUP BY 
    film_id;


-- Step 2: Join Film Attributes with Rental Counts

CREATE TABLE film_analysis_data AS
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

COPY (SELECT * FROM film_analysis_data) TO '/Users/amanda/Desktop/amanda/MSBA-UW-2023/film_analysis_data.csv' WITH CSV HEADER;








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
