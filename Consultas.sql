>## Consultas iniciales

1. Obtener el nombre, idioma original de la película, fecha de alquiler y fecha de devolución de todos los alquileres realizados por el cliente: Nombre: BARBARA Apellido: JONES (22 Filas)
SELECT film.title , rental.rental_date, rental.return_date FROM rental
INNER JOIN inventory
    ON rental.inventory_id = inventory.inventory_id
INNER JOIN film
    ON inventory.film_id = film.film_id
INNER JOIN customer
    ON rental.customer_id = customer.customer_id
WHERE customer.first_name = 'BARBARA' 
    AND customer.last_name = 'JONES';

2. Mostrar Apellido, Nombre de los actores que participan en todas las películas de la categoría Comedy con y sin repetición (286 filas c/repetición) (147 filas s/repetición) [DISTINCT]

SELECT film.title , actor.last_name , actor.first_name FROM film
INNER JOIN film_actor
    ON film.film_id = film_actor.film_id
INNER JOIN actor
    ON film_actor.actor_id = actor.actor_id
INNER JOIN film_category
    ON film.film_id = film_category.film_id
INNER JOIN category
    ON category.category_id =  film_category.category_id
WHERE category.name='Comedy';
                        
3. Obtener todos los datos de película en las que participo el actor de nombre : RAY  (30 filas)

SELECT film.title, actor.first_name FROM film
INNER JOIN film_actor
    ON film.film_id = film_actor.film_id
INNER JOIN actor
    ON film_actor.actor_id = actor.actor_id
WHERE actor.first_name = 'RAY'

4. Obtener un listado de todas las películas cuya duración sea entre 61 y 99 minutos (ambos inclusive) y el lenguaje original sea French (9 rows)
SELECT film.title, film.length, language.name, original_language_id FROM film
INNER JOIN language
    ON film.original_language_id = language.lenguage_id
WHERE film.length BETWEEN 61 AND 99 AND language.name = 'French'

5. Mostrar nombre ciudad y nombre de país (en MAYÚSCULAS) de todas las ciudades de los países (Austria, Chile, France) ordenadas por país luego nombre localidad (10 filas) [UPPER]
SELECT UPPER(city.city), UPPER(country.country) FROM city
INNER JOIN country
    ON city.country_id = country.country_id
WHERE country.country IN ('Austria', 'Chile', 'France') ORDER BY country.country, city.city;

6. Mostrar el apellido (minúsculas) concatenado al nombre (MAYÚSCULAS) cuyo apellido de los actores contenga SS. (7 Filas) [LIKE, UPPER, LOWER]

SELECT UPPER(actor.first_name) || ' ' || LOWER(actor.last_name) FROM actor
WHERE actor.last_name LIKE '%SS%';  

7. Mostrar el nro de ejemplar y nombre película de todos los alquileres del día 26 (sin importar mes) que sean del almacén de la ciudad Woodridge (99 filas) [Utilizando extract o date_part]
SELECT film.title, rental.rental_date, city.city, store FROM rental
INNER JOIN inventory
    ON rental.inventory_id = inventory.inventory_id
INNER JOIN film
    ON film.film_id = inventory.film_id
INNER JOIN store
    ON inventory.store_id = store.store_id
INNER JOIN address
    ON store.address_id = address.address_id
INNER JOIN city
    ON address.city_id = city.city_id

WHERE EXTRACT(DAY FROM rental_date) = 26 AND city.city = 'Woodridge'

8. Mostrar la segunda pagina (cada una tiene 10 películas) del listado nombre de la película , lenguaje original y valor de reposición de la películas ordenadas por su valor de reposición del mas caro al mas barato (10 filas) [LIMIT, OFFSET y ORDER]
SELECT film.title, film.replacement_cost, film.language FROM film
INNER JOIN language
    ON film.original_language_id = language.language_id
WHERE DESC OFFSET 10 LIMIT 10 --OFFSET 10 porque como cada pagina tiene 10 peliculas, entonces comenzamos a partir del 10 para que tome la 2da pagina
AND ORDER BY film.replacement_cost

9. Mostrar el nombre de la película, el nombre del cliente, nro de ejemplar, fecha de alquiler, fecha de devolución de los ejemplares que demoraron mas de 7 días en ser devueltos (3557 filas) [AGE]
SELECT film.title, customer.first_name, inventory.inventory_id, rental_date, return_date FROM rental
INNER JOIN inventory
    ON rental.inventory_id = inventory.inventory_id
INNER JOIN film
    ON inventory.film_id = film.film_id
INNER JOIN customer
    ON rental.customer_id = customer.customer_id
WHERE AGE(return_date, rental_date) > INTERVAL '7 days'

>## Consultas intermedias.
10.  Mostrar todas las películas que están alquiladas y que todavía no fueron devueltas. Mostrando el nombre de la película, el número de ejemplar, quien la alquilo y la fecha. Mostrar el nombre del cliente de la manera Apellido, Nombre y renombre el campo como 'nombre_cliente' 
SELECT film.title, inventory.inventory_id, rental_date, return_date, customer.first_name AS nombre_cliente, customer.last_name from rental
INNER JOIN inventory
    ON rental.inventory_id = inventory.inventory_id
INNER JOIN film
    ON inventory.film_id = film.film_id
INNER JOIN customer
    ON rental.customer_id = customer.customer_id

WHERE return_date IS NULL;

11. Mostrar cuales fueron las 10 películas mas alquiladas
SELECT film.title, COUNT(rental.rental_id) AS cantVecesAlquilada FROM rental
INNER JOIN inventory
    ON rental.inventory_id = inventory.inventory_id
INNER JOIN film
    ON inventory.film_id = film.film_id
GROUP BY film.title --Agrupamos los alquileres por titulo, entonces vamos agrupar todas las filas que esten relacionadas a la misma pelicula 
ORDER BY rental.rental_id DESC LIMIT 10:

12. Realizar un listado de las películas que fueron alquiladas por el cliente "OWENS, CARMEN"
SELECT film.title, customer.last_name, customer.first_name FROM rental
INNER JOIN inventory
    ON rental.inventory_id = inventory.inventory_id
INNER JOIN film
    ON inventory.film_id = film.film_id
INNER JOIN customer
    ON rental.customer_id = customer.customer_id

WHERE customer.first_name = 'CARMEN' AND customer.last_name = 'OWENS'

13. Buscar los pagos que no han sido asignados a ningún alquiler
SELECT payment_id, rental_id, payment_date FROM payment
WHERE rental_id IS NULL

14. Seleccionar todas las películas que son en "Mandarin" y listar las por orden alfabético. Mostrando el titulo de la película y el idioma ingresando el idioma en minúsculas. 
SELECT film.title, LOWER(language.name) FROM film
INNER JOIN language
    ON film.language_id = language.language_id

WHERE language.name = 'Mandarin'
ORDER BY film.title;

15. Mostrar los clientes que hayan alquilado mas de 1 vez la misma película 
SELECT customer.first_name, COUNT(rental.customer_id) AS cantidad_veces_alquilada FROM rental
INNER JOIN inventory
    ON rental.inventory_id = inventory.inventory_id
INNER JOIN film
    ON inventory.film_id = film.film_id
INNER JOIN customer
    ON rental.customer_id = customer.customer_id
GROUP BY customer.customer_id, customer.first_name, film.film_id, film.title
HAVING COUNT(rental.customer_id) > 1;

16. Mostrar los totales de alquileres por mes del año 2005 

SELECT EXTRACT(MONTH FROM rental_date) AS mesDelAño, COUNT(rental.rental_id) AS totalAlquileres FROM rental
WHERE EXTRACT(YEAR FROM rental_date)  = 2005
GROUP BY rental_date ORDER BY rental_date;

17. Mostrar los totales históricos de alquileres discriminados por categoría. Ordene los resultados por el campo monto en orden descendente al campo calculado llamarlo monto.
SELECT category.name, SUM(payment.amount) AS monto FROM payment
INNER JOIN rental
    ON payment.rental_id = rental.rental_id
INNER JOIN inventory
    ON rental.inventory_id = inventory.inventory_id
INNER JOIN film
    ON inventory.film_id = film.film_id
INNER JOIN film_category
    ON film.film_id = film_category.film_id
INNER JOIN category
    ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY monto DESC;

18. Listar todos los actores de las películas alquiladas en el periodo 7 del año 2005. Ordenados alfabéticamente representados "APELLIDO, nombre" renombrar el campo como Actor 
SELECT UPPER(actor.last_name) || ',' ||actor.first_name AS Actor FROM rental
INNER JOIN inventory
    ON rental.inventory_id  = inventory.inventory_id
INNER JOIN film
    ON inventory.film_id = film.film_id
INNER JOIN film_actor
    ON film.film_id = film_actor.film_id
INNER JOIN actor
    ON film_actor.actor_id = actor.actor_id
    
WHERE EXTRACT(YEAR FROM rental.return_date) = 2005 AND EXTRACT(MONTH FROM rental.rental_date) = 7
ORDER BY Actor ASC;

19. Listar el monto gastado por el customer last_name=SHAW; first_name=CLARA; 
SELECT customer.last_name, customer.first_name, SUM(payment.amount) AS totalGastado FROM payment
INNER JOIN rental
    ON payment.rental_id = rental.rental_id
INNER JOIN customer
    ON rental.customer_id = customer.customer_id
WHERE customer.first_name= 'CLARA' AND customer.last_name = 'SHAW'
GROUP BY customer.last_name, customer.first_name;

20. Listar el valor mas alto de los alquileres registrados en el año 2005. Mostrar además quien fue el cliente que abono ese alquiler. 

SELECT customer.first_name, customer.last_name, payment.amount, payment_date FROM payment
INNER JOIN rental
    ON payment.rental_id = rental.rental_id
INNER JOIN customer
    ON rental.customer_id = customer.customer_id
WHERE EXTRACT(YEAR FROM payment.payment_date) = 2005
ORDER BY payment.amount DESC LIMIT 1;

21. Listar el monto gastado por los customer que hayan gastado mas de 40 en el mes 6 de 2005. 

SELECT customer.first_name, customer.last_name, SUM(payment.amount) FROM payment
INNER JOIN customer
    ON payment.customer_id = customer.customer_id
WHERE EXTRACT(YEAR FROM payment.payment_date) = 2005
    AND EXTRACT(MONTH FROM payment.payment_date) = 6
GROUP BY customer.first_name, customer.last_name
HAVING SUM(payment.amount) > 40;

22. Mostrar la cantidad del clientes hay por ciudad

SELECT city.city, COUNT(customer.customer_id) AS clientesPorCiudad FROM customer
INNER JOIN address
    ON customer.address_id = address.address_id
INNER JOIN city
    ON address.city_id = city.city_id
GROUP BY city.city
ORDER BY clientesPorCiudad DESC;

23. Mostrar las 5 películas con mayor cantidad de actores.

SELECT film.title, COUNT(film_actor.actor_id) AS cantidadActores FROM film
INNER JOIN film_actor
    ON film.film_id = film_actor.film_id
GROUP BY film.title, film.film_id
ORDER BY cantidadActores DESC LIMIT 5;

24. Mostrar los días donde se hayan alquilado mas de 10 de películas de "Drama" 

SELECT DATE(rental.rental_date) AS fechaAlquiler, COUNT(rental.rental_id) FROM rental
INNER JOIN inventory
    ON rental.inventory_id = inventory.inventory_id
INNER JOIN film
    ON inventory.film_id = film.film_id
INNER JOIN film_category
    ON film.film_id = film_category.film_id
INNER JOIN category
    ON film_category.category_id = category.category_id
WHERE category.name = 'Drama'
GROUP BY fechaAlquiler
HAVING COUNT(rental.rental_id) > 10 ORDER BY fechaAlquiler; 

25. Mostrar los actores que no están en ninguna película 

SELECT actor.first_name, actor.last_name FROM actor
LEFT JOIN film_actor
    ON actor.actor_id = film_actor.actor_id
WHERE film_actor.film_id IS NULL
ORDER BY actor.last_name, actor.first_name;

28. Clientes que alquilaron tanto la película más como la menos alquilada

SELECT c.first_name, c.last_name FROM rental r
INNER JOIN inventory i 
    ON r.inventory_id = i.inventory_id
INNER JOIN customer c ON 
r.customer_id = c.customer_id

WHERE i.film_id IN (SELECT film_id FROM maxc)
INTERSECT SELECT c.first_name, c.last_name FROM rental r
INNER JOIN inventory i 
    ON r.inventory_id = i.inventory_id
INNER JOIN customer c 
    ON r.customer_id = c.customer_id
WHERE i.film_id IN (SELECT film_id FROM minc)
