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


