# https://judge.softuni.org/Contests/Practice/Index/3315#2

CREATE DATABASE softuni_imdb;

#1. Table Design
CREATE TABLE countries (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL UNIQUE,
    continent VARCHAR(30) NOT NULL,
    currency VARCHAR(5) NOT NULL
);

CREATE TABLE genres (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE actors (
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birthdate DATE NOT NULL,
    height INT,
    awards INT,
    country_id INT NOT NULL,
    
    CONSTRAINT fk_actors_countries
        FOREIGN KEY (country_id)
            REFERENCES countries(id)
);

CREATE TABLE movies_additional_info (
	id INT PRIMARY KEY AUTO_INCREMENT,
    rating DECIMAL(10, 2) NOT NULL,
    runtime INT NOT NULL,
    picture_url VARCHAR(80) NOT NULL,
    budget DECIMAL(10, 2),
    release_date DATE NOT NULL,
    has_subtitles TINYINT(1),
    description TEXT
);

CREATE TABLE movies (
	id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(70) NOT NULL UNIQUE,
    country_id INT NOT NULL,
    movie_info_id INT NOT NULL UNIQUE,
    
    CONSTRAINT fk_movies_countries
		FOREIGN KEY (country_id)
        REFERENCES countries(id),
        
	CONSTRAINT fk_movie_info_id_movies_additional_info
		FOREIGN KEY (movie_info_id)
        REFERENCES movies_additional_info(id)
);

CREATE TABLE movies_actors (
	movie_id INT,
    actor_id INT,
    KEY pk_movies_actors (movie_id, actor_id),
    
    CONSTRAINT fk_movies_actors_movies
		FOREIGN KEY (movie_id)
        REFERENCES movies(id),
        
	CONSTRAINT fk_movies_actors_actors
		FOREIGN KEY (actor_id)
        REFERENCES actors(id)
);

CREATE TABLE genres_movies (
	genre_id INT,
    movie_id INT,
    KEY pk_genres_movies (genre_id, movie_id),
    
     CONSTRAINT fk_genres_movies_genres
		FOREIGN KEY (genre_id)
        REFERENCES genres(id),
        
	CONSTRAINT fk_genres_movies_movies
		FOREIGN KEY (movie_id)
        REFERENCES movies(id)
);

# 2. Insert
INSERT INTO actors(first_name, last_name, birthdate, height, awards, country_id)
SELECT
	REVERSE(a.first_name),
	REVERSE(a.last_name),
    DATE(birthdate - 2), #DATE_ADD(a.birthdate, INTERVAL - 2 DAY)
    a.height + 10,
    a.country_id,
    3
FROM actors a
WHERE a.id <= 10;

# 3.Update
UPDATE movies_additional_info
SET runtime = runtime - 10
WHERE id BETWEEN 15 AND 25;

# 4. Delete
DELETE c FROM countries c
LEFT JOIN movies m
		ON m.country_id = c.id
WHERE m.country_id IS NULL;

DELETE FROM countries
WHERE id NOT IN (SELECT country_id FROM movies);

# 5. Countries
# SELECT * FROM countries ORDER BY currency DESC, id;
SELECT id,
		name,
        continent,
        currency
FROM countries
ORDER BY currency DESC, id;

# 6. Old movies
SELECT m.id,
		m.title,
        mai.runtime,
        mai.budget,
        mai.release_date
FROM movies m
	JOIN movies_additional_info mai
		ON m.movie_info_id = mai.id
WHERE YEAR (mai.release_date) BETWEEN 1996 AND 1999
ORDER BY mai.runtime, m.id
LIMIT 20;

# 7. Movie casting
SELECT CONCAT_WS(' ', a.first_name, a.last_name) AS 'full_name',
		CONCAT(REVERSE(a.last_name), LENGTH(a.last_name),'@cast.com') AS 'email',
        2022 - YEAR(birthdate)AS 'age',
        a.height
FROM actors a
WHERE id NOT IN (SELECT actor_id FROM  movies_actors)
# LEFT JOIN movies_actors AS ma ON a.id = ma.actor_id
# WHERE ma.actor_id IS NULL
ORDER BY a.height

#8.International festival
SELECT;

SELECT c.name,
    COUNT(*) `movies_count`
FROM countries AS c
    JOIN movies AS m ON c.id = m.country_id
GROUP BY c.name
HAVING movies_count >= 7
ORDER BY c.name DESC;

# 9. Rating system
SELECT m.title,
	CASE
		WHEN ma.rating <= 4 THEN 'poor'
		WHEN ma.rating <= 7 THEN 'good'
		WHEN ma.rating > 7 THEN 'excellent'
	END AS 'rating',
    CASE
		WHEN ma.has_subtitles = 1 THEN 'english'
		WHEN ma.has_subtitles = 0 THEN '-'
	END AS 'subtitles',
    ma.budget
FROM movies m
	JOIN movies_additional_info ma
    ON m.movie_info_id = ma.id
ORDER BY ma.budget DESC;

# 10. History movies
DELIMITER $$
CREATE FUNCTION udf_actor_history_movies_count(full_name VARCHAR(50)) 
RETURNS INT
DETERMINISTIC 
BEGIN
	DECLARE history_movies_count INT; # броят на филмите, в които актьора участва
    SET history_movies_count:= (
		SELECT COUNT(g.name) AS 'history_movies'
        FROM actors a
			JOIN movies_actors ma ON a.id = ma.actor_id
            JOIN genres_movies gm USING (movie_id)
            JOIN genres g ON g.id = gm.genre_id
		WHERE g.name = 'History' AND full_name = CONCAT(a.first_name, ' ', a.last_name)
        GROUP BY g.name
    );
RETURN history_movies_count;
END $$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION udf_actor_history_movies_count(full_name VARCHAR(50))
    RETURNS INT
    DETERMINISTIC
BEGIN
    DECLARE total_number_of_movies_actor_has_role INT;

    SELECT
        COUNT(*) INTO total_number_of_movies_actor_has_role
    FROM actors AS a
             LEFT JOIN movies_actors AS ma ON a.id = ma.actor_id
             LEFT JOIN genres_movies AS gm ON ma.movie_id = gm.movie_id
    WHERE CONCAT_WS(' ', a.first_name, a.last_name) = `full_name` AND gm.genre_id = 12
    GROUP BY a.first_name, a.last_name;

    RETURN total_number_of_movies_actor_has_role;
END$$
DELIMITER ;

#11. Movie awards
DELIMITER $$
CREATE PROCEDURE udp_award_movie (movie_title VARCHAR(50))
BEGIN
	UPDATE actors a
		JOIN movies_actors ma ON a.id = ma.actor_id
        JOIN movies m ON ma.movie_id = m.id
	SET a.awards = a.awards + 1
    WHERE m.title = movie_title;
END$$
DELIMITER ;





