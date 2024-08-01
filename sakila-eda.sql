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



