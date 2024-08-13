--- Popularity & Revenue

--  What are the top 1% of movies based on the highest revenue generated? 
	-- Is that high revenue due to popularity or late fees?
create or replace view top_1_revenues as 
	with revenue_and_volume as (
		select f.film_id, sum(p.amount) as total_revenue, count(r.rental_id) as rental_volume
		from film f, inventory i, rental r, payment p
		where f.film_id = i.film_id
		and i.inventory_id = r.inventory_id
		and r.rental_id = p.rental_id
		group by f.film_id, f.rating
		order by sum(p.amount) desc
	)
	select * 
		from revenue_and_volume
		limit (0.01 * (select count(*) from revenue_and_volume))::integer;

select *
from top_1_revenues;


-- TODO: identify revenues coming from normal rental rate vs late fees


-- Any movies that have never been rented?

