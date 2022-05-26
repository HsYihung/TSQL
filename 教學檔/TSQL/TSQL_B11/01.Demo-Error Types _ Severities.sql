--	Module 11   T-SQL 程式中錯誤訊息
--		11-1: 錯誤訊息的類型及其所具有的屬性
--		11-2: 透過ERROR_XXX()系統函數取得錯誤訊息
--		11-3: 系統函數@@ERROR 與ERROR_NUMBER()之間的差異

--	錯誤訊息編號 : 用來表示錯誤訊息所對應的唯一錯誤號碼
--	https://docs.microsoft.com/zh-tw/sql/relational-databases/errors-events/database-engine-events-and-errors?view=sql-server-ver15

--  錯誤訊息嚴重性層級(Seveirity) : 會傳回嚴重性。數值範圍為0-24, 其中嚴重性低 (例如 : 0~9) 的錯誤
--					表示是 "參考訊息" 或 "低階警告" , 嚴重性高的錯誤表示應該儘快處理的問題
-- https://docs.microsoft.com/zh-tw/sql/relational-databases/errors-events/database-engine-error-severities?view=sql-server-ver15


--	01.Demo - Error types and Severities.sql
-- Step 1: Open a new query window to MarketDev
use  AdventureWorks ;
go

-- Step 2: Note the returned error from a "syntax error"
--              比對 WebSite 錯誤訊息編號

selec  *  from  Person.Person ;  --  'selec' 接近 '*' 之處的語法不正確。
go

-- Step 3: Note the returned error from an "object resolution error"
--              Describe each returned entry in the error message
select  *  from  Dog ;						-- 無效的物件名稱 'Dog'
go


-- Step 4: Note the returned error from a runtime error
--              Describe each returned entry in the error message
--              and show how double-clicking the error in the messages
--              tab takes you directly to the error
select  12/0 ;								-- 發現除以零的錯誤。
go

-- Step 5: Query the contents of the sys.messages view
--              Note the language_id settings
select * from sys.messages 
where language_id=1028
order by language_id, message_id;
go

-- Step 6: Query the English messages only with severity 19 or above. 
--              Note the is_event_logged column
select * from  sys.messages
where  language_id = 1033 and  severity >= 19
order by  severity,  message_id ;


select * from  sys.messages
where  language_id = 1028 and severity >= 19
order by severity,  message_id ;