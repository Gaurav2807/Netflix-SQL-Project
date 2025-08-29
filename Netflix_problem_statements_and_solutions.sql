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
Select * from Netflix;

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


