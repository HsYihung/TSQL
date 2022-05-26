--	Module 7    03.Lab - PRIMARY KEY NONCLUSTERED.sql

--		索引 :	針對特定一或多個欄位資料做索引，並以其索引預先排序，當尋找這些欄位資料時
--					將會比過去的循環式搜尋擁有較高的效率也較快速
--		索引種類:
--					1. 叢集索引 (Clustered)
--					2. 非叢集索引 (Non-Clustered)

-- Step 1: 使用【LabDB2】資料庫
use  LabDB2 ;
go

drop table if exists PhoneLog ;

-- Step 2: Create a table with a primary key nonclustered specified
--	將 PRIMARY KEY 建立為『非叢集索引』
create table PhoneLog(
	PhoneLogID  int  identity(1,1)  constraint  PK_PhoneLog  primary key nonclustered,		-- nonclustered
	LogRecorded datetime2  not null,
	PhoneNumberCalled  nvarchar(100)  not null,
	CallDurationMs  int not null
);


insert PhoneLog values ('2020-1-1', '0999999', '1')
go 100

-- Step 3: Query sys.indexes to view the structure
-- (note also the name chosen by SQL Server for the constraint and index)
select * from sys.indexes
where object_id = object_id('PhoneLog');	-- index_id = 2, type_desc = 'HEAP', 'NONCLUSTERED'
go

select * from sys.partitions
where object_id = object_id ('PhoneLog');		-- index_id = 0, 2 
go        

--  check : AdventuresWorks  →  table  HumanResources.Employee  →  索引

-- Step 4: Drop the table
drop table if exists PhoneLog;
go

