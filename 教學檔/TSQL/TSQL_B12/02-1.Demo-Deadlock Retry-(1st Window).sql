--  Module 12   02-1.Demo - Deadlock Retry - (1st Window).sql

-- Step 1 : 在此視窗中，請先執行下方關於死結方面的重試程式碼(deadlock retry code)
--              然後再 "立即" 執行【2nd Window】(第二視窗)的程式碼
--              (請切換到【2nd Window】(第二視窗))


-- Step 2 : 請注意，這兩個視窗完全沒有對外顯示的紅色錯誤訊息。
--  用 while 迴圈去解決 deadlock 

use  LabDB2 ;
go

declare @RetryCount int = 5 ;	   -- retry 5 times
while (@RetryCount > 0)				-- retry update if deadlock victim
begin
	begin try
		begin tran  ;
			update DeadlockProduct 
			set ProductName = 'ProductID = 1 ~~Modified (1st Window)'
            where ProductID = 1 ;

			waitfor delay  '00:00:06' ;

			update DeadlockProduct 
			set ProductName = 'ProductID = 2 ~~Modified (1st Window)'
            where ProductID = 2 ;

			set @RetryCount = 0 ;		-- stop trying
			select @@trancount  as  Tran_Count ;		--	1
		commit tran ;
		select @@trancount  as  Tran_Count ;			--  0
	end try

	begin catch 
		if (error_number() = 1205)									-- deadlock victim
			begin
				set @RetryCount = @RetryCount - 1 ; 
				waitfor delay  '00:00:02' ;								-- wait for 2 sec.
				print  N'警告：(1st Window) 有死結(Deadlock) 情況發生！' ;
			end 
		else 
			set @RetryCount = -1 ;  -- 跳出 while 迴圈
		if xact_state() != 0  -- 使用XACT_STATE來確認交易失敗就還原整個交易(rolled back the transaction)，
			print '回滾 rollback tran 情況發生！'
			rollback tran ;
	end catch ;
end ;

select * from DeadlockProduct

