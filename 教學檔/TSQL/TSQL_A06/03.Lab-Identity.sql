--	Module 6 - Lab03  識別欄位(IDENTITY)的使用

--	識別欄位可以基於基底值自動遞增生成欄位數值，識別欄位只能為整數類型。
--	每個資料表只能建立一個識別欄位。
--	一般用於產生流水號或做為主鍵編號。
--	識別欄位可以設定初始值和遞增數值。
--	語法 : IDENTITY [ (seed , increment) ]
--					seed  裝載到表中的第一個行所使用的值。
--					increment  增量值，該值被新增到前一個已裝載的行的標識值上。
--					必須同時指定種子和增量，或者二者都不指定。如果二者都未指定，則取預設值 (1,1)。

--		如果在經常進行刪除操作的表中存在著標識列，那麼在標識值之間可能會產生差距。
--		如果這構成了問題，那麼請不要使用 IDENTITY 屬性。但是，為了確保未產生差距，
--		或者為了彌補現有的差距，在用 SET IDENTITY_INSERT ON 顯式地輸入標識值之前，
--		請先對現有的標識值進行計算。

use LabDB;
go

drop table if exists NewEmployees;
go

create table NewEmployees  (  
     IDNum int identity(1,1),  
     FirstName varchar(20),  
     LastName varchar(30),
     Gender char(1)
);
select * from NewEmployees
go

--  新增一筆資料 column_list 不需指定識別欄位
insert NewEmployees (FirstName, LastName, Gender)
	values ('Karin', 'Josephs', 'F');
go 5

select * from NewEmployees;
go

--  開啟資料表的 SET IDENTITY_INSERT 選項為 ON
--  並且新增一筆資料包含識別欄位的值
set identity_insert NewEmployees ON;　　-- 允許使用者定義 IDENTITY

insert NewEmployees(IDNum, FirstName, LastName, Gender)
	values (1, 'Tom', 'Cruise', 'M'), (99, 'Mary', 'Rosemary', 'F');

set identity_insert NewEmployees OFF;
select * from NewEmployees;
go

--  新增一筆測試資料並使用@@IDENTITY函數回傳識別欄位值
insert NewEmployees(FirstName, LastName, Gender)
	values ('Angelina', 'Jolie', 'F');
select @@identity ;
select * from NewEmployees;
go

select ident_current('NewEmployees') as Current_Identity;

select scope_identity() as [scope_identity];

