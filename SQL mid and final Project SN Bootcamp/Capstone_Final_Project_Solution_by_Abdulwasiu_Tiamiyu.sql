-------------- ABDULWASIU TIAMIYU ----------------

-- FINAL PROJECT SOLUTION --
            
use mavenmovies;
-- Number 1
/* 
1. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 

SELECT 
    st.store_id,
    s.first_name,
    s.last_name,
    a.address,
    a.district,
    c.city,
    co.country
FROM
    staff s
        JOIN
    store st ON st.manager_staff_id = s.staff_id
        JOIN
    address a ON a.address_id = st.address_id
        JOIN
    city c ON c.city_id = a.city_id
        JOIN
    country co ON co.country_id = c.country_id;
    
    
-- Number 2
/*
2.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/
SELECT 
    s.store_id,
    i.inventory_id,
    f.title,
    f.rating,
    p.amount,
    f.replacement_cost
FROM
    store s
        JOIN
    inventory i ON i.store_id = s.store_id
        JOIN
    film f ON f.film_id = i.film_id
        JOIN
    rental r ON r.inventory_id = i.inventory_id
        JOIN
    payment p ON p.rental_id = r.rental_id;

-- Number 3
/* 
3.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/
SELECT DISTINCT
    s.store_id, I.inventory_id, COUNT(i.inventory_id), f.rating
FROM
    store s
        JOIN
    inventory i ON i.store_id = s.store_id
        JOIN
    film f ON f.film_id = i.film_id
        JOIN
    rental r ON r.inventory_id = i.inventory_id
        JOIN
    payment p ON p.rental_id = r.rental_id
GROUP BY i.inventory_id;
        

-- Number 4
/* 
4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 
SELECT 
    s.store_id,
    c.name AS category,
    COUNT(f.film_id),
    AVG(f.replacement_cost),
    SUM(f.replacement_cost) total_replacement_cost
FROM
    film f
        JOIN
    film_category fc ON fc.film_id = f.film_id
        JOIN
    category c ON c.category_id = fc.category_id
        JOIN
    inventory i ON i.film_id = f.film_id
        JOIN
    store s ON s.store_id = i.store_id
GROUP BY s.store_id , c.name;


-- Number 5
/*
5.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/
SELECT 
    c.first_name,
    c.last_name,
    st.store_id,
    c.active active_status,
    a.address,
    ci.city,
    co.country
FROM
    customer c
        JOIN
    store st ON st.store_id = c.store_id
        JOIN
    address a ON a.address_id = c.address_id
        JOIN
    city ci ON ci.city_id = a.city_id
        JOIN
    country co ON co.country_id = ci.country_id;
    
   
    -- Number 6
    /*
6.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/
SELECT DISTINCT
    c.first_name,
    c.last_name,
    COUNT(p.rental_id) total_rent,
    SUM(p.amount) total_payment
FROM
    customer c
        JOIN
    payment p ON c.customer_id = p.customer_id
GROUP BY first_name , last_name
ORDER BY SUM(p.amount) DESC;


-- Number 7
/*
7. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/
SELECT 
    first_name,
    last_name,
    IF(advisor_id IS NOT NULL,
        'advisor',
        'investor') AS investor_or_advisor,
    NULL AS company_name
FROM
    advisor 
UNION ALL SELECT 
    first_name,
    last_name,
    IF(investor_id IS NOT NULL,
        'investor',
        'advisor') AS is_investor,
    company_name
FROM
    investor;


-- Number 8 
/*
8. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/

SELECT 
    ROUND(SUM(CASE
                WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN 1
            END) * 100 / COUNT(actor_award_id),
            2) AS percentage_of_carrying_a_film_by_actor_with_3_awards,
    ROUND(SUM(CASE
                WHEN actor_award.awards IN ('Emmy, Oscar' , 'Emmy, Tony', 'Oscar, Tony') THEN 1
            END) * 100 / COUNT(actor_award_id),
            2) AS percentage_of_carrying_a_film_by_actor_with_2_awards,
    ROUND(SUM(CASE
                WHEN actor_award.awards IN ('Emmy' , 'Oscar', 'Tony') THEN 1
            END) * 100 / COUNT(actor_award_id),
            2) AS percentage_of_carrying_a_film_by_actor_with_just_1_award
FROM
    actor_award;