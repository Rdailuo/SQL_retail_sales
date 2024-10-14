# "Pepito" Retail Store Sales Analysis SQL Project

## Project Overview

This project provides an analysis of a retail sales dataset using SQL and applies data analysis kills to explore, clean, and analyze retail sales data . It involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. The objective is to answer business-oriented questions to inform decisions on customer segmentation, profitability, and operational efficiency.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_p2`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE sql_project_p2;

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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Which Category has the Highest Total Sales between November and December of 2023?
    Objective: Determine which category performs best during the busiest months to help with inventory and marketing decisions.**:
```sql
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

```

2. **Calculate the Total Sales and Average Spending per Customer
   Objective: Understand customer value by calculating total sales and average spending, helping identify high-value customers.**:
```sql
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
```

3. **Analyze Sales Performance by Gender and Age Group.
   Objective: Segment the customer base by gender and age group to help with personalized marketing strategies.**:
```sql
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
```

4. **Calculate Gross Profit Margin for Each Category
-- Objective: Determine profitability by calculating gross profit margins for each product category.**:
```sql
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
```

5. **Identify Peak Sales Hours by Analyzing Sales Volume by Hour
   Objective: Optimize staffing and operations by understanding peak sales hours.**:
```sql
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
```

6. **Find the peak sales hour and identify the most popular category during that hour.
   Part 1: This query will return the hour of the day (as sale_hour) with the highest total sales (total_sales). Note the sale_hour value for the next step.**:
```sql
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
```
**Part 2. Now, we replace peak_hour_value with the hour returned from Part 1. This query identifies the category with the highest total sales during that peak hour:**

```sql
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
```


## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Conclusion

In this project I applied skills from covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. How to Run the Analysis
2. Clone the repository.
3. Load the dataset into your SQL environment.
4. Execute the queries in sequence as shown above.

**Credit:** Guidance from najirh N H (Zero Analyst)
