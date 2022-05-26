--	Module 6 檢視表(Views) 的設計與實作
--		6-1: 使用CREATE VIEW 建立檢視表物件
--		6-2: 如何查詢某一檢視表原始定義的內容
--		6-3: 如何修改檢視表、刪除檢視表

--		View(檢視表) : 用來建立查詢資料庫中一個或多個資料表內資料的檢視(資料行和資料列)
--		的 "虛擬資料表"，像一個 "被賦予名稱的 select 查詢" 或 "有名稱的資料表運算式"
--		與資料表的差異在於 View 並 "不儲存資料"，僅負責儲存 SQL 查詢敘述並將查詢結果顯示

--		View(檢視表)優點:
--			a. 針對每位使用者設計查看資料庫資料並簡化查詢功能
--			b. 讓使用者能夠透過檢視存取資料但 "不將直接存取來源的資料表"，增加安全性
--			c. 透過 "應用程式" 存取檢視表時，當資料表結構改變時只需變更檢視表設定，不需修改程式

--	2017/ 2019 SQL Server p11-1


use LabDB2
go

drop view if exists vSalesPerson, vPerson

select * from AdventureWorks.Sales.SalesPerson

--  Task 2 : Create a view using a single table 
create view vSalesPerson
as
select BusinessEntityID, TerritoryID, SalesQuota, rowguid
from AdventureWorks.Sales.SalesPerson   -- from adventureworks
where BusinessEntityID <=280

select * from vSalesPerson

select * from sys.syscomments			--	LabDB2  →  檢視
where id = object_id('vSalesPerson') ;
go

select object_definition (object_id ('vSalesPerson'));
go

exec sp_helptext 'vSalesPerson';
exec sp_help 'vSalesPerson';


-- Task 3: Complex views: Create a view using a multi-table join
create view vPerson
as
select pp.BusinessEntityID, pp.Title, pp.FirstName, pp.LastName, sp.name
from AdventureWorks.Person.Person as pp
join AdventureWorks.Person.StateProvince as sp
on pp.BusinessEntityID = sp.StateProvinceID			--  check : LabDB2 → 檢視

--	觀察 vPerson 
select * from vPerson

select * from sys.syscomments			--	LabDB2  →  檢視
where id = object_id('vPerson') ;
go

select object_definition (object_id ('vPerson'));
go

exec sp_helptext 'vPerson';
exec sp_help 'vPerson';


--	例二
select * from AdventureWorks.Production.ProductReview		--	PR
select * from AdventureWorks.Production.Product					--	PP
--  select * from sys.foreign_keys

create view vPR_PP
as
select pr.ProductID, pr.ReviewerName, p.Name, p.ProductNumber 
from AdventureWorks.Production.ProductReview as pr
join AdventureWorks.Production.Product as p 
on pr.ProductID = p.ProductID

-- Select from the view
select * from vPR_PP



-- Task 4: ALTER VIEW
alter view vPR_PP
with encryption					-- 加密
as
select pr.ProductID, pr.ReviewerName, pr.EmailAddress, p.Name, p.ProductNumber  -- 加一欄位 EmailAddress
from AdventureWorks.Production.ProductReview as pr
join AdventureWorks.Production.Product as p on pr.ProductID = p.ProductID
go
select * from vPR_PP


--  觀察 encryption vs. no encryption
select * from sys.syscomments 
where id = object_id('vPR_PP') ;		--  encryption, check : column ctext, text
go
select * from sys.syscomments		--  no encryption, check : column ctext, text
where id = object_id('vPerson') ; 
go


select object_definition (object_id ('vPR_PP')) as view_definition; --  encryption
go
select object_definition (object_id ('vPerson')) as view_definition; --  no encryption
go

--  物件 'vPR_PP' 的文字已加密。
exec sp_helptext  'vPR_PP';--   encryption
exec sp_helptext  'vPerson';--  no encryption

--  兩者差別不大
exec sp_help 'vPR_PP';--   encryption
exec sp_help 'vPerson';--  no encryption

-- Task 5: Clean up
drop view if exists vPerson, vPR_PP, vSalesPerson ;
