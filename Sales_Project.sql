-- SQL Retail Sales Analysis - P1
CREATE DATABASE sales_pro;


-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
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

select count(*) from retail_sales;

select * from retail_sales;

--Data Cleaning

select * from retail_sales where transaction_id is NULL;

SELECT * FROM retail_sales WHERE sales_date IS NULL;

SELECT * FROM retail_sales WHERE sales_time IS NULL;

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sales_date IS NULL
    OR 
    sales_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sales IS NULL;
	
-- Deleting the rows where value is null

DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sales_date IS NULL
    OR 
    sales_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sales IS NULL;

--Checking the database again to count rows after deleting null values 

select count(*) from retail_sales;


-- Data Exploration

-- How many sales we have?

select count (*) as total_sales from retail_sales;

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_sales FROM retail_sales;


SELECT DISTINCT category FROM retail_sales;

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * FROM retail_sales WHERE sales_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT 
  *
  FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sales_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4
	
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sales > 1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sales_date) as year,
    EXTRACT(MONTH FROM sales_date) as month,
    AVG(total_sales) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sales_date) ORDER BY AVG(total_sales) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
    ORDER BY 1, 3 DESC
	

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
    customer_id,
    SUM(total_sales) as total_sale
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.


SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sales_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sales_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift