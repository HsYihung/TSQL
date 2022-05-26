--	Module 15.   02.Lab - Inline TVF.sql
--			ず碠戈ㄧ计(Inline TVFs) Table-valued Function
--			籔浪跌 (VIEW) だ (畉 TVF 肚把计,  盿Τ把计 VIEW)

--			ず碠戈ㄧ计(Inline TVFs) : 摸ㄧ计ず甧度穦Τ虫 Select  痹瓃
--						ㄤ "SELECT 琩高挡狦"嘿 "︽ず戈栋ㄧ计"

use  LabDB2 ;
go

--  Example 1
drop function if exists fn_SaleInYear

create function dbo.fn_SaleInYear(@SalesYear int)
returns table																-- return table
as
return  select * 
			from Northwind.dbo.Orders
			where year(OrderDate) =@SalesYear 

--  check : LABDB2  △  祘Α┦  △  ㄧ计  △  戈ㄧ计
select * from dbo.fn_SaleInYear(1996)


-- Example 2
drop function if exists fn_SalesStoreBySalesID

create function dbo.fn_SalesStoreBySalesID (@SalesPersonID int )
returns table
as
return	select top(3) SalesPersonID, BusinessEntityID, Name
			from AdventureWorks.Sales.Store
			where SalesPersonID = @SalesPersonID				--  @SalesPersonID
			order by name desc													-- order by name

select * from dbo.fn_SalesStoreBySalesID(279)			-- 279, 282, 286
