---temp
/*
#t  lokale temp Tabelle
gibt es nur in der ErstellerSession
Lebensdauer: Verbindung wird getrennt, oder drop table

##t globale temp tabelle
auch in anderen Sessions erreichbar
Lebensdauer: Verbindung wird getrennt, oder drop table
laufende Abfragen werden nicht unterbrochen
*/

select * into #t from customers
select * into ##t from customers
select * from #t
select * from ##t



select		country, city, count(*) as Anz
from		customers
group by	country, city

select		country,  count(*) as Anz
from		customers
group by	country

select		 count(*) as Anz
from		customers



select		country, city, count(*) as Anz
from		customers
group by	country, city
with cube


select		country, city, count(*) as Anz
into #t3
from		Kundeumsatz
group by	country, city
with rollup

select * from #t3 where country = 'France'


with rollup