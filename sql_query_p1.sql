
-- create table
CREATE TABLE retail_sales(
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(15),
				age INT,
				category VARCHAR(15),
				quantity INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sales FLOAT
)

SELECT * FROM retail_sales;

SELECT COUNT(*) FROM retail_sales;

--DATA CLEANING

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
		OR quantity IS NULL
		OR
		price_per_unit IS NULL
		OR 
		cogs IS NULL
		OR
		total_sales IS NULL


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
		OR quantity IS NULL
		OR
		price_per_unit IS NULL
		OR 
		cogs IS NULL
		OR
		total_sales IS NULL;


-- Data exploration--

--How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales;

--How many customers we have 
SELECT COUNT(DISTINCT(customer_id)) FROM retail_sales;

--How many unique categories we have?
SELECT COUNT(DISTINCT(category)) FROM retail_sales;

--DATA ANALYSIS--
--1.Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from retail_sales
where sale_date='2022-11-05';

--2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022:
select * from retail_sales
where 
	category='Clothing' 
	and quantity>=4
	and (extract(year from sale_date)='2022' and extract(month from sale_date)='11')
	group by 1;

--3.Write a SQL query to calculate the total sales (total_sale) for each category.
select category,sum(total_sales) as total_sales_c
from retail_sales 
group by category;

--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
select 
	round(avg(age),2)
from retail_sales
where category='Beauty';

--5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select 
	* 
from retail_sales
where total_sales>1000

--6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
select 
	category,gender,count(distinct transactions_id)
from retail_sales
group by category,gender;

--7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
select 
	*
	from(
		select
			extract(year from sale_date) as yea,
			extract(month from sale_date) as mon,
			avg(total_sales),
			rank()over(partition by extract(year from sale_date) order by avg(total_sales) desc)
		from retail_sales
		group by 1,2) as best_selling
where rank=1;

--8.Write a SQL query to find the top 5 customers based on the highest total sales :
select customer_id,sum(total_sales) 
	from retail_sales
group by 1
order by 2 desc
limit 5;

--9.Write a SQL query to find the number of unique customers who purchased items from each category.:
select category,count(distinct(customer_id)) 
	from retail_sales
group by category;

--10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
select 
	case
		 when extract(hour from sale_time) <12 then 'MORNING'
		 when extract(hour from sale_time) >=12 and extract(hour from sale_time) <=17 then 'AFTERNOON'
		 else 
		 	'EVENING'
	end as shift,
		 count(*)
from retail_sales
group by 1;
--or
--Using CTE(COMMON TABLE EXPRESSION)
with hourly_sale as
	(select
			*,
		case
			 when extract(hour from sale_time) <12 then 'MORNING'
			 when extract(hour from sale_time) >=12 and extract(hour from sale_time) <=17 then 'AFTERNOON'
		else 
		 	'EVENING'
	end as shift 
from retail_sales
	)
select 
	shift,count(*)
from hourly_sale
group by shift;


