/***********************************
    Project Skill Assessment - SQL
************************************/

-- Create project Database Schema and load data
-- Version 1.0
-- Author: Vivian Kuang


/***********************************
    Build database and schema
************************************/

-- set parameter to load in data and arrange memory for loading data
SET GLOBAL local_infile=ON;
SET GLOBAL bulk_insert_buffer_size = 1024 * 1024 * 4;

-- DROP database IF EXISTS project;
DROP SCHEMA IF EXISTS project;
CREATE SCHEMA project;

USE project;


-- drop the 'salesman' table if exists
DROP TABLE if EXISTS project.salesman;

-- Create the 'salesman' table
CREATE TABLE salesman (
    salesman_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50),
    commission DECIMAL(8, 2)
);


-- drop the 'salesman' table if exists
TRUNCATE project.salesman;

-- Load data from salesman.csv into salesman table
LOAD DATA LOCAL INFILE 'C:/Users/vivian/Desktop/WeCloudData/Project Management Assessment/Python and SQL Quiz/salesman.csv'
INTO TABLE project.salesman
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
;


-- drop the 'customer' table if exists
DROP TABLE if EXISTS project.customer;

-- Create the 'customer' table
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    cust_name VARCHAR(100),
    city VARCHAR(50),
    grade VARCHAR(10),
    salesman_id INT
);

-- truncate the data of the 'customer' table if exists
TRUNCATE project.customer;

-- Load data from customer.csv into customer table
LOAD DATA LOCAL INFILE 'C:/Users/vivian/Desktop/WeCloudData/Project Management Assessment/Python and SQL Quiz/customer.csv'
INTO TABLE project.customer
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
;

-- drop the 'orders' table if exists
DROP TABLE if EXISTS project.orders;

-- Create the 'orders' table
CREATE TABLE orders (
    ord_no INT PRIMARY KEY,
    purch_amt DECIMAL(8, 2),
    ord_date DATE,
    customer_id INT,
    salesman_id INT
);

-- truncate the data of the 'orders' table if exists
TRUNCATE project.orders;

-- Load data from orders.csv into orders table
LOAD DATA LOCAL INFILE 'C:/Users/vivian/Desktop/WeCloudData/Project Management Assessment/Python and SQL Quiz/orders.csv'
INTO TABLE project.orders
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
;


-- drop the 'nobel_win' table if exists
DROP TABLE if EXISTS project.nobel_win;

-- Create the 'nobel_win' table
CREATE TABLE nobel_win (
    year VARCHAR(10),
    subject TEXT,
    winner VARCHAR(100),
    country VARCHAR(50),
    category VARCHAR(50)
);

-- truncate the data of the 'nobel_win' table if exists
TRUNCATE project.nobel_win;

-- Load data from nobel_win.csv into nobel_win table
LOAD DATA LOCAL INFILE 'C:/Users/vivian/Desktop/WeCloudData/Project Management Assessment/Python and SQL Quiz/nobel_win.csv'
INTO TABLE project.nobel_win
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
;


/***********************************
    Week 9, SQL Assessment Quiz
************************************/

/*
 Instructions:
 - There are 4 tables in the folder, make sure to correctly import the tables
   (using code) and write queries to answer each of the questions below.
 */

 -- Question 1
    -- Using the `nobel_win` table, write a SQL query to show all the winners of the
    -- Nobel prize in the year 1970, excluding the subject Physiology and Economics.
SELECT *
FROM nobel_win
WHERE year = 1970 AND subject NOT IN ('Physiology', 'Economics');

/*
+------+------------+------------------------+---------+-----------+
| year | subject    | winner                 | country | category  |
+------+------------+------------------------+---------+-----------+
| 1970 | Physics    | Hannes Alfven          | Sweden  | Scientist |
| 1970 | Physics    | Louis Neel             | France  | Scientist |
| 1970 | Chemistry  | Luis Federico Leloir   | France  | Scientist |
| 1970 | Literature | Aleksandr Solzhenitsyn | Russia  | Linguist  |
+------+------------+------------------------+---------+-----------+
*/

-- Question 2
    -- Using the `order` table, write a SQL statement to exclude the rows which satisfy:
    -- (1) Order dates are 2012-08-17 and purchase amount is below 1000
    -- OR
    -- (2) Customer id is greater than 3005 and purchase amount is below 1000.

SELECT *
FROM project.orders
WHERE NOT ((ord_date = '2012-08-17' AND purch_amt < 1000)
          OR (customer_id > 3005 AND purch_amt < 1000));

/*
 +--------+-----------+------------+-------------+-------------+
| ord_no | purch_amt | ord_date   | customer_id | salesman_id |
+--------+-----------+------------+-------------+-------------+
|  70001 |    150.50 | 2012-10-05 |        3005 |        5002 |
|  70002 |     65.26 | 2012-10-05 |        3002 |        5001 |
|  70003 |   2480.40 | 2012-10-10 |        3009 |        5003 |
|  70005 |   2400.60 | 2012-07-27 |        3007 |        5001 |
|  70007 |    948.50 | 2012-09-10 |        3005 |        5002 |
|  70008 |   5760.00 | 2012-09-10 |        3002 |        5001 |
|  70009 |    270.65 | 2012-09-10 |        3001 |        5005 |
|  70010 |   1983.43 | 2012-10-10 |        3004 |        5006 |
|  70013 |   3045.60 | 2012-04-25 |        3002 |        5001 |
+--------+-----------+------------+-------------+-------------+
 */


-- Question 3
    -- Using the `customer` table, write a SQL statement to find the information of all
    -- customers whose first name and/or last name ends with "n".
    -- E.g. Ryan Reynolds, Ed Sheeran, Elton John (note: these names are just examples)

SELECT *
FROM project.customer
WHERE cust_name LIKE '%n' OR cust_name LIKE '% n';

/*
 +-------------+----------------+--------+-------+-------------+
| customer_id | cust_name      | city   | grade | salesman_id |
+-------------+----------------+--------+-------+-------------+
|        3001 | Brad Guzan     | London |       |        5005 |
|        3004 | Fabian Johnson | Paris  |   300 |        5006 |
|        3008 | Julian Green   | London |   300 |        5002 |
|        3009 | Geoff Cameron  | Berlin |   100 |        5003 |
+-------------+----------------+--------+-------+-------------+
 */

-- Question 4
    -- Using the `orders` table, write a SQL statement to find the highest purchase
    -- amount ordered by each customer on a particular date with their ID, order date,
    -- and highest purchase amount.

SELECT customer_id, ord_date, MAX(purch_amt) AS highest_purchase_amount
FROM project.orders
GROUP BY customer_id, ord_date
order by 1, 2;

/*
 +-------------+------------+-------------------------+
| customer_id | ord_date   | highest_purchase_amount |
+-------------+------------+-------------------------+
|        3001 | 2012-09-10 |                  270.65 |
|        3002 | 2012-04-25 |                 3045.60 |
|        3002 | 2012-09-10 |                 5760.00 |
|        3002 | 2012-10-05 |                   65.26 |
|        3003 | 2012-08-17 |                   75.29 |
|        3004 | 2012-10-10 |                 1983.43 |
|        3005 | 2012-09-10 |                  948.50 |
|        3005 | 2012-10-05 |                  150.50 |
|        3007 | 2012-07-27 |                 2400.60 |
|        3008 | 2012-06-27 |                  250.45 |
|        3009 | 2012-08-17 |                  110.50 |
|        3009 | 2012-10-10 |                 2480.40 |
+-------------+------------+-------------------------+
12 rows in set (0.00 sec)
 */

-- Question 5
    -- Using the `salesman` and `customer` tables, write a SQL statement to prepare a list
    -- with the salesman name, customer name, and cities for the salesmen and customer who
    -- belong to the same city.

SELECT s.name AS salesman_name, c.cust_name AS customer_name, s.city
FROM project.salesman s
JOIN project.customer c ON s.city = c.city
order by 1;

/*
+---------------+----------------+----------+
| salesman_name | customer_name  | city     |
+---------------+----------------+----------+
| James Hoog    | Nick Rimando   | New York |
| James Hoog    | Brad Davis     | New York |
| Mc Lyon       | Fabian Johnson | Paris    |
| Nail Knite    | Fabian Johnson | Paris    |
| Pit Alex      | Brad Guzan     | London   |
| Pit Alex      | Julian Green   | London   |
+---------------+----------------+----------+
 */