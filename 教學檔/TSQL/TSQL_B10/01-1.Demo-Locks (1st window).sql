 --	Module 10  資料庫的鎖定(Locks) 管理簡介
--				10-1: 鎖定的類型
--				10-2: 將死結(Deadlocks) 產生的機率降到最低的方法
--				10-3: 交易隔離等級(Transaction Isolation Level) 的設定

--	交易的鎖定的類型:
--		1. 獨佔式鎖定 (Exclusive Lock)
--		2. 共用式鎖定 (Shared Lock)
--		3. 更新式鎖定 (Update Lock)
--		4. 意圖式鎖定 (Intent Lock)

--	鎖定模式	描述
--		1.獨佔式鎖定(Exclusive Lock)(X) : 禁止其他交易對象 "存, 取或鎖定" 資料，
--				當進行A交易時資料使用獨佔式鎖定後，B交易若對相同資料欲進行任何交易鎖定
--				將會被拒絕(當資料庫進行新增、修改、刪除與查詢時，會先將資料進行此鎖
--				定，直到交易完成後才會釋放並在需要時可以進行ROLLBACK), 用於資料修改動作，
--				例如 INSERT、UPDATE 或 DELETE。 確保不能對相同資源同時進行多重更新。

--		2. 共用式鎖定(Shared Lock) (S): 將資料設定為唯讀，
--				此時 "禁止" 其他交易對資料進行獨佔式鎖定(Exclusive Lock)，但允許其他交易對資料
--				再進行共用式鎖定，亦即資料可同時被多個交易做共用式鎖定 "讀取資料" 內容，
--				但是 "不可以進行獨佔式鎖定與更改資料內容" (當"僅讀取資料庫資料"但不更動內容時，
--				會將資料做共用式鎖定，防止其他人更改資料), 用於 "不變更或更新" 資料的讀取作業，
--				例如 SELECT 陳述式。

--		3. 更新式鎖定(Update Lock)(U) : 更新式鎖定與共享式交易相同，
--				但當交易需要將資料 "進行修改更新時會自動提升成獨佔式" 鎖定並修改資料
--				(當此時並無其他共享式鎖定存在), 用於可更新的資源上。 防止當多個工作階段正在讀取、
--				鎖定及後來可能更新資源時發生常見的死結。

--		4. 意圖式鎖定(Intent Lock) : 表示欲僅鎖定物件中的 "部分資源"，其主要的目的為
--				提升獨占式鎖定時的資料處理效能，用來標示出某物件中的 "部分鎖定資料"，不
--				需再檢查資料表中的每一項資源是否已經被鎖定，已決定該資料是否可進行獨占式鎖定
--				意圖式鎖定的種類:
--						1. IntentShared(IS) : 表示欲進行 "共享式鎖定" 並讀取指定物件中的 "部分資源"
--						2. IntentExclusive(IX) : 表示欲進行"獨佔式鎖定" 並更改指定物件中的 "部分資源"
--						3. SharedWithIntentExclusive(SIX) : 表示欲進行共享式鎖定並讀取指定物件中
--									的全部資源，同時進行 "獨佔式鎖定並更改指定物件中的部分資源"

--		5.  結構描述	執行相依於資料表結構描述的作業時使用。 結構描述鎖定的類型為：
--				結構描述修改 (Sch-M) 與結構描述穩定性 (Sch-S)。DDL對資料表無效

--		6. 大量更新 (BU)	用於大量複製資料到資料表，且已指定 TABLOCK 提示時。

--		7. 索引鍵範圍	當使用可序列化交易隔離等級時，保護查詢讀取的資料列範圍。 
--				確定其他交易無法插入資料列，這些資料列在查詢重新執行時可限定可序列化交易的查詢。


--	01-1.Demo - Locks (1st window)

-- Step 1 - Open Activity Monitor【活動監視器】 to view the current lock information.

-- Step 2 - Explain each of the rows returned

-- Step 3 - Open a new query window to the Deadlock database
use  LabDB2 ;
go


-- 建一 DeadlockProduct 準備工作
drop table if exists DeadlockProduct ;

select  * into DeadlockProduct
from  MarketDev.Marketing.Product ;
go

alter table DeadlockProduct
	add constraint PK_DeadlockProduct  primary key (ProductID) ;
go
select * from DeadlockProduct

-- Use the SPID to identify the connection 傳回目前使用者處理序的工作階段識別碼
select  @@spid  AS  'spid' ;


-- Step 4 - Update product 1 in a transaction
begin tran ;
	update DeadlockProduct 
	set  ProductName = 'Update from window 1'
	where  ProductID = 1 ;							-- not commit yet

select * from DeadlockProduct
select @@trancount						-- trancount = 1

-- Step 5 - Switch to the【2nd window】


-- Step 15 - Roll back the transaction in the【1st window】
rollback ;
go
