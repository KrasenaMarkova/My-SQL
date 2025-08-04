# 1.Count Employees by Town
DELIMITER $$
CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
	RETURN(
		SELECT COUNT(*)
        FROM employees e
         JOIN addresses a 
			ON e.address_id = a.address_id
		JOIN towns t
			ON t.town_id = a.town_id
        WHERE t.name = town_name
        );
END$$
DELIMITER ;

DELIMITER $$
DROP FUNCTION ufn_count_employees_by_town;
CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR(50))
RETURNS INT
READS SQL DATA
BEGIN
	DECLARE e_count INT;
    SET e_count := (SELECT COUNT(*) AS 'count'
		FROM employees e
			JOIN addresses a ON e.address_id = a.address_id
			JOIN towns t ON a.town_id = t.town_id
		WHERE t.name = town_name);
    
    RETURN e_count;
END$$
DELIMITER ;

# 2.Employees Promotion
DELIMITER $$
CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR(50))
BEGIN
    UPDATE employees AS e
        JOIN departments AS d
			ON e.department_id = d.department_id
    SET e.salary = e.salary * 1.05
    WHERE d.name = department_name;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR(50))
BEGIN
	UPDATE employees e
	SET e.salary = e.salary * 1.05
	WHERE e.department_id = (
		SELECT d.department_id 
        FROM departments d 
        WHERE d.name = department_name
	);
    
    SELECT e.first_name, e.salary
	FROM employees e 
		JOIN departments d ON e.department_id = d.department_id
	WHERE d.name = department_name
	ORDER BY e.first_name, e.salary;
END$$
DELIMITER ;

# 3.Employees Promotion by ID
UPDATE employees e
SET e.salary = e.salary * 1.05
WHERE e.employee_id = id

DELIMITER $$
CREATE PROCEDURE usp_raise_salary_by_id(id INT)
BEGIN
	UPDATE employees e
	SET e.salary = e.salary * 1.05
	WHERE e.employee_id = id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE usp_raise_salary_by_id(user_id INT)
BEGIN
	DECLARE e_cnt INT;
    SET e_cnt := (SELECT COUNT(*) FROM employees WHERE employee_id = user_id);
    
    -- e_cnt = 1 => update; e_cnt = 0 => abort
    START TRANSACTION;
	
    UPDATE employees
	SET salary = salary * 1.05
	WHERE employee_id = user_id;
    
    IF (e_cnt = 0) THEN
		ROLLBACK;
	ELSE
		COMMIT;
	END IF;
END$$
DELIMITER ;

# 4. Triggered
CREATE TABLE deleted_employees (
    employee_id  INT PRIMARY KEY AUTO_INCREMENT,
    first_name   VARCHAR(50),
    last_name    VARCHAR(50),
    middle_name  VARCHAR(50),
    job_title    VARCHAR(50),
    department_id INT,
    salary       DECIMAL(19, 4)
);

DELIMITER $$
CREATE TRIGGER delete_employees
AFTER DELETE
ON employees
FOR EACH ROW
BEGIN
    INSERT INTO deleted_employees 
			(first_name, last_name, middle_name, job_title, department_id, salary)
    VALUES (OLD.first_name,
            OLD.last_name,
            OLD.middle_name,
            OLD.job_title,
            OLD.department_id,
            OLD.salary);
END$$
DELIMITER ;




