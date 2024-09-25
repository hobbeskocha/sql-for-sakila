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

--- Popularity & Revenue

--  What are the top 1% of movies based on the highest revenue generated? 
	-- Is that high revenue due to popularity (rental rate) or late fees?
create or replace view revenue_volume_all as (
with revenue_streams as (
		select f.film_id, f.title, f.rental_duration, f.rating,
			date(r.return_date) > date(r.rental_date + f.rental_duration * interval '1 day') as is_late,
			p.amount,
			r.rental_id
		from film f, inventory i, rental r, payment p
		where f.film_id = i.film_id
		and i.inventory_id = r.inventory_id
		and r.rental_id = p.rental_id
	)
select 
	rs.film_id, 
	rs.title, 
	rs.rental_duration, 
	rs.rating,  
		sum(case when rs.is_late then 0
				else rs.amount end) as regular_revenue, 
		sum(case when rs.is_late then rs.amount
				else 0 end) as late_revenue,
		sum(amount) as total_revenue,
	count(rs.rental_id) as rental_volume
	from revenue_streams rs
	group by rs.film_id, rs.title, rs.rental_duration, rs.rating
	order by total_revenue desc
	);

-- Identify revenues coming from normal rental rate vs late fees for the top 1% (by total revenue), assuming payments when the movie is late are late fees
with top_1_revenues as (
	select * 
		from revenues_and_volume
		limit (0.01 * (select count(*) from revenues_and_volume))::integer
	),
	revenue_streams as (
		select tr.film_id, tr.title,
			date(r.return_date) > date(r.rental_date + tr.rental_duration * interval '1 day') as is_late,
			p.amount
		from top_1_revenues tr, inventory i, rental r, payment p
		where tr.film_id = i.film_id
		and i.inventory_id = r.inventory_id
		and r.rental_id = p.rental_id
	)
select 
	rs.film_id,
	rs.title, 
		sum(case when rs.is_late then 0
				else rs.amount end) as regular_revenue, 
		sum(case when rs.is_late then rs.amount
				else 0 end) as late_revenue,
		sum(amount) as total_revenue
	from revenue_streams rs
	group by rs.film_id, rs.title
	order by total_revenue desc;

-- which films have earned the highest revenue and have the highest popularity within each rating?
with rankings as (
	select rv.film_id, rv.title, rv.rating,
		rank() over(partition by rv.rating order by rv.total_revenue desc) as revenue_rank,
		rank() over(partition by rv.rating order by rv.rental_volume desc) as volume_rank
		from revenues_and_volume rv
	)
select r.film_id, r.title, r.rating, r.revenue_rank, r.volume_rank
	from rankings r
	where (r.revenue_rank = 1 or r.volume_rank = 1);

