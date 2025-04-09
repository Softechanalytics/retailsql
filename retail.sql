SELECT TOP (1000) [transactions_id]
      ,[sale_date]
      ,[sale_time]
      ,[customer_id]
      ,[gender]
      ,[age]
      ,[category]
      ,[quantiy]
      ,[price_per_unit]
      ,[cogs]
      ,[total_sale]
  FROM [Retails].[dbo].[Retails]

  -- EDA Process
  -- No of data imported
  Select 
        count(*)
    From Retails;

-- Number of customers
select count(distinct customer_id) Count_customers
from Retails;


-- Checking for Null Values

Select top 1 * from Retails;

Select * 
    from Retails
    Where 
    transactions_id is NULL
    or
    sale_date is NULL
    OR
    Sale_time is NULL
    OR
    gender is null
    OR
    Category is NULL
    OR
    Quantiy is NULL
    or 
    cogs is NULL
    OR
    total_sale is NUll;

-- Since we have few value with Null value, we can delete them
-- Data cleaning
Delete 
From Retails
   Where 
    transactions_id is NULL
    or
    sale_date is NULL
    OR
    Sale_time is NULL
    OR
    gender is null
    OR
    Category is NULL
    OR
    Quantiy is NULL
    or 
    cogs is NULL
    OR
    total_sale is NUll;

-- Data Exploration
-- Number of geneder
Select 
    Gender,
    count(gender) Count_of_Gender
from Retails
group by gender;

-- Number of Category
Select 
    category,
    count(category) Count_of_Category
from Retails
group by category;

-- Total sales
select format(sum(Total_sale),'N2') Total_Sales
From Retails;
-- how many sales we have
select 
    count(*) Count_of_sale
from retails;

-- How many unique  customer we have
select 
    count(distinct customer_id)
from Retails;

-- How many unique  category we have
select 
    count(distinct Category) Count_category
from Retails;

Select distinct category from retails

-- Data Analysis & Business Key Problems & Answer
-- My Analysis & Fomdomg
--Q1: Retrieve all column  fro sales made on '2022-11-05'

Select *
from retails
where cast(sale_date as Date) = '2022-11-05';

-- Q2: Write Sql query to retrieve all transactions where category is clothings and the quantity sold in more than 10 in the month of Nov-22

SELECT *
FROM Retails
WHERE category = 'Clothing'
    AND sale_date >= '2022-11-01'
    AND sale_date < '2022-12-01'
    AND quantity >= 4;

-- Q3 Write a Sql query to Calculate the totals sales for each category
SELECT
    Category,
    format(Sum(total_sale),'N2') as Total,
    count(*) total_order
From Retails
    Group by category;

-- Q4 Write a SQL Query to find the average  age of customer who pruchased items from the 'Beauty' Category.
Select 
        Round(avg(age),2) Average_age
From Retails
where category = 'Beauty'


--Q5: Write a sql query to find the total number of transaction (transaction_id) made by each in gender in each category

Select
    Category,
    gender,
    Count(transactions_id) Nos_Transaction
From Retails
group by category,gender
order by Category,gender

-- Q6: Write a query to find all transaction where the total_sale is greater than 1000
Select *
from Retails
where total_sale > 1000;
  

--Q7: Write a query to calculate the average sale for each month. Find the best selling month in each year
    Select
       Year,
       Month,
       Avg_sales
       From
       (
                SELECT
                    year(sale_Date) YEAR,
                    month(sale_date) month,
                    round(Avg(total_sale),2) Avg_sales,
                    Rank() over(Partition by year(sale_Date) order by avg(total_sale) desc) Rank
                From Retails
                group by year(sale_Date),month(sale_date)
       ) as  t1
Where Rank = 1

-- Q8: Write a sql query to find the top 5 customer based on the highest sales
-- METHOD 1
SELECT
    Customer_id,
    Highest_sales,
    RAnK
    FROM
        (

            Select 
                Customer_id,
                Sum(total_sale) highest_sales,
                rank() over(order by Sum(total_sale) desc) rank
            from Retails
            group by customer_id
        ) t
Where Rank <= 5;

-- mETHOD 2
Select 
     toP 5
     Customer_id,
     Sum(total_sale) highest_sales
from Retails
group by customer_id
order by highest_sales desc;


-- Q9: Write a Sql query to find the number of unique customer who purchased items from each category

select 
        Category,
        count(distinct customer_id) unique_count_customer
From Retails
    group by category;

-- 10: Write a Sql queury to create each shift and number of orders (Example Morning <= 12., After Between 12 & 17, Even > 17)
SELECT
    CASE 
        WHEN DATEPART(HOUR, sale_time) > 17 THEN 'Evening'
        WHEN DATEPART(HOUR, sale_time) > 12 AND DATEPART(HOUR, sale_time) <= 17 THEN 'Afternoon'
        ELSE 'Morning'
    END AS SHIFT,
    COUNT(*) AS NumberOrder
FROM Retails
GROUP BY 
    CASE 
        WHEN DATEPART(HOUR, sale_time) > 17 THEN 'Evening'
        WHEN DATEPART(HOUR, sale_time) > 12 AND DATEPART(HOUR, sale_time) <= 17 THEN 'Afternoon'
        ELSE 'Morning'
    END
ORDER BY SHIFT;

       