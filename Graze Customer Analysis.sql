


--List the name, barcode, category and pack weight of all of the graze products


	--CHECKING THE TABLES
SELECT * FROM promotional_feature_space;
SELECT * FROM products;
SELECT * FROM locations;
SELECT * FROM metrics;

--QUESTION 1:
--LIST THE NAME, BARDCODE AND CATEGORY AND PACK WEIGHT OF ALL OF THE GRAZE PRODUCT
SELECT p.category, SUM(m.sales_value) AS SV FROM metrics AS m
LEFT JOIN products AS p
ON p.id - m.product_id
GROUP BY p.category


--QUESTION 2
-- HOW MANY PRODUCT SOLD 0 UNIT IN WEEK COMMENCING 5TH FEB 2018 IN LOCATION ID 1526
SELECT count(a.product_id) AS Noofproduct
FROM
(
	SELECT Product_id, 
		sum(sales_units) AS sales_unit 
		FROM metrics
		WHERE location_id = 1526 AND WEEK = '2018-02-05'
		GROUP BY product_id)a
		WHERE a.sales_unit = 0
		

-- QUESTION 3:

--WHAT IS THE NAME OF THE NON-GRAZE PRODUCT THAT WAS SOLD FOR THE FIRST TIME ON THE 23RD OF APRIL
SELECT Product_id, SUM(sales_units) AS Sales FROM metrics 
WHERE WEEK = '2018-04-23' AND product_id Not IN (SELECT product_id, 
sum(sales_units) FROM metrics WHERE WEEK > '2018-04-23')
GROUP BY product_id
--OR 
SELECT a.Product_id, a.Sales FROM 
(
SELECT Product_id, SUM(sales_units) AS Sales FROM metrics 
WHERE WEEK = '2018-04-23'
GROUP BY product_id)a

LEFT JOIN

(SELECT product_id, sum(sales_units) FROM metrics
WHERE WEEK <= '2018-04-23'
GROUP BY product_id) b

ON a.product_id <> b.product_id

WHERE WEEK <= '2018-04-23' AND WHERE a.Sales = '0'


-- QUESTION 4
--WHAT WAS THE TOTAL SALES VALUE (£) OF GRAZE PRODUCT IN THE SNACKING NUTS CATEGORY IN THE FIRST FOUR WEEKS OF 2018, IN EACH 
RETAILER?

SELECT SUM(sales_Value) AS SV FROM metrics 
WHERE product_id IN 
(SELECT product_id FROM products WHERE Category = "Snacking Nuts" AND brand = "Graze")
SELECT WEEK FROM metrics 
GROUP BY WEEK
LIMIT 4;
