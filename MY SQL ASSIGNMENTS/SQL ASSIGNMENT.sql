USE `classicmodels`;
# Day 3.1
select customerNumber,customername,state,creditlimit from customers where state is NOT NULL AND creditlimit >50000 and creditlimit < 100000 order by creditlimit desc;

# Day 3.2
select DISTINCT productline from products where productline like '%cars' ;

# Day 4.1
SELECT ordernumber, status, CASE WHEN comments IS NULL THEN '_'  ELSE comments END AS comments FROM orders WHERE status = 'shipped';

# Day 4.2
SELECT employeeNumber,firstname,jobtitle,
         CASE
             WHEN jobtitle = 'President' THEN 'P'
             WHEN jobtitle LIKE '%Sales Manager%' THEN 'SM'
             WHEN jobtitle LIKE '%Sale Manager%' THEN 'SM'
             WHEN jobtitle = 'Sales Rep' THEN 'SR'
             WHEN jobtitle LIKE '%VP%' THEN 'VP'
             ELSE jobtitle -- Default case
         END AS job_title_abbreviation
     FROM employees;
     
# Day 5.1
select YEAR(paymentDate) as Year ,MIN(amount) as Amount from payments GROUP BY YEAR(paymentDate);

# Day 5.2
SELECT YEAR(orderDate) as Year, CONCAT('Q',QUARTER(orderDate)) as Quarter,COUNT(DISTINCT customerNumber) 
as unique_customers,COUNT(orderNumber) as total_orders FROM orders GROUP BY YEAR(orderDate), Quarter;

# Day 5.3
SELECT DATE_FORMAT(paymentDate, '%b') AS Month,CONCAT(FORMAT(SUM(amount)/1000,'0.0'),'K') 
AS Formatted_Amount FROM payments GROUP BY Month HAVING SUM(amount) BETWEEN 500000 AND 1000000 ORDER BY SUM(amount) DESC;

# Day 6.1 
create table Journey(Bus_ID integer NOT NULL,Bus_Name varchar(45) NOT NULL,Source_Station varchar(45) NOT NULL,Email varchar (45) UNIQUE);
desc journey;

# Day 6.2
create table Vendor(Vendor_ID integer UNIQUE NOT NULL,Name varchar(45) NOT NULL,Email varchar(45) UNIQUE,Country varchar(45) DEFAULT "N/A");
desc Vendor;

# Day 6.3
Create table movies(Movie_ID integer UNIQUE NOT NULL,Name varchar (45) NOT NULL,Release_Year varchar (10) DEFAULT "-",Cast varchar(45) NOT NULL,
Gender ENUM("MALE","FEMALE"),No_Of_Shows integer check(No_Of_Shows > 0));
desc Movies;

# Day 6.4
CREATE TABLE Suppliers (supplier_id INT AUTO_INCREMENT PRIMARY KEY,supplier_name VARCHAR(255),location VARCHAR(255));
desc Suppliers;
create table Product(product_id integer AUTO_INCREMENT PRIMARY KEY,product_name varchar(255) UNIQUE NOT NULL,
description TEXT,supplier_id INT, FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id));
desc product;

# Day 7.1
SELECT e.employeeNumber as Employee_Number, CONCAT(e.firstName, ' ', e.lastName) 
as 
	Sales_Person, COUNT(DISTINCT c.customerNumber) as Unique_Customers 
FROM 
	Employees e 
LEFT JOIN 
Customers c 
ON 
e.employeeNumber = c.salesRepEmployeeNumber GROUP BY e.employeeNumber, Sales_Person ORDER BY Unique_Customers DESC;

# Day 7.2
SELECT c.customerNumber as Customer_Number, customerName,p.productCode as Product_Code,productName,SUM(od.quantityOrdered) as Total_Quantities,
	SUM(p.quantityInStock) as Total_Quantities_In_Stock,SUM(od.quantityOrdered) - (-SUM(p.quantityInStock)) as Left_Over_Quantities
    FROM
		Customers c
	JOIN
		Orders o
    ON
		c.customerNumber = o.customerNumber
    JOIN
		Orderdetails od
    ON
		o.orderNumber = od.orderNumber
    JOIN
		Products p
    ON
		od.productCode = p.productCode
    GROUP BY
		Customer_Number, Product_Code
    ORDER BY
		Customer_Number;

# Day 7.3
create table Laptop (Laptop_Name Varchar(255));
insert into Laptop (Laptop_Name) Values('Laptop A'),("Laptop B"),("Laptop C");
Create table Colours (colour_Name Varchar(255));
insert into Colours (Colour_Name) Values('Red'),("Blue"),("Green");
SELECT l.Laptop_Name, c.Colour_Name
    FROM Laptop l
    CROSS JOIN Colours c;
    
# Day 7.4 
CREATE TABLE Project ( EmployeeID INT, FullName VARCHAR(255), Gender VARCHAR(10), ManagerID INT);
INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);

SELECT E.FullName AS Employee_Name, M.FullName AS Manager_Name
    FROM Project E
    LEFT JOIN
    Project M
    ON E.ManagerID = M.EmployeeID;
    
# Day 8
create table facility ( Facility_ID INT, Name VARCHAR(255), State VARCHAR(255), Country VARCHAR(255) );
alter table facility MODIFY COLUMN Facility_ID INT AUTO_INCREMENT PRIMARY KEY FIRST;
alter table facility ADD COLUMN city VARCHAR(255) NOT NULL AFTER Name;
desc facility;

# Day 9
create table university ( ID INT, Name VARCHAR(255) );
INSERT INTO university
    VALUES
    (1, "       Pune          University     "),
    (2, "  Mumbai          University     "),
    (3, "     Delhi   University     "),
    (4, "Madras University"),
    (5, "Nagpur University");
update university set name = replace(name, ' ' , '' );
UPDATE university SET Name = REPLACE(Name, 'University', ' University');
select * from university;

# Day 10
Create table productStatus(Year integer ,Value Integer);
insert into ProductStatus values (2003 , 1421),(2004 , 1052), (2005 , 523);
Select * from ProductStatus;

CREATE VIEW Products_Status AS
    SELECT
    Year,
    SUM(Value) AS TotalProductsSold,
    CONCAT(ROUND(SUM(Value) * 100.0 / SUM(SUM(Value)) OVER (), 0), '%') AS PercentageOfTotalValue
    FROM ProductStatus
    GROUP BY Year;
Select Year,concat(TotalProductsSold, " " ,"(",PercentageOfTotalValue,")") as Value from Products_Status;

# Day 11.1

/* Stored Procedure
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCustomerLevel`(IN input_customerNumber INT)
BEGIN
    DECLARE customer_level VARCHAR(50);
    
    SELECT
        CASE
            WHEN creditLimit > 100000 THEN 'Platinum'
            WHEN creditLimit BETWEEN 25000 AND 100000 THEN 'Gold'
            WHEN creditLimit < 25000 THEN 'Silver'
            ELSE 'Unknown'
        END INTO customer_level
    FROM Customers
    WHERE customerNumber = input_customerNumber;
    
    SELECT customer_level AS CustomerLevel;
END
*/
CALL GetCustomerLevel(114);

# Day 11.2
/*
Stored Procedure:-

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_country_payments`(p_year int, p_country varchar(50))
BEGIN
select year(paymentdate) as Paymentyear, country as customercountry, concat(format(sum(amount)/ 1000,0), 'K') As TotalAmount from payments
join
customers on 
payments.customernumber = customers.customernumber
where
year(paymentdate) = p_year and country = p_country
group by paymentyear, customercountry;
END
*/
call get_country_payments(2003,'France');

# Day 12.1
SELECT YEAR(orderDate) AS `YEAR`,monthname(orderDate) AS MONTH, COUNT(orderNumber) AS `TOTAL ORDERS`, 
concat(Round((COUNT(orderNumber)/(LAG(COUNT(orderNumber)) OVER(ORDER BY YEAR(orderDate),month(month) )))*100-100,0),'%') AS `% YoY Change`
FROM ORDERS GROUP BY `YEAR`,month ORDER BY  `YEAR`,month(month) ;

# Day 12.2
CREATE TABLE emp_udf ( Emp_ID INT AUTO_INCREMENT PRIMARY KEY, Name VARCHAR(255), DOB DATE );
INSERT INTO emp_udf (Name, DOB)
    VALUES
		("Piyush", "1990-03-30"),
		("Aman", "1992-08-15"),
		("Meena", "1998-07-28"),
		("Ketan", "2000-11-21"),
		("Sanjay", "1995-05-21");
        
/*
Stored Procedures:>

CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_age`(dob date) RETURNS varchar(50) CHARSET latin1
    DETERMINISTIC
begin
    declare years int;
    declare months int;
    declare age varchar(50);

    set years = timestampdiff(year, dob, curdate());
    set months = timestampdiff(month, dob, curdate()) - (years * 12);
    
    set age = concat(years, ' years ', months, ' months');
    
    return age;
end
*/
SELECT Emp_ID, Name, DOB, calculate_age(DOB) AS Age FROM emp_udf;

# Day 13.1
SELECT customerNumber, customerName FROM Customers WHERE customerNumber NOT IN (SELECT customerNumber FROM Orders);

# Day 13.2
#Create a temporary table to store the results of the left outer join

CREATE TEMPORARY TABLE LeftJoinResult AS
    SELECT
		c.customerNumber,
		c.customerName,
		COUNT(o.orderNumber) AS OrderCount
    FROM
		Customers c
    LEFT JOIN
		Orders o ON c.customerNumber = o.customerNumber
    GROUP BY
		c.customerNumber, c.customerName;

# Create a temporary table to store the results of the right outer join
CREATE TEMPORARY TABLE RightJoinResult AS
    SELECT
		o.customerNumber,
		c.customerName,
		COUNT(o.orderNumber) AS OrderCount
    FROM
		Customers c
    RIGHT JOIN
		Orders o ON c.customerNumber = o.customerNumber
    GROUP BY
		o.customerNumber, c.customerName;
        
# Combine the results of left and right joins using UNION
SELECT * FROM LeftJoinResult
    UNION
    SELECT * FROM RightJoinResult;
    
# Day 13.3
select * from orderdetails;

SELECT OrderNumber,Quantityordered AS SecondHighestQuantity
    FROM(SELECT OrderNumber,Quantityordered,ROW_NUMBER() OVER (PARTITION BY OrderNumber ORDER BY Quantityordered DESC) AS rn
    FROM Orderdetails) AS RankedData WHERE rn = 2;

# Day 13.4
select max(productcount) as max,min(productcount) as min from (select ordernumber,count(*) as productcount from orderdetails group by ordernumber) as counts;

# Day 13.5
SELECT ProductLine, COUNT(*) AS Count
    FROM Products
    WHERE BuyPrice > (SELECT AVG(BuyPrice) FROM Products)
    GROUP BY ProductLine;
    
# Day 14 
Create table Emp_EH(EmpID int primary key,EmpName varchar(255),EmailAddress varchar(255));
desc Emp_EH;

/*
PROCEDURE>
DELIMITER //
CREATE PROCEDURE InsertEmpDataWithExceptionHandling(
    IN p_EmpID INT,
    IN p_EmpName VARCHAR(255),
    IN p_EmailAddress VARCHAR(255))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error occurred';
    END;

    INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress) VALUES (p_EmpID, p_EmpName, p_EmailAddress);
END;
//
DELIMITER ;
*/

# Day 15
create table Emp_BIT(Name varchar(255) not null,Occupation varchar(255) not null,Working_date date,Working_hours int);
insert into Emp_BIT values
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11),
('Yash', 'Scientist', '2020-10-05', -12);

/* DELIMITER $$
CREATE TRIGGER before_insert_working_hours
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
  IF NEW.working_hours < 0 THEN
    SET NEW.working_hours = -NEW.working_hours;
  END IF;
END $$
DELIMITER ; */

insert into Emp_BIT values('Rishi', 'Scientist', '2020-10-05', -12);
Select * from Emp_BIT;






