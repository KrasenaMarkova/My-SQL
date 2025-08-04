CREATE DATABASE minions;

USE minions;

CREATE TABLE minions(
id INT NOT NULL UNIQUE PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100),
age INT
);

CREATE TABLE towns(
town_id INT NOT NULL UNIQUE PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100)
);

ALTER TABLE minions
ADD COLUMN town_id INT,
ADD CONSTRAINT fk_town_id
FOREIGN KEY (town_id) REFERENCES towns(id);

INSERT INTO towns(id, name) VALUES
(1,'Sofia'),
(2,'Plovdiv'),
(3,'Varna');

INSERT INTO minions VALUES
(1,'Kevin',22,1),
(2,'Bob',15,3),
(3,'Steward',NULL,2);

SET SQL_SAFE_UPDATES = 0;

DELETE FROM minions;
TRUNCATE TABLE minions;


DROP TABLE minions;
DROP TABLE towns;


CREATE TABLE people(
	id INT PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	name VARCHAR(200) NOT NULL,clients
	picture TEXT,
	height DOUBLE(10,2),
	weight DOUBLE(10,2),
	gender CHAR(1) NOT NULL,
	birthdate DATE NOT NULL,
	biography TEXT
);

INSERT INTO people VALUES
(1, 'GOSHO', 'TEST', 1.90, 90, 'm', '1990-01-01', '123'),
(2, 'IVAN', 'TEST', 1.90, 90, 'm', '1990-09-01', '123'),
(3, 'STAMAT', 'TEST', 1.90, 90, 'm', '1990-05-01', '123'),
(4, 'VIK', 'TEST', 1.90, 90, 'm', '1990-02-01', '123'),
(5, 'MARIA', 'TEST', 1.90, 90, 'f', '1990-06-01', '123');


CREATE TABLE users(
	id INT NOT NULL UNIQUE PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(30) NOT NULL,
    password VARCHAR(26) NOT NULL,
    profile_picture TEXT,
    last_login_time DATETIME,
    is_deleted BOOLEAN
);

INSERT INTO users(username, password, profile_picture, last_login_time, is_deleted) VALUE
('LILI', '12345', NULL, '2024-09-10 20:11:45', false),
('SASHO', '12345', NULL, '2024-09-10 20:11:45', false),
('PESHO', '12345', NULL, '2024-09-10 20:11:45', false),
('IVAN', '12345', NULL, '2024-09-10 20:11:45', false),
('TOSHO', '12345', NULL, '2024-09-10 20:11:45', false);

SELECT * FROM users;


ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users
PRIMARY KEY (id, username);


ALTER TABLE users
CHANGE COLUMN last_login_time last_login_time DATETIME DEFAULT NOW();

ALTER TABLE users
MODIFY COLUMN last_login_time DATETIME DEFAULT NOW();


ALTER TABLE users
DROP PRIMARY KEY,
ADD PRIMARY KEY (id);

ALTER TABLE users
MODIFY username VARCHAR(30) NOT NULL UNIQUE;


CREATE DATABASE movies;

USE movies;

CREATE TABLE directors(
	id INT NOT NULL UNIQUE PRIMARY KEY AUTO_INCREMENT,
    director_name VARCHAR(100) NOT NULL,
    notes TEXT
);

CREATE TABLE genres(
	id INT NOT NULL UNIQUE PRIMARY KEY AUTO_INCREMENT,
    genre_name VARCHAR(100) NOT NULL,
    notes TEXT
);

CREATE TABLE categories(
	id INT NOT NULL UNIQUE PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    notes TEXT
);

CREATE TABLE movie(
	id INT NOT NULL UNIQUE PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    director_id INT,
    copyright_year DATE,
    length DOUBLE(10,2),
    genre_id INT,
    category_id INT,
    rating DOUBLE(5,2),
    notes TEXT
);

INSERT INTO directors VALUES
(1, 'Pesho', 'Mladost'),
(2, 'Ivan', 'Mladost'),
(3, 'Pesho', 'Mladost'),
(4, 'Pesho', 'Mladost'),
(5, 'Pesho', 'Mladost');

INSERT INTO genres VALUES
(1, 'PESHO', 'MLADOST'),
(2, 'IVAN', 'MLADOST'),
(3, 'PESHO', 'MLADOST'),
(4, 'GOSHO', 'MLADOST'),
(5, 'PESHO', 'MLADOST');

INSERT INTO categories VALUES
(1, 'ABOVE', 'MLADOST'),
(2, 'BELOW', 'MLADOST'),
(3, 'PESHO', 'MLADOST'),
(4, 'GOSHO', 'MLADOST'),
(5, 'PESHO', 'MLADOST');

INSERT INTO movie VALUES
(1, 'HARRY POTTER', 1, '2003-12-12', 2.30, 3, 2, 9.5, 'HARRY'),
(2, 'LISTOPAD', 1, '2003-12-12', 2.30, 3, 2, 9.5, 'HARRY'),
(3, 'KASANDRA', 1, '2003-12-12', 2.30, 3, 2, 9.5, 'HARRY'),
(4, 'HEY', 1, '2003-12-12', 2.30, 3, 2, 9.5, 'HARRY'),
(5, 'GREY', 1, '2003-12-12', 2.30, 3, 2, 9.5, 'HARRY');


CREATE DATABASE car_rental;
USE car_rental;

CREATE TABLE categories(
	id INT PRIMARY KEY AUTO_INCREMENT,
    category VARCHAR(100),
    daily_rate DOUBLE(10, 2),
    weekly_rate DOUBLE(10,2),
    monthly_rate DOUBLE(10,2),
    weekend_rate DOUBLE(10,2)
);

CREATE TABLE cars(
	id INT PRIMARY KEY AUTO_INCREMENT,
    plate_number VARCHAR(10),
    make VARCHAR(50),
    model VARCHAR(50),
    car_year DATE,
    category_id INT,
    doors INT,
    picture BLOB,
    car_condition VARCHAR(50),
    available BOOLEAN
);

CREATE TABLE employees(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(60),
    last_name VARCHAR(60),
    title VARCHAR(100),
    notes TEXT
);

CREATE TABLE customers(
	id INT PRIMARY KEY AUTO_INCREMENT,
    driver_licence_number INT,
    full_name VARCHAR(200),
    address VARCHAR(250),
    city VARCHAR(100),
    zip_code INT,
    notes TEXT
);

CREATE TABLE rental_orders(
	id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    customer_id INT,
    car_id INT,
    car_condition VARCHAR(50),
    tank_level DOUBLE(5,2),
    kilometrage_start INT,
    kilometrage_end INT,
    total_kilometrage INT,
    start_date DATE,
    end_date DATE,
    total_days INT,
    rate_applied DOUBLE(5,2),
    tax_rate DOUBLE(5,2),
    order_status VARCHAR(50),
    notes TEXT
);

INSERT INTO categories(category, daily_rate, weekly_rate, monthly_rate, weekend_rate) VALUES
('SUV', 12.3, 20.5, 30.5, 40.5),
('MOTO', 12.5, 20.5, 30.5, 40.7),
('CAR', 13.4, 20.5, 30.5, 40.6);

INSERT INTO cars(plate_number, make, model, car_year, category_id, doors, picture, car_condition, available) VALUES
('SV1111SV', 'TOYOTA', 'Prius', '2014-12-31', 5, 4, NULL, 'NOT GOOD NOT BAD', TRUE),
('SV1111SV', 'TOYOTA', 'Prius', '2014-12-31', 5, 4, NULL, 'NOT GOOD NOT BAD', TRUE),
('SV1111SV', 'TOYOTA', 'Prius', '2014-12-31', 5, 4, NULL, 'NOT GOOD NOT BAD', TRUE);

INSERT INTO employees (first_name, last_name, title, notes) VALUES
('GOSHO', 'GEORGIEV', 'SALES', 'VACATION'),
('PESHO', 'GEORGIEV', 'SALES', 'VACATION'),
('MARA', 'IVANOV', 'SALES', 'VACATION');

INSERT INTO customers (driver_licence_number, full_name, address, city, zip_code, notes) VALUES
(12345, 'GOSHO GOSHOV', 'str PLISKA', 'RUSE', 7000, 'TEST'),
(12345, 'GOSHO GOSHOV', 'str PLISKA', 'RUSE', 7000, 'TEST'),
(12345, 'GOSHO GOSHOV', 'str PLISKA', 'RUSE', 7000, 'TEST');

INSERT INTO rental_orders (employee_id, customer_id, car_id, car_condition, tank_level, kilometrage_start, kilometrage_end, total_kilometrage, start_date, end_date, total_days, rate_applied, tax_rate, order_status, notes) VALUES
(1, 1, 1, 'GOSHO', 100, 5000, 6000, 10000, '2024-09-09', '2024-09-10', 1, 5.5, 10, 'FINISHED', 'TEST'),
(2, 1, 1, 'GOSHO', 100, 5000, 6000, 10000, '2024-09-09', '2024-09-10', 1, 5.5, 10, 'FINISHED', 'TEST'),
(4, 1, 1, 'GOSHO', 100, 5000, 6000, 10000, '2024-09-09', '2024-09-10', 1, 5.5, 10, 'FINISHED', 'TEST');