SELECT * FROM Walmartsales.sales;

# feature engineering
select time from Walmartsales.sales;
# Add the time_of_day column
SELECT time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM Walmartsales.sales;
ALTER TABLE Walmartsales.sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE Walmartsales.sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);
SELECT * FROM Walmartsales.sales;

# ADD day_name column
SELECT date,DAYNAME(date)
FROM Walmartsales.sales;
ALTER table Walmartsales.sales ADD COLUMN day_name Varchar(10);
Update walmartSales.sales
SET day_name=dayname(date);
SELECT * FROM Walmartsales.sales;

#ADD month_name column
SELECT DATE,MONTHNAME(DATE)
FROM Walmartsales.sales;
ALTER TABLE Walmartsales.sales ADD COLUMN month_name varchar(10);
update WalmartSales.sales
SET month_name=MONTHNAME(DATE);
SELECT * FROM Walmartsales.sales;


#GENERIC
#1.How many unique cities does the data have?
SELECT 
DISTINCT CITY
FROM Walmartsales.sales;

#2.In which city is each branch?
SELECT 
DISTINCT CITY,
BRANCH
FROM Walmartsales.sales;
SELECT * FROM Walmartsales.sales;

#PRODUCT
#1.How many unique product lines does the data have?
SELECT 
count(Distinct product_line)
From Walmartsales.sales;

#2. what is most selling product_line?
SELECT
SUM(quantity)as qty,
product_line
from Walmartsales.sales
group by product_line
order by qty desc;

#3.What is the total revenue by month?
select
month_name as month,
Sum(total) as total_revenue
from Walmartsales.sales
group by month_name
order by total_revenue;

#4. what month had the largest cogs?
select 
month_name as month,
sum(cogs) as cogs
from Walmartsales.sales
group by month_name
order by cogs;

#5. what product line had the largest revenue?
select
product_line,
sum(total)as total_revenue
from Walmartsales.sales
group by product_line
order by total_revenue desc;




#6. what is the city with the largest revenue?
select 
city,
Sum(total) as total_revenue
 from Walmartsales.sales
 group by city
 order by total_revenue desc;
 
 #7.what product line had the largest vat?
select
product_line,
avg(tax_pct) as avg_tax
from Walmartsales.sales
group by product_line
order by avg_tax desc;
 
 #8. what is most common payment method?
 select
  payment,
  count(*) as num_of_payment
  from Walmartsales.sales
  group by payment 
  order by num_of_payment desc;
  
  #9. fetch each product line and add a column to those products line showing "good",bad". Good if its greater than average sales
  
  select 
   AVG(quantity)as avg_qnty
   from Walmartsales.sales;
   
   SELECT 
   product_line,
   case
    when avg(quantity)>5.5 then "Good"
    else "Bad"
    end as Remark
    from Walmartsales.sales
    group by product_line;
    
   
   #10. which branch sold more products than average products sold?
     select 
     branch,
     sum(quantity)as qnty
     from Walmartsales.sales
     group by branch
     having sum(quantity)> (select avg(quantity) from Walmartsales.sales);
     
     
     #11. what is the most common product line by gender?
      select 
      gender,
      product_line,
       count(gender)as total_cnt
	from Walmartsales.sales
       group by product_line,gender
       order by total_cnt desc;
       
	#12. what is the average rating of each product?
    select
    product_line,
      round (avg(rating),2) as avg_rating
      from Walmartsales.sales
	group by product_line
    order by avg_rating desc;

       
    
# SALES QUESTIONS
 #1.Number of sales made in each time of the day per weekday
 SELECT
 time_of_day,
 count(*) as total_sales
 from Walmartsales.sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;

 
#2.Which of the customer types brings the most revenue?
select
customer_type,
sum(total) as total_revenue
from Walmartsales.sales
group by customer_type
order by total_revenue desc;



#3.Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT
	city,
    ROUND(AVG(tax_pct), 2) AS avg_tax_pct
from Walmartsales.sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;

#4.Which customer type pays the most in VAT?
 SELECT
	customer_type,
	AVG(tax_pct) AS total_tax
from Walmartsales.sales
GROUP BY customer_type
ORDER BY total_tax desc;
  
 #Customer questions
 
 #1.How many unique customer types does the data have?
 SELECT 
 DISTINCT CUSTOMER_TYPE
 from Walmartsales.sales;
 
 
#2.How many unique payment methods does the data have?
SELECT
 DISTINCT PAYMENT
  from Walmartsales.sales;
  
 
#3.What is the most common customer type?
SELECT
CUSTOMER_TYPE,
COUNT(*) AS CUSTOMER_CNT
 from Walmartsales.sales
 GROUP BY CUSTOMER_TYPE
 ORDER BY CUSTOMER_CNT DESC;
 
#4.Which customer type buys the most?
SELECT
customer_type,
count(*)
 from Walmartsales.sales
 group by customer_type;
 
 
#5.What is the gender of most of the customers?
 select
  gender,
  count(*)
  from Walmartsales.sales
  group by gender;
  
  
#6.What is the gender distribution per branch?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM Walmartsales.sales
WHERE branch = "A"
GROUP BY gender
ORDER BY gender_cnt DESC;

#7.Which time of the day do customers give most ratings?
SELECT
time_of_day,
avg(rating) as avg_rating
from Walmartsales.sales
 group by time_of_day
 order by avg_rating desc;
 
 
#8.Which time of the day do customers give most ratings per branch?
select 
branch
time_of_day,
avg(rating) as avg_rating
from Walmartsales.sales
 where branch="A"
 group by time_of_day
 order by avg_rating desc;



#9.Which day fo the week has the best avg ratings?
SELECT
  day_name,
  avg(rating)as avg_rating
  from Walmartsales.sales
  group by day_name
  order by avg_rating desc;

#10.Which day of the week has the best average ratings per branch?
SELECT
  day_name,BRANCH,
  avg(rating)as avg_rating
  from Walmartsales.sales
  where branch="A"
  group by day_name
  order by avg_rating desc;
   
   
   

  
  