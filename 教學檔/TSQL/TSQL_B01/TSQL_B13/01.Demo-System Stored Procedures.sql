 --	Module 13 預存程序(Stored Procedure)的設計與實作
--				13-1: 如何建立與執行預存程序
--				13-2: 如何修改預存程序
--				13-3: 如何刪除預存程序

--	Stored Procedure(預存程序)的類型:
--				System Stored Procedure(系統預存程序)
--				Extended Stored Procedure(擴充預存程序)
--				User-Defined Stored Procedure(使用者自訂預存程序)


--	SQL Server 的 Stored Procedure (預存程序sp) : 用來將常用複雜的工作 "預先設計"
--			為SQL程式並儲存為一個程序名稱，需要使用時再以 EXECUTE 執行此程序完成
--			工作，其優點為可重複使用、執行效率高、安全性佳 (加密編碼) 與操作流程統一
--			，通常為了增加資料存取的安全與保密，會將資料表限制一般使用者無法 "直接" 存取並
--			建立 "檢視表" 或 "預存程序" 供使用者 "間接" 存取特定的資料內容與程序,  
--			有點類似於把一個函數存在一個變數裡，之後呼叫這個變數的時候就可以跑裡面的程式碼。

--	01.Demo - System Stored Procedures.sql

-- Step 1: Open a new query window to the tempdb database
use  LabDB2 ;
go

-- Step 2: Browse the list of 「System Stored Procedures 」

--				System Stored Procedure (系統預存程序) : SQLServer 內建的預存程序，以
--				sp_開頭用來執行系統相關的設定、管理與資訊的取得
--            【master】→【可程式性】→【預存程序】→【系統預存程序】。
--				ex. : sp_attach_db,   sp_detach_db,  sp_help, 

-- Step 3: Execute some system stored procedures to see how they could be used
exec  sys.sp_configure ;
go

exec  sys.sp_helpdb ;
go


--				Extended Stored Procedure (擴充預存程序) : 由程式語言撰寫的DLL檔提供
--				擴充功能存取資料(例如:C++語言)，以 xp_ 為開頭表示
--            【master】→【可程式性】→【擴充預存程序】→【系統擴充預存程序】。

--				需 set facet = true  安全考量
--				物件總管 → \SQLEXPRESS(SQL...) (右鍵) → Facet → XPCmdShellEnable (Ture)
--				執行 xp_ 開頭的預存程序必須事先指定所在資料庫位置，且基於系統安全性原故
--				預設會關閉 xp_ 開頭的預存程序需事先設定開啟才可使用

 
exec xp_cmdshell 'dir c:\'

--  xp_cmdshell 擴充預存程式也會建議傳回狀態。 傳回碼值儲存在變數 @result 中
declare @result int;  
exec @result = xp_cmdshell 'dir c:\*.exe';    -- try : remove *.exe
if (@result = 0)  
   print 'Success'  
else  
   print 'Failure';



--  如何讀取某資料庫的所有預存程序名稱(Stored Procedure name)
select * from sysobjects
where xtype= 'PK' 
order by name

   