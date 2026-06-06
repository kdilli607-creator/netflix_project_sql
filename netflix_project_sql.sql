create table netflix(
show_id	 varchar (10),
type	varchar(20),
title	varchar(220),
director	varchar(300),
casts	varchar( 1000),
country	varchar(200),
date_added	varchar(150),
release_year	int,
rating	varchar(20),
duration	varchar(20),
listed_in	varchar(200),
description varchar(300)
);

-- 1) count the number of movies and tv shows 

select 
type,
count(*)
from netflix
group by type2

-- 2)find the most common rating for movies and tv shows

select type, rating
from (select type, rating,count(*), 
rank() 
over(partition by type order by count(*)desc)as ranking
from netflix
group by 1,2)as table_1
where ranking = 1

-- 3)list all the movies relased in a specific year (ex:2020)

select*from netflix
where type = 'Movie' and release_year = 2020

-- 4)find the top 5 countries with most content on netflix

select
-- unnest:- it separates the multiple values into single values
 unnest(string_to_array(country, ',')), 
count(show_id)
from netflix
group by 1
order by 2 desc 
limit 5

-- 5)identify the longest movie 

select *from netflix
where type = 'Movie'
and
duration = (select max(duration)from netflix) 

-- 6)find the content added last in 5 years

select*from netflix
where to_date(date_added,'month DD ,YYYY')>= current_date - interval '5 years'

-- 7)find all the movies/tv shows dircted by dirctor 'rajiv chilika'

select*from netflix
where director ILIKE '%Rajiv Chilaka%'

-- 8) list all tv shows more than 5 seasons

select
*
from netflix
where type = 'TV Show' and SPLIT_PART (duration,' ', 1):: numeric >5


-- (:: numeric) IT CONVERTS TECT TO INTEGER
-- SPLIT_PART FUNCTION
-- select
-- split_part('apple banana cherry dog', ' ',4) 
-- SPLIT_PART(COLMUN NAME, DELIMITERS SPACE , 1) HERE ONE 1 INDICATED 1ST POSITION 

-- 9)COUNT THE NUMBER OF CONTENT ITEMS IN EACH GENRE

SELECT 
-- STRING_TO_ARRAY FUNCTION CONVERT MULTIPLE VALUES INTO SINGLE SEPARATE VALUES
UNNEST(STRING_TO_ARRAY(LISTED_IN , ',')),
COUNT(SHOW_ID)
FROM NETFLIX
GROUP BY 1
ORDER BY 2 DESC

-- 10)FIND EACH YEAR AND THE AVG NO. OF CONTENT RELEASE BY INDIA ON NETFLIX .
-- RETUIRN TOP 5 YEAR WITH HIGHEST AVG CONTENT RELEASE

SELECT 
extract(year from to_date(date_added,'month DD,YYYY')) as year,
count(*),
round(
COUNT(*)::numeric /(SELECT COUNT(*)FROM NETFLIX WHERE COUNTRY = 'India')::numeric*100 ,2)as total_content
FROM NETFLIX
WHERE COUNTRY = 'India'
group by 1

-- 11)list all the movies that are documentaries

select*from netflix
where listed_in ILIKE '%DOCUMENTARIES%'

-- 12)FIND THE ALL CONTENT WITHOUT DIRECTOR

select*from netflix
where director is null

-- 13)find tha how many movies actor 'salman khan ' appeared in last 10 years

select*
from netflix

where casts ILIKE '%salman khan%' AND release_year > extract(year from current_date)-10

-- 14)find the top 10 actors who have appeared in the highest number of movies produced in india

select
unnest(string_to_array(casts,',')),
count(*) as total
from netflix
where country ilike '%india%'
group by 1
order by 2 desc
limit 10

-- 15)categorize the content based on the presence of the key words'kill' and 'violence' in the description
-- label content containing these keywords as 'bad' and all the other content as 'good' 
-- count how many items fall into each category


with new_table as(
select *, CASE
	when description ILIKE '%KILL%' 
					OR
	description ILIKE '%VIOLENCE%'

THEN 'ADULT CONTENT'
ELSE 'FAMILY CONTENT'
END CATEGORY
FROM netflix
)
select category,
count(*)as total
from new_table 
group by 1





