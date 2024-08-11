-- Customer
-- Where are our customers located? District, City, country, etc.; Active customers in each region
select country, sum(active) as active_customers, count(customer_id) as total_customers
	from customer c, address a, city ci, country co
	where c.address_id = a.address_id
	and a.city_id = ci.city_id
	and ci.country_id = co.country_id
	group by country
	order by total_customers desc;

select country, round(sum(active)::numeric/count(customer_id)::numeric, 2) as active_proportion, count(customer_id) as total_customers
	from customer c, address a, city ci, country co
	where c.address_id = a.address_id
	and a.city_id = ci.city_id
	and ci.country_id = co.country_id
	group by country
	order by total_customers desc;
