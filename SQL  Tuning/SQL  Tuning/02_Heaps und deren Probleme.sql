
alter table kundeumsatz add id int identity

set statistics io, time on
--pro Session nun aktiv
--IO = Anzahl der Seiten
--time: Dauer in ms und CPU Zeit in ms

select * from kundeumsatz where id = 117


--Seiten
--immer 8192bytes
--Nutzlast 8072bytes
--Limit: max 700 Datensätze
--bei fixen Länge: die Summe muss pro DS unter 8060 bleiben
--der DS muss in Seite passen

create table t1 (id int, xspx int, spy char(4100))

--Messen der Seitenauslastung

dbcc showcontig('kundeumsatz')
--- Gescannte Seiten.............................: 41075
--- Mittlere Seitendichte (voll).....................: 98.16%

--56000 Seiten wurden aber gelesen..
--besser mit DMVs DataManagement Views
select * from sys.dm_db_index_physical_stats
		(db_id(),object_id('Kundeumsatz'),NULL, NULL,'detailed')
--forward record count: für die zusätzluiche Spalte ID wurden 15000 Seiten gebraucht
--der müsste immer NULL oder 0 sein


--Clustered IX auf bel. Spalten.. dann löschen 
--bei CL IX kann das übrigens nie passieren... 
 -- nun 41896

 --Gibts ne Hilfe: Brent Ozar  sp_blitzIndex




  EXEC sp_MSforeachtable 'select  * from sys.dm_db_index_physical_stats
		(db_id(),object_id(''?''),NULL, NULL,''detailed'')'