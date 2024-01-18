select customerid as KDnr , sum(freight) as SummeFracht
from orders
where shipcity = 'London' and freight < 10
group by customerid
order by customerid


select customerid as KDnr , sum(freight) as SummeFracht
from orders o
where o.shipcity = 'London' and freight < 10 --and Kdnr like 'B%'
group by KDnr
order by KDnr


--> FROM (ALIAS) --> JOIN (ALIAS) --> where --> group by 
--> having --> select (Alias, und Berechnung) --> order by
--> TOP DISTINCT ---> AUSGABE



--daher tu nie: mit having etwas filtern ,was ein where  kann
--im having sollte immer nur AGG sein


