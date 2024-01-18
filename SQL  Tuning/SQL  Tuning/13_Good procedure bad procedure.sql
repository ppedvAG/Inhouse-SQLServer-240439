--Benutzerfreundliche Prozeduren

create procedure gp_kundenSuche @par1 char(5)
as
select * from northwind.dbo.customers where customerid like @par1 +'%'
GO


--exec gp_kundensuche 'A'

--besser
alter procedure gp_kundenSuche @par1 varchar(5)
as
select * from northwind.dbo.customers where customerid like @par1 +'%'
GO

set statistics io on
set statistics time on

--exec gp_kundensuche 'A'

--exec gp_kundensuche '%'
select * from northwind.dbo.customers where customerid like '%%'



--aber dennoch nicht gut
--Plan..

select * into Kunden2 from  northwind.dbo.customers 

insert into kunden2 select * from kunden2
go 14

alter table Kunden2 add ID int identity


 create  procedure gp_kundenSuche2 @par1 varchar(10)
as
IF @par1 = '*'
select Country,city from Kunden2 --where ID like @par1 
ELSE
select Country,city from Kunden2 where ID = @par1
GO

--NIX_CustID_allIN


--besser wäre in der Prozedur auf andere, 
--optimierte Prozeduren zu verzweigen
--exec gp_kundensuche2 '*'
--exec gp_kundensuche2 '1'

