CREATE DATABASE summer_olympics;

#1.Table Design
CREATE TABLE countries (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE athletes (
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    age INT NOT NULL,
    country_id INT NOT NULL,
    
    CONSTRAINT fk_athletes_countries
        FOREIGN KEY (country_id)
            REFERENCES countries(id)
);

CREATE TABLE sports (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE disciplines (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE,
    sport_id INT NOT NULL,
    
    CONSTRAINT fk_disciplines_sports
		FOREIGN KEY (sport_id)
			REFERENCES sports(id)
);

CREATE TABLE medals (
	id INT PRIMARY KEY AUTO_INCREMENT,
    type VARCHAR(10) NOT NULL UNIQUE
);

CREATE TABLE disciplines_athletes_medals (
	discipline_id INT NOT NULL,
    athlete_id INT NOT NULL,
    medal_id INT NOT NULL,
    
    CONSTRAINT pk_disciplines_athletes_medals
		PRIMARY KEY (discipline_id, athlete_id, medal_id),
        
    #CONSTRAINT pk_disciplines_athletes PRIMARY KEY (discipline_id, athlete_id, medal_id),
    
     CONSTRAINT fk_disciplines_athletes_medals_disciplines
		FOREIGN KEY (discipline_id)
			REFERENCES disciplines(id),
            
	CONSTRAINT fk_disciplines_athletes_medals_athletes
		FOREIGN KEY (athlete_id)
			REFERENCES athletes(id),
            
	CONSTRAINT fk_disciplines_athletes_medals_medals
		FOREIGN KEY (medal_id)
			REFERENCES medals(id),
	
    UNIQUE KEY unique_discipline_medal (discipline_id, athlete_id)
);

# 2. Insert
INSERT INTO athletes(first_name, last_name, age, country_id)
SELECT
		UPPER(a.first_name),
        CONCAT(a.last_name, ' comes from', ' ', c.name) AS 'last_name',
        SUM(a.age + a.country_id) AS 'age',
        a.country_id
FROM athletes a
JOIN countries c ON a.country_id = c.id
WHERE c.name LIKE "A%"
GROUP BY a.id;

# 3. Update
select * from disciplines;

UPDATE your_table
SET your_field = REPLACE(your_field, 'articles/updates/', 'articles/news/')
WHERE your_field LIKE '%articles/updates/%';

UPDATE disciplines
SET name = REPLACE(name, 'weight', '')
WHERE name LIKE ('%weight%');

#4. Delete
DELETE FROM athletes
WHERE age > 35;

#5.Countries without athletes
select id, first_name, last_name from athletes 
where id not in (select athlete_id from disciplines_athletes_medals)
order by id asc;

select * from medals;
select * from countries where id = 190;
select * from athletes where country_id = 190;

SELECT c.id,
		c.name 
FROM countries c 
left outer JOIN athletes a ON c.id = a.country_id
where a.country_id is null
ORDER BY c.id DESC
LIMIT 15;

#6.Youngest medalists
SELECT
		CONCAT_WS(' ', first_name, last_name) AS 'full_name',
		a.age
FROM athletes a
	LEFT JOIN disciplines_athletes_medals dam ON a.id = dam.athlete_id
ORDER BY a.age, a.id
LIMIT 2;

#7.Athletes without medals
select id, first_name, last_name from athletes 
where id not in (select athlete_id from disciplines_athletes_medals)
order by id asc;

#8.Athletes with medals divided by sports
SELECT
		a.id,
        a.first_name,
        a.last_name,
        COUNT(dam.medal_id) AS 'medals_count',
        sp.name AS 'sport'
FROM athletes a
	JOIN disciplines_athletes_medals dam ON a.id = dam.athlete_id
    JOIN disciplines d ON dam.discipline_id = d.id
    JOIN medals m ON dam.medal_id = m.id
    JOIN sports sp ON d.sport_id = sp.id
GROUP BY a.id, sp.name
ORDER BY medals_count DESC, a.first_name
LIMIT 10;

#9. Age groups of the athletes
SELECT
		CONCAT_WS(' ', first_name, last_name) AS 'full_name',
	CASE
		WHEN a.age <= 18 THEN 'Teenager'
		WHEN a.age <= 25 THEN 'Young adult'
		WHEN a.age >= 26 THEN 'Adult'
	END AS 'age_group'
FROM athletes a
ORDER BY age DESC, full_name;

#10.Find the total count of medals by country
DELIMITER $$
CREATE FUNCTION udf_total_medals_count_by_country (name VARCHAR(40)) 
RETURNS INT
DETERMINISTIC 
BEGIN
	DECLARE total_number_of_medals INT;
    SET total_number_of_medals:= (
		SELECT COUNT(g.name) AS 'history_movies'
        FROM actors a
			JOIN movies_actors ma ON a.id = ma.actor_id
            JOIN genres_movies gm USING (movie_id)
            JOIN genres g ON g.id = gm.genre_id
		WHERE g.name = 'History' AND full_name = CONCAT(a.first_name, ' ', a.last_name)
        GROUP BY g.name
    );
RETURN total_number_of_medals;
END $$



DELIMITER $$
CREATE FUNCTION udf_total_medals_count_by_country (name VARCHAR(40)) 
RETURNS INT
DETERMINISTIC 
BEGIN
	DECLARE total_medals INT;
    
		SELECT COUNT(m.id) AS 'count_of_medals'
		INTO total_medals
        FROM medals m
			JOIN disciplines_athletes_medals dam ON m.id = dam.medal_id
            JOIN athletes a ON dam.athlete_id = a.id
			JOIN countries c ON a.country_id = c.id
		WHERE c.name = name;
RETURN total_medals;
END $$
DELIMITER ;

#11.Update athlete's information
DELIMITER $$
CREATE PROCEDURE udp_first_name_to_upper_case (letter CHAR(1))
BEGIN
	UPDATE athletes
	SET first_name = UPPER(first_name)
    WHERE LOWER(RIGHT(first_name, 1)) = letter;
END$$
DELIMITER ;

























