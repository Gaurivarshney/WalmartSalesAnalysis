create database if not exists salesDataWalmart;

create table if not exists sales(
	invoice_id varchar(30) not null primary key,
    branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10,2) not null,
    quantity int not null,
    VAT float(6,4) not null,
    total decimal(12,4) not null,
    date datetime not null,
    time time not null,
    payment_method varchar(15) not null,
    cogs decimal(10,2) not null,
    gross_margin_pct float(10,2),
    gross_income decimal(12,4) not null,
    rating float(2,1)    
);

select time,
		(case
			when `time` between "00:00:00" and "12:00:00" then "Morning"
            when `time` between "12:01:00" and "16:00:00" then "Afternoon"
            else "Evening"
        end
        )as time_of_day
from sales;
-- ------------------------------Feature Enginnering------
-- ------adding column time_of_day---- 
alter table sales add column time_of_day varchar(20);

update sales 
set time_of_day=(case
			when `time` between "00:00:00" and "12:00:00" then "Morning"
            when `time` between "12:01:00" and "16:00:00" then "Afternoon"
            else "Evening"
        end
        );
        
-- --------------------Add Day Name Column---
select date, dayname(date)as day_name from sales;
alter table sales add column day_name varchar(20);
update sales set day_name= dayname(date);

-- -----------adding column month name-------- 
select date, monthname(date)as month_name from sales;
alter table sales add column month_name varchar(20);
update sales set month_name= monthname(date);



-- Genric Questions-- 
-- How many unique cities does the data have?-- 
select distinct city from sales;

-- branch is from which city?

select distinct city, branch from sales;

-- ------------------- --Product Analysis based questions---------------------------  
-- --------------------------------------------------------------------------

-- How many product line does the data have?
select count(distinct product_line) from sales;

-- What is the most common payment method?--
select payment_method,count(payment_method)as count
from sales
group by payment_method
order by count desc;

-- What is the most selling product line?
select product_line, count(product_line*quantity)as cnt from sales
group by product_line
order by cnt desc;

-- What is the total revenue by month?
select month_name as month,
sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

-- which month had the largest COGS(cost of good sold)?
select month_name as month,
sum(cogs) as cogs
from sales
group by month_name
order by cogs desc;

-- which product_line had the largest revenue?
select product_line,
sum(total) as total_revenue
from sales 
group by product_line
order by total_revenue desc;

-- which city generate the highest revenue?
select city,branch,
sum(total) as total_revenue
from sales 
group by city, branch
order by total_revenue desc;

-- which product line had largest VAT?
select product_line , avg(VAT) as avg_tax
from sales
group by product_line
order by avg_tax desc;


-- Which branch sold more products than avg products sold?

select branch , sum(quantity) as qty
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);

-- What is the most common product line by gender?
select product_line,
gender ,
count(gender) as total_cnt
from sales
group by product_line , gender
order by total_cnt desc;

-- What is the avg rating of each product line?

select product_line, round(avg(rating),2) as Rating
from sales
group by product_line
order by Rating desc;


-- ------------------- --Sales Analysis based questions---------------------------  
-- --------------------------------------------------------------------------

-- Number of Sales made in each time of the day per week day?
select time_of_day,
count(total) as total_sales
from sales
where day_name='sunday'
group by time_of_day
order by total_sales desc;

-- Which of the customer type bring the most revenue?
select customer_type, sum(total) as total_sales
from sales
group by customer_type
order by total_sales desc;

-- Which City has the largest tax percent/ VAT(value added tax)?
select city, avg(VAT) as VAT 
from sales
group by city
order by VAT desc;

-- Which Customer type pays the most in VAT?
select customer_type , avg(VAT) as VAT
from sales 
group by customer_type
order by VAT desc;

-- ------------------- --Customer Analysis based questions---------------------------  
-- --------------------------------------------------------------------------

-- How many unique customer type does the data have?
select customer_type, count(customer_type) cnt
from sales
group by customer_type
order by cnt;

-- How many unique payment method does the data have?
select distinct payment_method from sales;

-- What is the most common Customer type/ buys the most
select customer_type, count(total)as total_sales
from sales
group by customer_type
order by total_Sales desc;

-- What is the gender of most of the customer?
select gender , count(gender) as cnt
from sales 
group by gender
order by cnt desc;

-- What is the gender distribution per branch?
select gender , count(gender) as cnt
from sales 
where branch='A'
group by gender
order by cnt desc;

-- Which time of the day customer gives most ratings?
select time_of_day, avg(rating) as cnt_rating
from sales
group by time_of_day
order by cnt_rating desc;

-- Which time of the day customer gives most ratings per branch?
select time_of_day, avg(rating) as avg_rating
from sales
where branch='A'
group by time_of_day
order by cnt_rating desc;

-- Which day of the week has the best avg rating?
select day_name , avg(rating) as avg_rating
from sales
group by day_name
order by avg_rating desc;

-- Which day of the week has the best avg rating per branch?
select day_name , avg(rating) as avg_rating
from sales
where branch='A'
group by day_name
order by avg_rating desc;