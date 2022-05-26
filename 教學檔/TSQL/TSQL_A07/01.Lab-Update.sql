 --	Module 7 - DML指令的使用如何做資料的修改與刪除
--		7-1 : 使用 UPDATE 修改資料 
--		7-2 : 使用 DELETE 刪除資料  
--		7-3 : DELETE 指令與 TRUNCATE TABLE 指令的差別

--	UPDATE 用於變更資料表中現有的資料。
--		UPDATE table_nameSET column1=value1, column2=value2, column3=value3···
--		WHERE some_column=some_value; 

--	table_name 指定的來源資料表。column 要變更的資料行名稱。
--	無法更新識別欄位(IDENTITY)。
--	修改資料前記得先確認 WHERE 條件式，這樣才會只更新特定某(幾)筆資料，不然 “全部的” 資料都會更改。


--	使用 UPDATE 修改資料
use LabDB;
go

drop table if exists TempEmployees
select * into TempEmployees from Northwind.dbo.Employees

select * from TempEmployees;

--	更新 TempEmpolyees 資料表中的特定幾筆資料
select * from TempEmployees where TitleOfCourtesy='Mr.'

update TempEmployees set LastName='Pitt', FirstName='Brad'  
where TitleOfCourtesy='Mr.';			-- update 不給where 會全部update, 怕怕  !!

update TempEmployees set TitleOfCourtesy = 'Mr.'   -- 沒有 where, 要特別小心

select * from TempEmployees;
go

-- 更新 TempEmpolyees 中所有的資料
update TempEmployees set City = 'Seattle';

select * from TempEmployees;
go

-- Error : 無法更新識別欄位(IDENTITY)
update TempEmployees set EmployeeID=0;

--	使用 其它的 Table 來更新資料
select * from TempEmployees;
select * from Northwind.dbo.Employees

update TempEmployees
set	TitleOfCourtesy = ne.TitleOfCourtesy,
		City = ne.City										--	請加入  LastName, First Name
from TempEmployees as le,  
		Northwind.dbo.Employees as ne
where le.EmployeeID=ne.EmployeeID


select * from TempEmployees;
select * from Northwind.dbo.Employees

---------------------------------------------
select * from Northwind.dbo.Products;

select * into TempProduct
from Northwind.dbo.Products where UnitPrice>10;

alter table TempProduct add OrderDate date
select * from TempProduct;
go

-- 指定計算值將價格資料值加1.5倍
update TempProduct set UnitPrice*=1.5;  -- unitprice=unitprice*1.5
select * from TempProduct;
go

-- 指定複合運算子,將目前價格加10
update TempProduct set UnitPrice+=10;
select * from TempProduct;
go

-- 更新開始日期為今天
update TempProduct set OrderDate=getdate();
select * from TempProduct;
go

--	@@ROWCOUNT 會傳回受到上一個陳述式影響的資料筆數。
--	@@ROWCOUNT 會傳回 int 型別。
--	執行 UPDATE 陳述式後可使用 @@ROWCOUNT 來偵測是否有任何資料變更。

declare @count int;
update TempProduct set UnitPrice*=0.5
where UnitPrice>=20;
set @count = @@rowcount;

if @count > 0
	print '共更新了 ' + convert(varchar(3), @count) + ' 筆資料'
go

select * from TempProduct;
