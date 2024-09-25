-- Popularity Helpers

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


--- Create the table "Full_film_table" using left join
CREATE or REPLACE VIEW Full_film_table AS
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
SELECT DISTINCT language_name FROM Full_film_table;
---


--- Replace the table "Full_film_table_new_2" using inner join instead of left join ---

CREATE or REPLACE VIEW Full_film_table_2 AS
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


--- Create the full rental-film view ---
SELECT * FROM rental;
SELECT count(*) FROM rental;
SELECT * FROM inventory;
SELECT count(*) FROM inventory;
SELECT * FROM customer;
SELECT count(*) FROM customer;

CREATE or REPLACE VIEW rental_film_table AS
SELECT 
    r.rental_id, 
    r.rental_date, 
    r.inventory_id, 
    r.customer_id, 
    r.return_date, 
	r.staff_id, 
    r.last_update, 
    i.film_id, 
	i.store_id as inventory_store,
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
LEFT JOIN 
    inventory as i ON i.inventory_id = r.inventory_id
LEFT JOIN 
    Full_film_table_2 as F_f_2 ON F_f_2.film_id = i.film_id;

SELECT * FROM rental_film_table LIMIT 10;
SELECT count(*) FROM rental_film_table;
SELECT count(*) FROM rental;

SELECT count(*) FROM Full_film_table_2;
SELECT * FROM Full_film_table_2;
SELECT count(*) FROM film;


-- Business Questions [Popularity]

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



-- Step 1: Create a view with Rental Counts

CREATE OR REPLACE VIEW film_popularity AS
SELECT 
    film_id,
    COUNT(rental_id) AS rental_count
FROM 
    rental_film_table
GROUP BY 
    film_id;
	
-- Step 2: Join Film Attributes with Rental Counts

CREATE OR REPLACE VIEW film_analysis_data_new AS
SELECT 
    fft2.film_id,
	fft2.title,
    fft2.release_year,
    fft2.rental_duration,
	fft2.rental_rate,
    fft2.length,
    fft2.replacement_cost,
    fft2.rating,
    fft2.special_features,
	fft2.category_name,
	fft2.actor_ids,
    fp.rental_count
FROM 
    Full_film_table_2 fft2
JOIN 
    film_popularity fp ON fft2.film_id = fp.film_id;

SELECT * FROM film_analysis_data_new;
SELECT distinct category_name FROM film_analysis_data_new ;

--- Step 3: Perform Correlation Analysis

WITH category_numeric_mapping AS (
    SELECT 
        category_name,
        DENSE_RANK() OVER (ORDER BY category_name) AS category_numeric
    FROM 
        (SELECT DISTINCT category_name FROM film_analysis_data_new) AS distinct_categories
)
SELECT 
    corr(rental_count, rental_duration) AS popularity_duration_corr,
    corr(rental_count, rental_rate) AS popularity_rate_corr,
    corr(rental_count, length) AS popularity_length_corr,
	corr(rental_count, replacement_cost) AS popularity_replacement_corr, 
    corr(rental_count, 
         CASE 
             WHEN rating = 'G' THEN 1
             WHEN rating = 'PG' THEN 2
             WHEN rating = 'PG-13' THEN 3
             WHEN rating = 'R' THEN 4
			 WHEN rating = 'NC-17' THEN 4
             ELSE NULL  
         END) AS popularity_rating_corr, 
    corr(rental_count, c.category_numeric) AS popularity_category_corr
FROM film_analysis_data_new
JOIN 
    category_numeric_mapping c ON film_analysis_data_new.category_name = c.category_name;


-- Does the most popular category of movies make the highest revenue? 
-- Which category of movies have the best ratings and highest revenue?

SELECT * FROM rental_film_table LIMIT 10;

WITH Popular_category as (
	SELECT COUNT(*) as category_popularity, film_category
	FROM rental_film_table
	GROUP BY film_category
)
SELECT rft.film_category, 
       SUM(rft.film_rental_rate) as revenue,
	   pc.category_popularity
FROM Popular_category pc
JOIN rental_film_table rft 
	ON pc.film_category = rft.film_category
GROUP BY rft.film_category, pc.category_popularity
ORDER BY REVENUE DESC;