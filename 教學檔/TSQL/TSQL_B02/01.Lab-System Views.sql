 --	Module 2  資料表(Tables) 的進階觀念、設計與實作
--		2-1: 透過系統檢視表(system views) 查詢Meta-Data
--		2-2: 搭配uniqueidentifier資料類型然後藉由NEWID()、NEWSEQUENTIALID()來產生GUID 的值
--		2-3: 關於timestamp 與rowversion資料類型的使用方式


--	中繼資料函數 
--  https://docs.microsoft.com/zh-tw/sql/t-sql/functions/metadata-functions-transact-sql?view=sql-server-ver15
--			所有中繼資料函數都不具決定性。 這表示這些函數並非每次呼叫時，都會傳回相同的結果，
--			即便使用同一組輸入值也是如此。

--	01.Lab : 透過系統檢視表(system views) 查詢Meta-Data

use LabDB2;
go

--  check : master → 檢視 → 系統檢視表 → sys.tables
select schema_name(schema_id)+ '.' + name as tablename,  *		-- "type_desc"
from sys.tables;
go

use LabDB2
--  check : LabDB2 → 檢視 → 系統檢視表 → information_schema.table_constraints
select *
from information_schema.table_constraints
where table_name = 'Employee';			--  Don't add schema name HR
go
--  觀察欄位 : constrint_schema,  constraint_name, constraint_type



--	check : LabDB2 → 檢視 → 系統檢視表 → sys.key_constraints
select *
from sys.key_constraints
where parent_object_id = object_id('HR.Employee')
go

