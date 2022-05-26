--	Module 9 - Lab02 運算子執行的優先序

--	SQL有4種類型的運算子，分別是算數運算子、邏輯運算子、指派運算子及比較運算子
--		算數運算子：加法(+)、減法(-)、乘法(*)、商數(/)、餘數(%)
--		邏輯運算子：AND、OR、NOT : 標準布林邏輯運算子。
--				LIKE : 搭配萬用字元，判斷 "字串" 是否符合指定的模式。
--				BETWEEN : 在某範圍內。
--				IN : 是否在一列值中間。
--				ALL、ANY、SOME : 比較 "純量值" 與單一資料行集的值，ALL必須合部符合，
--							ANY和SOME類似，任意組的比較為TRUE則 SOME 或 ANY 會傳回 TRUE。
--				EXISTS : 指定資料列是否存在於子查詢之中。
--		指派運算子：指定給予值(=)
--		比較運算子：小於(<)、大於(>)、小於等於(<=)、大於等於(>=)、等於(=)、不等於(!=, <>)


use Northwind;
go

--	當運算式中兩個運算子有相同的優先層級時，會依據它在運算式中的位置，由 "左至右" 來做運算。 
--	例如，在下列 SET 陳述式中的數字運算，會先做減法運算子，再執行加法運算子。
declare @Number1 int;  
set @Number1 = 10 - 5 + 100;  
select @Number1							-- 結果
print @Number1;								-- 訊息

--	先乘除後加減，乘法運算子的優先順序高於加法運算子。
declare @Number2 int;  
set @Number2 = 2 * 4 + 5;  
select @Number2;  

--	括號內優先運算
declare @Number3 int;  
set @Number3 = 4 * (1 + 8);  
select @Number3;

--	如果運算式有巢狀括號，最內層括號的運算式最先做運算。
declare @Number4 int;  
set @Number4 = 2 * (4 + (5 - 3) );  
select @Number4;  

declare @Number5 int;									-- Number5 is int
set @Number5 = '100';									-- Number5 is assigned '100' 文字
select @Number5;

declare @Number6 varchar;							-- Number6 is varchar
set @Number6 = 100;										-- Number6 is assigned 100 int 數字
select @Number6;

--	下列範例，如果括號省略會得出不同的結果
select OrderID, CustomerID, Freight, ShipCity, ShipName 
from Orders 
where Freight > 10 and (CustomerID like '%VI%' or ShipName like '%VI%')
--where Freight > 10 and CustomerID like '%VI%' or ShipName like '%VI%'


--	找出是否所有Freight大於10
if 10 < any (select Freight from Orders)						-- try 0, ANY, SOME or where Freight >10
    print 'True'   
else  
    print 'False' ;  
select Freight from Orders

--	找出是否有大於65歲的員工; ANY或SOME都一樣
if 65 < some (select (year(getdate())- year(BirthDate)) from Employees)   -- if boolean
	print 'True'   
else  
	print 'False' ;  
select (year(getdate())- year(BirthDate)) from Employees

--	子查詢傳回不只 1 個值。這種狀況在子查詢之後有 =、!=、<、<=、>、>= 
--	或是子查詢作為運算式使用時是不允許的。
--  Error : select Freight from Orders 傳回多個查詢結果, 因為 @myFreight int 是一整數
declare @myFreight int = (select Freight from Orders)		-- error
print @myFreight


--	Level	Operators
--	1	~ (位元 NOT)
--	2	* (乘), / (除), % (餘數)
--	3	+ (正), - (負), + (加), + (串連), - (減), & (位元AND), ^ (位元互斥 OR), | (位元 OR)
--	4	=, >, <, >=, <=, <>, !=, !>, !< (比較運算子)
--	5	NOT
--	6	AND
--	7	ALL, ANY, BETWEEN, IN, LIKE, OR, SOME
--	8	= (指派)

--	當運算式有多個運算子時，運算子的優先順序會影響查詢的結果。
--	上面的表格顯先運算子的優先順序，由上而下，層級高的優先評估。
--	優先順序 : 算數運算子 (先乘除後加減) ＞ 比較運算子 ＞ 邏輯運算子 ＞ 指派運算子
--	當兩個運算子具有相同的優先層級時，會依照它在運算式的位置，由左至右來做運算。
--	小括號()內的所有項目會先運算，並求得單一值，括號外的運算子再使用該值做運算。
