--	Module 7 叢集索引 (Clustered Index) 的規劃與建立
--			7-1: 叢集索引的結構
--			7-2: 如何建立叢集索引
--			7-3: 如何設計有效的叢集索引


--		叢集與非叢集索引說明
--		https://docs.microsoft.com/zh-tw/sql/relational-databases/indexes/clustered-and-nonclustered-indexes-described?view=sql-server-ver15

--		Heap : 堆積是一種沒有叢集索引的資料表。 一個或多個可以建立在儲存為堆積之資料表上的
--					非叢集索引。資料會以無指定順序的方式儲存於堆積中。 
--					一般來說，資料一開始是會以資料表中插入資料列的順序儲存，
--					但是 Database Engine 會移動堆積中的資料，以有效率地儲存資料列，
--					因此無法預期資料順序。 為確保從堆積中傳回之資料列順序，必須使用 ORDER BY 子句。

--		若要指定儲存資料列的永久邏輯順序，請於資料表上建立叢集索引，如此一來資料表便不是堆積


-- Step 1: 使用【LabDB2】資料庫
use LabDB2 ;
go

drop table if exists PhoneLog ;

-- Step 2: 建立一個以 Heap 為結構的資料表, no any Primary Key
create table PhoneLog (
	PhoneLogID int identity(1, 1)  not null,
	LogRecorded datetime2  not null,
	PhoneNumberCalled nvarchar(100)  not null,
	CallDurationMs  int not null
);


-- Step 3: Query sys.indexes to view the structure.
select * from sys.indexes
where object_id = object_id('PhoneLog');			-- index_id = 0, type_desc = 'HEAP'
go


select * from sys.partitions
where object_id = object_id ('PhoneLog');			-- index_id = 0,
go        



--	Heap : 資料會以無指定順序的方式儲存於堆積中, 由於插入資料時不會強制執行嚴格的順序，
--				因此插入作業通常會比同等的插入" 叢集索引 " 作業"快"。

-- 切勿使用堆積的情況 :
--		經常按排序順序傳回資料時，請勿使用堆積。 
--		在排序資料行中的叢集索引，可免去進行排序作業。
-- https://docs.microsoft.com/zh-tw/sql/relational-databases/indexes/heaps-tables-without-clustered-indexes?view=sql-server-ver15

-- Step 4: Drop the table
drop table if exists PhoneLog;
go

