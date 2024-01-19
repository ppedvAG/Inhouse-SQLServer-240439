--Window Function

----F() OVER(PARTITION BY Col1 ORDER BY Col2 DESC)

--ROW_NUMBER------------
--fortlaufende Zahl--

SELECT
		orderid,
		employeeid,
		customerid,
		freight,
		row_number () OVER ( 	PARTITION BY employeeid
			ORDER BY freight DESC
		) Rang
	FROM orders





-------------RANK-----------------
--RANK überspringt gleichen Rang----
	SELECT
		orderid,
		employeeid,
		customerid,
		freight,
		RANK () OVER ( 
			PARTITION BY employeeid
			ORDER BY freight DESC
		) Rang
	--	string_a
	FROM orders

	select string_Agg(Lastname,';') over (order by employeeid) from employees

	select * from [order details]

	--




---------dense_rank----------
--vergibt gleichen Rang mehrmals---


select freight , rank() over (order by freight),
				dense_Rank() over (order by freight) from orders
order by freight asc

select employeeid,orderid,  freight , rank() over (order by freight),
				dense_Rank() over (partition by employeeid order by freight) from orders
order by employeeid, freight asc



----NTILE----
--aufteilen in gleiche Anzahl ---

select ntile(3) over (order by freight)
, freight from orders


---auch mit AGG---
--Prozentanteil

select 
	orderid,productid, 
	sum(unitprice*quantity) over (partition by orderid),
	 cast(1 *  (unitprice*quantity)/sum(unitprice*quantity) over (partition by orderid) 
		* 100 as Decimal(5,2))
	 from [Order Details]
	 order by 1,4



---,SUM(Col1) OVER (PARTITION BY Col2)
---ORDER BY Col3   ROWS UNBOUNDED PRECEDING)--aufsummieren

select * from t1
select id, sum(x) over ( order by id  ROWS UNBOUNDED PRECEDING) 
from t1

select orderid, 
	sum(unitprice*quantity)
		over ( order by orderid ROWS UNBOUNDED PRECEDING) ,
	sum(unitprice*quantity)
		over ( order by orderid RANGE UNBOUNDED PRECEDING),
	sum(unitprice*quantity)
		OVER(ORDER BY orderid ROWS Between CURRENT ROW and 2 Following )    	
  ,sum(unitprice*quantity)
		OVER(ORDER BY orderid ROWS Between 2 FOLLOWING and 3 Following )    
  ,sum(unitprice*quantity)
		OVER(ORDER BY orderid ROWS Between 2 Preceding and 2 Following ) 
from [order details]



 CREATE TABLE T (a INT, b INT, c INT);   
GO  
INSERT INTO T VALUES (1, 1, -3), (2, 2, 4), (3, 1, NULL), (4, 3, 1), (5, 2, NULL), (6, 1, 5);   
select * from t

  
SELECT b, c,   
    LAG(2*c, b*(SELECT MIN(b) FROM T), -c/2.0) OVER (ORDER BY a) AS i  
FROM T;

SELECT b, c,   
    LEAD(2*c, b*(SELECT MIN(b) FROM T), -c/2.0) OVER (ORDER BY a) AS i  
FROM T;

  ,SUM(Col2) OVER(ORDER BY Col1 RANGE UNBOUNDED PRECEDING) "Range" 
  ,SUM(Col2) OVER(ORDER BY Col1 ROWS UNBOUNDED PRECEDING) "Rows"   
  ,SUM(Col2) OVER(ORDER BY Col1 ROWS Between CURRENT ROW and 2 Following )     
  ,SUM(Col2) OVER(ORDER BY Col1 ROWS Between 2 FOLLOWING and 3 Following )    
  ,SUM(Col2) OVER(ORDER BY Col1 ROWS Between 2 Preceding    and 2 Following ) 


--best verkaufte Product pro Jahr und MItarbeiter und im Vergelich zu Gesamtumsatz
--Wie hoch war also der Anteil eines Verkäufers pro Produkt und Jahr am Gesamtumsatz

;WITH CTE
as
(
select distinct 
		e.LastName, p.ProductName,	year(orderdate) as jahr
		,sum(od.unitprice*quantity) over (partition by e.lastname, productname order by year(orderdate)) as UpLP
		,sum(od.unitprice*quantity)over (partition by year(orderdate),productname ) as UpJP
from orders o 
				inner join [order details] od on o.OrderID=od.OrderID
				inner join Employees e on e.EmployeeID=o.EmployeeID
				inner join products p on p.ProductID=od.ProductID
--order by e.LastName, year(orderdate),UpLP desc--,productname 
)
select lastname, productname, jahr, UpLP, convert(decimal(4,2),Uplp/UpJP) AnteilamGesamtUmsatz from cte
--where productname in ('chai', 'Pavlova') and jahr = 1996
order by lastname,jahr,productname

select * from products

-- Summe Frachtkosten pro Jahr und Angestellter im Vergleich zu jeweiligen Vorjahr
select EmployeeID, YEAR(orderdate),
		sum(freight) as aktFracht,
		LAG(sum(Freight),1,0) over (partition by employeeid 
									order by year(orderdate)) 
									as VorJahr
from orders 
group by EmployeeID, YEAR(OrderDate)
order by 1



select * from products




--Welche Produkte wurden am meisten pro QUarta und Jahr am besten verkauft
with cte as
(
select productname, year(orderdate)	as jahr ,datepart(qq,orderdate)as Quartal,  sum(od.quantity)  as Menge	,
		 rank() over (partition by  year(orderdate), datepart(qq,orderdate) order by  sum(od.quantity) desc)  as RANG

from 
	orders o 
	inner join  [order details]   od on o.orderid = od.orderid
	inner join products p on od.productid = p.productid		
group by 
		   productname	  ,year(orderdate)	 ,datepart(qq,orderdate)
 )
 select *	from cte  where RANG between 1 and 3


 --all time Top verkaufte produkte		 --kommt am häufgisten unter den TOP 3 vor
 with cte as
(
select productname, year(orderdate)	as jahr ,datepart(qq,orderdate)as Quartal,  sum(od.quantity)  as Menge	,
		 rank() over (partition by  year(orderdate), datepart(qq,orderdate) order by  sum(od.quantity) desc)  as RANG

from 
	orders o 
	inner join  [order details]   od on o.orderid = od.orderid
	inner join products p on od.productid = p.productid		
group by 
		   productname	  ,year(orderdate)	 ,datepart(qq,orderdate)
 )
select Productname, count(*) from cte 
where Rang in (1,2,3)
group by productname  order by 2 desc


select datediff(dd,requireddate, shippeddate),requireddate, shippeddate from orders

--Gibt es Produkte , die im aktuellen Monat (1998 Monat) 3 	hätten nachbestellt werden sollen	---noch nicht geliefert und auf Lager sind weniger als Reorderlevel
select 	  year(orderdate), month(orderdate),p.productname, Menge=sum(od.quantity) 	,p.unitsinstock, p.reorderlevel
from 
	orders o 
	inner join  [order details]   od on o.orderid = od.orderid
	inner join products p on od.productid = p.productid		
	where datediff(dd,requireddate, shippeddate) > 0	
group by 	  year(orderdate) ,month(orderdate)  , p.productname,p.unitsinstock, p.reorderlevel
order by 1 desc, 2 desc


 --Wo haben wir weniger auf Lager als bestellt und nicht 


select year(orderdate) as Jahr, datepart(qq,orderdate) as Quartal ,
	   p.productname,
	    sum(quantity) over (
				partition by  year(orderdate) , datepart(qq,orderdate), p.productname 
					
						    )
from orders o inner join  [order details]   od
on o.orderid = od.orderid
inner join products p on od.productid = p.productid			 
group by   year(orderdate),	  datepart(qq,orderdate)   ,p.productname
order by jahr, quartal asc







select EOMONTH(getdate())





select * from sys.dm_exec_Query_plan_Stats