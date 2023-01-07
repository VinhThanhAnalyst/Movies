--View dataset

SELECT * 
FROM netflix

--The show_id column is the unique id for the dataset, therefore we are going to check for duplicates

SELECT show_id, COUNT(*)                                                                                                                                                                            
FROM netflix 
GROUP BY show_id                                                                                                                                                                                            
ORDER BY show_id DESC;

--No duplicates

--Populate director data
SELECT *
FROM netflix
WHERE director is NULL
ORDER BY cast 

-- Find out if some directors are likely to work with particular cast
WITH cte AS
(
SELECT title, CONCAT(director, '---', cast) AS director_cast 
FROM netflix
)

SELECT director_cast, COUNT(*) AS count
FROM cte
GROUP BY director_cast
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;

--populate NULL rows in directors using their record with cast 

UPDATE netflix 
SET director = 'Alastair Fothergill'
WHERE cast = 'David Attenborough'
AND director IS NULL;

UPDATE netflix 
SET director = 'Rajiv Chilaka'
WHERE cast = 'Vatsal Dubey, Julie Tejwani, Rupa Bhimani, Jigna Bhardwaj, Rajesh Kava, Mousam, Swapnil'
AND director IS NULL;

--Repeat this step to populate the rest of the director nulls
--Populate the rest of the NULL in director as "Not Given"

UPDATE netflix 
SET director = 'Not Given'
WHERE director IS NULL;

--Populate the country using the director column

SELECT a.country, a.director, b.country, b.director, ISNULL(a.country, b.country)
FROM netflix  AS a
JOIN netflix AS b 
ON a.director = b.director 
AND a.show_id <> b.show_id
WHERE a.country IS NULL;

UPDATE a
SET country = ISNULL(a.country, b.country)
FROM netflix  AS a
JOIN netflix AS b 
ON a.director = b.director 
AND a.show_id <> b.show_id
WHERE a.country IS NULL;

--To confirm if there are still directors linked to country that refuse to update

SELECT director, country, date_added
FROM netflix
WHERE country IS NULL;

--Populate the rest of the NULL in director as "Not Given"

UPDATE netflix 
SET country = 'Not Given'
WHERE country IS NULL;

--Show date_added nulls

SELECT show_id, date_added
FROM netflix
WHERE date_added IS NULL;

--DELETE nulls

DELETE FROM netflix
WHERE date_added is NULL

--Show rating NULLS

SELECT show_id, rating
FROM netflix
WHERE rating IS NULL;

--Delete the nulls
DELETE FROM netflix 
WHERE show_id 
IN (SELECT show_id FROM netflix WHERE rating IS NULL) 

--Show duration NULLS
SELECT duration
FROM netflix
WHERE duration IS NULL;

--Delete the Nulls
DELETE FROM netflix 
WHERE show_id 
IN (SELECT show_id FROM netflix WHERE duration IS NULL);


--DROP unneeded columns

ALTER TABLE netflix
DROP COLUMN cast;

ALTER TABLE netflix
DROP COLUMN description;

SELECT country, country1
FROM netflix;

--Breaking out country and retain the first one from the right
SELECT country,
PARSENAME(REPLACE(country, ',', '.'), 1)
FROM netflix

ALTER TABLE netflix
ADD country1 NVARCHAR(255);

UPDATE netflix 
SET country1 = PARSENAME(REPLACE(country, ',', '.'), 1)

--Delete column
ALTER TABLE netflix 
DROP COLUMN country;

