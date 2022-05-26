--	Module 5	  03.Lab - Using Set Operators.sql
--			集合運算子的使用

use AdventureWorks ;
go

select * from HumanResources.Employee

--	Using UNION ALL : to return all rows from both tables " including duplicates "
select BirthDate,  HireDate, SalariedFlag	-- 96 records
from HumanResources.Employee
where BirthDate <'1970-01-01'
union all														-- 360 records
select BirthDate, HireDate, SalariedFlag		-- 264 records
from HumanResources.Employee
where BirthDate >'1960-01-01'					
order by BirthDate


--	Using UNION : to return all rows from both tables " excluding duplicates "
select BirthDate,  HireDate, SalariedFlag	--96 records
from HumanResources.Employee
where BirthDate <'1970-01-01'
union															-- 289 records
select BirthDate, HireDate, SalariedFlag		-- 264 records
from HumanResources.Employee
where BirthDate >'1960-01-01'					
order by BirthDate



--	Using INTERSECT : to return only rows found in both tables
select BirthDate,  HireDate, SalariedFlag	--96 records
from HumanResources.Employee
where BirthDate <'1970-01-01'
intersect														-- 70 records  (1960 ~ 1970)
select BirthDate, HireDate, SalariedFlag		-- 264 records
from HumanResources.Employee
where BirthDate >'1960-01-01'					
order by BirthDate


--	Using EXCEPT : to return only rows from left table
select BirthDate,  HireDate, SalariedFlag	--96 records
from HumanResources.Employee
where BirthDate <'1970-01-01'
except															-- 26 records
select BirthDate, HireDate, SalariedFlag		-- 264 records
from HumanResources.Employee
where BirthDate >'1960-01-01'					


--	Reverse position of tables, return only rows from left table
select BirthDate,  HireDate, SalariedFlag	--264 records
from HumanResources.Employee
where BirthDate >'1960-01-01'
except															-- 193 records
select BirthDate, HireDate, SalariedFlag		-- 96 records
from HumanResources.Employee
where BirthDate <'1970-01-01'					


				
