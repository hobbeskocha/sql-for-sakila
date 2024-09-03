-- Lateness
-- Do certain films or categories see more late returns? 

-- Re-format for Lateness questions > one row for one category [late count/ total count/ proportion]

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



--- (1)Lateness count by film

SELECT 
    film_id, 
    COUNT(*) AS late_rentals_count
FROM 
    rental_film_table
WHERE 
    (DATE(return_date) - DATE(rental_date)) > (film_rental_duration)
GROUP BY 
    film_id
ORDER BY 
    late_rentals_count DESC ;

---

SELECT * FROM  rental_film_table;



--- (1-1)Lateness count by film with proportion
SELECT 
    film_id,
    SUM(
        CASE 
            WHEN (DATE(return_date) - DATE(rental_date)) > (film_rental_duration) 
            THEN 1 
            ELSE 0 
        END
    ) AS late_count,
    COUNT(*) AS total_count,
    ROUND(
		SUM(
        	CASE 
            	WHEN (DATE(return_date) - DATE(rental_date)) > (film_rental_duration) 
            	THEN 1 
            	ELSE 0 
        	END
    	)::numeric / COUNT(*)::numeric
		,2)  AS late_proportion
FROM 
    rental_film_table
GROUP BY 
    film_id
ORDER BY 
    film_id;


--- (2-1)Lateness count by film_category
SELECT 
    film_category, 
    COUNT(*) AS late_rentals_count
FROM 
    rental_film_table
WHERE 
    (DATE(return_date) - DATE(rental_date)) > (film_rental_duration)
GROUP BY 
    film_category
ORDER BY 
    late_rentals_count DESC ;


--- (2-2)Lateness count by film_category with proportion
SELECT 
    film_category,
    SUM(
        CASE 
            WHEN (DATE(return_date) - DATE(rental_date)) > (film_rental_duration) 
            THEN 1 
            ELSE 0 
        END
    ) AS late_count,
    COUNT(*) AS total_count,
    ROUND(
		SUM(
        	CASE 
            	WHEN (DATE(return_date) - DATE(rental_date)) > (film_rental_duration) 
            	THEN 1 
            	ELSE 0 
        	END
    	)::numeric / COUNT(*)::numeric
		,2)  AS late_proportion
FROM 
    rental_film_table
GROUP BY 
    film_category
ORDER BY 
    late_proportion DESC;


--- (4)Lateness count by film_replacement_cost
--- (5)Lateness count by film_rating
--- (6)Lateness count by film_rental_rate
--- (7)Lateness count by store_id

--- (3)Lateness count by store_id
SELECT 
    store_id,
    SUM(
        CASE 
            WHEN (DATE(return_date) - DATE(rental_date)) > (film_rental_duration) 
            THEN 1 
            ELSE 0 
        END
    ) AS late_count,
    COUNT(*) AS total_count,
    ROUND(
		SUM(
        	CASE 
            	WHEN (DATE(return_date) - DATE(rental_date)) > (film_rental_duration) 
            	THEN 1 
            	ELSE 0 
        	END
    	)::numeric / COUNT(*)::numeric
		,2)  AS late_proportion
FROM 
    rental_film_table
GROUP BY 
    store_id
ORDER BY 
    late_proportion DESC;




----








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
