create database FlutterTech_Analysis;

use FlutterTech_Analysis;

CREATE TABLE EMPLOYEES (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(50),
    phone_number VARCHAR(30),
    hire_date DATE,
    salary INT NOT NULL,
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES EMPLOYEES(employee_id)
);

select * from employees;
drop table employees;

create table CUSTOMERS(
customer_id int,
customer_name varchar(100),
email varchar(50),
phone int,
city varchar(100),
state varchar(100),
registration_date date,
customer_type varchar(50),
primary key(customer_id)
);

select * from customers;

create table transactions(
transaction_id int Primary key,
employee_id int,
customer_id int,
sale_date date,
product_name varchar(100),
quantity int,
unit_price decimal(8,2),
total_amount decimal(50,4),
commission_rate decimal(10,2),
foreign key(employee_id) references employees(employee_id),
foreign key(customer_id) references customers(customer_id)

);
DROP TABLE TRANSACTIONS;

select * from transactions;

Select 
concat(EMPLOYEES.first_name, ' ', EMPLOYEES.last_name) AS EMPLOYEE_NAME,
CUSTOMERS.customer_name,
transactions.sale_date
from transactions
JOIN EMPLOYEES on employees.employee_id = transactions.employee_id
JOIN CUSTOMERS on customers.customer_id= transactions.customer_id
order by sale_date DESC;

Select 
employees.department, 
SUM(transactions.total_amount) AS total_sales
from employees
JOIN transactions on transactions.employee_id= employees.employee_id
GROUP BY employees.department
order by total_sales DESC;

SELECT 
    customers.customer_type,
    SUM(transactions.total_amount) AS total_revenue
FROM 
    Transactions
JOIN CUSTOMERS ON transactions.customer_id = customers.customer_id
GROUP BY 
customers.customer_type
ORDER BY 
    total_revenue DESC;
    
    
    
SELECT 
    CONCAT(EMPLOYEES.first_name, ' ', EMPLOYEES.last_name) AS employee_name,
    COUNT(transactions.transaction_id) AS transaction_count,
    SUM(transactions.total_amount) AS total_sales
FROM 
    transactions 
JOIN EMPLOYEES  ON transactions.employee_id = employees.employee_id
GROUP BY 
    employees.employee_id
having
    COUNT(transactions.transaction_id) > 2;
    
SELECT 
    s.product_type,
    AVG(s.total_amount) AS avg_transaction_amount
FROM 
    SALES_TRANSACTIONS s
GROUP BY 
    s.product_type
HAVING 
    COUNT(transactions.transaction_id) > 1;
    
SELECT 
CONCAT(employees.first_name, ' ', employees.last_name) AS employee_name,
SUM(transactions.total_amount * transactions.commission_rate / 100) AS total_commission
FROM 
    transactions
JOIN EMPLOYEES  ON transactions.employee_id = EMPLOYEES.employee_id
GROUP BY 
    EMPLOYEES.employee_id
ORDER BY 
    total_commission DESC
LIMIT 3;
    

SELECT 
customers.customer_name,
COUNT(DISTINCT MONTH(transactions.sale_date)) AS unique_months,
SUM(transactions.total_amount) AS total_spent
FROM transactions
JOIN CUSTOMERS ON transactions.customer_id = CUSTOMERS.customer_id
GROUP BY 
    CUSTOMERS.customer_id
HAVING 
    unique_months > 1;
    
SELECT 
CONCAT(employees.first_name, ' ', employees.last_name) AS employee_name,
SUM(transactions.total_amount) AS total_sales,
COUNT(transactions.transaction_id) AS transaction_count,
AVG(transactions.total_amount) AS avg_transaction
FROM transactions
JOIN EMPLOYEES  ON transactions.employee_id = employees.employee_id
WHERE 
    employees.department = 'Sales'
GROUP BY 
    employees.employee_id
HAVING 
    total_sales > 100000;
    
   

UPDATE transactions
SET commission_rate = 9
WHERE employee_id 
IN (
SELECT employee_id
FROM transactions
GROUP BY employee_id
HAVING SUM(total_amount) > 400000
);


SELECT *
FROM transactions
WHERE commission_rate = 9;


SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
