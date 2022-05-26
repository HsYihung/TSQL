--	Module 14 - Lab02 IIF()、CHOOSE()、CASE 運算式
--			MSSQL 內有兩個邏輯函數- CHOOSE 和 IIF
--			邏輯函數是根據傳入的邏輯判斷條件來判斷，如果符合就傳回對應的數值
--			邏輯函數傳入的是判斷條件而不是數值
--			邏輯函數可以視為 CASE 運算式的簡化。

--	IIF 函數會根據第一個布林運算式的判斷來決定回傳 true_value 或 false_value。

--	CHOOSE 函數會根據傳入的索引值來傳回指定的項目資料。
--			index : 表示以 1 為基底之項目清單中的整數索引。
--			如果指定的 index 超過項目清單的數值陣列上限，會回傳NULL。
--			CHOOSE 作用類似陣列中的索引，其中的陣列是數值清單所組成。

--  CASE 運算式有兩種格式：
--			簡單的 CASE 運算式會比較運算式和一組簡單運算式來得出結果。
--			搜尋 CASE 運算會評估一組布林運算式來得出結果。

--	IIF 示範
declare @x int = 500, @y int = 100;  
select iif ( @x > @y, 'TRUE_Value', 'FALSE_Value' ) as result;  

--	Error :　回傳錯誤，CASE 規格中的結果運算式至少要有一個是 NULL 常數以外的運算式。
select iif ( 45 > 30, null, null) as result;  

--	如果只需要做二元的判斷,使用IIF來簡化T-SQL敘述式
declare @bool bit = 0;
select 
	case @bool
		when 0 then '女'
		when 1 then '男'      -- select '男'
	end;

declare @bool bit = 1;
select iif (@bool = 0, '女', '男');
select iif (@bool = 1, 'False', 'True');

--	二元的判斷 in database
select * from [Order Details]

select *, iif(UnitPrice>10,  '大於10',  ' ' )
from [Order Details]
--order by UnitPrice desc


--	CHOOSE : SQL Server 2012 以後的版本，提供了 CHOOSE 新的邏輯函來做這種二元以上的邏輯判斷
select choose(3, 'Manager', 'Director', 'Developer', 'Tester' ) as result;

select choose(0, 'Manager', 'Director', 'Developer', 'Tester' ) as result; 
select choose(5, 'Manager', 'Director', 'Developer', 'Tester' ) as result; 

--	下列範例會根據 EmployeeID 傳回簡單的字元字串。
use Northwind;
go

select * from Orders

select CustomerID,  EmployeeID, EmployeeID%5,
       choose (EmployeeID%5, 'A', 'B', 'C', 'D') as EmpID_Level    -- 0 : NULL
from Orders;  


--	下列範例會傳回雇用員工的季節。 MONTH 函數用於從 HireDate 資料行傳回月份的值。  */
select CustomerID,  ShipCity, OrderDate,
       choose(month(OrderDate), 'Winter', 'Winter',  'Spring', 'Spring', 'Spring', 'Summer', 'Summer',   
									'Summer', 'Autumn', 'Autumn', 'Autumn', 'Winter') as QuarterShip
from Orders 
where  year(OrderDate) >= 1997 
order by year(OrderDate) asc;  


--	下列範例利用 CASE 運算式來變更產品類別目錄的顯示方式，使它們更容易了解。
select * from Orders

select CustomerID, ShipVia, ShipViaCategory =  
	case  ShipVia
		when '1' then 'Road'  
        when '2' then 'Mountain'  
        when '3' then 'Touring'  
        else 'No via'						-- choose 可能無法處理
     end
from Orders  
order by ShipVia;  
go  

--  same as following
select CustomerID, ShipVia,
			choose (shipVia, 'Road', 'Mountain', 'Touring' , 'No via') as ShipViaCategory
from Orders  
order by ShipVia;  
go  

--	搜尋的 CASE 運算式允許以比較值為基礎來取代結果集中的值
--	下列範例以產品的價格範圍為基礎，將標價顯示為文字註解。

select CustomerID, ShipName, ShipAddress, Freight, "PriceRange" =   
	case   
         when Freight =  0  then 'no Freight'  
         when Freight < 10 then 'Under $10'  
         when Freight < 20 then 'Under $20'  
         when Freight < 30 then 'Under $30'  
         else 'Over $30'  					-- choose 可能無法處理
      end  
from Orders  
order by CustomerID, Freight ;  
go  


--	比較使用CASE運算式及CHOOSE函數(簡化) 
declare @qq int = datename(quarter, '2020-10-18');
select @qq,
	case 
		when @qq = 1 then '第一季'
		when @qq = 2 then '第二季'
		when @qq = 3 then '第三季'
		when @qq = 4 then '第四季'
	end;
go

-- (簡化)
declare @qq int = datename(quarter, '2020-10-18');
select choose (@qq, '第一季', '第二季', '第三季', '第四季');
go


