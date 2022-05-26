 --	Module 5 - Lab02 CHECK 條件約束

--	UNIQUE 和 CHECK 兩種類型的條件約束，都是用來強制執行 SQL Server 資料表中的資料完整性。
--	CHECK 條件約束可以限制存入資料庫中的數值，指定一個或多個資料行為可接受的資料值。
--	例如 : 年齡一定不可為負數 (Age>0, Age<120)。

--	CHECK 條件約束類似於 FOREIGN KEY 條件約束，用來限制放入資料行的值。 
--			其間的不同在於它們判定值是否有效的方式：
--						FOREIGN KEY 條件約束 : 從另一個資料表取得有效值。
--						CHECK 條件約束 : 從自己資料表設定的邏輯運算式來判定有效值。
--	如果設定 CHECK 條件約束的欄位設定為允許 NULL，此欄位如果插入 NULL 值，
--			SQL Server 會允許插入 NULL 值且不會傳回錯誤，這是因為　
--			CHECK 條件約束只拒絕運算式判斷為 FALSE 的值，而 NULL 會判斷為 UNKNOWN。


use LabDB;
go

--	建立 Member 資料表並建立 Age 檢查條件約束
--	先 DROP 上個 LabDB 的測試 TABLE
drop table if exists Member;
go

--	建立 Age 檢查條件約束 0 < Age < 150
create table Member (
	ID int identity(1, 1) not null,     -- (1, 1) 1 開始, 增量 1
	Name varchar (50) null,
	Age int null check (Age > 0 and Age < 150)  
);
go

--	新增測試資料  
insert into Member (Age) values (49);  
go  5

select * from Member

-- Error : 	Adding values that will be fail under the check constraint  
insert into Member (Age) values (200);  
go

--	Member 資料表新增一個年資欄位,並且規定 Age 必須大於 Seniority
alter table Member
	add Seniority int null default 1,                     --給預設值1, 讓它不違反上例 Age>0 的限制規定
	check(Age > Seniority);
go

select * from Member

-- 新增測試資料  
insert into Member (Age, Seniority) values (49, 25);  
go  

insert into Member (Age, Seniority) values (25, 30);  
go