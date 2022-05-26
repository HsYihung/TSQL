--	Module 2  02.Lab - uniqueidentifier Data Type.sql
--			GUID : Globally Unique Identifier
--			uniqueidentifier 資料類型的資料行或本機變數可以利用下列方法，初始化為一個值：
--			使用 NEWID 或 NEWSEQUENTIALID 函式。
--			從 xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx 格式的字串常數轉換，
--			其中每一個 x 是範圍 0-9 或 a-f 的十六進位數字。 
--			32個十六進位數字
--			例如，6F9619FF-8B86-D011-B42D-00C04FC964FF 是有效的 uniqueidentifier 值。

--			SQL Server 中的全域唯一識別碼 (GUID) 資料類型會以 uniqueidentifier 資料類型來表示，
--			它會儲存 16 位元組的二進位值。 GUID 是二進位數字，主要當成識別項使用，
--			在許多電腦位於許多站台上的網路中，該識別項必須是唯一的。 
--			GUID 可藉由呼叫 Transact-SQL NEWID 函數來產生，並保證在 "全世界" 都是唯一的。 
--			世界上的任何兩台計算機都不會生成重複的 GUID 值。

--			GUID 主要用於在擁有多個節點、多台計算機的網絡或系統中，分配必須具有唯一性的標識符。

--  原文網址：http://read01.com/NyKE3G.html

--         具有更新訂閱的合併式複寫和異動複寫，都使用 uniqueidentifier 資料行，以確保資料列可以在多份資料表唯一識別。
--	https://docs.microsoft.com/zh-tw/sql/t-sql/data-types/uniqueidentifier-transact-sql?view=sql-server-ver15


--			主要當成識別項使用，在許多電腦位於許多站台上的網路中，該識別項必須是唯一的。
--  https://docs.microsoft.com/zh-tw/dotnet/framework/data/adonet/sql/comparing-guid-and-uniqueidentifier-values


--	Step 0: Create a table with a uniqueidentifier data type
use  LabDB2 ;
go

--	check : master → 檢視 → 系統檢視表 → sys.databases

drop table  if exists TestGuid1, TestGuid2

-- Step 1-1: Create a table with a uniqueidentifier data type
create table TestGuid1 (
	id int not null identity(1, 1),
	[Guid_NewID] UniqueIdentifier default newid()
);


-- Step 1-2: Add 3 rows using the NEWID() function.	GUID : Globly Unique ID
insert TestGuid1 ([Guid_NewID]) default values ;
go 5


-- Step 1-3: Examine the resulting rows
select * from TestGuid1 ;


--  使用 NEWID() 函數，隨機、亂數(random)選取 N 筆資料列
use Northwind
go
select * from Customers  -- 回傳有 91 筆客戶資料

 
--  以隨機、亂數的排序方式，顯示全部的客戶資料
select  CustomerID, Phone
from Northwind.dbo.Customers
order by newid()


--  觀察 : an example about 'rowguid' on column : 'rowguid' & 'ModifiedDate'
use AdventureWorks
select * from Sales.Customer



-- Step 2-1: Create a table with a uniqueidentifier data type
--		它是由網絡卡上的標識數字(每個網絡卡都有唯一的標識號、奈秒級時間、晶片ID碼和許多可能的數字)以
--		觀察 : cmd → ipconfig/all → 乙太網路卡 VMware Network Adapter VMnet8 → 實體位址 : 00-50-56-C0-00-08
--												 → 無線區域網路介面卡 區域連線* 2: → 實體位址 : 30-24-32-B8-A7-64

--		及 CPU 時鐘的唯一數字生成的的一個 32 個4位元組(byte)。
--		缺點 : 儲存空間增大；索引時間較慢。

use LabDB2
create table TestGuid2 (
	id int not null identity (1, 1),
	[Guid_NewSequential_ID] UniqueIdentifier default NewSequentialId()
);
go


-- Step 2-2: Add 3 rows using the NEWID() function.	
insert TestGuid2 ([Guid_NewSequential_ID]) default values
go 5
 

-- Step 2-3: Examine the resulting rows

select * from TestGuid1 ;
select * from TestGuid2 ;

--  newsequentialid 函式比起 newid 函式最大的好處是：如果你在一個 UNIQUEIDENTIFIER 欄位上建立索引，
--  使用 newid 產生的新的值是不固定的，所以新的值導致索引B+樹的變化是隨機的。
--  而 newsequentialid 產生的新的值是有規律的，則索引B+樹的變化是有規律的。
--  有規律和無規律就會帶來效能的改進。

--	 UNIQUEIDENTIFIER做主鍵(Primary Key)是一件很方便的事情，在資料合併等操作中有不可替代的優勢
--  但是由於普通的GUID的分散性使得如果主鍵加上聚集索引(Clustered Index)會導致在插入記錄時效率大大降低

-- Step 3: Clean up by dropping the tables
drop table  if exists TestGuid1, TestGuid2
