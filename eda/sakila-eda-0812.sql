--Examine the Database Schema
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';

-- Perform Basic Table Inspection
SELECT * FROM actor LIMIT 10;
SELECT * FROM film LIMIT 10;
SELECT COUNT(*) FROM film;

SELECT * FROM address LIMIT 10;
SELECT * FROM category LIMIT 10;
SELECT * FROM city LIMIT 10;

SELECT * FROM country LIMIT 10;
SELECT * FROM customer LIMIT 10;
SELECT COUNT(*) FROM customer;

SELECT * FROM film_actor LIMIT 10;
SELECT * FROM film_category LIMIT 10;
SELECT * FROM inventory LIMIT 10;
SELECT * FROM language LIMIT 10;

SELECT * FROM rental LIMIT 10;
SELECT * FROM staff LIMIT 10;
SELECT * FROM store LIMIT 10;
SELECT * FROM payment LIMIT 10;
SELECT COUNT(*) FROM payment;


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

-- Data Distribution of categorical data (Rating)
SELECT rating, COUNT(*)
FROM film
GROUP BY rating
ORDER BY count desc;

-- Data Distribution of film collection: Rating & Rental, replacement cost, duration
SELECT rating, COUNT(*),
       ROUND(AVG(rental_rate), 2) as avg_rental_rate, 
       ROUND(AVG(replacement_cost), 2) AS avg_replacement_cost, 
	   ROUND(AVG(rental_duration), 2) AS avg_rental_duration,
	   ROUND(AVG(length), 2) AS avg_length
FROM film
GROUP BY rating
ORDER BY count desc;

-- Data Distribution of film collection: legnth 
SELECT 
    CASE 
        WHEN length < 86.43 THEN 'Short'
        WHEN length BETWEEN 86.43 AND 144.57 THEN 'Middle'
        ELSE 'Long'
    END AS length_category,
    COUNT(*) AS count_of_films,
	ROUND(AVG(rental_rate), 2) as avg_rental_rate, 
    ROUND(AVG(replacement_cost), 2) AS avg_replacement_cost, 
	ROUND(AVG(rental_duration), 2) AS avg_rental_duration
FROM film
GROUP BY length_category
ORDER BY length_category;



-- Unique Values of film collection
SELECT DISTINCT release_year FROM film;
SELECT DISTINCT language_id FROM film;
SELECT DISTINCT rental_duration FROM film ORDER BY rental_duration DESC;
SELECT DISTINCT rental_rate FROM film ORDER BY rental_rate DESC;
SELECT DISTINCT replacement_cost FROM film ORDER BY replacement_cost DESC;
SELECT DISTINCT release_year, language_id, rental_duration, rental_rate, replacement_cost  FROM film;

-- Duplicate rows





