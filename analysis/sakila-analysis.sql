-- Popularity & Revenue
-- Which top 1% of movies have generated the highest revenue? Is that due to popularity or late fees?


-- Lateness
-- What length of movies (longer or shorter) are more likely to be returned late?
with median_length as (
	select percentile_cont(0.5) within group(order by length) as median_len
	from film
)
select 
	f.title,
	case when f.length > ml.median_len then 'Longer' 
		else 'Shorter' end as longer,
	f.length
	from film f, inventory i, rental r, payment p, median_length ml
	where f.film_id = i.film_id
	and i.inventory_id = r.inventory_id
	and r.rental_id = p.rental_id;

-- Customer
-- Where are our customers located? District, City, country, etc.; Active customers in each region
select city, country, sum(active) as active_customers, count(customer_id) as total_customers
	from customer c, address a, city ci, country co
	where c.address_id = a.address_id
	and a.city_id = ci.city_id
	and ci.country_id = co.country_id
	group by city, country;

select country, round(sum(active)::numeric/count(customer_id)::numeric, 2) as active_proportion, count(customer_id) as total_customers
	from customer c, address a, city ci, country co
	where c.address_id = a.address_id
	and a.city_id = ci.city_id
	and ci.country_id = co.country_id
	group by country
	order by total_customers;
