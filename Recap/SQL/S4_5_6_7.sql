

--CTE's


--Ordinary CTE's

--List customers who have an order prior to the last order of a customer named Sharyn Hopkins 
--and are residents of the city of San Diego.

SELECT *
FROM sales.customers C, sales.orders D
WHERE C.customer_id = D.customer_id
AND C.city = 'San Diego'
AND D.order_date < (
	SELECT MAX(B.order_date)
	FROM sales.customers A, sales.orders B
	WHERE A.customer_id = b.customer_id
	AND A.first_name = 'Sharyn' AND A.last_name = 'Hopkins'
	)

--with CTE

WITH T1 AS
(
	SELECT	MAX(B.order_date) LAST_ORDER
	FROM	sales.customers A, sales.orders B
	WHERE	A.customer_id = b.customer_id
	AND		A.first_name = 'Sharyn' AND A.last_name = 'Hopkins'
)
SELECT	
FROM	sales.customers A, sales.orders B, T1 C
WHERE	A.customer_id = B.customer_id
AND		B.order_date < LAST_ORDER
AND		A.city = 'San Diego'



----------------

--Recursive CTE's

-- Create a table with each digit from 0 to 9 on one line.

SELECT 0 

SELECT 0 number

SELECT 0 number
UNION ALL
SELECT 1

WITH T1 AS
(
SELECT 0 number
UNION ALL
SELECT 1
)
SELECT * FROM T1
--

WITH T1 AS
(
SELECT 0 number
UNION ALL
SELECT number +1
FROM	T1
WHERE	number<9
)
SELECT * FROM T1



--CTE with new table Values

WITH Users As
(
SELECT * 
FROM (
		VALUES 
				(1,'start', CAST('01-01-20' AS date)),
				(1,'cancel', CAST('01-02-20' AS date)), 
				(2,'start', CAST('01-03-20' AS date)), 
				(2,'publish', CAST('01-04-20' AS date)), 
				(3,'start', CAST('01-05-20' AS date)), 
				(3,'cancel', CAST('01-06-20' AS date)), 
				(1,'start', CAST('01-07-20' AS date)), 
				(1,'publish', CAST('01-08-20' AS date))
		) as table_1 ([user_id], [action], [date])
)
SELECT * FROM Users



--------------------------///////////////////////////////////////

--UNION / UNION ALL


--List Customer's last names in Sacramento and Monroe 

SELECT	last_name
FROM	sales.customers
WHERE	city = 'Sacramento'

UNION ALL

SELECT	last_name
FROM	sales.customers
WHERE	city = 'Monroe'



--2ND WAY
SELECT	last_name
FROM	sales.customers
WHERE	city IN ('Sacramento', 'Monroe')



--UNION --returns unique values

SELECT	last_name
FROM	sales.customers
WHERE	city = 'Sacramento'

UNION

SELECT	last_name
FROM	sales.customers
WHERE	city = 'Monroe'

----


SELECT	first_name, last_name
FROM	sales.customers
WHERE	city = 'Sacramento'

UNION

SELECT	first_name, last_name
FROM	sales.customers
WHERE	city = 'Monroe'



--

SELECT	city, 'STATE' AS STATE
FROM	sales.stores

UNION ALL

SELECT	state, 'BALDWIN' as city
FROM	sales.stores

----------

SELECT	city, 'STATE' AS STATE
FROM	sales.stores

UNION ALL

SELECT	state, 1 as city
FROM	sales.stores


-------------------///////////////////////////////////////


--INTERSECT

-- Write a query that returns brands that have products for both 2016 and 2017.



SELECT	brand_id 
FROM	production.products
WHERE	model_year= 2016

INTERSECT

SELECT	brand_id
FROM	production.products
WHERE	model_year= 2017
ORDER BY brand_id DESC



---------------

SELECT *
FROM	production.brands
WHERE	brand_id IN (
					SELECT	brand_id 
					FROM	production.products
					WHERE	model_year= 2016

					INTERSECT

					SELECT	brand_id
					FROM	production.products
					WHERE	model_year= 2017
					) 


--Write a query that returns customers who have orders for both 2016, 2017, and 2018

SELECT	first_name, last_name
FROM	sales.customers
WHERE	customer_id IN (
						SELECT	customer_id
						FROM	sales.orders
						WHERE	order_date BETWEEN '2016-01-01' AND '2016-12-31'

						INTERSECT

						SELECT	customer_id
						FROM	sales.orders
						WHERE	order_date BETWEEN '2017-01-01' AND '2017-12-31'

						INTERSECT

						SELECT	customer_id
						FROM	sales.orders
						WHERE	order_date BETWEEN '2018-01-01' AND '2018-12-31'
						)



--///////////////////////////////////////


--EXCEPT

--Write a query that returns brands that have a 2016 model product but not a 2017 model product.


SELECT *
FROM	production.brands
WHERE brand_id IN (
					SELECT	brand_id
					FROM	production.products
					WHERE	model_year= 2016

					EXCEPT

					SELECT	brand_id
					FROM	production.products
					WHERE	model_year = 2017
				)



-- Write a query that returns only products ordered in 2017 (not ordered in other years).

SELECT	*
FROM	sales.orders A


SELECT	product_id, product_name
FROM	production.products
WHERE	product_id IN (
					SELECT	DISTINCT B.product_id
					FROM	sales.orders A, sales.order_items B
					WHERE	A.order_id= B.order_id
					AND		A.order_date BETWEEN '2017-01-01' AND '2017-12-31'

					EXCEPT

					SELECT	DISTINCT B.product_id
					FROM	sales.orders A, sales.order_items B
					WHERE	A.order_id= B.order_id
					AND		A.order_date NOT BETWEEN '2017-01-01' AND '2017-12-31'
					)

---------///////////////////////////////////////


--Write a query that returns State where 'Trek Remedy 9.8 - 2017' product is not ordered


SELECT	E.[state], COUNT (D.product_id) count_of_products
FROM
		(
		SELECT	C.order_id, C.customer_id, B.product_id
		FROM	production.products A, sales.order_items B, sales.orders C
		WHERE	A.product_id = B.product_id
		AND		B.order_id = C.order_id
		AND		A.product_name = 'Trek Remedy 9.8 - 2017'
		) D
RIGHT JOIN sales.customers E ON E.customer_id = D.customer_id
GROUP BY
		E.[state]
HAVING
		COUNT (D.product_id) = 0


----
--new approach


SELECT distinct state
FROM
SALES.customers X
WHERE NOT EXISTS
(
SELECT	D.STATE
FROM	production.products A, sales.order_items B, sales.orders C, sales.customers D
WHERE	A.product_id = B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = 'Trek Remedy 9.8 - 2017'
AND		D.STATE = X.STATE
) 



---

SELECT STATE
FROM	sales.customers

EXCEPT

SELECT	D.STATE
FROM	production.products A, sales.order_items B, sales.orders C, sales.customers D
WHERE	A.product_id = B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = 'Trek Remedy 9.8 - 2017'



--------------------------------------


---------///////////////////////////////////////


--CASE EXPRESSION

-- Generate a new column containing what the mean of the values in the Order_Status column.

-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed

SELECT  order_status,
		CASE order_status WHEN 1 THEN 'Pending'
						  WHEN 2 THEN 'Processing'
						  WHEN 3 THEN 'Rejected'
						  WHEN 4 THEN 'Completed'
		END AS MEANOFSTATUS
FROM	sales.orders


-- Create a new column containing the labels of the customers' email service providers ( "Gmail", "Hotmail", "Yahoo" or "Other" )



SELECT	first_name, last_name, email, CASE
				WHEN email LIKE '%@gmail.%' THEN 'Gmail' 
				WHEN email LIKE '%@hotmail.%' THEN 'Hotmail'
				WHEN email LIKE '%@yahoo.%' THEN 'Yahoo'
				WHEN email IS NOT NULL THEN 'Other'
			ELSE NULL END email_service_provider
FROM	sales.customers;






-- List customers who bought both 'Electric Bikes' and 'Comfort Bicycles' and 'Children Bicycles' in the same order.
--SET OPERATORS


SELECT	A.customer_id, A.first_name, A.last_name
FROM	sales.customers A, sales.orders B
WHERE	A.customer_id = B.customer_id
AND		B.order_id IN (
					SELECT	B.order_id
					FROM	production.products A, sales.order_items B
					WHERE	A.product_id = B.product_id
					AND		A.category_id = (
												SELECT	category_id
												FROM	production.categories
												WHERE	category_name = 'Electric Bikes'
											)
					INTERSECT
					SELECT	B.order_id
					FROM	production.products A, sales.order_items B
					WHERE	A.product_id = B.product_id
					AND		A.category_id = (
												SELECT	category_id
												FROM	production.categories
												WHERE	category_name = 'Comfort Bicycles'
											)
					INTERSECT
					SELECT	B.order_id
					FROM	production.products A, sales.order_items B
					WHERE	A.product_id = B.product_id
					AND		A.category_id = (
												SELECT	category_id
												FROM	production.categories
												WHERE	category_name = 'Children Bicycles'
											)
					)


--------------------////////////////////

--Date Functions




CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)


--https://www.mssqltips.com/sqlservertip/1145/date-and-time-conversions-using-sql-server/ 


SELECT *
FROM	t_date_time


INSERT t_date_time (A_time, A_date, A_smalldatetime, A_datetime, A_datetime2, A_datetimeoffset)
VALUES 
('12:00:00', '2021-07-17', '2021-07-17','2021-07-17', '2021-07-17', '2021-07-17' )


-----



INSERT t_date_time (A_time) VALUES (TIMEFROMPARTS(12,00,00,0,0));

INSERT INTO t_date_time (A_date) VALUES (DATEFROMPARTS(2021,05,17));



select convert(varchar, getdate(), 6)


INSERT INTO t_date_time (A_datetime) VALUES (DATETIMEFROMPARTS(2021,05,17, 20,0,0,0));


INSERT INTO t_date_time (A_datetimeoffset) VALUES (DATETIMEOFFSETFROMPARTS(2021,05,17, 20,0,0,0, 2,0,0));


SELECT	A_date,
		DATENAME(DW, A_date) [DAY],
		DAY (A_date) [DAY2],
		MONTH(A_date),
		YEAR (A_date),
		A_time,
		DATEPART (NANOSECOND, A_time),
		DATEPART (MONTH, A_date)
FROM	t_date_time



-------------


SELECT	A_date,	
		A_datetime,
		DATEDIFF (DAY, A_date, A_datetime)
FROM	t_date_time



select	DATEDIFF (DAY, order_date, shipped_date), order_date, shipped_date, DATEDIFF (DAY, shipped_date, order_date)
from	sales.orders
where	order_id = 1


--------------

SELECT	DATEADD (YEAR, 5, order_date), 
		DATEADD (DAY, 5, order_date),
		DATEADD (DAY, -5, order_date),
		order_date
FROM	sales.orders
where	order_id = 1




SELECT	EOMONTH( order_date), order_date
FROM	sales.orders



SELECT	ISDATE( CAST (order_date AS nvarchar)), order_date
FROM	sales.orders


SELECT ISDATE ('1234568779')

SELECT ISDATE ('WHERE')

SELECT ISDATE ('2021-12-02')

SELECT ISDATE ('2021.12.02')


----------------------------

SELECT GETDATE()  --today's date: 2022-01-23 08:45:24.033


SELECT CURRENT_TIMESTAMP


SELECT GETUTCDATE()


-------------------------



SELECT *
FROM	t_date_time


INSERT t_date_time 
VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())


----------------------


/*
Question: Create a new column that contains labels of the shipping speed of products.
If the product has not been shipped yet, it will be marked as "Not Shipped",
If the product was shipped on the day of order, it will be labeled as "Fast".
If the product is shipped no later than two days after the order day, it will be labeled as "Normal"
If the product was shipped three or more days after the day of order, it will be labeled as "Slow".
*/

SELECT *,
		CASE	WHEN order_status <> 4 THEN 'Not Shipped'
				WHEN order_date = shipped_date THEN 'Fast' -- DATEDIFF (DAY, order_date, SHIPPED_DATE) = 0  
				WHEN DATEDIFF (DAY, order_date, SHIPPED_DATE) BETWEEN 1 AND 2 THEN 'Normal'
				ELSE 'Slow'
		END AS ORDER_LABEL
FROM sales.orders





SELECT	*,
		CASE WHEN order_status <> 4 THEN 'Not Shipped'
			 WHEN order_date = shipped_date THEN 'Fast' -- DATEDIFF (DAY, ORDER_DATE, SHIPPED_DATE) = 0
			 WHEN DATEDIFF (DAY, ORDER_DATE, shipped_date) BETWEEN 1 AND 2 THEN 'Normal'
			 ELSE 'Slow'
		END AS ORDER_LABEL,
		DATEDIFF (DAY, ORDER_DATE, shipped_date) datedif
FROM	sales.orders
order by datedif




SELECT	*,
		CASE WHEN order_status <> 4 THEN 'Not Shipped'
			 WHEN DATEDIFF (DAY, ORDER_DATE, shipped_date) = 0 THEN 'Fast'
			 WHEN DATEDIFF (DAY, ORDER_DATE, shipped_date) BETWEEN 1 AND 2 THEN 'Normal'
			 ELSE 'Slow'
		END AS ORDER_LABEL,
		DATEDIFF (DAY, ORDER_DATE, shipped_date) datedif
FROM	sales.orders
order by datedif



-------------------


--Write a query returning orders that are shipped more than two days after the ordered date. 


SELECT *, DATEDIFF(DAY, order_date, shipped_date) DATE_DIFF
FROM	sales.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date) >2


----Write a query that returns the number distributions of the orders in the previous query result, according to the days of the week.



SELECT	SUM(CASE WHEN DATENAME (DW, order_date) = 'Monday' THEN 1 ELSE 0 END) AS MONDAY,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Tuesday' THEN 1 ELSE 0 END) AS Tuesday,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Wednesday' THEN 1 ELSE 0 END) AS Wednesday,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Thursday' THEN 1 ELSE 0 END) AS Thursday,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Friday' THEN 1 ELSE 0 END) AS Friday,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Saturday' THEN 1 ELSE 0 END) AS Saturday,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Sunday' THEN 1 ELSE 0 END) AS Sunday
FROM	sales.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2




--Write a query that returns the order numbers of the states by months.

SELECT	A.state , YEAR(B.order_date) YEARS, MONTH(B.order_date) months, COUNT (DISTINCT order_id) NUM_OF_ORDERS
FROM	SALES.customers A, sales.orders B
WHERE	A.customer_id = B.customer_id
GROUP BY	A.state, YEAR(B.order_date), MONTH(B.order_date) 
ORDER BY	state, YEARS, months


--------///////////////////////---------



--------String Functions  ----------


--LEN

SELECT LEN (123344)

SELECT LEN ( 123344)

SELECT LEN ('WELCOME')

SELECT LEN (' WELCOME')

SELECT LEN ('"WELCOME"')

SELECT '"WELCOME"'


--CHARINDEX

SELECT CHARINDEX ('C', 'CHARACTER')

SELECT CHARINDEX ('C', 'CHARACTER', 2)


SELECT CHARINDEX ('CT', 'CHARACTER')


SELECT CHARINDEX ('ct', 'CHARACTER')



--PATINDEX

SELECT PATINDEX ('R', 'CHARACTER') --RETURNS 0


SELECT PATINDEX ('%R%', 'CHARACTER') --RETURNS 4


SELECT PATINDEX ('%R', 'CHARACTER')  --RETURNS 9


SELECT PATINDEX ('%r', 'CHARACTER') --RETURNS 9


SELECT PATINDEX ('%A____', 'CHARACTER')  --AFTER A, THERE ARE 4 CHARACTER AND THIS QUERY RETURNS 5



--LEFT

SELECT LEFT ('CHARACTER', 3)  ---RETURNS CHA

SELECT LEFT (' CHARACTER', 3)  ---RETURNS ' CH'


--RIGHT


SELECT RIGHT ('CHARACTER', 3)


SELECT RIGHT ('CHARACTER ', 3)


--SUBSTRING


SELECT SUBSTRING ('CHARACTER', 3, 5) --START FROM 3RD AND TAKE 5 CHARACTER --ARACT


SELECT SUBSTRING ('12345689', 3, 5)

SELECT SUBSTRING ('CHARACTER', -1, 5)

SELECT SUBSTRING ('CHARACTER', 0, 5)



--LOWER

SELECT LOWER ('CHARACTER')

--UPPER

SELECT UPPER ('character')

--STRING_SPLIT

SELECT	VALUE
FROM	string_split('John,Sarah,Jack' , ',')

SELECT	VALUE
FROM	string_split('John/Sarah/Jack' , '/')


SELECT	VALUE
FROM	string_split('John//Sarah//Jack' , '/')

SELECT	*
FROM	string_split('John//Sarah//Jack' , '/')



-- character >>>>>> Character



SELECT UPPER (LEFT('character', 1))


select LEN('character')-1


SELECT RIGHT ('character', LEN('character')-1)

--SOLUTION:
SELECT UPPER (LEFT('character', 1)) + RIGHT ('character', LEN('character')-1)


--TRIM

SELECT TRIM(' CHARACTER ')

SELECT TRIM (' CHARACT ER')

SELECT TRIM('./' FROM '/character..') result

---

--LTRIM

SELECT LTRIM(' CHARACTER ')

--RTRIM

SELECT RTRIM(' CHARACTER ')



--REPLACE

SELECT REPLACE ('CHARACTER', 'RAC' , '')


SELECT REPLACE ('CHARACTER', 'RAC' , '/')


--STR

SELECT STR (1234.573, 6, 2)  --RETURN 6 CHARACTER

SELECT STR (1234.573, 7, 1)  -- RETURN 7 CHARACTER, IT ADDS A BLANK TO THE BEGINNING


--JACK_10

SELECT 'JACK' + '_' + '10'


SELECT 'JACK' + '_' + STR (10, 2)


-------------

--CAST

SELECT CAST (123456 AS CHAR(6))

SELECT CAST (123456 AS VARCHAR(10))    

SELECT CAST (123456 AS VARCHAR(10)) + ' CHRIS'   



SELECT CAST (GETDATE() AS DATE)


--CONVERT

SELECT CONVERT (INT, 30.30)


SELECT CONVERT (FLOAT, 30.30)


--COALECE()

SELECT COALESCE(NULL, NULL, 'JACK', 'HANS', NULL) --RETURNS FIRST NON NULL VALUE

--NULLIF

SELECT NULLIF ('JACK', 'JACK')  -- IF THEY ARE EQUAL , THIS RETURNS NULL


SELECT NULLIF ('JACK', 'HANS')  --IF IT IS NOT NULL RETURNS FIRST VALUE		


SELECT first_name
FROM	sales.customers


SELECT NULLIF (first_name, 'Debra')   -- IF FIRST NAME DEBRA, WILL RETURN NULL
from	sales.customers


SELECT	COUNT (NULLIF (first_name, 'Debra')) --DOES NOT COUNT NULL, SO IT RETURNS 1444
from	sales.customers


SELECT	COUNT (*)  --THIS RETURNS 1445
from	sales.customers


--ROUND


SELECT ROUND (432.368, 2, 0)  --2 NUMBERS AFTER POINT

SELECT ROUND (432.368, 2)

SELECT ROUND (432.368, 1, 0)


SELECT ROUND (432.368, 1, 1)

SELECT ROUND (432.300, 1, 1)


SELECT ROUND (432.368, 3, 0)


------------How many yahoo mails in customer’s email column?

select count(*)
from sales.customers
where email like '%yahoo%'

---USE CASE AND PATINDEX

SELECT	SUM (CASE WHEN PATINDEX('%yahoo%', email) > 0 THEN 1 ELSE 0 END) num_of_domain
FROM	SALES.customers



--Write a query that returns the characters before the '.' character in the email column.
SELECT	CHARINDEX('.', email)
		email
FROM	sales.customers

SELECT	SUBSTRING (email, 1, CHARINDEX('.', email)-1), 
		email
FROM	sales.customers


---Add a new column to the customers table that contains the customers' contact information. 
--If the phone is available, the phone information will be printed, if not, the email information will be printed.


SELECT *, COALESCE (phone, email) contact
FROM	sales.customers



--Write a query that returns streets. The third character of the streets is numerical.


SELECT SUBSTRING( street, 3, 1), street  --start from 3rd, only 1 character
FROM sales.customers
WHERE	SUBSTRING( street, 3, 1) LIKE '[0-9]' --



SELECT SUBSTRING( street, 3, 1), street
FROM sales.customers
WHERE	SUBSTRING( street, 3, 1) NOT LIKE '[^0-9]'  --other solution



SELECT SUBSTRING( street, 3, 1), street
FROM sales.customers
WHERE	ISNUMERIC (SUBSTRING( street, 3, 1) ) = 1   --other solution



--In the street column, clear the string characters that were accidentally added to the end of the initial numeric expression.

---////////////////////////////////////




--Select customers who have purchase both Children Bicycle and Comfort Bicycle on a single order. 
--(expected columns: Customer id, first name, last name, order id)

SELECT	E.Customer_id, first_name, last_name, D.order_id, a.category_name,
		CASE WHEN A.category_name = 'Children Bicycles' THEN 1 ELSE 0 END AS IS_CHILDREN, 
		CASE WHEN A.category_name = 'Comfort Bicycles' THEN 1 ELSE 0 END IS_COMFORT
FROM	production.categories A,
		production.products B,
		sales.order_items C,
		sales.orders D,
		sales.customers E
WHERE	A.category_id = B.category_id AND
		B.product_id = C.product_id AND
		C.order_id = D.order_id AND
		D.customer_id = E.customer_id
AND		A.category_name IN ('Children Bicycles','Comfort Bicycles')
		

			   		 	  	  	 
--1

SELECT	E.Customer_id, first_name, last_name, D.order_id,
		SUM(CASE WHEN A.category_name = 'Children Bicycles' THEN 1 ELSE 0 END) AS IS_CHILD,
		SUM(CASE WHEN A.category_name = 'Comfort Bicycles' THEN 1 ELSE 0 END) AS IS_COMFORT
FROM	production.categories A,
		production.products B,
		sales.order_items C,
		sales.orders D,
		sales.customers E
WHERE	A.category_id = B.category_id AND
		B.product_id = C.product_id AND
		C.order_id = D.order_id AND
		D.customer_id = E.customer_id
AND		A.category_name IN ('Children Bicycles', 'Comfort Bicycles')
GROUP BY
		E.Customer_id, first_name, last_name, D.order_id
HAVING
		SUM(CASE WHEN A.category_name = 'Children Bicycles' THEN 1 ELSE 0 END) >= 1 AND
		SUM(CASE WHEN A.category_name = 'Comfort Bicycles' THEN 1 ELSE 0 END) >= 1
ORDER BY D.order_id


--control

SELECT	A.category_name, E.first_name,E.last_name, D.order_id
FROM	production.categories A,
		production.products B,
		sales.order_items C,
		sales.orders D,
		sales.customers E
WHERE	A.category_id = B.category_id AND
		B.product_id = C.product_id AND
		C.order_id = D.order_id AND
		D.customer_id = E.customer_id
AND		A.category_name IN ('Children Bicycles', 'Comfort Bicycles')
and		E.customer_id = 1185


--2

SELECT	E.customer_id, E.first_name,E.last_name, D.order_id
FROM	production.categories A,
		production.products B,
		sales.order_items C,
		sales.orders D,
		sales.customers E
WHERE	A.category_id = B.category_id AND
		B.product_id = C.product_id AND
		C.order_id = D.order_id AND
		D.customer_id = E.customer_id
AND		A.category_name = 'Children Bicycles'

INTERSECT

SELECT	E.customer_id, E.first_name,E.last_name, D.order_id
FROM	production.categories A,
		production.products B,
		sales.order_items C,
		sales.orders D,
		sales.customers E
WHERE	A.category_id = B.category_id AND
		B.product_id = C.product_id AND
		C.order_id = D.order_id AND
		D.customer_id = E.customer_id
AND		A.category_name = 'Comfort Bicycles'


---3

WITH CTE AS(SELECT E.customer_id, E.first_name, E.last_name, D.order_id, A.category_name,	   CASE WHEN A.category_name = 'Children Bicycles' THEN 1 ELSE 0 END AS is_children,	   CASE WHEN A.category_name = 'Comfort Bicycles' THEN 1 ELSE 0 END AS is_comfort,	   	   CASE WHEN A.category_name IN ('Children Bicycles', 'Comfort Bicycles') THEN 1 ELSE 0 END AS is_bothFROM production.categories AS A,	 production.products AS B,	 sales.order_items AS C,	 sales.orders AS D,	 sales.customers AS EWHERE A.category_id = B.category_id AND	  B.product_id = C.product_id AND	  C.order_id = D.order_id AND	  D.customer_id = E.customer_idAND   A.category_name IN ('Children Bicycles', 'Comfort Bicycles'))SELECT CTE.customer_id, CTE.first_name, CTE.last_name, CTE.order_idFROM CTEWHERE is_both = 1






select street, right(left(street, CHARINDEX(' ',street)-1), 1), 
		isnumeric(right(left(street, CHARINDEX(' ',street)-1), 1)),
			(
			case when isnumeric(right(left(street, CHARINDEX(' ',street)-1), 1)) = 0
			then replace(street,right(left(street, CHARINDEX(' ',street)-1), 1), '')
			else street end) as modified_street
from sales.customers



SELECT	street, 
		LEFT(street,CHARINDEX(' ',street)-1),
		RIGHT(street,LEN(street)-CHARINDEX(' ',street)+1),
		LEFT(street,CHARINDEX(' ',street)-2)+ ' '+ RIGHT(street,LEN(street)-CHARINDEX(' ',street)+1) as new_street
FROM	sales.customers
WHERE	ISNUMERIC(LEFT(street,CHARINDEX(' ',street)-1))=0






select
	street,
	replace(street,
	substring(left(street,
	charindex(' ', street)-1), 1,
	charindex(' ', street)-1),
	substring(left(street,
	charindex(' ', street)-1), 1,
	charindex(' ', street)-2))
from sales.customers
where ISNUMERIC(LEFT(street,CHARINDEX(' ',street)-1))=0





----------------------------------------------------


--- find the stock numbers --quantity of the products

SELECT *
FROM production.stocks
ORDER BY product_id

SELECT product_id, SUM(quantity)
FROM production.stocks
GROUP BY product_id
ORDER BY 1


SELECT  *, SUM(quantity) OVER(PARTITION BY product_id)
FROM production.stocks


SELECT DISTINCT product_id, SUM(quantity) OVER(PARTITION BY product_id) ---this is same with the group by method
FROM production.stocks
----
-- Calculate the average bike prices by brand with both Group By and Window Functions.

SELECT *
FROM production.products

SELECT brand_id, AVG(list_price) avg_price
FROM production.products
GROUP BY brand_id

SELECT  DISTINCT brand_id, AVG(list_price) OVER (PARTITION BY brand_id)
FROM production.products
-------
-- 1. ANALYTIC AGGREGATE FUNCTIONS --


--MIN() - MAX() - AVG() - SUM() - COUNT()

--- 1. The price of the cheapest bike

SELECT MIN(list_price) OVER ()
FROM production.products

SELECT DISTINCT MIN(list_price) OVER ()
FROM production.products


--- 2. The price of the cheapest bike in each category

SELECT DISTINCT category_id,MIN(list_price) OVER(PARTITION BY category_id)
FROM production.products


------3. How many different bikes are there?


SELECT DISTINCT COUNT(product_id) OVER() NUM_OF_BIKE
FROM production.products


-- How many different bikes at the order_items table?


SELECT COUNT(DISTINCT product_id)
FROM sales.order_items


SELECT DISTINCT COUNT(product_id) OVER() NUM_OF_BIKE
FROM
	(
			SELECT DISTINCT product_id
			FROM sales.order_items
	) A



-- 4. How many different bikes are in each category?


SELECT  DISTINCT category_id,COUNT(product_id) OVER(PARTITION BY category_id)
FROM production.products

-- 5. How many different bikes are in each brand in each category?

SELECT DISTINCT brand_id, category_id, COUNT(product_id) OVER(PARTITION BY category_id, brand_id)
FROM production.products


--- Can we calculate how many different brands are in each category with only one select statement and wf?

SELECT brand_id, COUNT(DISTINCT brand_id)
FROM production.products
GROUP BY brand_id


SELECT category_id, COUNT(DISTINCT brand_id) OVER (PARTITION BY category_id)
FROM production.products


SELECT DISTINCT category_id, COUNT(brand_id) OVER(PARTITION BY category_id) num_of_brand
FROM
(
SELECT DISTINCT brand_id, category_id
FROM production.products

) A



---- 2. ANALYTIC NAVIGATION FUNCTIONS --


--first_value() - last_value() - lead() - lag()


--- In the Orders table, print the following values ​​next to each order, respectively:
--- 1. Print the order date of the previous sale of each staff (LAG FUNCTION)


SELECT *,
      LAG(order_date, 1) OVER (PARTITION BY staff_id ORDER BY order_date, order_id) prev_ord_date
FROM sales.orders


--- 2. Print the order date of the next sale of each staff member (lead function)

SELECT *,
      LEAD(order_date, 1) OVER (PARTITION BY staff_id ORDER BY order_date, order_id) NEXT_ord_date
FROM sales.orders

SELECT *,
      LEAD(order_date, 2) OVER (PARTITION BY staff_id ORDER BY order_date, order_id) NEXT_ord_date
FROM sales.orders


--- WINDOW FRAME
--HOW MANY ROWS IN THE PRODUCTION.PRODUCTS

SELECT COUNT(*) OVER () TOTAL_ROW
FROM production.products

--FOR EACH CATEGORY ID

SELECT DISTINCT category_id,
		COUNT(*) OVER () TOTAL_ROW ,
		COUNT(*) OVER (PARTITION BY category_id) NUM_OF_ROW,
		COUNT(*) OVER (PARTITION BY category_id ORDER BY product_id) num_of_row_new
FROM production.products


--- WINDOWS FRAME	

SELECT  category_id,
COUNT(*) OVER (PARTiTION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) CURRENT_WITH_FOLLOWING  -- UNBOUNDED MEANS ADD ONE BY ONE
FROM production.products


SELECT  category_id,
COUNT(*) OVER (PARTiTION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) CURRENT_WITH_FOLLOWING  --count  
FROM production.products


---------///----
SELECT category_id, 
COUNT(*) OVER (PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) CURRENT_WITH_FOLLOWING  -- 1 ITSELF, 1 PREVIOUS AND 1 FOLLOWING, TOTAL IS 3
FROM production.products
ORDER BY category_id, product_id
---

SELECT category_id, 
COUNT(*) OVER (PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) CURRENT_WITH_FOLLOWING  --1 ITSELF, 2 PREVIOUS AND 3 FOLLOWING, TOTAL IS 6
FROM production.products
ORDER BY category_id, product_id

---------///----

---- FIRST VALUE
-- 1. Name of the cheapest bike among all bikes

SELECT FIRST_VALUE(product_name) OVER(ORDER BY list_price)
FROM production.products

--SOLUTION
SELECT distinct FIRST_VALUE(product_name) OVER(ORDER BY list_price), min(list_price) over()
FROM production.products

--2ND WAY
SELECT list_price, product_name
FROM production.products
WHERE product_name = (	SELECT	DISTINCT
				                FIRST_VALUE(product_name) OVER(ORDER BY list_price ASC) cheapest_product
						FROM	production.products
						)


--- 2. Name of the cheapest bike in each category

SELECT DISTINCT category_id, FIRST_VALUE(product_name) OVER (PARTITION BY category_id order by list_price)
FROM production.products

-- 1. Name of the cheapest bike among all bikes (LAST VALUE)

SELECT DISTINCT
 FIRST_VALUE (product_name) OVER  (ORDER BY list_price),
  LAST_VALUE (product_name) OVER  (ORDER BY list_price DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
 FROM production.products


 SELECT	category_id, COUNT(*) OVER (PARTITION BY categorY_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING  AND 1 FOLLOWING)
 FROM	production.products
 ORDER BY category_id, product_id



 -- 3. ANALYTIC NUMBERING FUNCTIONS --


--ROW_NUMBER() - RANK() - DENSE_RANK() - CUME_DIST() - PERCENT_RANK() - NTILE()


--1. Rank the price of the bikes within each category (starting from 1 and increasing 
--one by one according to the increasing price)
--ROW SIRAYLA NUMARALANDIRIR
SELECT	category_id, list_price, 
		ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) row_numb
FROM	production.products

--2. Do the same question so that bikes with the same price get the same sequence number (use the RANK function)

SELECT	 category_id, list_price, 
		ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) row_numb,  --This is to see the difference
		RANK() OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM
FROM	production.products


--3. Do the same question so that bikes with the same price get the same sequence number 
---(use the DENSE_RANK function)

SELECT category_id, list_price, 
	ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) row_numb,
	RANK() OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
	DENSE_RANK() OVER(PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM
FROM production.products


-- 4. Print the percentiles according to the prices of the bicycles in each category.

SELECT category_id, list_price, 
	ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) row_numb,
	RANK() OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
	DENSE_RANK() OVER(PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,
	ROUND(CUME_DIST() OVER(PARTITION BY category_id ORDER BY list_price),2) CUM_DIST,
	ROUND(PERCENT_RANK () OVER(PARTITION BY category_id ORDER BY list_price),2) PERCENT_RANK
FROM production.products



--6. Divide the bikes in each category into 4 groups according to the increasing price. 
-- If possible, there will be the same number of bikes in each group. (Use NTILE function)

SELECT category_id, list_price, 
	ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) row_numb,
	RANK() OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
	DENSE_RANK() OVER(PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,
	ROUND(CUME_DIST() OVER(PARTITION BY category_id ORDER BY list_price),2) CUM_DIST, ---gives 1 to the biggest number , then calculate the oher
	ROUND(PERCENT_RANK () OVER(PARTITION BY category_id ORDER BY list_price),2) PERCENT_RANK, ---gives 0 to the smallest number, then calculates hte other AND takes only distincts
	NTILE(4) OVER (PARTITION BY category_id ORDER BY list_price) NTILE_RESULT
FROM production.products
