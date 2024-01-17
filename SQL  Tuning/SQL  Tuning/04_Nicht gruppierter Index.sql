--Nicht gr IX

--Kopie von Daten in sortierter Form
--pro Tabelle: ca 1000

--muss evtl Lokkup machen, wenn Spalrten nicht iX enthalten sind

--Lookup sind teuer... je mehr desto schlechter

set statistics io, time on

--Im Plan: Scan oder seek.. reiner Heap ohne IX--> Table scan
select id from kundeumsatz where id = 117
--Seiten ca 41000 Dauer 50ms  CPU 170ms

--Schlüsselspalte = where Spalte
--nun NIX_ID eindeutig
select id from kundeumsatz where id = 117

--nun im Plan: SEEK
--Seiten 3 0 ms

--Plan: IX Seek mit Lookup
select id, freight from kundeumsatz where id = 117
--Seiten 4 0ms

select id, freight from kundeumsatz where id < 117
--seiten 119.. Lookup wird schon 99% der Kosten haben

--Bei ca 10650 geht der SQL von IX Seek wg Lookup auf Table Scan
select id, freight from kundeumsatz where id < 10650

--nun NIX_ID_FR_u
select id, freight from kundeumsatz where id < 920000

--Hauptsache KEIN LOOKUP

--bäh.. wieder Lookup
select id, freight, country, city from kundeumsatz where id < 10650

--IX mit eingeschl Spalten
--daher:_ NIX_ID_inkl_CICYFR_u
--reiner Seek
select id, freight, country, city from kundeumsatz where id < 10650

--Where Spalten kommt zu den 
--Indexschlüsselspalten, Spalten des Select zu den eingeschlossenen

select		country, city, sum(unitprice*quantity)
from		kundeumsatz
where		employeeid = 3 and freight < 2
group by	country, city

--NIX_FR_EM_inkl_CICYUPQU

--bei OR Bedingungen schlägt SQL nichts mehr vor
--evtl 2 Ind


select		country, city, sum(unitprice*quantity)
from		kundeumsatz
where		employeeid = 3 or freight < 2 and Shipcountry = 'UK'
group by	country, city
-- ! Klammern!!!!! and ist immer stärker bindend
--erst klammern dann IX


--nur IX die man wirklich braucht.. alle anderen kosten Leistung bei INS UP DEL

--wie finde ich Indizes, die keiner verwendet

select * from sys.dm_db_index_usage_stats







