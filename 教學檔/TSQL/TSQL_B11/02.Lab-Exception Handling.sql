 --	Module 11    02.Lab - Exception Handling.sql

--			ERROR_NUMBER() 會傳回錯誤碼。
--			ERROR_SEVERITY() 會傳回嚴重性。數值範圍為0-24, 其中嚴重性低(例如:0~9)的錯誤
--							表示是參考訊息或低階警告嚴重性高的錯誤表示應該儘快處理的問題
--			ERROR_STATE() 會傳回錯誤狀態碼。可以透過此狀態碼至內含的已知問題的資料庫判斷
--							所記錄的問題與所遇到的錯誤是否相同，方便處理錯誤
--			ERROR_PROCEDURE() 會傳回發生錯誤的預存程序或觸發程序的名稱。
--			ERROR_LINE() 會傳回程式批次、預存程序、觸發程序或函數中造成錯誤的行號。
--			ERROR_MESSAGE() 會傳回錯誤訊息的完整文字。 文字包括提供給任何可替代參數的值，
--							例如，長度、物件名稱或次數。

use LabDB2
select * from NewTable;

--	系統函數@@ERROR 與ERROR_NUMBER()之間的差異
--				@@ERROR : 判斷SQL Server的錯誤發生的全域變數的值做判斷，
--								當@@ERROR為0時表示正確執行
--				ERROR_NUMBER():用來取得在CATCH區塊所發生錯誤的錯誤號碼，
--								在CATCH區塊外呼叫會回傳NULL

begin tran
	Insert NewTable values(1, 'eeee');       -- error :  identitiy id
	print @@error			--  @@ error 不好捕捉
	print @@error			--
	if @@error !=0
		begin
			print 'error happen'
			rollback tran
		end
	else 
		commit tran;


select @@trancount
select * from NewTable;


declare @TestTryCash int
begin try
		select @TestTryCash = 1000/0    -- error  /0
end try
begin catch
		if @@error !=0
			select	error_number()		as [err number],
						error_severity()		as [error severity], 
						error_state()				as [error state],
						error_procedure()	as [error procedure],
						error_line()				as [error line], 
						error_message()		as [error message]
		else
			print 'OK'
end catch
