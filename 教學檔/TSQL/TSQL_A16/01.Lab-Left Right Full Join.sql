--	Module 16 多表格聯結(Join) 的變形查詢語法
--		16-1 : 外部聯結(Outer Joins) 
--		16-2 : 交叉聯結(Cross Joins)
--		16-3 : 自我聯結(Self-Joins)

--			內部聯結(Inner Joins) : 將所有資料表內的資料視為一個資料表。
--			外部聯結(Outer Joins) : 先取出第一個資料表，再根據關聯欄位將其他資料表依次加入。
--			交叉聯結(Cross Joins) : 將第一個資料表中的每一筆資料與第二個資料表中的資料做乘積處理(較少使用)。
--			自我聯結(Self-Joins) : 將同一個資料表內的資料依判斷條件取出所需的資料。

--	Lab01 OUTER JOIN 
--	Outer Joins 外部連接 : LEFT JOIN、RIGHT JOIN、FULL JOIN

--	INNER JOIN					即	A ∩ B，稱AB的交集。
--	LEFT JOIN						即	A。
--	RIGHT JOIN					即	B。
--	FULL JOIN						即	A ∪ B，稱AB的聯集。
--	CROSS JOIN					(交叉聯結或稱笛卡兒乘積) ，即A × B，稱AB的積集。
--	SELF JOIN						自我聯結。即	A ∩ A....

--	SQL Server 2017/ 2019 p 9-2

use Northwind

--	使用 INNER JOIN 查詢產品資料及類別
select * from Employees					-- 9 records
select * from EmployeeTerritories	-- 49 records

--  產生兩個EmployeeID 有重疊的資料庫
select * into #EmpTemp from Employees where EmployeeID <=6							-- 6 records
select * into #EmpTerTemp from EmployeeTerritories where EmployeeID >=3		-- 40 records

select * from #EmpTemp
select * from #EmpTerTemp

--	使用 INNER JOIN 查詢
select e.EmployeeID, LastName, et.TerritoryID   
from #EmpTemp as e
inner join #EmpTerTemp as et	
on e.EmployeeID= et.EmployeeID


-- 例2
select * from Orders						-- 830
select * from [Order Details]		--2155

--  產生兩個OrderID 有重疊的資料庫
select * into #OrderTemp from Orders where OrderID <=10280
select * into #OrderDeTemp from [Order Details] where OrderID between 10270 and 10300

select * from #OrderTemp			-- 33
select * from #OrderDeTemp		-- 83


--	使用 INNER JOIN 查詢
select o.OrderID, CustomerID, od.UnitPrice   
from #OrderTemp as o
inner join #OrderDeTemp as od
on o.OrderID= od.OrderID


--	使用 LEFT OUTER JOIN 查詢產品資料及類別
select * from #EmpTemp
select * from #EmpTerTemp

select e.EmployeeID, e.LastName, et.TerritoryID   
from #EmpTemp as e
left join #EmpTerTemp as et						
on e.EmployeeID= et.EmployeeID


-- 例2
select * from #OrderTemp			-- 33
select * from #OrderDeTemp		-- 83

select o.OrderID, o.CustomerID, od.UnitPrice   
from #OrderTemp as o
left join #OrderDeTemp as od						
on o.OrderID= od.OrderID


--測試 RIGHT OUTER JOIN 的結果
select * from #EmpTemp
select * from #EmpTerTemp

select e.EmployeeID, e.LastName, et.TerritoryID   
from #EmpTemp as e
right join #EmpTerTemp as et						
on e.EmployeeID= et.EmployeeID

-- 例2
select * from Orders						-- 830
select * from [Order Details]		--2155

select o.OrderID, o.CustomerID, od.UnitPrice   
from #OrderTemp as o
right join #OrderDeTemp as od						
on o.OrderID= od.OrderID


--測試 FULL OUTER JOIN 的結果
select * from #EmpTemp
select * from #EmpTerTemp

select e.EmployeeID, e.LastName, et.TerritoryID   
from #EmpTemp as e
full join #EmpTerTemp as et						
on e.EmployeeID= et.EmployeeID
order by EmployeeID

-- 例2
select * from Orders						-- 830
select * from [Order Details]		--2155

select o.OrderID, o.CustomerID, od.UnitPrice   
from #OrderTemp as o
full join #OrderDeTemp as od						
on o.OrderID= od.OrderID
order by OrderID

