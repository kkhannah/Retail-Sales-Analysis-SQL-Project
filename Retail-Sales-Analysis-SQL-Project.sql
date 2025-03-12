-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p1;
USE sql_project_p1;
-- Create TABLE
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales;
SELECT COUNT(*) FROM retail_sales;
SELECT count(*) FROM retail_sales WHERE transaction_id IS NULL
OR sale_date IS NULL OR sale_time IS NULL OR gender IS NULL
OR category IS NULL OR quantity IS NULL OR cogs IS NULL
OR total_sale IS NULL;
    
DELETE FROM retail_sales
WHERE transaction_id IS NULL
OR sale_date IS NULL OR sale_time IS NULL
OR gender IS NULL OR category IS NULL
OR quantity IS NULL OR cogs IS NULL
OR total_sale IS NULL;
    
-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_customers FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is >=4 in the month of Nov-2022
SELECT * FROM retail_sales WHERE category='Clothing' AND quantity>=4 AND substr(sale_date,1,7)='2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category, SUM(total_sale) as total_sales,count(*) as total_orders FROM retail_sales GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age),2) as avg_age FROM retail_sales WHERE category='Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales WHERE total_sale>1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category,gender,count(*) as num_transactions FROM retail_sales GROUP BY category,gender ORDER BY category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
WITH average_cte as (SELECT substr(sale_date,1,7) as month_year, round(avg(total_sale),2) as avg_sales FROM retail_sales GROUP BY substr(sale_date,1,7))
, rank_cte AS (SELECT month_year, avg_sales, RANK() OVER (PARTITION BY substr(month_year,1,4) ORDER BY avg_sales desc) AS rank_data FROM average_cte)
SELECT month_year,avg_sales FROM rank_cte WHERE rank_data=1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id, SUM(total_sale) as total_sales FROM retail_sales GROUP BY customer_id ORDER BY SUM(total_sale) desc LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category,  COUNT(DISTINCT customer_id) as cnt_unique_cs FROM retail_sales GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH shift_cte as (
SELECT *, CASE
WHEN HOUR(sale_time)<12 THEN 'Morning'
WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening' END as shift FROM retail_sales)

SELECT shift, COUNT(*) as total_sales FROM shift_cte GROUP BY shift;

