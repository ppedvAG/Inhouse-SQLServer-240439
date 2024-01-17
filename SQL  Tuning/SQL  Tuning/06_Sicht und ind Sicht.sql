--adhoc Abfrage				1.
--Abfrage auf Sicht         2.
--Prozeduren                3.
--Funktionen´               4.

/*
1		2			3|4
langsam----------------------------> schnell

normal
4          1/2                3

*/

--Sicht
select * from (select * from kundeumsatz) k
where k.City = 'London'

create view vDemo1
as
select * from kundeumsatz where city = 'London'

select * from vdemo1

--wofür ne Sicht?
--komplexe Statements verinefachen wg Wiederverwendbarkeit
create view vKU
as
SELECT      Customers.CustomerID, Customers.CompanyName, Customers.ContactName, Customers.ContactTitle, Customers.City, Customers.Country, Employees.LastName, Employees.FirstName, Orders.OrderDate, Orders.EmployeeID, Orders.Freight, Orders.ShipName, Orders.ShipAddress, Orders.ShipCity,
                   Orders.ShipCountry, [Order Details].OrderID, [Order Details].ProductID, [Order Details].UnitPrice, [Order Details].Quantity, Products.ProductName, Products.UnitsInStock
FROM         Customers INNER JOIN
                   Orders ON Customers.CustomerID = Orders.CustomerID INNER JOIN
                   Employees ON Orders.EmployeeID = Employees.EmployeeID INNER JOIN
                   [Order Details] ON Orders.OrderID = [Order Details].OrderID INNER JOIN
                   Products ON [Order Details].ProductID = Products.ProductID
GO

select * from vKu

--Summe der Frachtkosten pro Land eines Kunden
--wie cool.. mit der Sicht keine Join.. juhu

select country,sum(freight) from vKU
group by country

--anderes Ergebnis..??.. 
select country, sum(freight) 
	from customers c  inner join orders o 
						on c.CustomerID=o.CustomerID
group by country

--sicht nur dann verwenden , wenn alle Tabellen tats gebraucht werden, die in der Sicht verwendet werden

create table slf (id int, stadt int, land int)

insert into slf
select 1,10,100
UNION ALL
select 2,20,200
UNION ALL
select 3,20,300

select * from slf


create view vSLF
as
select * from slf

select * from vSLF

alter table slf add fluss int

update slf set fluss = id *1000

select * from vSLF--Fluss fehlt

alter table slf drop column land

select * from vSLF
--uiuiuiuiuiui.. Land mit Werten von Fluss

--besser so:

drop table slf
drop view vslf

create table slf (id int, stadt int, land int)

insert into slf
select 1,10,100
UNION ALL
select 2,20,200
UNION ALL
select 3,20,300

select * from slf


create view vSLF with schemabinding --nur exaktes Arbeiten möglich
as
select id, stadt , land from dbo.slf

select * from vSLF

alter table slf add fluss int

alter table slf drop column land -- geht nicht mehr


set statistics io, time on
select country, count(*) from kundeumsatz
group by country

create or alter view vdemo2 with schemabinding
as
select country, count_big(*) as Anzahl from dbo.kundeumsatz
group by country

select * from vdemo2