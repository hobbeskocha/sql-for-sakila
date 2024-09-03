-- Customer
-- Where are our customers located, by country?; Active customers in each region
select coalesce(country, 'Overall') as country,
		round(sum(active)::numeric/count(customer_id)::numeric, 2) as active_proportion,
		sum(active) as active_customers,
		count(customer_id) as total_customers
	from customer c, address a, city ci, country co
	where c.address_id = a.address_id
	and a.city_id = ci.city_id
	and ci.country_id = co.country_id
	group by rollup(country)
	order by country asc;

select coalesce(country, 'Overall') as country, coalesce(store_id::text, 'Overall') as store,
		round(sum(active)::numeric/count(distinct customer_id)::numeric, 2) as active_proportion,
		sum(active) as active_customers,
		count(distinct customer_id) as total_customers
	from customer c, address a, city ci, country co
	where c.address_id = a.address_id
	and a.city_id = ci.city_id
	and ci.country_id = co.country_id
	group by cube(country, store_id)
	order by country asc, store asc;

-- select store_id, count(distinct customer_id)
-- from customer c, address a
-- 	where c.address_id = a.address_id
-- 	group by store_id;

-- Rental volume and revenue by country and store
select coalesce(co.country, 'Overall') as country,
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

select coalesce(co.country, 'Overall') as country, coalesce(c.store_id::text, 'Overall') as store,
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
