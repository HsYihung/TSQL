--	Module 3 - Lab03 建立、修改與刪除資料表

--	database_name 是建立資料表的資料庫名稱，必需指定現有資料庫的名稱，
--			    如果未指定，則會預設為目前所在的資料庫。
--	schema_name 是指此資料表所屬的結構描述名稱，如果未指定，則會預設為 dbo
--	table_name 是指資料表的名稱，最長支援 128 個字元。


use LabDB;
go


--	使用 IF EXISTS 來刪除資料表
--		下列範例會建立名稱為 Table1 的資料表 
--		下列陳述式會刪除資料表。 
drop table if exists Table1; 

--	再做一次， 下列陳述式不會執行任何動作，因為資料表已刪除；但它不會造成錯誤。
drop table if exists Table1;  
go  


create table Table1 (Col1 int);  

insert into Table1 values (10)		--  into 可寫可不寫
go  3

-- 修改資料表 欄位名稱
-- ALTER TABLE 語法並沒有辦法變更欄位名稱, 請使用 sp_rename
--	注意: 變更物件名稱的任何部分將會中斷指令碼和預存程序。
select * from Table1

exec sp_rename 'Table1.Col1', 'Col2';   -- 不可用  Alter ... Alter 沒有辦法變更欄位名稱
go

select * from Table1

drop table if exists Table1;  
go  

-- drop again with no error because of 'if exists'
drop table if exists Table1;  
go  
