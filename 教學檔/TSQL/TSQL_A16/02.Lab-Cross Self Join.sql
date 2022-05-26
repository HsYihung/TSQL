--	Module 16 - Lab02 交叉聯結(Cross Joins)自我聯結(Self-Joins)

--	交叉連接為兩個資料表間的笛卡兒乘積 (Cartesian product)，兩個資料表在結合時，
--			不指定任何條件，即將兩個資料表中所有的可能排列組合出來
--			並使用 WHERE 條件式限制顯示的資料筆數(6x5=30)
--			通常用於測試資料庫伺服器效能。

use Northwind;
go
select * from Orders
where OrderID<10250    -- 2 筆

select * from [Order Details]
where ProductID<3        -- 82 筆

select o.OrderID, o.CustomerID, od.ProductID, od.UnitPrice
from Orders as o
cross join [Order Details] as od									--  2 tables 笛卡爾乘積 164 筆
where o.OrderID<10250 and od.ProductID<3


--語法二,同上
select o.OrderID, o.CustomerID, d.ProductID, d.UnitPrice
from Orders as o, [Order Details] as d						--  2 tables 笛卡爾乘積
where o.OrderID<10250 and d.ProductID<3


--	同一個資料表聯結到自己，就稱為自我聯結。
--	當需要取出同一個資料表中的相關資料時，就可以使用自我聯結。
--	自我聯結必需使用別名不然 SQL 資料庫無法識別。

--SELF JOIN 在員工資料表中,找出員工的主管姓名
select employeeID, ReportsTo from Employees

select EmployeeID, FirstName, LastName, Title, ReportsTo from Employees
go 2

--	SELF JOIN twice
select	e1.EmployeeID, e1.FirstName, e1.LastName, e1.ReportsTo, 
			e2.FirstName, e2.LastName, e2.ReportsTo
from Employees as e1 
join Employees as e2 on e1.ReportsTo=e2.EmployeeID
order by e1.EmployeeID


--	SELF JOIN triple
select	e1.EmployeeID, e1.LastName, e1.FirstName, e1.ReportsTo,
			e2.LastName, e2.FirstName,  e2.ReportsTo,
			e3.LastName, e3.FirstName,  e3.ReportsTo
from employees as e1
left join employees as e2 on e1.reportsto = e2.employeeID
left join employees as e3 on e2.reportsto = e3.employeeID


--使用 LEFT JOIN 來實現 SELF JOIN,會比上面的例子多出一筆資料,有一個員工的主管資料為NULL
select e1.EmployeeID, e1.FirstName, e1.LastName, e1.ReportsTo, e2.FirstName, e2.LastName
from Employees as e1 
left join Employees as e2 on e1.ReportsTo=e2.EmployeeID
order by e1.EmployeeID


