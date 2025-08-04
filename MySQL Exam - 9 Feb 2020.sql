# https://judge.softuni.org/Contests/Practice/Index/2027#0
CREATE DATABASE softuni_football;

#1.Table Design
CREATE TABLE skills_data (
	id INT PRIMARY KEY AUTO_INCREMENT,
    dribbling INT DEFAULT 0,
    pace INT DEFAULT 0,
    passing INT DEFAULT 0,
    shooting INT DEFAULT 0,
    speed INT DEFAULT 0,
    strength INT DEFAULT 0
);

CREATE TABLE countries (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL
);

CREATE TABLE towns (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    country_id INT NOT NULL,
    
    CONSTRAINT fk_towns_countries
		FOREIGN KEY (country_id)
			REFERENCES countries(id)
);

CREATE TABLE stadiums (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    capacity INT NOT NULL,
    town_id  INT NOT NULL,
    
    CONSTRAINT fk_stadiums_towns
		FOREIGN KEY (town_id)
			REFERENCES towns(id)
);

CREATE TABLE coaches (
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(10) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL DEFAULT 0,
    coach_level INT NOT NULL DEFAULT 0
);

CREATE TABLE players(
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(10) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    age INT NOT NULL DEFAULT 0,
    position CHAR(1) NOT NULL,
    salary DECIMAL(10,2) NOT NULL DEFAULT 0,
    hire_date DATETIME,
    skills_data_id INT NOT NULL,
    team_id INT,

    CONSTRAINT fk_players_skills_data
        FOREIGN KEY (skills_data_id)
            REFERENCES skills_data(id),

    CONSTRAINT fk_players_teams
        FOREIGN KEY (team_id)
            REFERENCES teams(id)
);

CREATE TABLE players_coaches (
	player_id INT,
    coach_id INT,
    
    CONSTRAINT fk_players_coaches_players
		FOREIGN KEY (player_id)
			REFERENCES players(id),
    
    CONSTRAINT fk_players_coaches_coaches
		FOREIGN KEY (coach_id)
			REFERENCES coaches(id)
);

CREATE TABLE teams (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    established DATE NOT NULL,
    fan_base BIGINT(20) NOT NULL DEFAULT 0,
    stadium_id INT NOT NULL,
    
    CONSTRAINT fk_teams_stadiums
		FOREIGN KEY (stadium_id)
			REFERENCES stadiums(id)
);

#2. Insert
INSERT INTO coaches (first_name, last_name, salary, coach_level)
SELECT
	p.first_name,
    p.last_name,
    p.salary * 2,
    CHAR_LENGTH(p.first_name) AS 'coach_level'
FROM players p
WHERE p.age >= 45;

#3. Update
UPDATE coaches c
SET c.coach_level = c.coach_level + 1
WHERE c.id IN (
	SELECT coach_id
    FROM players_coaches)
    AND first_name LIKE 'A%';

UPDATE coaches AS c
SET c.coach_level = c.coach_level + 1
WHERE c.first_name LIKE 'A%'
  AND EXISTS (
    SELECT 1
    FROM players_coaches AS pc
    WHERE pc.coach_id = c.id
);

#4.Delete
DELETE FROM players
WHERE age >= 45;

#5.Players
SELECT first_name,
		age,
        salary
FROM players
ORDER BY salary DESC;

#6. Young offense players without contract
SELECT p.id,
		CONCAT_WS(' ', p.first_name, p.last_name) AS 'full_name',
        p.age,
        p.position,
        p.hire_date
FROM players p
	JOIN skills_data s ON p.skills_data_id = s.id
WHERE p.age < 23 AND p.hire_date IS NULL AND p.position = 'A' AND s.strength > 50
ORDER BY p.salary, p.age;

#7.Detail info for all teams
SELECT t.name AS 'team_name',
		t.established,
        t.fan_base,
        COUNT(p.id) AS 'players_count'
FROM teams t
	LEFT JOIN players p ON p.team_id = t.id
GROUP BY t.id
ORDER BY players_count DESC, t.fan_base DESC;

#8.The fastest player by towns
SELECT
    MAX(sd.speed) AS `max_speed`,
    twn.name AS `town_name`
FROM towns AS twn
    LEFT JOIN stadiums AS s on twn.id = s.town_id
    LEFT JOIN teams AS t on s.id = t.stadium_id
    LEFT JOIN players p on t.id = p.team_id
    LEFT JOIN skills_data sd on sd.id = p.skills_data_id
WHERE t.name != 'Devify'
GROUP BY twn.name
ORDER BY max_speed DESC, twn.name;
    
# 9.Total salaries and players by country
SELECT c.name,
		COUNT(p.id) AS 'total_count_of_players',
        SUM(p.salary) AS 'total_sum_of_salaries'
FROM countries c
    LEFT JOIN towns t ON c.id = t.country_id
    LEFT JOIN stadiums st ON t.id = st.town_id
    LEFT JOIN teams tm ON st.id = tm.stadium_id
    LEFT JOIN players p ON tm.id = p.team_id
GROUP BY c.name
ORDER BY total_count_of_players DESC, c.name;
    
#10. Find all players that play on stadium
DELIMITER $$
CREATE FUNCTION udf_stadium_players_count (stadium_name VARCHAR(30))
RETURNS INT
DETERMINISTIC 
BEGIN
	DECLARE number_of_playerst_that_play_home_matches INT;
		SELECT COUNT(p.id) INTO number_of_playerst_that_play_home_matches
		FROM stadiums AS s
             LEFT JOIN teams AS t ON s.id = t.stadium_id
             LEFT JOIN players AS p ON t.id = p.team_id
		WHERE s.name = `stadium_name`;
    
RETURN number_of_playerst_that_play_home_matches;
END $$
DELIMITER ;

#11.Find good playmaker by teams
DELIMITER $$
CREATE PROCEDURE udp_find_playmaker (min_dribble_points INT, team_name VARCHAR(45))
BEGIN
DECLARE avg_speed FLOAT;

    SELECT AVG(speed)
    INTO avg_speed
    FROM skills_data;

    SELECT
        CONCAT_WS(' ', p.first_name, p.last_name) AS `full_name`,
        p.age,
        p.salary,
        sd.dribbling,
        sd.speed,
        t.name
    FROM players AS p
             JOIN skills_data AS sd ON sd.id = p.skills_data_id
             JOIN teams t on t.id = p.team_id
    WHERE sd.dribbling >= min_dribble_points AND t.name = `team_name`
    ORDER BY speed DESC
    LIMIT 1;
END$$
DELIMITER ;








