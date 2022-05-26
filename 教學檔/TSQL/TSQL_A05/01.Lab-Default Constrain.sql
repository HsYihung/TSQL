--	Module 5 使用一般的條件約束 (Constraints) 來實作資料的完整性
--		5-1 : DEFAULT 條件約束
--		5-2 : CHECK 條件約束
--		5-3 : Table-level constraint vs. Column-level constraint

--	DEFAULT 條件約束用來設定資料欄位的預設值。
--	在新增資料的時候如果這個欄位沒有指定值， SQL Server 就會使用預設值。
--	如果資料欄位未設定 DEFAULT，而且使用者未輸入資料，可能有兩種情況 :
--		允許 NULL : 會 NULL 插入資料行。
--		不允許 NULL : 資料行將會保留空白，必須在提供資料欄位值後才能儲存資料。

--	資料庫設計上可以使用 DEFAULT + NOT NULL 來確保欄位有值，可以減少程式執行上的錯誤產生。
--	DEFAULT 值如果是文字字串，請使用單引號 (‘) 包起來，而不要使用雙引號 (“) 。
--	DEFAULT 值如果是數字，直接輸入數字，不用加上引號。
--	也可以使用物件或函數做為 DEFAULT 值，例如預設日期欄位為今天的日期，可以使用 GETDATE()。


-- Lab01 DEFAULT 條件約束
use LabDB;
go

--	在 CREATE TABLE 時建立 DEFAULT 限制
create table Member (
	ID int not null,
	Name varchar(50) not null,
	MemEnable bit default 0             -- BIT 一種整數資料類型，其值有 1、0 或 NULL 幾種。
);
go

insert Member values (1, 'Helen', 0)
insert Member values (2, 'Mary', 1)
insert Member values (3, 'Tom', '')
insert Member values (3, 'Tom', Null)
select * from Member

--	在 CREATE TABLE 時建立 DEFAULT 限制命名 CONSTRAINT
create table Member1 (
	  ID int not null,
	  Name varchar(50) not null,
	  MemEnable bit constraint DF_MemEnable default 0    -- use bit True, False
);
go

--	在現有的資料表建立 DEFAULT 限制
alter table Member1 drop DF_MemEnable;  -- 移除資料表 DEFAULT 0 的限制

alter table Member1 add constraint DF_MemEnable default 1 for MemEnable;  -- 增加資料表 DEFAULT 1限制


-- ERROR : following DON'T work now -- set 語法問題
alter table Member1 alter column MemEnable set default 1 ;			--		語法問題

alter table Member1 add constraint DF_SomeName default 0 for MemEnable;  -- 重複


--	DROP TABLE
drop table if exists Member, Member1;
go