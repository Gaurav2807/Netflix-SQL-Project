-- Netflix project
DROP TABLE IF EXISTS Netflix;

CREATE TABLE Netflix 
(
	show_id	VARCHAR(6),
	content_type VARCHAR(10),
	title VARCHAR(110),
	director VARCHAR(210),
	actors VARCHAR(780),
	country	VARCHAR(130),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(10),
	listed_in VARCHAR(80),
	description VARCHAR(250)
);

-- All rows
Select 
	* 
	from Netflix;

-- Count of records
Select 
	count(*) as total_content 
	from Netflix;

-- Distinct content type
Select 
	distinct(content_type) 
	from Netflix;

-- 15 Business problems :

-- 1. Count the number of Movies vs TV Shows
	Select 
		content_type, count(content_type) total_count 
		from Netflix 
		group by content_type;


-- 2. Find the most common rating for movies and TV shows
	Select 
		content_type, rating, total_count
		from (
				Select 
				content_type, rating, count(*) total_count, rank() over(partition by (content_type) order by count(*) desc) ranking
				from Netflix 
				group by content_type, rating
				order by total_count desc
			) total_count_table
		where ranking = 1;


-- 3. List all movies released in a specific year (e.g., 2020)
	Select
		title 
		from Netflix
		where content_type = 'Movie' and release_year = 2020


-- 4. Find the top 5 countries with the most content on Netflix
Select 
	Unnest(string_to_array(country, ',')) unique_countries, count(*) content_count
	from Netflix
	group by 1 
	order by content_count desc 
	limit 5;

-- 5. Identify the longest movie
Select 
	title, duration
	from Netflix
	where content_type = 'Movie' and duration = (Select max(duration) from Netflix)


-- 6. Find content added in the last 5 years
Select 
	content_type, title, date_added
	from netflix
	where to_date(date_added, 'Month DD, YYYY') >= now() - interval '5 years'


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
Select 
	content_type, title, director
	from Netflix 
	where director ilike '%Rajiv Chilaka%'


-- 8. List all TV shows with more than 5 seasons
Select 
	Content_type, title, Cast(Regexp_replace(duration, '[^1-9]', '', 'g') as int) numeric_duration /* "Split_part(duration, ' ', 1) :: numeric" -> this could be an alternate way to choose the numeric part from the "duration" column*/
	from Netflix 
	where content_type = 'TV Show' and Cast(Regexp_replace(duration, '[^1-9]', '', 'g') as int) > 5 
	order by numeric_duration asc


-- 9. Count the number of content items in each genre
Select 
	unnest(string_to_array(listed_in, ',')) Genere, count(*) number_of_shows
	from Netflix 
	group by 1
	order by 2 desc


-- 10.Find each year and the average numbers of content release in India on netflix. Return top 5 year with highest avg content release!
Select 
	unnest(string_to_array(country, ',')) unique_countries, 
	split_part(date_added, ',', 2) release_year, 
	count(content_type) yearly_content_released, 
	Round((count(*) :: numeric / (Select count(*) from Netflix where country = 'India') :: numeric) * 100, 2) avg_content_per_year /* "Extract( Year from To_date(date_added, 'Month DD, YYYY'))" -> This is a better option to extract year after converting thr "date_added" column to "date" format" */
	from Netflix 
	where country = 'India'
	group by 1,2
	

-- 11. List all movies that are documentaries
With CTE_Category_count as
(
	Select 
		unnest(string_to_array(listed_in, ',')) Category, count(*) category_cnt
		from Netflix 
		group by 1
)
Select 
	category_cnt, sum(category_cnt) over( order by 1)
	from CTE_Category_count 
	where Category ilike '%Documentaries%';
/* Select * from Netflix where lited_in ilike '%Documentaries'*/


-- 12. Find all content without a director
Select 
	* 
	from Netflix 
	where director is null;


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
With CTE_Salman_Khan_movies as 
(
	Select 
		unnest(string_to_array(actors, ',')) unique_actors, *
		from Netflix 
		where release_year >= extract(year from current_date) - 10
		-- where to_date(date_added, 'Month DD, YYYY') >= now() - interval '10 years'
) 
Select 
	count(*)
	from CTE_Salman_Khan_movies 
	where unique_actors ilike '%Salman Khan%';


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
With CTE_unique_countries_and_actors as
(
	Select 
		unnest(string_to_array(actors, ',')) unique_actors, *
		from Netflix 
)
Select 
	unique_actors, count(*) 
	from CTE_unique_countries_and_actors
	where country ilike '%India%'
	group by 1
	order by 2 desc 
	limit 10;


	