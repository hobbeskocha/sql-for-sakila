select title, rental_date, return_date, amount
	from payment p, rental r, inventory i, film f
	where p.rental_id = r.rental_id
	and r.inventory_id = i.inventory_id
	and i.film_id = f.film_id
	order by return_date desc;

select title, replacement_cost, amount
	from payment p, rental r, inventory i, film f
	where p.rental_id = r.rental_id
	and r.inventory_id = i.inventory_id
	and i.film_id = f.film_id
	order by title, rental_date;

-- movies not returned
select title, rental_date, rental_date + concat(rental_duration, 'days')::interval as expected_return, return_date, amount
	from payment p, rental r, inventory i, film f
	where p.rental_id = r.rental_id
	and r.inventory_id = i.inventory_id
	and i.film_id = f.film_id
	and return_date is null
	and amount = 0.00
	order by return_date desc;

-- city countries
select address, city, country
	from city ci, country co, address ad
	where ci.country_id = co.country_id
	and ci.city_id = ad.city_id
	order by country, city;

-- film languages
select distinct l.name
from film f, language l
where f.language_id = l.language_id

-- payment values
select distinct amount
from payment;

-- rental rate values
select distinct rental_rate
from film;

-- rental rate vs amount
select f.film_id, f.rental_rate, p.amount
	from film f, inventory i, rental r, payment p
	where f.film_id = i.film_id
	and i.inventory_id = r.inventory_id
	and r.rental_id = p.rental_id
	and p.amount <> 0.00
	and p.amount >= f.rental_rate;

-- rental volumes
with rental_volumes as (
	select f.film_id,
			count(r.rental_id) as rental_volume
		from film f, inventory i, rental r
		where f.film_id = i.film_id
		and i.inventory_id = r.inventory_id
		group by f.film_id
)
select min(rental_volume),
		percentile_cont(0.5) within group(order by rental_volume) as median,
		max(rental_volume)
	from rental_volumes;

