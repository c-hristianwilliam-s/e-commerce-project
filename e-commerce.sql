CREATE TABLE OrderDetails (
	OrderID varchar(255),
	Amount numeric,
	Profit numeric,
	Quantity int,
	Category text,
	SubCategory text	
);

CREATE TABLE List_Of_Orders (
	OrderID varchar(255),
	OrderDate TEXT,
	CustomerName TEXT,
	State Text,
	City Text
);

-- BASIC INFO (SPECIFIC TO EACH TABLE)

--What locations does this dataset include?
SELECT city, state FROM list_of_orders;

--How many customers are in this dataset?
SELECT COUNT(*) FROM List_Of_Orders;

-- What are the categories of items?
SELECT DISTINCT Category FROM OrderDetails;

-- What are the sub-categories of items?
SELECT DISTINCT subcategory FROM OrderDetails;

--Total Profit made In Each Category
SELECT SUM(Profit) From OrderDetails WHERE Category = 'Furniture';
SELECT SUM(Profit) FROM OrderDetails WHERE Category = 'Electronics';
SELECT SUM(Profit) FROM OrderDetails WHERE Category = 'Clothing';

--Average quantity per order
SELECT AVG(quantity) AS Quantity FROM orderdetails;

--Average quantity per order where the category in each category
SELECT AVG(quantity) AS Quantity FROM orderdetails WHERE category = 'Clothing';
SELECT AVG(quantity) AS Quantity FROM orderdetails WHERE category = 'Electronics';
SELECT AVG(quantity) AS Quantity FROM orderdetails WHERE category = 'Furniture';

--Percentage of orders placed for furniture where the quantity was over 1
SELECT COUNT(CASE WHEN orderdetails.quantity > 1 THEN 1 END)*100/COUNT(*)
AS Furniture_Bundle FROM orderdetails WHERE category = 'Furniture';

--Which Products are being spent the most towards
SELECT category, subcategory, SUM(amount) AS Total FROM orderdetails
GROUP BY category, subcategory ORDER BY Total DESC;

--How many phones total were purchased 
SELECT orderdetails.subcategory, SUM(orderdetails.quantity) FROM orderdetails 
WHERE subcategory = 'Phones' GROUP BY orderdetails.subcategory;

--Percentage of orders placed that increased profit
SELECT COUNT(CASE WHEN orderdetails.profit > 0 THEN 1 END) * 100/COUNT(*) 
AS percentage_up, COUNT(CASE WHEN orderdetails.profit < 0 THEN 1 END) * 100/COUNT(*) 
AS percentage_down FROM orderdetails;




-- Data involving both tables

--Customers and their order totals 
SELECT List_Of_Orders.orderid AS OrderID, list_of_orders.customername AS Customer, 
SUM(OrderDetails.Amount) AS TotalSpent FROM List_Of_Orders JOIN OrderDetails 
ON List_Of_Orders.orderid = OrderDetails.orderid
GROUP BY list_of_orders.customername, List_Of_Orders.orderid
ORDER BY list_of_orders.orderid;

--How much profit was made from all purchases in the year 2018.
SELECT SUM(orderdetails.profit) AS Total_Profit FROM orderdetails JOIN list_of_orders
ON orderdetails.orderid = list_of_orders.orderid
WHERE orderdate LIKE '%-2018';

--How much profit was made from all purchases in the year 2019.
SELECT SUM(orderdetails.profit) AS Total_Profit FROM orderdetails JOIN list_of_orders
ON orderdetails.orderid = list_of_orders.orderid
WHERE orderdate LIKE '%-2019';

--Top 10 locations that profited the most from clothing
SELECT list_of_orders.city, list_of_orders.state, SUM(orderdetails.profit) AS Profit 
FROM list_of_orders JOIN orderdetails ON list_of_orders.orderid = orderdetails.orderid 
GROUP BY list_of_orders.city, list_of_orders.state ORDER BY Profit DESC Limit 10;

--Percentage of all purchase that were made in 2018 vs. 2019
SELECT COUNT(CASE WHEN list_of_orders.orderdate LIKE '%-2018' THEN 1 END) * 100/COUNT(*) AS Percentage_2018,
COUNT(CASE WHEN list_of_orders.orderdate LIKE '%-2019' THEN 1 END) * 100/COUNT(*) AS Percentage_2019
FROM list_of_orders JOIN orderdetails ON list_of_orders.orderid = orderdetails.orderid;

--Least to Greatest category in the summer months in 2018 (profit)
SELECT orderdetails.category, SUM(orderdetails.profit) AS Total_Profit FROM orderdetails JOIN list_of_orders
ON orderdetails.orderid = list_of_orders.orderid WHERE list_of_orders.orderdate LIKE '%06-2018' OR
list_of_orders.orderdate LIKE '%07-2018' OR list_of_orders.orderdate LIKE '%08-2018' GROUP BY
orderdetails.category ORDER BY Total_profit DESC;

--States and their total profit 
SELECT list_of_orders.state, SUM(orderdetails.profit) AS Total FROM orderdetails JOIN list_of_orders
ON orderdetails.orderid = list_of_orders.orderid GROUP BY list_of_orders.state;

--Which customer spent the most money
SELECT list_of_orders.customername, SUM(orderdetails.amount) AS total_spent FROM orderdetails 
JOIN list_of_orders ON orderdetails.orderid = list_of_orders.orderid GROUP BY list_of_orders.customername
ORDER BY total_spent DESC LIMIT 1;

--Which customer spent the least amount of money
SELECT list_of_orders.customername, SUM(orderdetails.amount) AS total_spent FROM orderdetails 
JOIN list_of_orders ON orderdetails.orderid = list_of_orders.orderid GROUP BY list_of_orders.customername
ORDER BY total_spent LIMIT 1;
