--- Lateness

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
