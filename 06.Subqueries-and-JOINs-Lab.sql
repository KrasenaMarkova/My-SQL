# 1.Managers
SELECT e.employee_id,
		CONCAT_WS(' ', e.first_name, e.last_name) AS 'full_name',
        d.department_id,
        d.name AS 'department_name'
FROM departments d
JOIN employees e
	ON d.manager_id = e.employee_id
ORDER BY e.employee_id
LIMIT 5;

# 2.Towns Addresses
SELECT t.town_id,
		t.name AS 'town_name',
        a.address_text AS 'address_text'
FROM towns t
JOIN addresses a
	ON t.town_id = a.town_id
WHERE t.name IN ('San Francisco', 'Sofia ', 'Carnation')
ORDER BY t.town_id, address_id;

#3.	Employees Without Managers
SELECT e.employee_id,
		e.first_name,
        e.last_name,
        e.department_id,
        e.salary
FROM employees e
WHERE manager_id IS NULL;

# 4.Higher Salary
SELECT COUNT(*)
FROM employees
WHERE salary > (
	SELECT AVG(salary)
    FROM employees
);




