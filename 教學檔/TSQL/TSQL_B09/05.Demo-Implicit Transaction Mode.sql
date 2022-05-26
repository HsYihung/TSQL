--	Module 9    05.Demo - Implicit Transaction Mode.sql

--			工具 → 選項 → 查詢執行 → SQL Server → ANSI  →  Set_Implicit_Transaction，
--			透過Set IMPLICIT_TRANSACTIONS ON或OFF的方式啟動與關閉隱含交易，
--			當資料庫進入此模式有開始交易便 TRANCOUNT=1，"直到執行COMMIT TRAN
--			或ROLLBACK Tran指令"，自動進行下個交易

-- Step 1 - Open a query window to the tempdb database
use  LabDB2 ;
go


-- Step 2 - Create and populate a test table
select * from NewTable ;
go

select  @@trancount  as  Tran_Count ;

-- Step 3 - Setting Implicit Transaction Mode → ON

set implicit_transactions on
select  @@trancount  as  Tran_Count ;

-- Step 4 : 
select * from NewTable ;
select  @@trancount  as  Tran_Count ;


-- Step 5 : 
rollback tran
select  @@trancount  as  Tran_Count ;


-- Step 6 : 
insert NewTable values (100, 'ddd') 
select * from NewTable ;
select  @@trancount  as  Tran_Count ;



-- Step 7 : either rollback or commit 
rollback tran
select  @@trancount  as  Tran_Count ;
select * from NewTable ;

commit  transaction ;
select  @@trancount  as  Tran_Count ;
select * from NewTable ;

--	若隱性交易一直 ON, 一但有insert, update 發生, 資料庫會一直被鎖住直到commit 發生

set implicit_transactions off
--	drop table if exists NewTable