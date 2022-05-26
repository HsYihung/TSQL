--	Module 3  03.Lab - Hierarchical Queries.sql
--	Recursive CTEs  的例子

use AdventureWorks;
go

select * from HumanResources.Employee2005

--  Level 0
select EmployeeID, ManagerID,  0              -- managerID = report to
from HumanResources.Employee2005
where ManagerID is null                             -- 他是大老闆 big boss

--  Level 1
select  EmployeeID, ManagerID, 1 
from HumanResources.Employee2005
where ManagerID in (select EmployeeID
								from HumanResources.Employee2005
								where ManagerID is null)

--  Level 2
select EmployeeID, ManagerID,  2 
from HumanResources.Employee2005
where ManagerID in (select EmployeeID
								from HumanResources.Employee2005
								where ManagerID in (select EmployeeID		-- find level 1
																	from HumanResources.Employee2005
																	where ManagerID is null))  -- find level 0


with RecursiveCTE( EmployeeID, ManagerID, EmpolyeeLevel) 
as (select EmployeeID, ManagerID,  0 as EmpolyeeLevel
	from HumanResources.Employee2005
	where ManagerID is null

	union all

	select  e.EmployeeID, e.ManagerID, EmpolyeeLevel + 1
	from HumanResources.Employee2005 as e
	inner join RecursiveCTE as r                          -- 又去 join 自己 RecursiveCTE
	on e.ManagerID = r.EmployeeID
)
select EmployeeID, ManagerID,  EmpolyeeLevel
from RecursiveCTE
order by EmpolyeeLevel, EmployeeID, ManagerID;
go

