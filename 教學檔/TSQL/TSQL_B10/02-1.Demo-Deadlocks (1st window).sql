--	Module 10  02-1.Demo - Deadlocks (1st window) 

--			當多個交易都鎖定相同資源，同時彼此等待被對方鎖定的資源時即發生死結，
--			通常資料庫會定時自動偵測死結問題的發生，當發生時會將在其中找出 "優先排除名單"
--			進行鎖定的釋放，提供其他交易可以繼續完成, 當 DeadLocks 產生時，
--			這時 Lock Manager 就會先依照死結優先權，選擇結束優先權較低 Process ，
--			如果兩個 Process 的死結優先權相同的話，那就會在估算那各 Rollback Cost 
--			較低並結束該Process ，並讓另一各 Process 可以順利完成。

--			資源可能是 : 單行(RID, 堆中的單行)、索引中的鍵(KEY, 行鎖)、頁(PAGE, 8KB)、
--			區結構(EXT, 連續的8頁)、堆或B樹(HOBT) 、表(TAB, 包括資料和索引)、檔案(File, 資料庫檔案)、
--			應用程式專用資源(APP)、元資料(METADATA)、分配單元(Allocation_Unit)、整個資料庫(DB)。

--			將死結(Deadlocks) 產生的機率降到最低的方法
--				1.  使用相同的存取順序 : 當所有交易皆以相同的順序存取時，因第一個鎖定資料
--					的才能夠進行下個鎖定，因此資料將不會產生Block(等待對方)的問題

--				2.  縮短交易時間 : 盡量將資料交易放在同個批次執行，減少交易次數跟時間，並
--					在交易中避免等待使用者的互動(例如:等待使用者輸入資料)

--				3.  使用較低的隔離等級 : 較低的隔離等級的資料鎖定可供多人同時讀取，較不易發生死結

-- Step 1: 開啟【工具】→【SQL Server Profiler】→ 【使用範本】在工具下拉式選單中【TSQL_Locks】
-- Step 2: 頁籤【事件選取範圍】→ 僅勾選【Deadlock Graph】事件的新追蹤(trace) → 執行。

-- Step 3: 在此視窗中，請先執行下方的交易指令碼
--              然後再立即執行【2nd Window】(第二視窗)的指令碼 (請切換到【2nd Window】(第二視窗))

use  LabDB2 ;
go

-- select * from DeadlockProduct
select  @@spid  AS  'spid' ;
begin tran
	  update DeadlockProduct set ProductName = 'Prod 2 Modified 1'
	  where ProductID = 2 ;

	  waitfor delay '00:00:08' ;

	  update DeadlockProduct set ProductName = 'Prod 1 Modified 1'
	  where ProductID = 1 ;
commit ;

select * from DeadlockProduct

-- Step 4: 請觀察一下究竟哪一方會出現 1205 的錯誤代號、作為交易死結 (Deadlocks)的犧牲者(victim) 。

-- Step 5: 停止選取的追蹤並查看這個 Deadlock Graph。

-- Step 6: 請將 Deadlock Graph 的結果加以匯出 。(檔案 → 匯出 →  擷取 SQL Server 事件 →  擷取死結事件 )

