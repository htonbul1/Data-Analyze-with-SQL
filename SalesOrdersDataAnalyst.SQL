USE SalesOrdersExample;
SELECT * FROM  Customers;

-- List customers in TX
SELECT CONCAT(custFirstname,' ', custLastName) as FullName , custCity from Customers
WHERE CustState = 'TX' 
ORDER BY FullName;

Select * from Products;
-- What is the total value of each products in my INV?
SELECT Productname, retailprice*quantityonhand as TotalValue from Products
ORDER BY TotalValue DESC;

SELECT * FROM Orders;
--  the orders given in Oct of 2017
SELECT * FROM Orders WHERE OrderDate >= '2017-10-01' AND OrderDate <= '2017-10-31' ;
SELECT * FROM Orders WHERE YEAR(OrderDate) = 2017 AND MONTH(OrderDate) = 10;

-- List the orders in Oct of 2017 with their order days and shipment day
Select orderNumber, DAY(OrderDate), DAY(ShipDate) as SiparisGün from Orders 
 WHERE YEAR(OrderDate) = 2017 AND MONTH(OrderDate) = 10 ;
 
 -- List order dates as year- month - day
SELECT orderNumber, orderDate, YEAR(OrderDate), MONTH(OrderDate), DAYOFWEEK(OrderDate) from Orders;

-- List the name ofour products and their categories
SELECT * FROM  products
LEFT OUTER JOIN Categories
ON Products.CategoryID = categories.CategoryID;

SELECT ProductName,CategoryDescription FROM  products
LEFT OUTER JOIN Categories
ON Products.CategoryID = categories.CategoryID;

-- List each order with their order date and customer name
SELECT Orders.*, CONCAT(CustFirstName ,' ', CustLastName) AS CustName FROM Orders 
LEFT OUTER JOIN Customers
ON Orders.CustomerID = Customers.CustomerID;

-- List the products that are shipped on 2017-10-01
SELECT ShipDate, Products.productNumber, ProductName, QuantityOrdered FROM order_details
LEFT OUTER JOIN Products
on order_details.productNumber = Products.productNumber
LEFT OUTER JOIN Orders
ON orders.orderNumber=order_details.orderNumber
WHERE ShipDate = '2017-10-01';

-- 'Cosmic Elite Road Warrior Wheels' Customers
Select DISTINCT CONCAT(CustFirstName, ' ' ,CustLastName) AS CustName from Order_details A
LEFT OUTER JOIN Products B ON A.productNumber = B.productNumber
LEFT OUTER JOIN Orders C ON A.orderNumber = C.orderNumber
LEFT OUTER JOIN Customers D ON C.CustomerID = D.CustomerID
WHERE ProductName = 'Cosmic Elite Road Warrior Wheels'
order by CustName ;


-- List the vendors who supplied as bikes
SELECT ProductName, VendName, WholesalePrice FROM product_vendors A
LEFT OUTER JOIN products B ON A.ProductNumber =  B.ProductNumber
LEFT OUTER JOIN vendors C ON A.VendorID = C.VendorID 
LEFT OUTER JOIN Categories D On D.CategoryID = B.CategoryID
WHERE CategoryDescription = 'Bikes';


SELECT * FROM Categories;
INSERT INTO Categories(categoryID, CategoryDescription)
VALUES (7, 'Food');

INSERT INTO customers(customerID,CustFirstName,CustLastName, CustPhoneNumber)
VALUES(1029,'Tarik', 'Kucukdeniz','5555523');
select * from customers;

-- UPDATE
UPDATE Customers SET CustCity = 'Istanbul' WHERE CustomerID = 1029;
UPDATE customers Set CustState = 'NTX' WHERE CustState = 'TX';

SELECT * FROM Products;

/* Increase the price of products in bikes category 10% */
UPDATE Products, categories SET RetailPrice = RetailPrice*1.1 
WHERE Products.CategoryID = categories.CategoryID
AND CategoryDescription = 'Bikes';

-- List products in the Bikes category
SELECT * FROM Products A
LEFT OUTER JOIN Categories B
ON A.CategoryID = B.CategoryID
WHERE CategoryDescription = 'Bikes';

-- Delete customer with ID 1029
DELETE from customers WHERE CustomerID=1029;

/* How many customers are there in each state? */
SELECT CustState, Count(*) FROM Customers
GROUP BY CustState;

/* How many orders has given on each day? */
SELECT dayofweek(OrderDate), count(*) FROM orders
group by dayofweek(OrderDate);

/* How many orders has been given by each customer */
SELECT orders.customerID, custFirstName, CustLastName, count(*) 
FROM Orders A
LEFT OUTER JOIN Customers B
ON A.CustomerID = B.CustomerID
group by A.customerID, custFirstName, CustLastName;

/* How many products are there in each category? */
SELECT CategoryDescription, COUNT(*)  FROM products A
LEFT OUTER JOIN Categories B
ON A.CategoryID = B.CategoryID
group by CategoryDescription;

/* How many items are there in our inventory fot each category */
SELECT CategoryDescription,SUM(QuantityOnHand)  FROM products A
LEFT OUTER JOIN Categories B
ON A.CategoryID = B.CategoryID
group by CategoryDescription;

/* How many items are sold for each products */
SELECT ProductName, sum(QuantityOrdered) as ToplamSatisAdet
FROM order_details A
LEFT OUTER JOIN products B
ON A.ProductNumber = B.ProductNumber
group by ProductName
order by ToplamSatisAdet desc;

/* What is the average basket size? */
select OrderNumber, SUM(QuotedPrice*QuantityOrdered), COUNT(productnumber), SUM(QuantityOrdered) from order_details A
GROUP BY  OrderNumber;

/* Report the total sales of each product in 2017 */
Select A.ProductNumber, ProductName, SUM(QuotedPrice * QuantityOrdered) AS TotalSales 
from Order_Details A 
LEFT OUTER JOIN orders B ON A.ordernumber = B.ordernumber
LEFT OUTER JOIN Products C ON A.Productnumber = C.productNumber
WHERE YEAR(OrderDate) = 2017
group by A.productNumber, ProductName
Order By TotalSales desc;

/* Total sales for each year */
select year(OrderDate) , sum(QuotedPrice * QuantityOrdered) 
FROM order_details A
LEFT OUTER JOIN Orders B On A.ordernumber = B.ordernumber
group by year(OrderDate);

/* List the total number customers for each employee */
select B.EmployeeID, CONCAT(EmpFirstName, ' ' , EmpLastName) AS Employee , Count(CustomerID) from orders A
LEFT OUTER JOIN employees B ON A.EmployeeID = B.EmployeeID
group by B.EmployeeID, Employee
order by Count(CustomerID) desc;

/* List the number of product in each category */
SELECT CategoryDescription, COUNT(*)  FROM products A
LEFT OUTER JOIN Categories B
ON A.CategoryID = B.CategoryID
group by CategoryDescription;

/* List the categories what have more than 10 products */
SELECT CategoryDescription, COUNT(*) FROM products A
LEFT OUTER JOIN Categories B
ON A.CategoryID = B.CategoryID
GROUP by CategoryDescription
HAVING count(*) > 10;

-- List employees who deal with more than 120 customers
select B.EmployeeID, CONCAT(EmpFirstName, ' ' , EmpLastName) AS Employee , Count(CustomerID) from orders A
LEFT OUTER JOIN employees B ON A.EmployeeID = B.EmployeeID
group by B.EmployeeID, Employee
HAVING Count(CustomerID) > 120
order by Count(CustomerID) desc;

-- List the customer from TX state, that have a total sales greater than 100000 
Select B.CustomerID, CustFirstName, CustLastName, sum(QuotedPrice * QuantityOrdered) as Total 
FROM order_details A 
LEFT OUTER JOIN Orders B on A.OrderNumber = B.OrderNumber
LEFT OUTER JOIN Customers C ON B.CustomerID = C.CustomerID
WHERE CustState = 'TX'
GROUP BY B.CustomerID, CustFirstName, CustLastName
HAVING Total > 100000;


-- How many products are coming from each vendor 
SELECT A.VendorID, VendName, Count(ProductNumber) FROM product_vendors A
LEFT OUTER JOIN Vendors B ON A.VendorID = B.VendorID
group by VendorID, VendName
HAVING Count(ProductNumber) > 5
Order by Count(ProductNumber) desc ;

-- List sellers average delivery time
SELECT VendName, AVG(daystodeliver) FROM product_vendors A
LEFT OUTER JOIN Vendors B ON A.VendorID = B.VendorID
group by VendName;

-- List sellers average, minimum, maximum delivery time
SELECT VendName, COUNT(ProductNumber), AVG(daystodeliver),
MIN(daystodeliver), MAX(daystodeliver) FROM product_vendors A
LEFT OUTER JOIN Vendors B ON A.VendorID = B.VendorID
group by VendName;

-- List average, maximum, minimum delivery time of single vendors
SELECT ProductName, AVG(daystodeliver),
MIN(daystodeliver), MAX(daystodeliver), COUNT(VendorID) FROM product_vendors A
LEFT OUTER JOIN Products B ON A.ProductNumber = B.ProductNumber
Group BY ProductName
HAVING COUNT(VendorID) = 1
ORDER BY AVG(daystodeliver) desc;

-- Report the avarege product price for each category  
SELECT CategoryDescription ,AVG(RetailPrice) FROM Products A 
LEFT OUTER JOIN Categories B ON A.CategoryID = B.CategoryID
GROUP BY CategoryDescription
order by AVG(RetailPrice) desc;

-- Which clothing categories products are more expensive than the average priceof clothing category 
SELECT * FROM Products A
LEFT OUTER JOIN Categories B 
ON A.CategoryID = b.CategoryID
where CategoryDescription = 'Clothing'
AND RetailPrice >
(SELECT AVG(RetailPrice) 
FROM Products A
LEFT OUTER JOIN Categories B 
ON A.CategoryID = b.CategoryID
where CategoryDescription = 'Clothing');

-- List sellers who supply above average lead time in the Bikes category
SELECT VendName, productname, DaysToDeliver FROM product_vendors A
Left outer join products B ON A.productNumber = B.productnumber
LEFT OUTER JOIN Categories C ON B.CategoryID = C.CategoryID
LEFT outer JOIN vendors D ON A.vendorID = D.VendorID
WHERE CategoryDescription = 'Bikes' and 
DaysToDeliver < (SELECT avg(daystodeliver) FROM product_vendors A
Left outer join products B ON A.productNumber = B.productnumber
LEFT OUTER JOIN Categories C ON B.CategoryID = C.CategoryID
LEFT outer JOIN vendors D ON A.vendorID = D.VendorID);

-- List the order details of the best salling product in Sept. 2017
CREATE VIEW v_alldata as
SELECT A.Quotedprice, A.quantityordered, orderdate, shipdate, CategoryDescription, C.*, E.* FROM Order_Details A 
LEFT OUTER JOIN Orders B ON A.OrderNumber = B.OrderNumber
Left outer join products C ON A.productNumber = C.productnumber
LEFT OUTER JOIN Categories D ON C.CategoryID = D.CategoryID
LEFT OUTER JOIN Customers E ON B.CustomerID = E.CustomerID;

-- VIEW
CREATE VIEW v_CategoriedProducts as
SELECT A.*, B.CategoryDescription
FROM Products A 
LEFT OUTER JOIN Categories B
ON A.CategoryID = B.CategoryID;

-- List the order details of Sept. 2017
Select * from v_alldata
WHERE MONTH(orderdate) = 9 and YEAR(orderdate) = 2017;

-- List the number of sales each product that has been sold in 09.2017 
Select ProductName, SUM(Quantityordered) as adet from v_alldata
WHERE MONTH(orderdate) = 9 and YEAR(orderdate) = 2017
Group BY ProductName  
order by adet desc;

-- List clients who pay more than Andrew Cencini  
SELECT CustFirstName, custLastName, CustomerID, SUM(Quotedprice*quantityordered) AS toplam_satis 
FROM v_alldata
GROUP BY CustFirstName, custLastName, CustomerID
HAVING SUM(Quotedprice*quantityordered) > (
SELECT SUM(Quotedprice*quantityordered) 
FROM v_alldata
WHERE CustFirstName = 'Andrew' and custLastName = 'Cencini'
GROUP BY CustFirstName, custLastName, CustomerID);

/* List customers who ordered bikes */
SELECT DISTINCT CustFirstName, custLastName FROM v_alldata 
WHERE categorydescription = 'Bikes';

/*Display customers who ordered clothing or accessories */
SELECT DISTINCT CustFirstName, custLastName FROM v_alldata 
WHERE categorydescription = 'clothing' or categorydescription = 'accessories';

/* Display customers who ordered clothing and accessories */
SELECT DISTINCT CustFirstName, custLastName FROM v_alldata 
WHERE categorydescription = 'clothing'
AND CustomerID IN (
Select CustomerID FROM v_alldata
where  categorydescription = 'accessories');

/* Bisiklet ve kıyafet alıp aksesuar almayan */
SELECT DISTINCT CustFirstName, custLastName FROM v_alldata 
WHERE categorydescription = 'clothing' 
AND CustomerID IN (
Select CustomerID FROM v_alldata
where  categorydescription = 'Bikes')
AND CustomerID NOT IN (
Select CustomerID FROM v_alldata
where categorydescription = 'Accessories');

/* Bisiklet, kıyafet ve aksesuar alan */
SELECT DISTINCT CustFirstName, custLastName FROM v_alldata 
WHERE categorydescription = 'clothing' 
AND CustomerID IN (
Select CustomerID FROM v_alldata
where  categorydescription = 'Bikes')
AND CustomerID IN (
Select CustomerID FROM v_alldata
where categorydescription = 'Accessories');

/* List unsold products */
SELECT * FROM Products
where ProductNumber NOT IN (
select ProductNumber FROM order_details);

/* List the number of orders received for bicycles and helmets in the same order (Basket Analysis) */
SELECT COUNT(ordernumber) FROM order_details A
LEFT OUTER JOIN products B ON A.ProductNumber = B.ProductNumber
LEFT OUTER JOIN  Categories C ON B.CategoryID = C.CategoryID
WHERE CategoryDescription = 'Bikes'
AND OrderNumber IN (
SELECT ordernumber FROM order_details A
LEFT OUTER JOIN products B ON A.ProductNumber = B.ProductNumber
WHERE ProductName LIKE '%helmet%');


