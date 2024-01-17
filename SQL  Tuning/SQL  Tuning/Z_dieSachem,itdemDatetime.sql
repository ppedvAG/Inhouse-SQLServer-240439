select * from orders



--alle Orders aus dem Jahr 1997 (orderdate)

-- falsch  aber schnell
select * from orders where orderdate between '1.1.1997' and '31.12.1997'
--theor. falsch, aber schnell
select * from orders where orderdate > '31.12.1996 23:59:59' 
					     and orderdate < '1.1.1998'

--garantiert korrekt, aber langsam
select * from orders where  year(orderdate) = 1997

--31.12.1997 00:00:00.000 
select * from orders where orderdate between '1.1.1997' and '31.12.1997 23:59:59.999'

--alle im Rentenalter

select * from employees  where datediff(yy, Birthdate, getdate()) > 65

select * from employees where birthdate < dateadd(yy, -65, getdate())




select * from orders where
select * from orders where



