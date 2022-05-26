--  Module 12   02-2.Demo - Deadlock Retry - (2nd Window).sql  

use  LabDB2 ;
go

declare @RetryCount int = 5 ;
while (@RetryCount > 0)				 -- retry update if deadlock victim
begin
	begin try
		begin tran ;
			update DeadlockProduct 
			set ProductName = 'ProductID = 2 ~~Modified (2nd Window)'
            where ProductID = 2 ;

			waitfor delay  '00:00:06' ;

			update DeadlockProduct 
			set ProductName = 'ProductID = 1 ~~Modified (2nd Window)'
            where ProductID = 1 ;

			set @RetryCount = 0 ;
			select @@trancount  as  Tran_Count ;
		commit tran ;
		select @@trancount  as  Tran_Count ;
	end try

	begin catch 
		if (error_number() = 1205)			-- deadlock victim
			begin
				set @RetryCount = @RetryCount - 1 ; 
				waitfor delay '00:00:02' ;
				print  N'警告：(2nd Window) 有死結(Deadlock) 情況發生！' ;
			end
		else
			set @RetryCount = -1 ;  -- 跳出 while 迴圈
		if xact_state() != 0  -- 使用XACT_STATE來確認交易失敗就還原整個交易(rolled back the transaction)，
			print '回滾 rollback tran 情況發生！ '
			rollback tran ;
		end catch ;
end ;

select * from DeadlockProduct