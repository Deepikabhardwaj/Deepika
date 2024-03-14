USE SAKILA;


select * from actor;

-- Task-1-- display all the full names of actors in database----

select * from film_actor;

select concat( first_name, '_', last_name ) as full_name from actor;
----------------------------------------------------------------------------------------------------------------------------------------
-- Task-2-- Managment wants to know if there are any names of the actors appearing frequently.
--------
-- Task-2- (a)--Display the number of times each first name appears in the database--

SELECT first_name, COUNT(*) as name_count FROM actor GROUP BY first_name ORDER BY name_count DESC;

-- Task-2- (b)-- What is the count of actors that have unique first name in the database?Display the first name of all these actors.

SELECT first_name, COUNT(*) as name_count FROM actor GROUP BY first_name HAVING COUNT(*) = 1;

--------------------------------------------------------------------------------------------------------------------------------------
-- Task-3-- The management is intrested to analyse the similarity in the last name of the actors.

-- Task-3(a)-- Display the number of times each last name appears in the database--

SELECT last_name, COUNT(*) as name_count FROM actor GROUP BY last_name ORDER BY name_count DESC;

-- Task-3- (b)-- Display all unique last name in the database.

SELECT last_name, COUNT(*) as name_count FROM actor GROUP BY last_name HAVING COUNT(*) = 1;

----------------------------------------------------------------------------------------------------------------------------------------

-- Task-4 --The Management wants to analyse the movies based on their rating to determine if they are suitable for kids or some parential assistance is required.Perform the following tasks to perform required analysis--

-- Task-4(a)-- Display the list of records of the movies with rating 'R'.(The movies rating with 'R' are not suitable for audience under age 17 years.

select * from film;

SELECT title, rating FROM film WHERE rating = 'R';

-- Task-4(b)-- Display the list of records for the movies that are not rated with 'R'.

SELECT title, rating FROM film WHERE rating <> 'R';

-- Task-4(c)-- Display the list of records for the movies that are suitable for the audience below 13 years of age.

SELECT title, rating FROM film WHERE rating = 'PG-13';
--------------------------------------------------------------------------------------------------------------------------------
-- Task-5-- The board memeber wants to understand the replacement cost of a movie copy.The replacement cost refers to the amount charged to the customer if the movie disc  is not returned or is retuned in a damaged state. 

-- Task-5(a)-- Display the list of records for the movies where the replacement cost is upto $11.

SELECT title, replacement_cost FROM film WHERE replacement_cost <= 11.00;

-- Task-5(b)-- Display the list of records for the movies where the replacement cost is between $11 and $20.

SELECT title, replacement_cost FROM film WHERE replacement_cost BETWEEN 11.00 AND 20.00;

-- Task-5(c)-- Display the list of records for the movies in descending order of their replacement cost.

SELECT title, replacement_cost FROM film ORDER BY replacement_cost DESC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Task-6--Display the names of the top 3 movies with the greatest number of actors.

SELECT m.title, COUNT(am.actor_id) as actor_count FROM film m JOIN film_actor am ON m.film_id = am.film_id
GROUP BY m.film_id, m.title ORDER BY actor_count DESC LIMIT 3;

---------------------------------------------------------------------------------------------------------------------------------------
-- Task-7--'Music of Queen' and 'Kris Kristofferson' have seen an unlikely resurgence.As an intended consequence, 
-- films starting with the letters 'K' and 'Q' have also soared in popularity.
-- Display the titles of the movies starting with the letters 'K' and 'Q'.

SELECT title FROM film WHERE title LIKE 'K%' OR title LIKE 'Q%' ORDER BY title;

-----------------------------------------------------------------------------------------------------------------------------------------

-- Task-8-- 'Agent Truman' has been a great success.Display the names of all actors who appeared in this film.

select concat( first_name, '_', last_name ) as full_name FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
WHERE film.title = 'Agent Truman';

------------------------------------------------------------------------------------------------------------------------------------------

-- Task-9--Sales have been lagging among young families,so the management wants to promote family movies.
-- Identified all the movies categorised as 'Family Film'.

select * from category;

select film.title as 'Movie Name', category.name as 'Category of Movie' from film inner join film_category on 
film.film_id = film_category.film_id inner join category on category.category_id=film_category.category_id where category.name='Family';
------------------------------------------------------------------------------------------------------------------------------------
-- Task-10-- The management wants to observe the rental rates and rental frequencies.(number of time the movie disc is rented)


-- Task-10(a)-- Display maximum,minimum and average rental rates of movies based on their ratings.
-- The output must be sorted in descending order of the average rental rates.

SELECT rating,
    MAX(rental_rate) AS max_rental_rate,
    MIN(rental_rate) AS min_rental_rate,
    AVG(rental_rate) AS avg_rental_rate
FROM film
GROUP BY rating
ORDER BY avg_rental_rate DESC;


-- Task-10-(b)-- Display the movies in descending order of their rental frequencies,
-- so the management can maintain more copies of the movies.

select film.title as 'Title of Movie',count(rental.rental_id) as 'Rental Frequency' from film
 join inventory on film.film_id=inventory.film_id
 join rental on inventory.inventory_id=rental.inventory_id group by film.title order by count(rental.rental_id) desc;



--------------------------------------------------------------------------------------------------------------------------------------------

-- Task-11-In how many film catgories, the difference between the average film replacement cost and the average 
-- film rental rate is greater than $15?

select category.name ,avg(replacement_cost) as 'Replacement Cost',avg(rental_rate) as 'Rental Cost',(avg(replacement_cost)-avg(rental_rate))as 'Difference' from film
 join film_category on film_category.film_id =film.film_id join category on film_category.category_id=category.category_id group by category.name having (avg(replacement_cost)-avg(rental_rate))>15 ;


-- Display the list of all film categories identified above ,
-- along with the corresponding average film replacement cost and average film rental rate.

SELECT film_id,AVG(replacement_cost) AS avg_replacement_cost, AVG(rental_rate) AS avg_rental_rate
FROM film
GROUP BY film_id
HAVING (AVG(replacement_cost) - AVG(rental_rate)) > 15;


-- Task-12-- Display the film categories in which the number of movies is greater than 70.


select E.name as 'Movie Name', count(F.film_id) as'Count of Movies' from category as E ,film_category as D,film as F
where E.category_id=D.category_id and F.film_id=D.film_id group  by E.name having  count(F.film_id)>70;

