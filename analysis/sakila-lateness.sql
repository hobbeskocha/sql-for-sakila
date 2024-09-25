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

-- quartiles for film lengths
select 
		film_id,
		case 
			when length <= (select percentile_cont(0.25) within group(order by length) from film) then 'Q1'
			when length > (select percentile_cont(0.25) within group(order by length) from film) 
					and length <= (select percentile_cont(0.5) within group(order by length) from film) then 'Q2'
			when length > (select percentile_cont(0.5) within group(order by length) from film) 
					and length <= (select percentile_cont(0.75) within group(order by length) from film) then 'Q3'
			else 'Q4' end as relative_length,
		length,
		rental_duration
	from film;

select 
	concat(min(length), '-', percentile_cont(0.25) within group(order by length)) as Q1,
	concat(percentile_cont(0.25) within group(order by length) + 1, '-', percentile_cont(0.5) within group(order by length)) as Q2,
	concat(percentile_cont(0.5) within group(order by length) + 1, '-', round(percentile_cont(0.75) within group(order by length))) as Q3,
	concat(round(percentile_cont(0.75) within group(order by length)) + 1, '-', max(length)) as Q4
	from film;

-- What length of movies are more likely to be returned late, in each quartile?
with movie_length as (
	select 
		film_id,
		case 
			when length <= (select percentile_cont(0.25) within group(order by length) from film) then 'Q1'
			when length > (select percentile_cont(0.25) within group(order by length) from film) 
					and length <= (select percentile_cont(0.5) within group(order by length) from film) then 'Q2'
			when length > (select percentile_cont(0.5) within group(order by length) from film) 
					and length <= (select percentile_cont(0.75) within group(order by length) from film) then 'Q3'
			else 'Q4' end as relative_length,
		length,
		rental_duration
	from film
), 
length_and_returns as (
	select ml.film_id, ml.relative_length,
	date(r.rental_date + ml.rental_duration * interval '1 day') as rental_due_date,
	date(r.return_date) as actual_return_date,
	date(r.return_date) > date(r.rental_date + ml.rental_duration * interval '1 day') as late
	from movie_length ml, inventory i, rental r
	where ml.film_id = i.film_id
	and i.inventory_id = r.inventory_id
	and date(r.return_date) is not null
)
select relative_length,
	sum(late::integer) as late_rentals,
	count(*) as total_rentals,
	concat(substring(
				cast(100 * round(sum(late::integer)::numeric / count(*), 4) as text),
				1, 5),
			'%') as late_proportion
	from length_and_returns
	group by relative_length
	order by relative_length;


-- Average days late by relative length in each quartile?
with movie_length as (
	select 
		film_id,
		case 
			when length <= (select percentile_cont(0.25) within group(order by length) from film) then 'Q1'
			when length > (select percentile_cont(0.25) within group(order by length) from film) 
					and length <= (select percentile_cont(0.5) within group(order by length) from film) then 'Q2'
			when length > (select percentile_cont(0.5) within group(order by length) from film) 
					and length <= (select percentile_cont(0.75) within group(order by length) from film) then 'Q3'
			else 'Q4' end as relative_length,
		length,
		rental_duration
	from film
), 
length_and_returns as (
	select ml.film_id, ml.relative_length,
	date(r.rental_date + ml.rental_duration * interval '1 day') as rental_due_date,
	date(r.return_date) as actual_return_date,
	date(r.return_date) > date(r.rental_date + ml.rental_duration * interval '1 day') as late
	from movie_length ml, inventory i, rental r
	where ml.film_id = i.film_id
	and i.inventory_id = r.inventory_id
)
select relative_length, round(avg(actual_return_date - rental_due_date), 3) as avg_days_late
	from length_and_returns
	where late is true
	group by relative_length
	order by relative_length;

-----------------------------------------------------------------------------------------

-- What length of movies (longer or shorter than the AVERAGE length) are more likely to be returned late?
with movie_length as (
	select 
		film_id,
		case when length > (select avg(length) from film) then 'Longer' 
			else 'Shorter/Equal' end as relative_length,
		length,
		rental_duration
	from film
), 
length_and_returns as (
	select ml.film_id, ml.relative_length,
	date(r.rental_date + ml.rental_duration * interval '1 day') as rental_due_date,
	date(r.return_date) as actual_return_date,
	date(r.return_date) > date(r.rental_date + ml.rental_duration * interval '1 day') as late
	from movie_length ml, inventory i, rental r
	where ml.film_id = i.film_id
	and i.inventory_id = r.inventory_id
	and date(r.return_date) is not null
)
select relative_length,
	sum(late::integer) as late_rentals,
	count(*) as total_rentals,
	concat(substring(
				cast(100 * round(sum(late::integer)::numeric / count(*), 4) as text),
				1, 5),
			'%') as late_proportion
	from length_and_returns
	group by relative_length;


-- Average days late by relative length to AVERAGE?
with movie_length as (
	select 
		film_id,
		case when length > (select avg(length) from film) then 'Longer' 
			else 'Shorter/Equal' end as relative_length,
		length,
		rental_duration
	from film
), 
length_and_returns as (
	select ml.film_id, ml.relative_length,
	date(r.rental_date + ml.rental_duration * interval '1 day') as rental_due_date,
	date(r.return_date) as actual_return_date,
	date(r.return_date) > date(r.rental_date + ml.rental_duration * interval '1 day') as late
	from movie_length ml, inventory i, rental r
	where ml.film_id = i.film_id
	and i.inventory_id = r.inventory_id
)
select relative_length, round(avg(actual_return_date - rental_due_date), 3) as avg_days_late
	from length_and_returns
	where late is true
	group by relative_length;
