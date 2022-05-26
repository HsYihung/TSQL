--	Module 5 - Lab03 Table-level constraint vs. Column-level constraint

--	CONSTRAINT(條件約束) 共有:
--			NOT NULL (不允許 NULL 值)
--			PRIMARY KEY (主索引鍵)
--			FOREIGN KEY (外部索引鍵)
--			UNIQUE (唯一值)
--			DEFAULT (預設值)
--			CHECK (資料檢查)

--	CONSTRAINT(條件約束) 可在建立資料表(CREATE TABLE)的時候指定"一個"或"多個"共用一個限制語法，
--			或是於資料表建立後加入(ALTER TABLE)，可以分為兩種層級 :
--			Column-level constraint (欄位層級) : 
--						可以為各別欄位指定條件約束，作為欄位規範的一部份。
--			Table-level constraint (資料表層級) :
--						可以為一個或多個欄位組成條件約束，做為資料表定義的條件約束。

--	資料庫完整性是為了確保資料庫中的資料，是正確、有效且一致的。
--	可以利用條件約束(Constraints)來實作資料庫的資料完整性。
--	實體完整性 : 資料表中資料行的資料完整性，例如 : 資料表只能有一個主索引鍵，
--						並且主鍵必須為唯一、不允許NULL，可以使用 NOT NULL、PRIMARY KEY、UNIQUE 
--						條件約束來限制資料的完整性。
--	域完整性 : 資料表中資料行的值必須滿足特定的條件約束，
--						如 : CHECK、FOREIGN KEY、DEFAULT、NOT NULL 等都屬於域完整性的範圍。
--	參考完整性 : 透過 FOREIGN KEY 條件約束來限制資料的完整性，實現了資料表與資料表之間的關聯。

use LabDB;
go

--	在建立資料表時
-- 用 Table-level constraint 或 Column-level constraint 來建立條件約束比較兩種方式的差異
drop table if exists Member0, Member1;
go

--	Column-level constraint : 單一欄位的限制 unique
create table Member0 (
	ID int not null,									-- constraint
	Name varchar(50) not null,				-- constraint
	Birthday date,
	Gender char(1) default 'M',				-- constraint
	Email varchar(20) unique				-- constraint
	);
go

--	Table-level constraint 建立UNIQUE : 多欄位(多半用在跨欄位Primary Key)的限制
create table Member1 (
	ID int not null,
	Name varchar(50) not null,
	Birthday date,
	Gender char(1) default 'M',
	Email varchar(20),
			constraint UQ_Email unique (Email)				-- Table-level constraint 一個欄位
);
go

--	多欄位(多半用在跨欄位Primary Key)的限制
create table Member2 (
	ID int not null,
	Name varchar(50) not null,
	Birthday date,
	Gender char(1) default 'M',
	Email varchar(20),

	constraint PK_ID primary key clustered (ID asc),
	constraint UQ_codes unique nonclustered (Name, Birthday)   --  跨欄位
) 
go


--	Column-level constraint 建立主索引鍵
  create table Member3 (
	ID int primary key,            -- column level
	Name varchar (50) not null,
	Gender char (1) not null default 'M'
);
go


--	Table-level constraint 建立主索引鍵
create table Member4 (
	ID int,
	Name varchar (50) not null,
	Gender char (1) not null default 'M'

	constraint PK_ID4 primary key(ID)
);
go
