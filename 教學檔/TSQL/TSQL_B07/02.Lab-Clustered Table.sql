--	Module 7   02.Lab - Clustered Table.sql

--  叢集索引(Clustered): 一個SQL Server資料表只會有一個叢集索引(主索引)，會其索引欄位
--					可由一個或多個欄位組成單一或複合索引, 叢集索引將資料表或檢視中的資料列
--					依其"欄位索引鍵值排序與儲存"。 


--	B tree (Balance Tree)
--	https://blog.niclin.tw/2018/06/18/%E4%BB%80%E9%BA%BC%E6%98%AF-b-tree-balance-tree/


--	Step 1: 使用【LabDB2】資料庫
use  LabDB2 ;
go

drop table if exists PhoneLog ;

-- Step 2: Create a table with a primary key specified.  means it is Clustered Table
create table PhoneLog(
	PhoneLogID int identity(1, 1)  primary key,          --  Clustered
	LogRecorded datetime2  not null,
	PhoneNumberCalled  nvarchar(100)  not null,
	CallDurationMs  int not null
);


-- Step 3: Query sys.indexes to view the structure
-- (note also the name chosen by SQL Server for the constraint and index)
select * from sys.indexes
where object_id = object_id('PhoneLog');		-- index_id = 1, type_desc = 'CLUSTERED'
go

select * from sys.partitions
where object_id = object_id ('PhoneLog');		-- index_id = 1,
go        

-- Step 4: Drop the table
drop table PhoneLog;
go
