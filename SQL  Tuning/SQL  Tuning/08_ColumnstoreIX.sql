select top 3 * from kundeumsatz
--where   Agg (sum/avg(min/max) 

--alle aus Lieferland Germany
--pro Stadt des Kunden Summe der Quantity
set statistics io , time on
select city, sum(quantity)
from kundeumsatz
where shipcountry = 'Germany'
group by city
--besser mit IX  NIX_sc_inkl_ciqu
--Seiten 1122 Zeit 16/19ms

select * into kundeumsatz2 from kundeumsatz
--570MB mit IX Daten
select city, sum(quantity)
from kundeumsatz2
where shipcountry = 'Germany'
group by city

select city, sum(quantity)
from kundeumsatz2
where freight < 1
group by city




