 --	Module 18. 觸發程序(DML Triggers)的進階觀念、設計與實作    
 --		18-1:如何建立 INSTEAD OF Triggers     
 --		18-2:使用 UPDATE() 函數來判斷欄位值是否被修改    
 --		18-3:巢狀觸發程序(Nested Triggers) 的運作方式及其注意事項    

--			INSTEAD OF 觸發程序 : 可用來攔截與取代指定操作，因觸發的指令並不會被
--			執行，因此需要 INSTEAD OF 觸發程序 "取代" 原指令執行操作，可用於 VIEW (檢
--			視表)，同一個資料表或檢視表只能定義每一個 INSERT、UPDATE 與 DELETE
--			指令各一個 INSTEAD OF 觸發程序

--  01.Lab - INSTEAD OF Trigger.sql

-- Step 1: Open a new query window and use the tempdb database
use  LabDB2 ;


drop table if exists CurrentPrice		-- drop table, drop trigger at the same time

-- Step 2: Create and populate the dbo.CurrentPrice table 
--              Note the additional 〝IsValid〞 column
create table CurrentPrice (
	CurrentPriceID  int, --identity (1, 1), 
		--constraint PK_CurrentPrice  primary key ,
	SellingPrice  decimal(18, 2)  not null ,
	ModifiedDate  datetime2  default sysdatetime() ,
	CreatedDate  datetime2  default sysdatetime() ,
	ModifiedBy  sysname  not null default original_login(),  -- 電腦名稱
	IsValid  bit  not null default 1									-- Add additional 〝IsValid〞 column
) ;


-- Populate the table
insert CurrentPrice (CurrentPriceID, SellingPrice)
	values (1, 2.3) ,  (2, 4.3) ,  (3, 5) ;


-- Select the current rows
select * from CurrentPrice ;

drop trigger if exists tg_CurrentPrice_Instead_of_Delete

-- Step 3: Create the trigger for INSTEAD OF DELETE
create trigger tg_CurrentPrice_Instead_of_Delete
on CurrentPrice
instead of delete				-- 當遇到 delete 就轉成 begin ...... end 中做的程序
as
begin
	set nocount on;
	update cp set cp.IsValid= 0,
				cp.ModifiedDate = sysdatetime()
	from CurrentPrice as cp
	inner join deleted as d
	on cp.currentPriceID = d.CurrentPriceID;
end


-- Step 4: Try to delete a row
--              Note the number of rows shown as being affected 
--              and that no errors are returned

select * from CurrentPrice
delete  CurrentPrice where  CurrentPriceID = 1 ;


-- Step 5: Requery the table and note that row 2 is still 
--              there but now "update" instead of "deleted"
select * from CurrentPrice ;


-- Step 6: Query sys.triggers and note the value in 
--              the 〝is_instead_of_trigger〞 column
select object_name(parent_id), object_name(object_id), * from sys.triggers;



-- 例二
 -- 如果 insert 的資料已經存在 table 中, 就轉成 update 資料, 否則就 insert 
drop trigger if exists tg_CurrentPrice_Instead_of_Insert

create trigger tg_CurrentPrice_Instead_of_Insert
on CurrentPrice
Instead of Insert
as
begin
      if exists (select * from CurrentPrice 
					where CurrentPriceID = (select CurrentPriceID from inserted)) 
	      begin 
	          update CurrentPrice set CurrentPrice.SellingPrice = inserted.SellingPrice 
		      from CurrentPrice
			  join inserted
              on CurrentPrice.CurrentPriceID = inserted.CurrentPriceID
			  print 'update success instead of insert'
	      end;
      else
	     begin
		     Insert into CurrentPrice (CurrentPriceID, SellingPrice, IsValid)-- values (inserted.CurrentPriceID, inserted.SellingPrice)
			 select CurrentPriceID, SellingPrice, IsValid from inserted
			 print 'insert success'
		 end
end;
 
insert CurrentPrice (CurrentPriceID, SellingPrice, IsValid) values(2, 28.6, '1')

select * from CurrentPrice;



-- Drop the table (and with it, the trigger)
drop table if exists CurrentPrice ;


--	巢狀觸發程序(Nested Triggers) 的運作方式及其注意事項

--  若 TableA 有個 AFTER Trigger 會去更改 TableB 中的資料，
--	而 TableB 也有個 Trigger 會去更改 TableA 中的資料，這種情況稱為巢狀 AFTER 觸發程序。 
--	巢狀 AFTER 觸發程序最多只會執行 32 次，之後就會停止。

exec sp_configure 'nested triggers'    --查詢設定
