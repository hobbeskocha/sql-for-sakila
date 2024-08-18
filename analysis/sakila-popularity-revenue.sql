--- Popularity & Revenue

--  What are the top 1% of movies based on the highest revenue generated? 
	-- Is that high revenue due to popularity (rental rate) or late fees?
create or replace view top_1_revenues as 
	with revenue_and_volume as (
		select f.film_id, f.rental_duration, sum(p.amount) as total_revenue, count(r.rental_id) as rental_volume
		from film f, inventory i, rental r, payment p
		where f.film_id = i.film_id
		and i.inventory_id = r.inventory_id
		and r.rental_id = p.rental_id
		group by f.film_id, f.rental_duration
		order by sum(p.amount) desc
	)
	select * 
		from revenue_and_volume
		limit (0.01 * (select count(*) from revenue_and_volume))::integer;

-- Identify revenues coming from normal rental rate vs late fees, assuming payments when the movie is late are late fees
with revenue_streams as (
	select tr.film_id, 
		date(r.return_date) > date(r.rental_date + tr.rental_duration * interval '1 day') as is_late,
		p.amount
	from top_1_revenues tr, inventory i, rental r, payment p
	where tr.film_id = i.film_id
	and i.inventory_id = r.inventory_id
	and r.rental_id = p.rental_id
)
select rs.film_id, 
		sum(case when rs.is_late then 0
				else rs.amount end) as regular_revenue, 
		sum(case when rs.is_late then rs.amount
				else 0 end) as late_revenue,
		sum(amount) as total_revenue
	from revenue_streams rs
	group by rs.film_id
	order by total_revenue desc;


-- TODO rank, partition by
select f.film_id, sum(p.amount) as total_revenue,
			count(r.rental_id) as rental_volume,
			rank() over(partition by count(r.rental_id) order by sum(p.amount) desc) as revenue_rank
		from film f, inventory i, rental r, payment p
		where f.film_id = i.film_id
		and i.inventory_id = r.inventory_id
		and r.rental_id = p.rental_id
		group by f.film_id, f.rating
		order by sum(p.amount) desc;


-- Any movies that have never been rented?

