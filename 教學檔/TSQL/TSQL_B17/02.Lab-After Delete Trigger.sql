--	02.Lab - AFTER DELETE Trigger.sql

-- Step 1: Open a new query window and use the AdventureWorks database
use LabDB2

-- Step 2: Show the contents
select * from Book

drop trigger if exists tg_book_delete_select

create trigger tg_book_delete_select on Book
for delete										-- 代表 delete 的資料「前」的資料
as
begin
	declare @ISBN nvarchar(20)	
	select @ISBN = ISBN from deleted					-- deleted
	print 'delete occured on ISBN no. : ' +@ISBN
	select * from Book
end


select * from Book
delete from Book where ISBN = 34

disable trigger  tg_book_delete_select on Book;
drop trigger if exists tg_book_delete_select

-------------------------------------------------------------------
--	FOR | AFTER : AFTER 指定只在觸發的資料表中所有 SQL 語法操作作業都執行
--	成功時才引發啟動DML 觸發程序，使用FOR與AFTER的意義相同

drop trigger if exists tg_book_delete_after

create trigger tg_book_delete_after on Book
after delete																	-- after delete
as
begin
	declare @ISBN nvarchar(20)	
	select @ISBN = ISBN from deleted				-- deleted

	print 'delete occured on ISBN no. : ' +@ISBN
	select * from Book
end


select * from Book
delete from Book where ISBN = 4

disable trigger  tg_book_delete_after on Book;

drop trigger if exists tg_book_delete_after



-- 例二

-- Step 1: Open a new query window 
--              and use the AdventureWorks database
use  LabDB2 ;
go

drop table if exists Temp_SalesTerritoryHistory ;


-- Step 2: Show the contents of the Sales.SalesTerritoryHistory table 
--              (Highlighting the nullable 〝EndDate〞 column)
select * into Temp_SalesTerritoryHistory from AdventureWorks.Sales.SalesTerritoryHistory ;
select * from Temp_SalesTerritoryHistory ;


-- Step 3: Create a trigger to disallow deletion of active history rows

drop trigger if exists  tg_SalesTerritoryHistory_Delete

create trigger tg_SalesTerritoryHistory_Delete on Temp_SalesTerritoryHistory
after delete
as
begin
	if exists (select 1 from deleted as d where d.EndDate is null)  -- 如果 EndDate 是 NULL 不可 delete
	begin
		print N'請注意!! 不可刪除目前這筆銷售區域的歷史資料'
		select * from deleted
		rollback;
	end
end


-- Step 4: Test the trigger by attempting to delete a row
--         (the delete will 〝fail〞)
select * from Temp_SalesTerritoryHistory

delete from Temp_SalesTerritoryHistory 
where BusinessEntityID = 275 ;					--try 280  注意 : 資料有兩筆其中有一筆是 NULL 的情況發生



-- Step 5: Drop the trigger
drop trigger if exists tg_SalesTerritoryHistory_Delete


-- 例三
use LabDB2

drop table if exists TempOrders, TempOrderDetails

select * from Northwind.dbo.Orders
select * from Northwind.dbo.[Order Details]

-- 建立 兩個暫時的 tables 
select * into TempOrders from Northwind.dbo.Orders
select * into TempOrderDetails from Northwind.dbo.[Order Details]

--  TempOrders 中一筆資料被 delete,  相對 Order Details 中的細項也要同步被刪除 
create trigger tg_OrderDelete on TempOrders
for delete
as
begin
	declare @OrderID int
	select @OrderID = OrderID from deleted

	print 'TempOrder delete occured'
	delete from TempOrderDetails where OrderID = @OrderID
	select * from TempOrders
	select * from TempOrderDetails
end


select * from TempOrders
select * from TempOrderDetails

delete from TempOrders where OrderID = 10248

drop trigger if exists tg_OrderDelete

