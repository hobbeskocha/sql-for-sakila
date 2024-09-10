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
       SUM(rft.film_rental_rate) as revenue,
	   pc.category_popularity
FROM Popular_category pc
JOIN rental_film_table rft 
	ON pc.film_category = rft.film_category
GROUP BY rft.film_category, pc.category_popularity
ORDER BY REVENUE DESC;

