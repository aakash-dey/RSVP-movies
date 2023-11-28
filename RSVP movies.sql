USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:



-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- Finding individual count of each table through separate queries
 
-- No of rows in director_mapping table = 3867
SELECT 
	COUNT(*) AS 'director_mapping_row_count'
FROM
	director_mapping;

-- No of rows in genre table = 14662
SELECT 
	COUNT(*) AS 'genre_row_count'
FROM
	genre;

-- No of rows in movie table = 7997
SELECT 
	COUNT(*) AS 'movie_row_count'
FROM
	movie;

-- No of rows in names table = 25735
SELECT 
	COUNT(*) AS 'names_row_count'
FROM
	names;

-- No of rows in ratings table = 7997
SELECT 
	COUNT(*) AS 'ratings_row_count'
FROM
	ratings;

-- No of rows in role_mapping table = 15615
SELECT 
	COUNT(*) AS 'role_mapping_row_count'	
FROM
	role_mapping;

-- Alternatively we can use a single line query in the follow manner to find out the number of rows in each table using INFORMATION_SCHEMA.TABLES.

SELECT
	table_name,
    table_rows
FROM
	INFORMATION_SCHEMA.TABLES
WHERE
	TABLE_SCHEMA = 'imdb';

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- Using CASE Statements, we can calcuate the null values in each column of the movie table.
SELECT
	SUM(CASE
			WHEN title IS NULL THEN 1
            ELSE 0
		END) AS title_null_count,
	SUM(CASE
			WHEN year IS NULL THEN 1
            ELSE 0
		END) AS year_null_count,
	SUM(CASE
			WHEN date_published IS NULL THEN 1
            ELSE 0
		END) AS date_published_null_count,
	SUM(CASE
			WHEN duration IS NULL THEN 1
            ELSE 0
		END) AS duration_null_count,
    SUM(CASE
			WHEN country IS NULL THEN 1
            ELSE 0
		END) AS country_null_count,
	SUM(CASE
			WHEN worlwide_gross_income IS NULL THEN 1
            ELSE 0
		END) AS worldwide_gross_income_null_count,
	SUM(CASE
			WHEN languages IS NULL THEN 1
            ELSE 0
		END) AS languages_null_count,
	SUM(CASE
			WHEN production_company IS NULL THEN 1
            ELSE 0
		END) AS prod_comp_null_count
FROM
	movie;
    
    

-- The columns country, worlwide_gross_income, langugage and production_company have NULL values in the movie table.


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- No of movies released year wise
SELECT
	year AS 'Year',
	count(id) AS number_of_movies
FROM
	movie
GROUP BY
	year
ORDER BY
	year;

-- No of movies released month wise
SELECT
	MONTH(date_published) AS month_num,
	count(id) AS number_of_movies
FROM
	movie
GROUP BY
	MONTH(date_published)
ORDER BY
	MONTH(date_published);


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
    
SELECT 
    year,
    COUNT(id) AS India_USA_movie_count
FROM 
	movie
WHERE 
	year = 2019
    AND (
		LOWER(country) LIKE '%usa%'
		OR LOWER(country) LIKE '%india%');

/* By using LIKE function we can also add movies which were produced in multiple countries of which 
	USA and India were part of inaddition to movies exclusively produced in USA and India. */


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT
	DISTINCT genre
FROM
	genre;

-- There are 13 unique genres in the genre table.

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT
	genre,
    COUNT(m.id) AS no_of_movies
FROM
	movie AS m
	INNER JOIN
    genre AS g
    ON m.id = g.movie_id
GROUP BY
	genre
ORDER BY
	no_of_movies DESC
	LIMIT 1;

-- Drama genre has the highest no_of_movies 


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

-- Using a CTE to determine the number of genres each movie_id belongs to and filtering out those movie_ids belonging to only one genre.
WITH one_genre AS
(
	SELECT
		movie_id,
		COUNT(genre) AS genre_count
	FROM
		genre
	GROUP BY
		movie_id
	 HAVING
	 	genre_count = 1
)
SELECT
	COUNT(movie_id) AS single_genre_movie_count
FROM
	one_genre;



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT
	genre,
    ROUND(AVG(duration),2) AS avg_duration
FROM
	movie AS m
	INNER JOIN
	genre AS g
	ON m.id = g.movie_id
GROUP BY
	genre
ORDER BY
	avg_duration DESC;

-- Action genre has the highest avg_duration of 112.88 mins.

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- Using RANK() function to order all the genres on the basis of movie_count in descending order in the CTE.
WITH genre_rank AS
(
	SELECT
		genre,
		COUNT(m.id) AS movie_count,
		RANK() OVER (ORDER BY COUNT(m.id) DESC) AS genre_rank
	FROM
		movie AS m
		INNER JOIN
		genre AS g
		ON m.id = g.movie_id
	GROUP BY
		genre	
)
SELECT
	*
FROM
	genre_rank
WHERE
	genre ='Thriller';

-- Filtering genre = 'Thriller' from the CTE genre_rank to get rank of the Thriller genre as 3.



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT
	MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
	MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
	ratings;


    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

-- Using ROW_NUMBER() function to order and rank each movie based on descending order of avg_rating and then filtering the top 10 ranks.
WITH rating_ranks AS
(
	SELECT
		title,
		avg_rating,
		ROW_NUMBER() OVER ( ORDER BY avg_rating DESC) AS movie_rank
	FROM
		movie AS m
		INNER JOIN
		ratings AS r
		ON m.id = r.movie_id
)
SELECT 
	*
FROM
	rating_ranks
WHERE
	movie_rank <= 10;



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT
	median_rating,
    COUNT(movie_id) AS movie_count
FROM
	ratings
GROUP BY
	median_rating
ORDER BY
	median_rating;

-- Ordering by median_rating provides us an overview on how many movies are there in each median_rating level.






/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH top_prod AS
(
	SELECT
		production_company,
		COUNT(m.id) AS movie_count,
		DENSE_RANK() OVER( ORDER BY COUNT(m.id) DESC) AS prod_company_rank
	FROM
		movie AS m
		INNER JOIN
		ratings AS r
		ON m.id = r.movie_id
	WHERE
		r.avg_rating > 8
		AND 
        production_company IS NOT NULL
	GROUP BY
		production_company
)
SELECT
	*
FROM
	top_prod
WHERE
	prod_company_rank = 1;


-- Both Dream Warrior Pictures and National Theatre Live are ranked first in terms of highest number of hit movies produced.




-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT
	genre,
    COUNT(m.id) AS movie_count
FROM
	genre AS g
    INNER JOIN
    movie AS m
    ON g.movie_id = m.id
    INNER JOIN
    ratings AS r
    ON m.id = r.movie_id
WHERE
	m.year = 2017
    AND 
    MONTH(m.date_published) = 3
    AND 
    m.country LIKE '%USA%'
    AND 
    r.total_votes > 1000
GROUP BY
	genre
ORDER BY
	movie_count DESC;

-- Drama had the highest number of movies which were produced in USA and released in March 2017 to have total_votes > 1000.

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT
	title,
    avg_rating,
    genre
FROM
	movie AS m
	INNER JOIN
    genre AS g
    ON m.id = g.movie_id
    INNER JOIN
    ratings AS r
    ON m.id = r.movie_id
WHERE
	title LIKE 'The%'
    AND 
    avg_rating > 8
 ORDER BY
	 avg_rating DESC;


-- Provided Ordering using average rating to give a structure the output display for movies starting with 'The'.



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT
	median_rating,
	COUNT(m.id) AS movie_count
FROM
	movie AS m
	INNER JOIN
    ratings AS r
    ON m.id = r.movie_id
WHERE
	date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY
	median_rating
 HAVING
 median_rating = 8;

-- There are 361 movies with a median_rating of 8 which were released between 1 April 2018 and 1 April 2019


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT
	languages,
    total_votes
FROM
	movie AS m
    INNER JOIN
    ratings AS r
    ON m.id = r.movie_id
WHERE
	LOWER(languages) = 'German'
    OR LOWER(languages) = 'Italian'
GROUP BY
	languages
ORDER BY
	total_votes DESC;




-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

-- Using CASE Statements, we can calcuate the null values in each column of the names table.
SELECT
	SUM(CASE
			WHEN name IS NULL THEN 1
            ELSE 0
		END) AS name_nulls,
	SUM(CASE
			WHEN height IS NULL THEN 1
            ELSE 0
		END) AS height_nulls,
	SUM(CASE
			WHEN date_of_birth IS NULL THEN 1
            ELSE 0
		END) AS date_of_birth_nulls,
	SUM(CASE
			WHEN known_for_movies IS NULL THEN 1
            ELSE 0
		END) AS known_for_movies_nulls
FROM
	names;






/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- CTE is used to shortlist the top 3 genres which are Drama,Action and Comedy based on movie_count.
WITH top3_genres AS
(
	SELECT
		genre,
        COUNT(movie_id) AS movie_count
	FROM
		genre AS g
        INNER JOIN
        ratings AS r
        USING (movie_id)
    WHERE
		avg_rating > 8
	GROUP BY
		genre
	ORDER BY
		movie_count DESC
	    LIMIT 3
)  -- Find the number of movies of a director in the top 3 genres and order by movie_count to find top 3 directors in the top 3 genres.
SELECT
	n.name AS director_name,
    COUNT(d.movie_id) AS movie_count
FROM
	names AS n
    INNER JOIN
    director_mapping as d
    ON n.id = d.name_id
    INNER JOIN
    genre AS g
    USING (movie_id)
    INNER JOIN
    ratings AS r
    USING (movie_id),
    top3_genres    
WHERE
	g.genre IN (top3_genres.genre)
	AND r.avg_rating > 8
GROUP BY
	director_name
ORDER BY
	movie_count DESC
    LIMIT 3;

-- The top 3 directors are James Mangold, Anthony Russo, Soubin Shahir.


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- CTE is used to rank the top actors who have provided most number of movies with a median_rating greater than 8.
WITH actor_summary AS
(
	SELECT
		n.name AS actor_name,
		COUNT(ro.movie_id) AS movie_count,
		ROW_NUMBER() OVER (ORDER BY COUNT(ro.movie_id) DESC) AS actor_rank
	FROM
		names AS n
		INNER JOIN
		role_mapping AS ro
		ON n.id = ro.name_id
		INNER JOIN
		ratings AS r
		USING (movie_id)
	WHERE
		r.median_rating >= 8
		AND ro.category = 'actor'
	GROUP BY
		actor_name
)
SELECT
	actor_name,
    movie_count
FROM
	actor_summary
WHERE
	actor_rank <= 2;


-- Top 2 actors based on movie_count who have median_rating of greater than 8 are Mammootty and Mohanlal.


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH top_rank_prod AS
(
	SELECT
		m.production_company AS production_company,
		SUM(r.total_votes) AS vote_count,
		RANK() OVER (ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
	FROM
		movie AS m
		INNER JOIN
		ratings AS r
		ON m.id = r.movie_id
	GROUP BY
		m.production_company
)
SELECT
	*
FROM
	top_rank_prod
WHERE
	prod_comp_rank <=3;


-- Top 3 production companies based on vote_count are Marvel Studios, Twentieth Century Fox and Warner Bros. respectively.


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Using two inputs in Order by clause in order to break tie in actor_avg_rating by using total_votes.
SELECT
	n.name AS actor_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(r.movie_id) AS movie_count,
    ROUND(SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes),2) AS actor_avg_rating,
    RANK() OVER(ORDER BY ROUND(SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes),2) DESC, SUM(r.total_votes) DESC) AS actor_rank
FROM
	names AS n
    INNER JOIN
    role_mapping AS ro
    ON n.id = ro.name_id
    INNER JOIN
    ratings AS r
	ON ro.movie_id = r.movie_id
	INNER JOIN
    movie AS m
    ON m.id = r.movie_id
WHERE
	LOWER(m.country) LIKE '%india%'
    AND
    ro.category = 'actor'
GROUP BY
	actor_name
HAVING
	movie_count >=5;


-- Vijay Sethupathi and Fahad Faasil make the top two actors respectively.

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT
	n.name AS actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(r.movie_id) AS movie_count,
    ROUND(SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes),2) AS actress_avg_rating,
    RANK() OVER(ORDER BY ROUND(SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes),2) DESC, SUM(r.total_votes) DESC) AS actress_rank
FROM
	names AS n
    INNER JOIN
    role_mapping AS ro
    ON n.id = ro.name_id
    INNER JOIN
    ratings AS r
	ON ro.movie_id = r.movie_id
	INNER JOIN
    movie AS m
    ON m.id = r.movie_id
WHERE
	LOWER(m.country) LIKE '%india%'
    AND
    LOWER(m.languages) LIKE '%hindi%'
    AND
    ro.category = 'actress'
GROUP BY
	actress_name
HAVING
	movie_count >=3;


-- Taapsee Pannu and Kriti Sanon are the top two actresses respectively based on actress_avg_rating




/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT
	m.title,
	CASE
		WHEN r.avg_rating > 8 THEN 'Superhit movies'
		WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        WHEN r.avg_rating <5 THEN 'Flop movies'
	END AS movie_rating_category
FROM
	ratings AS r
    INNER JOIN
    genre AS g
    USING (movie_id)
    INNER JOIN
    movie AS m
    ON m.id = g.movie_id
WHERE
	g.genre = 'Thriller';




/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

/* Use CTE to determine the avg_duration of movies in each genre. Then this avg_duration value is 
	used to calculate running total and moving average in the main query */
    
WITH genre_wise_avg_duration AS
(
SELECT
	g.genre,
    ROUND(AVG(m.duration),2) AS avg_duration
FROM
	genre AS g
    INNER JOIN
    movie AS m
	ON g.movie_id = m.id
GROUP BY
	g.genre
ORDER BY
	g.genre
)
SELECT
	*,
	SUM(avg_duration) OVER( ROWS UNBOUNDED PRECEDING) AS running_total_duration,
	ROUND(AVG(avg_duration) OVER(  ROWS 10 PRECEDING ),2) AS moving_avg_duration
FROM
	genre_wise_avg_duration;







-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH genre_ranks AS
(
	SELECT
		genre,
        COUNT(movie_id) AS movie_count,
        RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
	FROM
		genre AS g
        INNER JOIN
        ratings AS r
        USING (movie_id)
    WHERE
		avg_rating > 8
	GROUP BY
		genre
),
top_gross_movies AS 
(							-- Convert INR values to $ by dividing by 78 and inorder to compare all movie_values
	SELECT
		g.genre,
		m.year,
		m.title AS movie_name,
        m.worlwide_gross_income AS worldwide_gross_income,
		RANK() OVER(PARTITION BY m.year ORDER BY 
											( CASE 
												WHEN m.worlwide_gross_income LIKE '\$%' THEN ROUND((REPLACE(m.worlwide_gross_income,'$',' ')),2)
												WHEN m.worlwide_gross_income LIKE 'INR%' THEN ROUND((REPLACE(m.worlwide_gross_income,'INR','')/78),2) 
											END)
                                            DESC) AS movie_rank
	FROM
		genre AS g
		INNER JOIN
		movie AS m
		ON g.movie_id = m.id
	WHERE
		g.genre IN
				(SELECT 
					genre
                FROM
					genre_ranks
				WHERE
					genre_rank <= 3)
   GROUP BY	
 	 	m.title
	
)
SELECT
	*
FROM
	top_gross_movies
WHERE
	movie_rank <= 5
ORDER BY
		year;


/*  In 2017, Star Wars: Episode VIII - The Last Jedi was the highest grossing movie.
	In 2018, Avengers: Infinity War was the highest grossing movie.
	In 2019, Avengers: Endgame was the highest grossing movie. *%


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

-- Using CTE to filter the top ranking production companies which have highest number of multilingual movie_count.
WITH top_multilingual_prod AS
(
	SELECT
		m.production_company,
		COUNT(m.id) AS movie_count,
		RANK() OVER(ORDER BY COUNT(m.id) DESC) AS prod_comp_rank
	FROM
		movie AS m
		INNER JOIN
		ratings AS r
		ON m.id = r.movie_id
	WHERE
		POSITION(',' IN m.languages) > 0
		AND r.median_rating >= 8
		AND m.production_company IS NOT NULL
	GROUP BY
		m.production_company
)
SELECT
	*
FROM
	top_multilingual_prod
WHERE
	prod_comp_rank <= 2;

-- Star Cinema and Twentieth Century Fox are the top two production companies in the multilingual category.

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

/* Use CTE to rank the actresses based on number of super hit movies in the Drama genre. 
	Then filter the actress_rank in the main query to determine top 2 actresses. */ 
WITH actress_ratings AS
(
SELECT
	n.name AS actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(r.movie_id) AS movie_count,
    ROUND(SUM(r.total_votes * r.avg_rating)/SUM(r.total_votes),2) AS actress_avg_rating,
	ROW_NUMBER() OVER(ORDER BY COUNT(r.movie_id) DESC) AS actress_rank
FROM
	names AS n
    INNER JOIN
    role_mapping AS ro
    ON n.id = ro.name_id
    INNER JOIN
    ratings AS r
    ON ro.movie_id = r.movie_id
    INNER JOIN
    genre AS g
    ON r.movie_id = g.movie_id
WHERE
	ro.category = 'actress'
    AND
    r.avg_rating > 8
    AND
    g.genre = 'Drama'
    
GROUP BY
	actress_name
)
SELECT
	*
FROM
	actress_ratings
WHERE
	actress_rank <= 3;

-- The top 3 actress based on movie_count in Drama genre having delivered Superhit movies are Parvathy Thiruvothu, Susan Brown and Amanda Lawrence.

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

-- First CTE next_date is used to find the next_movie_date for each release of the director using lead function
WITH next_date AS
(
	SELECT 
		n.id AS director_id,
		n.name AS director_name,
        r.movie_id AS movie_id,
        r.total_votes AS total_votes,
        r.avg_rating AS avg_rating,
        m.duration AS duration,
        m.date_published AS date_published,
		LEAD(m.date_published,1,0) OVER(PARTITION BY n.name ORDER BY m.date_published) AS next_movie_date
	FROM
		names AS n
		INNER JOIN
		director_mapping AS d
		ON n.id = d.name_id
		INNER JOIN
		ratings AS r
		ON d.movie_id = r.movie_id
		INNER JOIN
		movie AS m
		ON r.movie_id = m.id
	
), 		-- second CTE is used to find the date_difference between each movie of a director.
date_difference AS 
(
	SELECT
		*,
		DATEDIFF(next_movie_date, date_published) AS diff_of_date
	FROM
		next_date
)	
	-- Find avg_inter_movie_days by using average function on diff_of_date and rounding it to nearest integer as expected by question and grouping by director_name.
SELECT 
	director_id,
    director_name,
    COUNT(movie_id) AS number_of_movies,
	ROUND(AVG(diff_of_date)) AS avg_inter_movie_days,
	ROUND(AVG(avg_rating),2) AS avg_rating,
	SUM(total_votes) AS total_votes,
	MIN(avg_rating) AS min_rating, 
    MAX(avg_rating) AS max_rating, 
    SUM(duration) AS total_duration
FROM
	date_difference
GROUP BY
	director_name
ORDER BY
	number_of_movies DESC
	LIMIT 9;




