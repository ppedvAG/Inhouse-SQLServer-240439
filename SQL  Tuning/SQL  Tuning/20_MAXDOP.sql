/*

MAXDOP 

Abfragen können eine oder mehr CPUs verwenden

Wird eine Abfrage schneller fertig sein, wenn mehr CPUs sie verarbeiten?
Normalerweise schon .. macht Sinn!

SQL verwendet allerdings keine variable Anzahl an Kernen.
--(Erst SQL 2022 ist dazu lernfähig)
SQL verwendet 1 oder alle Kerne bzw das was in MAXDOP angegeben ist.

Seit SQL 2016: Standardwert statt 0 nun Anzahl der Kerne , aber max 8



*/


set statistics io, time on



set statistics io, time on

select country, sum(unitprice*quantity)
from ku
group by country

--, CPU-Zeit = 687 ms, verstrichene Zeit = 183 ms.
--8 950ms 140ms
--6 820ms  151ms

select country, sum(unitprice*quantity)
from ku
group by country option (maxdop 6)

--, CPU-Zeit = 468 ms, verstrichene Zeit = 470 ms.

--Fazit : mit 6  CPUs statt 8 effizienter
--2 Kerne sind frei für andere Abfragen
--es wird weniger CPU verbraucht und die Dauer 
--ist ansatzweise gleich geblieben



--MAXDOP = 0 = alle
--MAXDOP Server = 8 
--MAXDOP DB = 4
--MAXDOP ABfrage = 1 

--dann wird 1 Kern verwendet..

--Fakt: Am Ende zählt der MAXDOP, der näher an der Abfrage dran ist
-- Server(4)-->DB(6)--Abfrage(8)-- es zählt 8

--auftreten des Parellelismus kann man messen


select * from sys.dm_os_wait_stats		   
where wait_type like 'CX%'
--Was sollte man einstellen: 
-- der Kostenschwellwert sollte bei 25 bei Datawarehouse sein.. 
-- bei Shop eher 50 und dann experimentieren

--SQL 2012: 5 und 0 (alle CPUs)

--im Plan tauchen Doppelpfeile auf.

--Dass SQL Server paralelisiert müssen 2 Bedingungen erfüllt sein
-- Bed 1: wenn der Kostenschwellwert überschritten wurde: default bei 5
--       dann werden rigoros alle CPUs verwendet

-- Seit SQL 2019 (Setup) wird folgendes vorgeschlagen: alle Prozessoren ,
---aber nicht mehr als 8 

--Wären nicht weniger besser gewesen?

--Tatsächlich ist es eher pro Abfrage zu entscheiden, was besser ist.
--Fakt: meist kommt man mit weniger CPUs gleich schnell weg und spart 
--zeitgleich CPU Leistung
--Taskmanager sollte eine Reduzierung der Prozesssorzeit zeigen





--Siet SQL 2016 läßt dich der MAXDOP auch pro DB einstellen

USE [master]
GO

GO
USE [Northwind]
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 4;
GO
