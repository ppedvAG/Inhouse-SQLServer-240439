/*
DB besteht i.d.R. aus 2 Dateien
.mdf (daten)-->    Dateigruppe . PRIMARY
.ldf (Log)


Mit Dateigruppen klassen sich Tabelen auf mehrer Datenträger verteilen , um 
HDDs zu entlasten 




*/

create table test1 (id int) on [PRIMARY]

create table test2 (id int) on ARCHIV
create table test3(id int) ON HOT


--TAB A 10000 
--TAB B 1000000


--Umsatz

create table u2024(id int, jahr int, spx int)

create table u2023(id int, jahr int, spx int)

create table u2022(id int, jahr int, spx int)

create table u2021(id int, jahr int, spx int)

select * from umsatz ???


create view umsatz
as
select * from u2024
UNION ALL
select * from u2023
UNION ALL
select * from u2022
UNION ALL
select * from u2021

select * from umsatz where id = 2022
select * from umsatz where jahr = 2022


ALTER TABLE dbo.u2023 ADD CONSTRAINT
	CK_u2023 CHECK (jahr=2023)

--INS UP DEL

--aber hier: es darf kein identity
--PK muss eindeutig über die Sicht werden (id und jahr)

select 100
UNION
select 200
UNION 
select 300
union
select 100

------100---------------200------------------------
create partition function fzahl(int)
as
RANGE LEFT FOR VALUES (100,200)

select $partition.fzahl(117)--1,2,3

--Dateigruppen pro Bereich
--bis100, bis200, bis5000, rest

--Verteilungschema

create partition scheme schemaZahl
as
partition fzahl to (bis100,bis200,rest)
---                   1        2   3

create table pTab (id int identity, nummer int, spx char(4100)) on schemaZahl(nummer)

---------------------------
--Exkurs

create table txy (id int identity, spx char(4100))

insert into txy
select 'XY'
GO 20000 --12 Sek
dbcc showcontig('txy')
--------------------------------------------


declare @i as int = 1

Begin tran
while @i<=20000
	begin
		insert into ptab (nummer, spx) values (@i, 'xy')
		set @i+=1  -- set @i= @i+1
	end
commit
---------------------------

set statistics io, time on

select * from ptab where id = 117 --20000 Seiten ca 30ms
select * from ptab where nummer = 117 --nur 100 Seiten

select * from ptab where nummer = 5017


