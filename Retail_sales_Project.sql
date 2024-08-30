create database sql_project_pr1;
use sql_project_pr1;

-- Create Table
CREATE TABLE retail_sales
(
	transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(20),
    age INT,
    category VARCHAR(20),
    quantity INT,
    price_per_unit INT,
    cogs FLOAT,
    total_sale INT
);

-- Check the table structure
DESC retail_sales;

-- Display top 10 rows
SELECT * FROM retail_sales
LIMIT 10;

-- Display count of rows
SELECT COUNT(*) FROM retail_sales;

-- Data Cleaning

-- Check the NULL values
SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL
    OR
    sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    customer_id IS NULL
    OR
    gender IS NULL
    OR
    age IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

-- Delete the null values rows

SET SQL_safe_updates = 0;

DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
    OR
    sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    customer_id IS NULL
    OR
    gender IS NULL
    OR
    age IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
SET SQL_SAFE_UPDATES = 1;

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) AS total_sale_count
FROM retail_sales;

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) AS unique_customer
FROM retail_sales;

-- Show the unique category we have?
SELECT DISTINCT category FROM retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * FROM retail_sales
WHERE sale_date = "2022-11-05";

/* Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing'
and the quantity sold is more than or Equal to 4 in the month of Nov-2022
*/

SELECT * FROM retail_sales
WHERE
	category = "Clothing"
    AND
    DATE_FORMAT(sale_date, "%Y-%m") = "2022-11"
    AND
    quantity >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT
	category,
    SUM(total_sale) AS Total_sales
FROM retail_sales
GROUP BY category
ORDER BY Total_sales DESC;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
	category,
    ROUND(AVG(age),2) AS Avg_age
FROM retail_sales
WHERE category = "Beauty";

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000;

/* Q.6 Write a SQL query to find the total number of transactions (transaction_id) 
made by each gender in each category.
*/

SELECT
	category,
    gender,
    COUNT(transactions_id) AS Transaction_count
FROM retail_sales
GROUP BY
	category, gender
ORDER BY Transaction_count DESC;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT * FROM
(
	SELECT
		YEAR(sale_date) AS 'year',
		MONTH(sale_date) AS 'month',
		AVG(total_sale) AS 'Avg_sale',
		RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS 'sale_rank'
	FROM retail_sales
	GROUP BY year, month
) AS temp
WHERE
	sale_rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT
	customer_id,
    SUM(total_sale) AS High_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY High_sale DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT
	category,
    COUNT(DISTINCT customer_id) AS 'Customer_count'
FROM retail_sales
GROUP BY category
ORDER BY Customer_count DESC;

/* 
Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12,
Afternoon Between 12 & 17, Evening >17)
*/
WITH hourly_sale AS (
	SELECT *,
		CASE
			WHEN HOUR(sale_time) < 12 THEN "Morning"
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN "Afternoon"
			ELSE "Evening"
		END AS Shift
	FROM retail_sales)
SELECT Shift, COUNT(*) AS No_of_Orders FROM hourly_sale
GROUP BY Shift ORDER BY COUNT(*) DESC;