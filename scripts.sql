-- Creating the DB and Using it
CREATE DATABASE practice;
USE practice;
-- Creating the table to work on
CREATE TABLE steam_games(
appid INT PRIMARY KEY,
name VARCHAR(255),
release_date VARCHAR(255),
estimated_owners VARCHAR(100),
peak_ccu INT,
price DOUBLE,
developers VARCHAR(255),
publishers VARCHAR(255),
categories TEXT,
genres TEXT,
tags TEXT,
positive INT,
negative INT,
avg_playtime_ever INT
);


-- failed attempt to import data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/games.csv'
INTO TABLE steam_games
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(appid, name, release_date, estimated_owners, peak_ccu, 
@dummy, price, @dummy, @dummy, @dummy, @dummy, @dummy, 
@dummy, @dummy, @dummy, @dummy, @dummy, @dummy, 
@dummy, @dummy, @dummy, @dummy, positive, negative,
@dummy, @dummy, @dummy, @dummy, 
avg_playtime_ever, @dummy, @dummy, @dummy,
developers, publishers, categories, genres, tags, @dummy, @dummy);

ALTER TABLE steam_games
MODIFY COLUMN developers TEXT,
MODIFY COLUMN publishers TEXT,
MODIFY COLUMN name TEXT;

TRUNCATE TABLE steam_games;
USE practice;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/games.csv'
INTO TABLE steam_games
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(appid, name, release_date, estimated_owners, peak_ccu, @dummy, price, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, -- We now have 16 dummies here instead of 15
@dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy,
@raw_positive, @raw_negative,
@dummy, @dummy, @dummy, @dummy,
@raw_playtime, @dummy, @dummy, @dummy,
developers, publishers, categories, genres, tags, @dummy, @dummy,
@dummy, @dummy, @dummy, @dummy, @dummy) -- The Overflow Bucket
SET avg_playtime_ever = IF(@raw_playtime = '', 0, @raw_playtime),
	positive = IF(@raw_positive = '', 0, @raw_positive),
	negative = IF(@raw_negative = '', 0, @raw_negative);

-- Q1: The Premium Market | Top 10 most expensive games with active reviews (excluding 0-review spam)

SELECT name,price,positive,negative
FROM steam_games
WHERE positive + negative > 0
ORDER BY price DESC LIMIT 10;

-- Q2A: The Hitmakers | Identifying developers with the highest volume of published games

SELECT developers, COUNT(name) AS game_count
FROM steam_games
WHERE developers != ''
GROUP BY developers
ORDER BY game_count DESC LIMIT 5;

-- Q2B: Studio Spotlight | Counting the total number of games developed by 'Rockstar Games'
SELECT developers, COUNT(name) AS game_count
FROM steam_games
WHERE developers = 'Rockstar Games';

-- Q3: Franchise Search | Identifying the highest-rated games containing 'One Piece' in the title

SELECT name,release_date,positive, negative
FROM steam_games
WHERE name LIKE 'one piece%'
ORDER BY positive DESC;

-- Q4: Hidden Gems | Locating premium titles for the 'Re:Zero' franchise using English subtitles

USE practice;
SELECT name,price,developers
FROM steam_games
WHERE name LIKE '%Starting Life in Another World%'
ORDER BY price DESC;

-- Q5: Tag Analysis | Quantifying the total volume of games containing the 'Nudity' tag

USE practice;
SELECT COUNT(tags) As count_of_adult_games
FROM steam_games
WHERE tags LIKE '%Nudity%';

-- Q6: Market Leaders | Top 10 developers with the highest volume of 'Nudity' tagged games

USE practice;
SELECT COUNT(tags) As count_of_adult_games, developers
FROM steam_games
WHERE tags LIKE '%Nudity%'
GROUP BY developers
ORDER BY count_of_adult_games DESC LIMIT 10;

-- Q7A: The Masterpiece Metric | Calculating raw approval rating percentages for games with >50k reviews

USE practice;
SELECT name, (positive / (positive + negative))*100 AS approval_percentage
FROM steam_games
WHERE positive+negative>50000
ORDER BY approval_percentage DESC LIMIT 10;

-- Q7B: Metric Refinement | Rounding approval ratings to 2 decimal places and adding total review context

USE practice;
SELECT name,positive + negative AS total_reviews,
ROUND((positive / (positive + negative))*100, 2) AS approval_percentage
FROM steam_games
WHERE positive+negative>50000
ORDER BY approval_percentage DESC LIMIT 10;

-- Q8: The Storefront Algorithm | Translating raw approval percentages into categorical text badges

USE practice;
SELECT name,
ROUND((positive / (positive + negative))*100, 2) AS approval_percentage,
positive + negative AS total_reviews,
CASE
	WHEN (positive / (positive + negative))*100 >= 95 THEN 'Overwhelming Positive'
	WHEN (positive / (positive + negative))*100 BETWEEN 80 AND 94.99 THEN 'Very Positive'
	ELSE 'Mixed'
END AS reviews
FROM steam_games
WHERE positive+negative >400000
ORDER BY approval_percentage DESC LIMIT 10;

-- Q9: A) Data Quality Check | Identifying duplicate game records in the database -- by name

SELECT name,COUNT(name) AS duplications
FROM steam_games
GROUP BY name
HAVING duplications > 1
ORDER BY duplications DESC;

-- Q9: B) Data Quality Check | Identifying duplicate game records in the database -- by appid

SELECT appid,COUNT(appid) AS duplications
FROM steam_games
GROUP BY appid
HAVING duplications > 1
ORDER BY duplications DESC;

-- Q10: Hidden Gems | Identifying highly-rated masterpieces with small player bases (500 - 1,000 reviews)

USE practice;
SELECT name,
ROUND((positive / (positive + negative))*100, 2) AS approval_percentage
FROM steam_games
WHERE positive+negative BETWEEN 499 AND 1000
ORDER BY approval_percentage DESC LIMIT 10;
