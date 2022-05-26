--	Module 12   T-SQL 程式中的例外處理
--		12-1: 使用結構化的例外處理TRY/CATCH 語法來處理錯誤訊息
--		12-2: 使用RAISERROR() 將一般訊息或者是錯誤訊息傳回給應用程式
--		12-3: 使用THROW 來引發或者是重新引發例外狀況

--		實作類似於 Transact-SQL Visual C# 與 Microsoft Visual C++ 語言中之例外狀況處理的 
--		Microsoft 錯誤處理。 您可以將 Transact-SQL 陳述式群組含括在 TRY 區塊內。 
--		如果 TRY 區塊內發生錯誤，就會將控制權傳給含括在 CATCH 區塊內的另一個陳述式群組。


--	SQL Server 中的每個錯誤訊息都包含以下幾個元素：
--			錯誤代碼（Error number）：每一則錯誤訊息都有唯一的整數值錯誤號碼，範圍由 1 到 49999
--			錯誤層級（Severity level）：嚴重性指出錯誤的嚴重程度。範圍由 0 到 24
--							0-9 表示狀態或不嚴重的錯誤資訊，
--							10 表示輸入資訊不正確，
--							11-16 表示使用者操作錯誤，
--							17-24 表示軟體或硬體上的錯誤，
--							20-24 表示極嚴重的錯誤，
--					用戶端連接會在收到訊息之後中斷，該錯誤會記錄在錯誤和應用程式記錄檔中
--			錯誤訊息（Error message）：錯誤訊息包含錯誤原因的資訊。訊息長度最大為 255 Unicode 字元.
--			狀態碼（State） ：範圍由 0 到 127 ，供程式內部使用。


--	01.Lab - SQL Server Error Handling.sql

-- Step 1: Open a new query window to LabDB2.
use  LabDB2 ;
go

-- Step 2: Use RAISERROR to raise an error of severity 10.
--              Note that in the results pane it is not displayed as an error.

--			產生錯誤訊息並起始工作階段的錯誤處理。 RAISERROR 可以參考儲存在 
--			sys.messages 目錄檢視表的使用者自訂訊息，或是動態建立訊息。 
--			訊息以伺服器錯誤訊息傳回給呼叫應用程式，或傳回給 TRY...CATCH 建構的相關聯 CATCH 區塊。 
--			新應用程式應該改用 THROW。

--	RAISERROR({msg_id|msg_string}, severity, state)
--	說明 : {msg_id|msg_string}:表示訊息編號或字串，若為字串其編號為50000


declare @DataBaseID int = db_id()
declare @DataBaseName sysname = db_name()
RaisError('目前所在data base 代號為 : %d,  data base name 是 : %s', 
				11,								--	Severity  try 11
				1,									--	State
				@DataBaseID,			--  first substitution argument
				@DataBaseName ) ;
go


-- Step 3: 11-16表示使用者操作錯誤，17-24表示軟體或硬體上的錯誤，20-24表示極嚴重的錯誤
declare @DataBaseID int = db_id()
declare @DataBaseName sysname = db_name()
RaisError('目前所在data base 代號為 : %d,  data base name 是 : %s', 
				19,								--	Severity  改成 18, 22 看看錯誤訊息
				1,									--	State
				@DataBaseID,			--  first substitution argument
				@DataBaseName ) ;
go


-- Step 4: 
-- Step 4-1:  @@ERROR 稍縱即逝, 快速被清除
RaisError ('message', 16, 1);
--print @@error
if @@error != 0
	print 'Error : ' + cast(@@error as varchar(8))	  -- @@ERROR 稍縱即逝, 快速被清除


-- Step 4-2: 如何抓住 @@ERROR value.
declare @ErrorValue int;
RaisError ('message', 16, 1);
set @ErrorValue = @@error
--print @ErrorValue
if @ErrorValue <> 0
	print 'Error : ' + cast(@ErrorValue as varchar(8));


-- Step 5: Use THROW to raise an error.

--  語法: THROW [{ error_number| @local_variable},
--								{ message | @local_variable},
--								{ state | @local_variable}][ ; ]
--	說明:	error_number:表示例外狀況的常數或變數，必須是大於或等於50000且小於
--							或等於2147483647的整數值
--				message:表示說明例外狀況的字串或變數的訊息，型別為nvarchar(2048)
--				state:表示要與訊息相關聯的狀態，介於0-255間型別為tinyint的常數或變數

throw 51245, 'hi Siri. good morning', 1;

throw 50000, 'Google, good morning', 2;

throw 50001, 'Happy now', 3;

throw 823, 'Happy, Happy now', 4   -- 請指定有效範圍 (50000 到 2147483647) 內的錯誤號碼。


--  下列範例示範如何使用 THROW 陳述式，重新引發上次擲回的例外狀況。

declare @d1 decimal (5, 2)
begin try  
	set @d1 = 9999.99			--	suppose 99.99 (5, 2)
	print @d1
end try
begin catch
--print N'錯誤代碼：' + cast(error_number() as varchar(5)) + N'  錯誤訊息：' + error_message();
--RaisError ('message', 15, 1);
--throw;
throw 50000, 'O!! my God!! ', 4;		
end catch



drop table if exists TestRethrow

create table TestRethrow  (id int primary key); 

begin try  
    insert TestRethrow(id) values(1);  
    insert TestRethrow(id) values(1);  --  Force error 2627, Violation of PRIMARY KEY constraint to be raised.  
end try  
begin catch  
--    print N'錯誤代碼 error code：' + cast(error_number() as varchar(5)) + N' 錯誤訊息 info：' + error_message();
--		RaisError ('message', 15, 1);
--     throw															--  關掉 throw 試試看
   throw 50000, 'O!! my God!! ', 4;		
end catch ;  


--  下列範例示範搭配 while loop 陳述式，擲回的例外狀況。
--	使用除數不能為0的規則，來傳回迴圈中的錯誤代碼，迴圈從1開始，每次遞減1，直到-1為止
declare @i int = 1
while @i >= (-1)
begin
	print ('@i = ' + convert(varchar, @i))
	begin try
		print ('1/@i = ' + convert(varchar, 1 / @i))
		print ('@@ERROR = ' + convert(varchar, @@ERROR))
		print ('--------------------')
		set @i = @i - 1
	end try

	begin catch
		print ('1/0 is wrong, @@ERROR = ' + convert(varchar, @@ERROR) + ', 錯誤訊息： ' +  ERROR_MESSAGE())
		print ('--------------------')
		set @i = @i - 1
		continue
	end catch
end



--  使用 begin Tran.....commit....rollback
select * from TestRethrow

begin try 
	begin tran
		insert TestRethrow(id) values(2);  
		insert TestRethrow(id) values(1);  --  Force error 2627, Violation of PRIMARY KEY constraint to be raised.  
	commit tran
end try  
begin catch  
	rollback tran
    print N'錯誤代碼：' + cast(error_number() as varchar(5)) + N' 錯誤訊息：' + error_message();
--		RaisError ('message', 15, 1);
--	throw															--  關掉 throw 試試看
--    throw 50000, 'O!! my God!! ', 4;		
end catch ;  
select * from TestRethrow



select  * from  sys.messages where message_id = 8134


