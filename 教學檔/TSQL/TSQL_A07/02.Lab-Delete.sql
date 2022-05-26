--	Module 7 - Lab02使用 DELETE 刪除資料

--	從資料表中刪除一筆或多筆資料。
--	[FROM] 為選擇性的關鍵字。
--	刪除資料前記得先確認 WHERE 條件式。
--	如未指定 WHERE 條件式，會將資料表的資料全部刪除。
--	可以使用 @@ROWCOUNT 函式，將刪除的資料列數目傳回用戶端應用程式，用法同上一小節的用法。

use LabDB;
go

-- 刪除資料表中所有資料
select * from TempEmployees;
delete from TempEmployees;   -- FROM 可省略
insert TempEmployees (LastName, FirstName) values ('Green', 'Tom') -- EmployeeID 會繼續增加
go
select * from TempEmployees;

-- 刪除資料表中指定的一組資料
select * from TempProduct
delete TempProduct where UnitPrice >20;
go

select * from TempProduct

-- 使用2種條件式
delete TempProduct 
where ProductID<35 and UnitPrice > 16;
select * from TempProduct

go

-- 刪除的10筆資料行
delete top(10) TempProduct;
go
select * from TempProduct


-- 刪除的 10% 資料行
delete top(10) percent TempProduct;
go

select * from TempProduct 
