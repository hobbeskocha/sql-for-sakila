-- Customer
-- Where are our customers located, by country?; Active customers in each region
select country, 
		round(sum(active)::numeric/count(customer_id)::numeric, 2) as active_proportion,
		sum(active) as active_customers,
		count(customer_id) as total_customers
	from customer c, address a, city ci, country co
	where c.address_id = a.address_id
	and a.city_id = ci.city_id
	and ci.country_id = co.country_id
	group by rollup(country)
	order by country asc;

select country, coalesce(store_id::text, 'overall') as store,
		round(sum(active)::numeric/count(customer_id)::numeric, 2) as active_proportion,
		sum(active) as active_customers,
		count(customer_id) as total_customers
	from customer c, address a, city ci, country co
	where c.address_id = a.address_id
	and a.city_id = ci.city_id
	and ci.country_id = co.country_id
	group by cube(country, store_id)
	order by country asc, store asc;


-- Rental volume and revenue by country and store
select co.country,
		count(r.rental_id) as rental_volume,
		sum(p.amount) as total_revenue
	from payment p, rental r, customer c, address a, city ci, country co
	where p.rental_id = r.rental_id 
	and r.customer_id = c.customer_id
	and c.address_id = a.address_id
	and a.city_id = ci.city_id
	and ci.country_id = co.country_id
	group by rollup(co.country)
	order by co.country asc;

select co.country, coalesce(c.store_id::text, 'overall') as store,
		count(r.rental_id) as rental_volume,
		sum(p.amount) as total_revenue
	from payment p, rental r, customer c, address a, city ci, country co
	where p.rental_id = r.rental_id 
	and r.customer_id = c.customer_id
	and c.address_id = a.address_id
	and a.city_id = ci.city_id
	and ci.country_id = co.country_id
	group by cube(co.country, c.store_id)
	order by co.country, store;
