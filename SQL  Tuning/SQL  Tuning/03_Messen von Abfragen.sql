set statistics io, time on --off

--gilt nur pro aktiver Sitzung
--ausschalten ! sonst Performanceverlust wg Messen

--IO = Anzahl der Seiten = logosche Lesevorgänge
--time = CPU Zeit(aufwand) in ms, Dauer der Abfrage in ms

--Ziel : Reduktion

--Seitenauslastung.. veraltet
dbcc showcontig('kundeumsatz')

--besser
select * from sys.dm_db_index_physical_stats
		(db_id(),object_id('Kundeumsatz'),NULL, NULL,'detailed')

