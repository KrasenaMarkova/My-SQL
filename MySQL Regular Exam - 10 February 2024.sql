CREATE DATABASE reserves_db;

#1. Table Design
CREATE TABLE positions (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE,
    description TEXT,
    is_dangerous TINYINT(1) NOT NULL
);

CREATE TABLE continents (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE countries (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE,
    country_code VARCHAR(10) NOT NULL UNIQUE,
    continent_id INT NOT NULL,
    
    CONSTRAINT fk_countries_continents
		FOREIGN KEY (continent_id)
			REFERENCES continents(id)
);

CREATE TABLE preserves (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE,
    latitude DECIMAL(9, 6),
    longitude DECIMAL(9, 6),
    area INT,
    type VARCHAR(20),
    established_on DATE
);

CREATE TABLE countries_preserves (
	country_id INT,
    preserve_id INT,
    
       CONSTRAINT fk_countries_preserves_countries
		FOREIGN KEY (country_id)
			REFERENCES countries(id),
            
	   CONSTRAINT fk_countries_preserves_preserves
		FOREIGN KEY (preserve_id)
			REFERENCES preserves(id)
);

CREATE TABLE workers (
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    age INT,
    personal_number VARCHAR(20) NOT NULL UNIQUE,
    salary DECIMAL(19, 2),
    is_armed TINYINT(1) NOT NULL,
    start_date DATE,
    preserve_id INT,
    position_id INT NOT NULL,
    
    CONSTRAINT fk_workers_preserves
		FOREIGN KEY (preserve_id)
			REFERENCES preserves(id),
            
	   CONSTRAINT fk_workers_positions
		FOREIGN KEY (position_id)
			REFERENCES positions(id)
);

#2. Insert
INSERT INTO preserves (name, latitude, longitude, area, type, established_on)
SELECT CONCAT(name, ' ', 'is in South Hemisphere') AS 'name',
		latitude,
        longitude,
        area * id,
        LOWER(type),
		established_on
FROM preserves
WHERE latitude < 0;

#3. Update
UPDATE workers
SET salary = salary + 500
WHERE position_id IN (5, 8, 11, 13);

#4.Delete
DELETE FROM preserves
WHERE established_on IS NULL;

#5.Most experienced workers
SELECT CONCAT(first_name, ' ', last_name) AS 'full_name',
		DATEDIFF('2024-01-01', start_date) AS 'days_of_experience'
FROM workers
WHERE DATEDIFF('2024-01-01', start_date) >= 5 * 365
ORDER BY days_of_experience DESC
LIMIT 10;

# 6. Workers salary
SELECT w.id,
		w.first_name,
        w.last_name,
        p.name AS 'preserve_name',
        c.country_code
FROM workers w
	JOIN preserves p ON w.preserve_id = p.id
    JOIN countries_preserves cp ON w.preserve_id = cp.preserve_id
    JOIN countries c ON cp.country_id = c.id
WHERE w.salary > 5000 AND w.age < 50
ORDER BY c.country_code;

# 7.Armed workers count
SELECT p.name,
		COUNT(w.is_armed) AS 'armed_workers'
FROM preserves p
	JOIN workers w ON p.id = w.preserve_id
WHERE w.is_armed IS TRUE
GROUP BY p.name
ORDER BY `armed_workers` DESC, p.name;

#8. Oldest preserves
SELECT p.name,
		c.country_code,
        YEAR(p.established_on) AS 'founded_in'
FROM preserves p
	JOIN countries_preserves cp ON p.id = cp.preserve_id
    JOIN countries c ON cp.country_id = c.id
WHERE MONTH(p.established_on) = 5
ORDER BY p.established_on
LIMIT 5;

#9. Preserve categories
SELECT p.id,
		p.name,
        CASE
			WHEN p.area <= 100 THEN 'very small'
			WHEN p.area <= 1000 THEN 'small'
			WHEN p.area <= 10000 THEN 'medium'
            WHEN p.area <= 50000 THEN 'large'
			WHEN p.area > 50000 THEN 'very large'
		END AS 'category'
FROM preserves p
ORDER BY p.area DESC;

#10.Extract average salary
DELIMITER $$
CREATE FUNCTION udf_average_salary_by_position_name (name VARCHAR(40)) 
	RETURNS DECIMAL(19, 2)
    DETERMINISTIC
BEGIN
    DECLARE average_amount_of_salary_for_this_position DECIMAL(19, 4);

    SELECT
        AVG(w.salary) INTO average_amount_of_salary_for_this_position
    FROM workers w
			JOIN positions p ON w.position_id = p.id
    WHERE p.name = name;
    RETURN average_amount_of_salary_for_this_position;
END$$
DELIMITER ;

#11.Improving the standard of living
DELIMITER $$
CREATE PROCEDURE udp_increase_salaries_by_country(country_name VARCHAR(40))
BEGIN
    UPDATE workers AS w
        JOIN countries_preserves AS cp ON w.preserve_id = cp.preserve_id
        JOIN countries AS c ON c.id = cp.country_id
    SET w.salary = w.salary * 1.05
    WHERE c.name = `country_name`;
END$$
DELIMITER ;





DELIMITER $$
CREATE PROCEDURE udp_increase_salaries_by_country (country_name VARCHAR(40)
#BEGIN

	UPDATE workers w
		JOIN countries_preserves cp ON a.id = ma.actor_id
        JOIN countries c ON 
	SET 
    WHERE c.name = country_name;
END$$
DELIMITER ;





BEGIN
	UPDATE workers w
		JOIN countries_preserves cp ON a.id = ma.actor_id
        JOIN countries c ON 
	SET 
    WHERE c.name = country_name;
END$$
DELIMITER ;

















