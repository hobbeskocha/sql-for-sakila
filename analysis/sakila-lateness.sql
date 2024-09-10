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

--- (3)Lateness count by store_id
SELECT 
    c.store_id as store_customer,
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
    rental_film_table rft
	LEFT JOIN customer c on rft.customer_id = c.customer_id
GROUP BY 
    c.store_id
ORDER BY 
    late_proportion DESC;



--- (4)Lateness count by film_replacement_cost
--- (5)Lateness count by film_rating
--- (6)Lateness count by film_rental_rate
--- (7)Lateness count by store_id
