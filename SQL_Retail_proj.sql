CREATE DATABASE sql_project_p1;
USE sql_project_p1;


CREATE TABLE retail_sales (
transactions_id	INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(15),
age INT,	
category VARCHAR(20),
quantiy INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);

SELECT COUNT(*) from retail_sales;

/*DATA CLEANING */

SELECT * FROM retail_sales 
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category is NULL
OR quantiy is NULL
OR price_per_unit is NULL
OR cogs is NULL
OR total_sale is NULL;

/*COUNT OF THE NULL DATA */

SELECT COUNT(*) FROM retail_sales 
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category is NULL
OR quantiy is NULL
OR price_per_unit is NULL
OR cogs is NULL
OR total_sale is NULL;

DELETE FROM 
retail_sales 
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category is NULL
OR quantiy is NULL
OR price_per_unit is NULL
OR cogs is NULL
OR total_sale is NULL;

/*DATA EXPLORATION*/

/*HOW MANY SALES WE HAVE*/
SELECT COUNT(*) as total_sale from retail_sales;

/*HOW UNIQUE MANY CUSTOMERS WE HAVE */

SELECT COUNT( DISTINCT customer_id) as total_sale from retail_sales; 

/*CATEGORIES IN THE TABLE*/
SELECT DISTINCT category FROM retail_sales;


/*DATA ANALYSIS PART AND THE BUSNIESS PROBLEMS*/
/*Write a SQL query to retrieve all columns for sales made on '2022-11-05'*/
SELECT * FROM retail_sales
WHERE sale_date='2022-11-05';

/* Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022  */
SELECT category ,sale_date,quantiy
FROM retail_sales
WHERE category='Clothing'
AND sale_date BETWEEN '2022-11-01' AND  '2022-11-30'
AND quantiy >=4 ;

/* Write a SQL query to calculate the total sales (total_sale) for each category */
SELECT category , 
SUM(total_sale) as net_sale,
COUNT(*) as total_order
FROM retail_sales
GROUP BY 1;

/* Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category */
SELECT category,
round(AVG(age),2) as avg_age
FROM retail_sales
WHERE category='Beauty';

/* Write a SQL query to find all transactions where the total_sale is greater than 1000 */
SELECT * FROM retail_sales
WHERE total_sale > 1000;

/* Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category */
SELECT category,gender,
count(*) as total_trans
FROM retail_sales
group by category,gender
ORDER BY 1;

/*Write a SQL query to calculate the average sale for each month. Find out best selling month in each year*/
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    YEAR (sale_date) as year,
    MONTH (sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY YEAR (sale_date) ORDER BY AVG(total_sale) DESC) as rank_in_year
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank_in_year = 1;


/*Write a SQL query to find the top 5 customers based on the highest total sales*/
SELECT customer_id,
sum(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

/* Write a SQL query to find the number of unique customers who purchased items from each category */
SELECT category,
COUNT( DISTINCT customer_id) as unique_cust
FROM retail_sales
GROUP BY category;

/* Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17) */
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN HOUR (sale_time) < 12 THEN 'Morning'
        WHEN HOUR  (sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift