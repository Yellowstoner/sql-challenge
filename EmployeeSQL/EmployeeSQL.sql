-- SQL CHALLENGE

DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS deptemp;
DROP TABLE IF EXISTS deptmanager;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS titles;

-- DATA MODELING
-- Pulled from https://app.quickdatabasediagrams.com/#/d/FBIE0f

-- DATA ENGINEERING

CREATE TABLE departments (
    dept_no VARCHAR NOT NULL,
    dept_name VARCHAR NOT NULL,
    CONSTRAINT pk_departments PRIMARY KEY (dept_no)
);

CREATE TABLE deptemp (
    emp_no INT NOT NULL,
    dept_no VARCHAR NOT NULL
);

CREATE TABLE deptmanager (
    dept_no VARCHAR NOT NULL,
    emp_no INT NOT NULL
);

CREATE TABLE employees (
    emp_no INT NOT NULL,
    emp_title_id VARCHAR NOT NULL,
    birth_date date NOT NULL,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    sex VARCHAR NOT NULL,
    hire_date date NOT NULL,
    CONSTRAINT pk_employees PRIMARY KEY (emp_no)
);

CREATE TABLE salaries (
    emp_no INT NOT NULL,
    salary INT NOT NULL
);

CREATE TABLE titles (
    title_id VARCHAR NOT NULL,
    title VARCHAR NOT NULL,
    CONSTRAINT pk_titles PRIMARY KEY (title_id)
);


ALTER TABLE deptemp ADD CONSTRAINT fk_deptemp_emp_no FOREIGN KEY(emp_no)
REFERENCES Employees (emp_no);

ALTER TABLE deptemp ADD CONSTRAINT fk_deptemp_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE deptmanager ADD CONSTRAINT fk_deptmanager_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE deptmanager ADD CONSTRAINT fk_deptmanager_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE employees ADD CONSTRAINT fk_employees_emp_title_id FOREIGN KEY(emp_title_id)
REFERENCES titles (title_id);

ALTER TABLE salaries ADD CONSTRAINT fk_salaries_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);


SELECT * FROM departments;
SELECT * FROM deptemp;
SELECT * FROM deptmanager;
SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM titles;


-- DATA ANALYSIS

-- 1. List the following details of each employee: employee number, last name, first name, sex, and salary.

SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees
JOIN salaries
ON employees.emp_no = salaries.emp_no;

-- 2. List first name, last name, and hire date for employees who were hired in 1986.

SELECT first_name, last_name, hire_date 
FROM employees
WHERE hire_date >= '1986-01-01' AND hire_date < '1987-01-01';

-- 3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.

SELECT departments.dept_no, departments.dept_name, deptmanager.emp_no, employees.last_name, employees.first_name, deptmanager.from_date, deptmanager.to_date
FROM departments
JOIN deptmanager
ON departments.dept_no = deptmanager.dept_no
JOIN employees
ON deptmanager.emp_no = employees.emp_no;

-- 4. List the department of each employee with the following information: employee number, last name, first name, and department name.

SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM deptemp
JOIN employees
ON deptemp.emp_no = employees.emp_no
JOIN departments
ON deptemp.dept_no = departments.dept_no;

-- 5. List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."

SELECT first_name, last_name, sex 
FROM employees
WHERE first_name = 'Hercules' AND
last_name LIKE 'B%';

-- 6. List all employees in the Sales department, including their employee number, last name, first name, and department name.

SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM deptemp
JOIN employees
ON deptemp.emp_no = employees.emp_no
JOIN departments
ON deptemp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales';

-- 7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.

SELECT deptemp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM deptemp
JOIN employees
ON deptemp.emp_no = employees.emp_no
JOIN departments
ON deptemp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales' 
OR departments.dept_name = 'Development';

-- 8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.

SELECT last_name,
COUNT(*) AS "frequency_count"
FROM employees
GROUP BY last_name
HAVING COUNT(*) > 1
ORDER BY last_name DESC;