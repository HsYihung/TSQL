--	Module 9   01.Demo-2 - SavePoint.sql

--  儲存點提供了復原部份交易的機制。 在 SQL Server 內，
--	您可以使用 SAVE TRANSACTION savepoint_name 陳述式來建立儲存點。 
--	稍後，您可以執行 ROLLBACK TRANSACTION savepoint_name 陳述式來回復到儲存點，
--	而不是回復到交易開始。


-- Step 1 - Open a query window to the tempdb database
use  LabDB2 ;
go

select * from NewTable
insert NewTable values (5, 'ccc') ;


-- Step 3 - Now try the same in a transaction
--	Explicit Transaction Management Mode ***/
begin tran ;
	update NewTable  set  Info = 'Update 2' where  ID = 2 ;

	save tran  savepoint_test ;						--在交易內設定的儲存點(savepoint)
 
	update NewTable set  info = 'Update 3' where   ID = 3 ;

	select * from NewTable ;			-- Update 2,  Update 3
	select @@trancount ;  -- 1
--  run to here first ------------
	rollback tran  savepoint_test ;		-- 只剩 Update 2, 但未 commit
commit tran ;	


select * from NewTable ;
select @@trancount  ;  -- 1

rollback tran  ;

select * from NewTable ;
select @@trancount  ;  -- 0

--	1. 交易來保證避免資料處於一種不合理的中間狀態
--		例子：A匯錢給B，A帳戶會減少存款、B帳戶會增加存款，此兩者的交易必須同時成功，
--		或同時失敗，不能存在只有一方的帳戶金額的變動(不合理的中間狀態)，
--		利用交易的機制可以解決這個問題。


-- 例二 **********************************************************
select * from NewTable ;

print @@trancount				-- 0
begin tran
	print @@Trancount
	-- update NewTable  set  Info = 'Update 2' where  ID = 2
	Insert NewTable values(8, 'insert 8');	

	begin tran 
		print @@Trancount
		Insert NewTable values(9, 'insert 9');
		select * from NewTable		-- yes,  'inert 8' and 'inert 9' existed
	commit tran;
--  commit tran;    -- this one not commit yet.  @@Transcount = 1
print @@Trancount

rollback tran;
print @@Trancount

select * From NewTable		--  'inert 8' and 'inert 9' 消失 because of rollback tran
