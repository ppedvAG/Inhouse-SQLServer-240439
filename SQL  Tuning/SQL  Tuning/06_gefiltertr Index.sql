--gefilterter Index.. nicht alle Daten im Index

--wichtig--> weniger Ebenen im Index

select country, city, freight
from kundeumsatz
where shipcountry = 'UK' -- and employeeid = 2

--NIX_SC_inkl_cocifr --perfekter = abdeckendeckender IX
--Tiefe =3 (Ebenen) 9000 Seiten etwa...

--HAT SICH DER GEFILTERTE ix GELOHNT?

--kommt der gefilterte auf die gleiche Ebenenanzahl, 
--dann hat sich das weniger gelohnt..sollte weniger sein!!



