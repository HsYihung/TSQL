--	Module 13   02.Lab - Create a new stored procedure.sql

--	User-Defined Stored Procedure (使用者自訂預存程序) : 
--				由使用者自訂的預存程序，儲存於該 "資料庫中可程式性項目的預存程序中"

use LabDB2
go

--  check : LabDB2 → 可程式序 → 預存程序 

--  Create Proc Proc_A
drop proc if exists Proc_A

create procedure Proc_A
as
select * from Northwind.dbo.Employees


select * from sys.procedures
select object_definition (object_id('Proc_A')) as Obj_def

exec Proc_A			--	check : LabDB2 → 可程式序 → 預存程序 → dbo.Proc_A



--  Create Proc Proc_B
drop proc if exists Proc_B			--	刪除預存程序

--	當有設定 nocount on 時就可以關閉 SQL Server 回傳 頁籤 "訊息" 中資料的行為，
--	這樣對效能會有不錯的改善，因為網路的傳輸量會降低不少。
create proc Proc_B
as
set nocount on					
select * from Northwind.dbo.Employees

exec Proc_B


-- Alter Proc
alter proc Proc_B				--	修改預存程序
as 
select * from Northwind.dbo.Employees where TitleOfCourtesy = 'Ms.' 

exec Proc_B


exec sp_helptext 'Proc_A'
exec sp_helptext 'Proc_B'

select * from sys.sql_modules where object_id =object_id ('Proc_A')
select * from sys.sql_modules where object_id =object_id ('Proc_B')

drop proc if exists Proc_A, Proc_B



-- 例二

-- Step 1: Open a new query window to the AdventureWorks database
select * from AdventureWorks.Production.ProductReview
select * from AdventureWorks.Production.Product

-- Step 2: Create a new stored procedure:  Production.GetReviews 
 --             that gets reviews for all products.


drop proc if exists GetReviews

create proc GetReviews
with encryption						-- 加密
as
select p.ProductID, p.Name, pr.ReviewDate, pr.ReviewerName, pr.Rating, pr.Comments
from AdventureWorks.Production.ProductReview as pr
join AdventureWorks.Production.Product as p
on p.ProductID = pr.ProductID
order by p.Name, pr.ReviewDate


-- Step 3:Test stored procedure

exec GetReviews

-- Step 4: Query sys.procedures to see the list of procedures
select * from sys.procedures


-- Step 5-1: Query the definition of the stored procedure.
exec sp_helptext 'GetReviews'


-- Step 5-2: Query the definition of the stored procedure.
select * from sys.sql_modules
where object_id = object_id('GetReviews')

-- Step 5-3: Query the definition of the stored procedure.
select object_definition (object_id('GetReviews')) as Obj_def


-- Step 6: Drop the stored procedure
drop proc if exists GetReviews
