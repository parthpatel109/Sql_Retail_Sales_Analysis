-- QI) create table
create table retail_sales (
	transactions_id	int primary key,
	sale_date date,	
	sale_time time,
	customer_id	int,
	gender varchar(15),
	age int,
	category varchar(15),	
	quantiy int,
    price_per_unit float,
	cogs float,
	total_sale float
);

-- QII) How many sales data we have
select count(*) as total_sale from retail_sales;

-- QIII) How many customers we have
select count(distinct customer_id) as Customers from retail_sales;


-- Q1) Retreive all columns from sales made on "2022-11-05"
select * from retail_sales
where sale_date = "2022-11-05";

-- Q2) Retreive all transactions where category is clothing and quantity sold is more than 10 in month of Nov'22
select * from retail_sales
where DATE_FORMAT(sale_date, '%Y-%m') = "2022-11"
	and	quantiy >= 4
    and category = "Clothing";

-- Q3) Calculate total sales for each category
select	category,
		format(sum(total_sale),0) as Total_Sales,
		count(*) as Orders
from retail_sales
group by 1;

-- Q4) Average age of customers who purchased beauty products
select
	round(avg(age),2) as Avg_age
from retail_sales
where category = "Beauty";

-- Q5) Querry to find all transactions where total sales gretear than 1000
select * from retail_sales
where total_sale > 1000;

-- Q6) Find the total number of transactions made by each gender in each category
select
		category as Category,
        gender as Gender,
        count(transactions_id) as Transactions
from retail_sales
group by 1,2
order by 1;

-- Q7) Calculate average sales for each month. Find the best selling month in each year
select Year, Month, Avg_Sales 
from( 
	select
			Year(sale_date) as Year,     -- DATE_FORMAT(sale_date, '%Y') as Year,
			Month(sale_date) as Month,   -- DATE_FORMAT(sale_date, '%m') as Month,
			round(avg(total_sale),2) as Avg_Sales,
			rank() over(partition by Year(sale_date) order by avg(total_sale) desc) as Rank1
	from retail_sales
	group by 1,2
    ) as t1
where Rank1 = 1;

-- Q8) Find top 5 customers based on total sales
select 	customer_id,
		sum(total_sale) as Total_sales
 from retail_sales
 group by 1
 order by 2 desc
 limit 5;
 
-- Q9) Find number of unique customers who purchased items from each category
select 
		category,
        count(distinct customer_id) as Customers
 from retail_sales
 group by 1;
 
-- Q10) Write query to create shift and number of orders (Ex: Mrng <12 , Afternoon 12 to 17 , Evening >17)
with hourly_sale
as (
	select *,
		case
			When hour(sale_time) < 12 Then 'Morning'
			When hour(sale_time) between 12 and 17 Then 'Afternoon'
			Else 'Evening'
		End as shift
	from retail_sales
)
select
	shift,
    count(*) as total_orders
from hourly_sale
group by 1;

-- Alternative solution

select 
	CASE
		WHEN HOUR(sale_time) < 12 THEN 'Morning'
		WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as 'Shift',
count(*) as 'Orders'
from Retail_sales
group by 1;

-- End of Project






