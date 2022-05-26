-- Module 3 - 資料表 (Tables) 的基礎觀念、設計與實作 
--		3-1 : 資料表的基礎觀念
--		3-2 : 什麼是結構描述
--		3-3 : 如何建立、修改與刪除資料表

--	2017/ 2019 SQL Server 
--		3-22 正規化
--		6-6~15	資料庫結構 (Excel file)

--	Lab01 建立資料表並新增測試資料
use LabDB;
go


-- SQL Server Database Engine 會使用資料行定義中的 SPARSE (疏鬆) 關鍵字，
-- 最佳化該資料行中值的儲存方式。 因此，當資料表中任何資料列的資料行值是 NULL 時，
-- 這些值就不需要儲存位置，但是需要更多的儲存空間來儲存非 NULL 值。
--	疏鬆資料行必須可為 NULL, 疏鬆資料行不能有預設值

create table Employees(
    id int identity (1, 2) not null ,			        -- not null 可寫可不寫
    name nvarchar (50) not null,
    address nvarchar (200) sparse null);		-- 疏鬆 sparse null
go
-- dbo.Employees → 資料行 → address (滑鼠右鍵) → 為疏鬆 True


--延續上例，新增一筆資料，並通過@@IDENTITY取得新增資料的ID值
insert into Employees(name, address)		-- into 可有可無
    values ('Kevin', 'Test Identity');
select @@identity
go 5

select * from Employees;
go

--  ALTER 對已存在的資料表做變動

--  ALTER 新增欄位
alter table Employees
   add phone_no  nvarchar (50),
          email  nvarchar (20);
go

--  ALTER 修改欄位
alter table Employees
　alter column name nvarchar(80)				--  不能文字轉數字, 數字轉文字
--  ALTER 刪除欄位
alter table Employees
    drop column phone_no, email

-- take a look table employee 下的資料行, 顯示資料表結構

select * from information_schema.tables

drop table if exists Employees

