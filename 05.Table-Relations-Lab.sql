# 1. Mountains and Peaks
CREATE TABLE mountains (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL
);

CREATE TABLE peaks (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
	mountain_id INT,
    
    CONSTRAINT fk_peaks_mountains
		FOREIGN KEY (mountain_id)
			REFERENCES mountains(id)
);

#2.Trip Organization
SELECT 
	driver_id,
    vehicle_type,
    CONCAT(first_name, ' ', last_name) AS 'driver_name'
FROM camp.vehicles
JOIN campers ON driver_id = campers.id;

# 3.SoftUni Hiking
SELECT
	starting_point AS 'route_starting_point',
    end_point AS 'route_ending_point',
    leader_id,
    CONCAT(first_name, ' ', last_name) AS 'leader_name'
FROM routes
JOIN campers ON campers.id = leader_id;

# 4. Delete Mountains
CREATE TABLE mountains (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL
);

CREATE TABLE peaks (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
	mountain_id INT,
    
    CONSTRAINT fk_peaks_mountains
		FOREIGN KEY (mountain_id)
			REFERENCES mountains(id)
            ON DELETE CASCADE
);
    

    



