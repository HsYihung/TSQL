--	Module 4 - Lab02 資料表 FOREIGN KEY 條件約束

--	FOREIGN KEY (外部索引鍵) 是用來強制約束資料表之間關聯的一種條件約束。
--	FOREIGN KEY (外部索引鍵) 只能指向主索引鍵 (PK) 或是 UNIQUE 資料。
--	FOREIGN KEY (外部索引鍵) 參考外部資料表，以保證資料的正確性。
--	關聯式資料庫中，資料表之間的關係是利用 FOREIGN KEY (外部索引鍵) 來建立的。
--	相關聯的欄位，資料型別及長度必需相同。但是名稱可以不同，只是習慣上會用相同的命名，以利於辨別。
--	FOREIGN KEY (外部索引鍵) 的資料可以重複，


--  使用串聯式參考完整性條件約束，就可以定義使用者嘗試刪除或更新現有外部索引鍵所指向的索引鍵時，
--	Database Engine 所採取的動作。 可以定義下列串聯式動作。

--	NO ACTION		: Database Engine 會引發錯誤，而且會回復對父資料表中資料列的刪除或更新動作。
--	CASCADE		: 更新或刪除父資料表中的對應資料列時，也會更新或刪除參考資料表中的該資料列。 
--	SET NULL		: 更新或刪除父資料表中的對應資料列時，所有組成外部索引鍵的值都會設定為 NULL。
--  SET DEFAULT: 如果更新或刪除父資料表中的對應資料列，則所有組成外部索引鍵的值都會設定為其預設值。 
-- https://docs.microsoft.com/zh-tw/sql/relational-databases/tables/primary-and-foreign-key-constraints?view=sql-server-ver15


--	下列範例會建立資料表並在 TempID 資料行上定義 FOREIGN KEY 條件約束，
--	而此資料行會參考 AdventureWorks 資料庫 Sales.Customer 資料表中的 CustomerID 資料行。

--	對 Sales.Customer 資料表所做的變更會自動更新至 TempCustomer 資料表。

drop table if exists AdventureWorks.dbo.TempCustomer

use LabDB;
go
--  use AdventureWorks		-- 錯誤範例 : 不支援跨資料庫的外部索引鍵參考。外部索引鍵
create table TempCustomer (
      TempID int not null ,
          constraint PK_TempCustomer primary key nonclustered (TempID),
          constraint FK_TempCustomer_SaleCustomer foreign key (TempID)
              references AdventureWorks.Sales.Customer (CustomerID)
              on delete cascade
              on update cascade,
      Name nvarchar(50)
   );
go --- see TempID (pk, fk)

--	刪除上面建立的 FOREIGN KEY

alter table TempCustomer
	drop constraint FK_TempCustomer_SaleCustomer;
go

--	下列範例會在 TempCustomer 資料表中的 TempID 資料行上建立 FOREIGN KEY，
--	並會參考 AdventureWorks 資料庫 Sale.Customer 資料表中的 CustomerID 資料行。
alter table TempCustomer
  add constraint FK_TempCustomer_SaleCustomer foreign key (TempID)
      references Sales.Customer (CustomerID)
      on delete cascade
      on update cascade
go  

--	ALTER AUTHORIZATION ON DATABASE:: DBName TO [NewLogin] 
alter authorization on database :: AdventureWorks to sa

drop table if exists TempCustomer



-- 例二 delete cascade

use LabDB

drop table if exists TempOrders, TempOrderDetails

select * into  TempOrders from Northwind.dbo.orders
select * into  TempOrderDetails from Northwind.dbo.[Order Details]

select * from TempOrders
select * from TempOrderDetails

alter table TempOrders
		add constraint PK_TempOrders_OrderID primary key (OrderID)

alter table TempOrderDetails
		add constraint FK_TempOrderDetails_OrderID foreign key (OrderID)
              references TempOrders (OrderID)
              on delete cascade
              on update cascade

-- delete OrderID in 父輩資料表
delete from TempOrders where OrderID=10248

select * from TempOrders
select * from TempOrderDetails
--  OrderID 10248 在兩資料表中都不見了



