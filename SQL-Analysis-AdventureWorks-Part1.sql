-- Retrieve all rows and columns from the employee table in the Adventureworks database. Sort the result set in ascending order on jobtitle.
select *
from HumanResources.Employee
order by JobTitle

-- Retrieve all rows and columns from the employee table using table aliasing in the Adventureworks database. Sort the output in ascending order on lastname.
select *
from Person.Person
order by LastName

-- Return all rows and a subset of the columns (FirstName, LastName, businessentityid) from the person table in the AdventureWorks database. The third column heading is renamed to Employee_id. Arranged the output in ascending order by lastname.
select FirstName, LastName, businessentityid as Employee_id
from Person.Person
order by LastName

-- Return only the rows for product that have a sellstartdate that is not NULL and a productline of 'T'. Return productid, productnumber, and name. Arranged the output in ascending order on name
select productid, productnumber, name
from production.Product
where SellStartDate IS NOT NULL and productnumber LIKE '%-T%'
order by name

-- Return all rows from the salesorderheader table in Adventureworks database and calculate the percentage of tax on the subtotal have decided. Return salesorderid, customerid, orderdate, subtotal, percentage of tax column. Arranged the result set in ascending order on subtotal.
select salesorderid, customerid, orderdate, subtotal,
(taxamt / subtotal) * 100 as tax_percent
from Sales.SalesOrderHeader
order by subtotal

-- Create a list of unique jobtitles in the employee table in Adventureworks database. Return jobtitle column and arranged the resultset in ascending order.
select distinct jobtitle
from HumanResources.Employee
order by jobtitle

-- Calculate the total freight paid by each customer. Return customerid and total freight. Sort the output in ascending order on customerid
select customerid, sum(freight) as total_freight
from sales.salesorderheader
group by customerid
order by customerid

-- Find the average and the sum of the subtotal for every customer. Return customerid, average and sum of the subtotal. Grouped the result on customerid and salespersonid. Sort the result on customerid column in descending order.
select customerid, salespersonid,
	avg(subtotal) as avg_subtotal,
	sum(subtotal) as sum_subtotal
from sales.salesorderheader
group by customerid, salespersonid
order by customerid desc

-- Retrieve total quantity of each productid which are in shelf of 'A' or 'C' or 'H'. Filter the results for sum quantity is more than 500. Return productid and sum of the quantity. Sort the results according to the productid in ascending order.
select productid, sum(quantity) as total_quantity
from production.productinventory
group by productid
order by productid

-- Find the total quentity for a group of locationid multiplied by 10
select locationid, sum(quantity) * 10 as total_quantity
from production.productinventory
group by locationid

-- Find the persons whose last name starts with letter 'L'. Return BusinessEntityID, FirstName, LastName, and PhoneNumber. Sort the result on lastname and firstname.
select pp.businessentityid, firstname, lastname, phonenumber
from person.personphone pp
join person.person p on pp.businessentityid = p.businessentityid
where lastname like 'L%'
order by lastname, firstname

-- Find the sum of subtotal column. Group the sum on distinct salespersonid and customerid. Rolls up the results into subtotal and running total. Return salespersonid, customerid and sum of subtotal column i.e. sum_subtotal.
select salespersonid, customerid, sum(subtotal) as sum_subtotal
from sales.salesorderheader
group by rollup (salespersonid, customerid)

-- Find the sum of the quantity of all combination of group of distinct locationid and shelf column. Return locationid, shelf and sum of quantity as TotalQuantity.
select distinct locationid, shelf, sum(quantity) as total_quantity
from production.productinventory
group by rollup (locationid, shelf)
order by total_quantity desc

-- Retrieve the total sales for each year. Filter the result set for those orders where order year is on or before 2016. Return the year part of orderdate and total due amount. Sort the result in ascending order on year part of order date.
select year(orderdate) as yearoforderdate,
	sum(totaldue) as totaldueorder
from sales.salesorderheader
group by year(orderdate)
order by yearoforderdate

-- Retrieve the salesperson for each PostalCode who belongs to a territory and SalesYTD is not zero. Return row numbers of each group of PostalCode, last name, salesytd, postalcode column. Sort the salesytd of each postalcode group in descending order. Shorts the postalcode in ascending order.
select row_number() over(partition by postalcode order by postalcode desc),
	lastname, salesytd, postalcode
from sales.salesperson sp
join person.person p
	on sp.businessentityid = p.businessentityid
join person.address a
	on sp.territoryid = a.addressid
order by postalcode

-- Return the number of characters in the column FirstName and the first and last name of contacts located in Australia
select distinct len(firstname) as fnamelength,
	firstname, lastname
from sales.vstorewithcontacts con
join sales.vstorewithaddress ad
	on con.businessentityid = ad.businessentityid
group by len(firstname)
having countryregionname = 'Australia'




