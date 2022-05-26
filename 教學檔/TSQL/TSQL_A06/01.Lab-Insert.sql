--	Module 6 DML指令的使用如何做資料的新增
--		6-1 : 使用 INSERT 新增資料
--		6-2 : 預設的日期表達格式
--		6-3 : 識別欄位(IDENTITY) 的使用 


--	Lab01 使用 INSERT 新增資料

--	INTO 是一個選擇性的關鍵字，"可以不使用"。
--	欄位清單 (column_list) 是指要插入資料表的一個或多個資料行所組成的清單，用括號包起來，並用逗號分隔。
--	VALUES 為要新增的資料值清單，如果有指定 column_list 則指定的欄位都應有一個資料值，
--			如果未指定欄位清單(column_list)，則資料表的每個資料行都必須有值，且必須要依資料行的順序排列。

--	文字或日期的值須加單引號。
--	可選擇性新增部份欄位。
--	如果資料行不在欄位清單(column_list) 之中，資料行符合下列條件，SQL Server 會自動提供欄位值 :
--			IDENTITY : 使用下一個累加值。
--			DEFAULT : 使用資料行的預設值。
--			timestamp : 使用目前的時間戳記值。
--			NULL : 使用 NULL 值。
--			計算資料行 : 使用計算的值。
--	資料類型為 Unicode 字元類型時(nchar、nvarchar、ntext)，資料值清單的前面可以加大寫字母’N’，
--			如果未指定’N’，SQL Server 會使用預設的字元編碼。


use LabDB;
go

--	建立一個測試資料表
drop table if exists Member;
go

create table Member (
	ID int identity,
	Name nvarchar(100),
	MsMr char (6) default ('Ms.'),
	BirthDate date default (getdate())
);
select * from Member
go

-- 新增一筆資料
insert into Member values ('使用者1', 'Mr.', '1-1-1999');   -- try insert into
select * from Member;
go

-- 新增多筆資料
insert Member values 
	('使用者2', '', '2010-10-20'),
	('使用者3', default , '2012-5-1'),
	('使用者4', 'Mr.', default);
select * from Member;
go

-- 指定欄位新增資料,Gender / BirthDate會使用預設值
insert Member (Name) values ('使用者5');

select * from Member;
go

-- 新增包含NULL的資料行- unknow
insert Member(Name, MsMr, BirthDate) values ('使用者6', null, null);
insert Member values ('使用者5', null, null);

select * from Member;
go

-- 新增一筆資料, Name 欄位值指定為 Unicode 編碼
insert Member (Name) values (N'使用者7');

select * from Member;
go


--  利用SELECT...INTO 將 Northwind.dbo.Employees 資料表
--  在LabDB上重建資料表, 並且只新增City = 'London'資料
select * from Northwind.dbo.Employees

select * into TempEmployees
from Northwind.dbo.Employees
where City = 'London';
go

--  check :  LabDB → DataTable → dbo.TempEmployees
select * from TempEmployees;
go


--	使用 INSERT INTO…SELECT, 將 TempEmployees 的資料新增到Member資料表
--	可以搭配使用 INSERT INTO…SELECT ，有效率的將大量資料從某份資料表傳送至另一份資料表。
--	並且 用 @@ROWCOUNT 函式回傳新增的資料筆數
insert  Member (Name, MsMr, BirthDate)
select LastName+' '+FirstName, TitleOfCourtesy, BirthDate from TempEmployees;  -- 從別的資料庫中條件 select 後 insert
print '共新增 ' + convert (varchar(3), @@rowcount) + ' 筆資料';
go

select * from Member
select * from TempEmployees


--	先匯出 member to member.csv 檔 first  --  need file name xxxx.csv
-- LabDB(滑鼠右鍵) → 工作 → 匯出資料 → 資料來源(Microsoft OLE DB Provider for SQL Server ) 
--			→ ... Flat File Desitination → ...c:\Temp\member.csv  → ......

bulk insert Member
from 'C:\Temp\member2.csv'
with (
	FieldTerminator = ',',
    RowTerminator = '\n',
	FirstRow           = 2,
    LastRow           = 25,
    --CodePage        ='utf8',
	keepnulls
)
select * from Member

-- https://docs.microsoft.com/zh-tw/sql/t-sql/statements/bulk-insert-transact-sql?view=sql-server-ver15

