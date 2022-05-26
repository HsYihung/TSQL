--	Module 4 - Lab03 UNIQUE 條件約束

--	UNIQUE 和 CHECK 兩種類型的條件約束，主要是用來強制執行 SQL Server 資料表中的資料完整性。
--	UNIQUE 確保欄位在資料表中的唯一性，限制資料表中的欄位不能有重複資料。
--	UNIQUE 允許 NULL 值。
--	一個資料表只能有一個 PRIMARY KEY ，但是可以有多個 UNIQUE 條件約束。
--	UNIQUE 和 PRIMARY KEY 都強制唯一性，但是當想要強制非主索引鍵的唯一性時，
--			就會使用 UNIQUE 條件約束而不是 PRIMARY KEY 條件約束，
--			例如 : 訂單資料表 以訂單號碼為PK, 那「發票號碼」這個欄位我們會設定為 UNIQUE 條件約束，
--						而不會將它設定為主索引鍵。

use LabDB;
go

--	以下範例會建立 TestTable 資料表並且在 TestID 資料行上建立UNIQUE條件約束。
create table TestTable (  
   TestID int,   
		constraint UQ_TestID unique (TestID) ,
	Name varchar(20)
);   
go  -- 並未顯示在資料行中

insert TestTable values (1, 'John')			--  insert twice
go 2

select * from TestTable


--	刪除上面建立的UNIQUE條件約束
alter table TestTable   
	drop constraint UQ_TestID;   -- UQ_TestID is UQ name
go  

insert TestTable values (1, 'John')
go 3

--	在現有的資料表上建立UNIQUE條件約束, 一樣使用上面建立好的 TestTable
--  若TestID 欄位有重複值出現, add Unique 會出現錯誤 
alter table TestTable   
	add constraint UQ_TestID unique (TestID)   
go  

--	試著新增 "多筆資料" 測試看看(整數或NULL值) 
insert TestTable values (1, 'John')
go

drop table if exists TestTable

-- Conclusion 
--		1.		Primary Key [unique,  no null]
--		2.		Foreign Key  [no unique,	null]
--		3.		UNIQUE Key [unique,	one null]
