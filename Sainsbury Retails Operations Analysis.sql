Select * from Picking_Data


--- Some basic cleaning 
--- Extract Minutes from Date
ALTER TABLE Picking_Data
Add Event_time2 Time;

ALTER TABLE Picking_Data
drop column F17, F18, f19, f20, f21, f22, f23, f24, f25

Update Picking_Data
SET Event_time2 =  right(event_time, 8) from Picking_Data

--Total Number of orders
Select count (*) from Picking_Data
--- 19761 Orders in a day

--Total Number of uniquie orders
select count (distinct order_number) from Picking_Data
--- 483 different customers 

Select count (distinct picker_id) from Picking_Data
-- 48 Pickers

Select count (distinct tote_code) from Picking_Data
--- 2484 Tote

----Highest Spending customer 

with AA as 
(Select Order_number, count(order_number) as Total_Orders from Picking_Data group by Order_number), 

AB as 
(
Select top 30 Order_number, count(order_number) as Top_30_Cust_Order from Picking_Data
group by Order_number ),

AD as 
(
Select AB.Top_30_Cust_Order/AA.Total_Orders from AA join Ab
on AA.order_number = AB.Order_number)

Select *  from AD


--Average Order by customers 
19761/483

Average order by customer
Select Count(order_number)/count(distinct order_number) as Average_order_per_Customer from Picking_Data

--Average Picker per customer = 
Select count(distinct order_number)/count (distinct picker_id) as Average_Picker_Per_customer from Picking_Data

			--Average Product picked for unique customer 
			Select picker_id, count(distinct order_number) from Picking_Data
			Group by picker_id

Select count (distinct picker_id) from Picking_Data

---- Product by each picker
Select picker_id, count(order_number) as Total_Order_Picked from Picking_Data
group by picker_id
order by Total_Order_Picked desc

						-----Quantity by picker 
						Select distinct (a.picker_id), a.Total_Order, a.Total_Unit, b.Total_Gram
						From 
						(Select picker_id, count(order_number) as Total_Order, sum(QTY) as Total_Unit from Picking_Data
						where PICKED_UNIT_OF_MEASURE = 'each'
						group by picker_id) a

						Inner join

						(Select picker_id, count(order_number) as Total_Order, sum(QTY) as Total_Gram from Picking_Data
						where PICKED_UNIT_OF_MEASURE = 'gram'
						group by picker_id) b
						on a.picker_id = b.picker_id

						Group by a.picker_id
						order by a.Total_Order,a.Total_Qty, b.Total_Qty

with AA as 
(
Select picker_id, count(order_number) as Total_Order, sum(QTY) as Total_Qty from Picking_Data
where PICKED_UNIT_OF_MEASURE = 'each'
group by picker_id),

AB as 
(Select picker_id, count(order_number) as Total_Order, sum(QTY) as Total_Qty from Picking_Data
where PICKED_UNIT_OF_MEASURE = 'gram'
group by picker_id),

AC as(

Select AA.picker_id as Picker_Unit, isnull(AA.Total_Order + AB.Total_Order,0) as Total_Orders, AA.Total_Qty as Total_Unit_Quantity, isnull(AB.Total_Qty,0) as total_Gram_Quantity
From AA left join AB
On AA.picker_id = AB.picker_id)

Select * from AC






----- POSSIBE DATA ERROR
Select count(PICKED_UNIT_OF_MEASURE) from Picking_Data
where PICKED_UNIT_OF_MEASURE <> UNIT_OF_MEASURE

----
--Average numbers of orders per picker  
Select count(order_number)/count (distinct picker_id) as Average_Picker_per_order from Picking_Data
--Each picker will Package 411 product, i do not have data on their efficiency, so i can tell the effect of this number on the quality of their work

-- tote to customer ratio
select count (distinct tote_number) as No_of_tote, count(distinct Order_Number) as No_of_Customer, 
count(distinct tote_number)/count(distinct Order_Number) Tote_Per_Customer from Picking_Data

-- tote to orders ratio 
select count (distinct tote_number) as No_of_tote, count(Order_Number) as No_of_Customer, 
count(Order_Number)/count(distinct tote_number) Tote_Per_Customer from Picking_Data

Average orders per tote


--- Product 
---Most ordered Products
Select * from Picking_Data
--- Number of Orders by product
Select top 30 ordered_product_id, count(order_number) as Number_of_orders from Picking_Data
group by ordered_product_id
order by Number_of_orders desc



- avereage unit per Transaction = - Helps u understand the buying behaviour.
Select ordered_product_id, round(avg(Ordered_QTY),0) As Average_Quantity_Ordered from Picking_Data
Where UNIT_OF_MEASURE = 'each'
group by ordered_product_id
order by Average_Quantity_Ordered desc
--- For instance, 230 and 234 can be seen as an outlier
---- Percentage of Normal delivery

Select ordered_product_id, round(avg(Ordered_QTY),0) As Average_Quantity_Ordered from Picking_Data
Where UNIT_OF_MEASURE = 'gram'
group by ordered_product_id
order by Average_Quantity_Ordered desc
--- For instance, 230 and 234 can be seen as an outlier
---- Percentage of Normal delivery


---- TIME
---Include Hours column and extract Hours from time
ALTER TABLE Picking_Data
Add Order_Hour INT;

Update Picking_Data
SET Order_Hour =  left(Event_time2, 2) from Picking_Data

--Busiest Hour 
Select Order_hour, count(order_number) as Number_of_orders from picking_Data
group by Order_hour
order by order_hour
--- 4 am to 9 am is the busiest, The most order comes in by 6 am, 7am, then 5 am respectively


---How time influences product that was sold****
Select Order_hour, count(ordered_product_id) as Product, max(ORDERED_QTY)  from Picking_Data
group by Order_hour -- Check Power BI

Select * from Picking_Data



-- Status of order 
Select PICK_TYPE, No_of_Orders, sum(a.No_of_Orders)/a.subtotal as Pert_Type
 from
(
Select PICK_TYPE, count(order_number)  as No_of_Orders, 19999 as subtotal from Picking_Data
Group by PICK_TYPE
)a
Group by PICK_TYPE, a.No_of_Orders, a.subtotal
Order by a.No_of_Orders desc

--Order accuracy rate = (Total orders delivered correctly / Total orders) x 100


---Order Availability
Select sum(ORDERED_QTY) As Ordered, Sum(QTY) as Delivered, Round(Sum(QTY)/sum(ordered_Qty),2) As Product_Availability_Rate  from Picking_Data
where PICKED_UNIT_OF_MEASURE = 'each'

Select sum(ORDERED_QTY) As Ordered, Sum(QTY) as Delivered, Round(Sum(QTY)/sum(ordered_Qty),2) from Picking_Data
where UNIT_OF_MEASURE = 'Gram'




      












