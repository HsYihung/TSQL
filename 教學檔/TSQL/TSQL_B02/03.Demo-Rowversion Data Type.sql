--	Module 2   03.Demo - rowversion Data Type.sql
--			timestamp(rowversion) : 紀錄資料更新自動產生的時間戳記, 主要用來提供記錄版本編號, 
--						一資料庫中只能有一個

--			此資料類型會公開在 "資料庫中自動產生的唯一" 二進位數字。 
--			rowversion 通常用來作為 "版本戳記資料表資料列的機制"。這會追蹤資料庫內的 "相對時間"，
--							而不是關聯於時鐘的實際時間, 與時鐘的實際時間無關 
--			儲存區大小為 8 位元組。 rowversion 資料類型只是會 "遞增的數字"，
--			因此 "不會保留日期或時間"。 若要記錄日期或時間，請使用 datetime2 資料類型。
--			rowversion 不適合做索引 index 或主鍵 PK , 因為會變

--	Step 1: Open a new query window to the tempdb database
use  LabDB2 ;
go

drop table if exists Orders

--	Step 2: Create and populate a table that uses the rowversion data type
create table Orders ( 
	  OrderID  int  identity (1, 1) ,							       -- identity
	  OrderDate  datetime  not null ,
	  SalespersonID  int  null ,
      CreateTime datetime2 default getdate() not null,  -- default always work on insert, not for update
	  Concurrency  rowversion  not null,                       -- like update time
	 --  timestamp                                                         -- no column name
) ;


--	傳回目前資料庫的目前 rowversion / timestamp 資料類型值。 
--  這個時間戳記在資料庫中必須是唯一的。
select  @@dbts ;   -- dbts : time stamp values of db


--	Step 3: Add 2 new rows to dbo.Opportunity
insert Orders (OrderDate)
	values	(sysdatetime())      -- add  6 for OrderDate
go 6

		   
--	Step 4: Show that the "rowversion" column was populated automatically 
select * from  Orders;		   

select  @@dbts ;


-- Step 5: Try to update the rowversion column. This will fail as 
--         you cannot update a rowversion column directly. 
--  Error :  can't update
update Orders										--	訊息 272，層級 16，無法更新時間戳記資料行。
set Concurrency = Concurrency +1
where OrderID =1;


select  @@dbts ;


--	Step 6: Try to insert an explicit value for the rowversion column.
--              This will fail as you cannot insert into a rowversion column directly.

insert Orders ( OrderDate,  Concurrency )				 
	values (sysdatetime() ,  0x00000000000007E7 ) ;    -- Error : can't insert
go 


-- Step 7: Update another column for OrderID 1
select  @@dbts ;

select * from Orders where OrderID = 1;

update Orders
set  SalespersonID = 35 
where OrderID =1;

select * from Orders						-- check :  Concurrency change

select @@dbts, * from Orders ;
