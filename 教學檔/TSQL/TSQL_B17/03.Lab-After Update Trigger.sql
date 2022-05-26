--	03.Lab - AFTER UPDATE Trigger.sql
use LabDB2

select * from Book

drop trigger if exists tg_Book_update

create trigger tg_Book_update on Book
for update
as
begin
	declare @ISBN_inserted nvarchar(20);
	declare @ISBN_deleted nvarchar(20);
	declare @Title_inserted nvarchar(50);
	declare @Title_deleted nvarchar(20);

	select @ISBN_inserted = ISBN from inserted					--  讀到的是 inserted
	select @ISBN_deleted = (select ISBN from deleted)			-- 另一種寫法, 讀到的是 deleted

	select @Title_inserted = Title from inserted
	select @Title_deleted = Title from deleted

	print 'DML inserted occured on ISBN no. : '+@ISBN_inserted+',  Title : '+@Title_inserted
	print 'DML deleted occured on ISBN no. : '+@ISBN_deleted+',  Title : '+@Title_deleted
	select * from Book where ISBN = @ISBN_inserted
end

select * from Book
update Book set Title = 'SQL Server 2016' where  ISBN = 68

drop trigger if exists tg_Book_update



-- 例二

-- Step 1: Open a new query window and use the tempdb database
use  LabDB2 ;


-- Step 2: Create the CurrentPrice table
drop table if exists CurrentPrice ;


create table CurrentPrice (
	CurrentPriceID  int  identity (1, 1) 
		constraint PK_CurrentPrice  primary key ,
	SellingPrice  decimal(18, 2)  not null ,
	ModifiedDate  datetime2  default sysdatetime() ,
	CreatedDate  datetime2  default sysdatetime() ,
	ModifiedBy  sysname  not null default original_login()  -- 電腦名稱
) ;


-- Step 3: Populate the table
insert into CurrentPrice (SellingPrice)
	values (2.3) ,  (4.3) ,  (5) ;



-- Step 4: Select the current rows
select * from CurrentPrice ;

  
-- Step 5: Update the row where CurrentPriceID = 2
update CurrentPrice 
set  SellingPrice = 20 
where  CurrentPriceID = 2 ;


-- Step 6: Reselect the rows and note that the 〝LastModified 〞column
--              has "not" been updated
select *  from CurrentPrice ;


-- Step 7: Create a trigger to update the LastModifed and ModifiedBy columns
drop trigger if exists tg_CurrentPrice_Update


create trigger tg_CurrentPrice_Update
on CurrentPrice
after update
as
begin
	set nocount on;
	update cp set cp.ModifiedDate = sysdatetime(),
				cp.ModifiedBy = Original_Login()
	from CurrentPrice as cp
	inner join inserted as i
	on cp.currentPriceID = i.CurrentPriceID;
end


-- Step 8: Test the UPDATE again then reselect rows from 
--              dbo.CurrentPrice and note that the LastModified
--              and Modified columns are now updated
update CurrentPrice 
set  SellingPrice = 30 
where  CurrentPriceID = 2 ;

select * from CurrentPrice ;


-- Step 9: Query the sys.triggers view and note the existence of the view
select object_name(parent_id), object_name(object_id), * from sys.triggers;


-- Step 10: Drop the dbo.CurrentPrice table
drop table if exists CurrentPrice		-- drop table, drop trigger at the same time

-- Step 11: Requery the sys.triggers view and 
--                note that the trigger is dropped when the table is dropped
select object_name(parent_id), object_name(object_id), * from sys.triggers;
go


