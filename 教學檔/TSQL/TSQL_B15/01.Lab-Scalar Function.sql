--	Module 15. 使用者自訂函數(UDF) 的設計與實作    (User Defined Function)
--		15-1 : 如何建立純量函數(Scalar Functions)     
--		15-2 : 如何建立內嵌資料表值函數(Inline TVFs)     
--		15-3 : 如何建立多重語句資料表值函數(Multi-Statement TVFs)     

--		使用者自訂函數(UDF) : 類似於資料庫內建函數，用來讓使用者能自行定義的函數，
--		並應用於資料庫的 SQL 敘述或運算式
--		UDF的優點:
--				可進行模組化的程式撰寫
--				增加執行速度
--				降低網路傳輸量

--		純量函數 (Scalar-Valued Functions) : 此類函數會傳回 "單一值"，其值型別
--		不可為 text、ntext、image、cursor 與 rowversion(timestamp)


--	01.Lab - Scalar Function.sql
use  LabDB2 ;
go

--  建立純量函數(Scalar Functions)  :  也就是返回一個值，有可能是字串, 數值, datetime
drop function if exists sf_myDate

--	DateAdd 函式會將指定的 number 值(以帶正負號的整數形式) 
--	加到輸入 date 值的指定 datepart，然後傳回該修改過的值。

create function sf_myDate(@myDate as date)
returns date
as
begin   -- 不可註解掉
	return DateAdd(year, -10, @myDate)
end		-- 不可註解掉

--  check : LABDB2  →  可程式性  →  函數  →  純量值函數

--  運用 dbo.sf_myDate 在資料庫中
select LastName, FirstName, BirthDate,
			dbo.sf_myDate(BirthDate) as 'BirthDate_10'					-- year -10
from Northwind.dbo.Employees




select dbo.sf_myDate(getdate()) as result		-- 注意 : dbo 不可省
select dbo.sf_myDate('2020-01-05') as result
select dbo.sf_myDate('01/05/2020') as result


-- Step 1 - Open a new query window against the tempdb database.
use  LabDB2 ;
go


-- Step 2 - Create a function
--          Note that SQL Server 2012 now includes a new function
--          for calculating the end of the current month (EOMONTH)

drop function if exists EndOfPreviousMonth

create function EndOfPreviousMonth (@DateToTest date)
returns date
as
begin
	return DateAdd(day, 0 - Day(@DateToTest), @DateToTest);   -- end day of last month
end


-- Step 3 - Query the function. 
select dbo.EndOfPreviousMonth (sysdatetime())   -- dbo 不可省
select dbo.EndOfPreviousMonth ('2016/03/04')   -- dbo 不可省

select eomonth ('02/04/2016')
select eomonth ('2016/02/04')
select eomonth ('2016/02/04', -1)   -- 上個月



--	此查詢會計算明細項目折扣價格的總和
drop function if exists discount_price

create function dbo.discount_price(@price decimal(12, 2), @discount decimal(12, 2)) 
returns decimal (12, 2)
as
begin
	return @price * (1 - @discount/100);
end

select dbo.discount_price(100, 3)  -- (price, %) 


--  運用 dbo.discount_price 在資料庫中
select OrderID, ProductID, UnitPrice, dbo.discount_price(UnitPrice, 3) as '折扣價'   -- 3% off
from Northwind.dbo.[Order Details]


-- Step 4 - Drop the function




