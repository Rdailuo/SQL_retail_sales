--SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p2;

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
		transactions_id	INT,
		sale_date DATE,
		sale_time TIME,
		customer_id	INT,
		gender VARCHAR(15),	
		age	INT,
		category VARCHAR(15),	
		quantity INT,	
		price_per_unit FLOAT,	
		cogs FLOAT,	
		total_sale FLOAT
	);

SELECT 
	COUNT(*)
FROM retail_sales

-- Data Cleaning

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantity IS NULL
	OR cogs IS NULL
	OR age IS NULL
	OR total_sale IS NULL;

DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantity IS NULL
	OR cogs IS NULL
	OR age IS NULL
	OR total_sale IS NULL;
	
-- Data Exploration

-- How many sales we have?
SELECT Count(*) as total_sale FROM retail_sales

-- How many customers we have?

SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- Based on research and acknowledgement by the store owner, the busiest months are November
-- and December. 
 -- Q.1 Which Category has the Highest Total Sales between November and December of 2023?
 -- Objective: Determine which category performs best during the busiest months, 
 -- to help with inventory and marketing decisions.

SELECT 
    category,
    SUM(total_sale) AS total_sales
FROM 
    retail_sales
WHERE 
    sale_date BETWEEN '2023-11-01' AND '2023-12-31' -- adjust as needed
GROUP BY 
    category
ORDER BY 
    total_sales DESC
LIMIT 1;



-- Q.2 Calculate the Total Sales and Average Spending per Customer
-- Objective: Understand customer value by calculating total sales 
-- and average spending, helping identify high-value customers.

SELECT 
    customer_id,
    SUM(total_sale) AS total_spent,
    AVG(total_sale) AS avg_spent
FROM 
    retail_sales
GROUP BY 
    customer_id
ORDER BY 
    total_spent DESC;

-- Q3. Analyze Sales Performance by Gender and Age Group
-- Objective: Segment the customer base by gender and age 
-- group to help with personalized marketing strategies.

SELECT 
    gender,
    CASE 
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+' 
    END AS age_group,
    SUM(total_sale) AS total_sales
FROM 
    retail_sales
GROUP BY 
    gender, age_group
ORDER BY 
    age_group, gender;
	
-- Q4. Calculate Gross Profit Margin for Each Category
-- Objective: Determine profitability by calculating gross 
-- profit margins for each product category.
SELECT 
    category,
    SUM(total_sale - (quantity * cogs)) AS gross_profit,
    (SUM(total_sale - (quantity * cogs)) / SUM(total_sale)) * 100 AS gross_profit_margin
FROM 
    retail_sales
GROUP BY 
    category
ORDER BY 
    gross_profit_margin DESC;
-- Q5. Identify Peak Sales Hours by Analyzing Sales Volume by Hour
-- Objective: Optimize staffing and operations by understanding peak sales hours.

SELECT 
    EXTRACT(HOUR FROM sale_time) AS sale_hour,
    COUNT(transactions_id) AS total_transactions,
    SUM(total_sale) AS total_sales
FROM 
    retail_sales
GROUP BY 
    sale_hour
ORDER BY 
    total_sales DESC;

-- Q6. find the peak sales hour and identify the most popular category during that hour
-- Part 1: This query will return the hour of the day (as sale_hour) with the highest total sales 
-- (total_sales). Note the sale_hour value for the next step.
WITH PeakHour AS (
    SELECT 
        EXTRACT(HOUR FROM sale_time) AS sale_hour
    FROM 
        retail_sales
    GROUP BY 
        sale_hour
    ORDER BY 
        SUM(total_sale) DESC
    LIMIT 1
)
-- Part 2. Now, we replace peak_hour_value with the hour returned from Step 1. This query 
--- identifies the category with the highest total sales during that peak hour:

SELECT 
    r.category,
    SUM(r.total_sale) AS total_sales
FROM 
    retail_sales r
JOIN 
    PeakHour p ON EXTRACT(HOUR FROM r.sale_time) = p.sale_hour
GROUP BY 
    r.category
ORDER BY 
    total_sales DESC
LIMIT 1;


-- End of Project

