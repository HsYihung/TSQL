-- 請練習撰寫底下指令，使用 AdventureWorks.Sales.SalesPerson 資料庫
-- 用欄位 BusinessEntityID <=286 和 >=280 分隔成兩個select
-- 觀察 row 的變化

use AdventureWorks ;
go

--	Using UNION ALL : to return all rows from both tables " including duplicates "
select *	 from Sales.SalesPerson
where BusinessEntityID <=286
union all
select *	 from Sales.SalesPerson
where BusinessEntityID >=280


--	Using UNION : to return all rows from both tables " excluding duplicates "
select *	 from Sales.SalesPerson
where BusinessEntityID <=286
union
select *	 from Sales.SalesPerson
where BusinessEntityID >=280


--	Using INTERSECT : to return only rows found in both tables
select *	 from Sales.SalesPerson
where BusinessEntityID <=286
intersect
select *	 from Sales.SalesPerson
where BusinessEntityID >=280


--	Using EXCEPT : to return only rows from left table
select *	 from Sales.SalesPerson
where BusinessEntityID <=286
except
select *	 from Sales.SalesPerson
where BusinessEntityID >=280


--	Reverse position of tables, return only rows from left table
select *	 from Sales.SalesPerson
where BusinessEntityID >=280
except
select *	 from Sales.SalesPerson
where BusinessEntityID <=286
