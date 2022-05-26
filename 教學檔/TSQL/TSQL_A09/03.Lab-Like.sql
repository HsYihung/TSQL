--	Module 9 - Lab03 使用 like 搭配萬用字元(Wildcard characters)來比對字串資料

-- 判斷特定字元字串是否符合指定的模式。 模式中可以包含一般字元及萬用字元。 
-- 在模式比對期間，一般字元必須與字元字串中所指定的字元完全相符。 
-- 不過，萬用字元可以符合任意字元字串片段。 使用萬用字元要比使用 = 與 != 字串
-- 比較運算子能讓 LIKE 運算子更有彈性。 如果有任何一個引數不是字元字串資料類型，
-- SQL Server Database Engine 會將它轉換成字元字串資料類型 (若可能的話)。

use Northwind;
go

-- 找出 CustomerID 為 V字母開頭的客戶
select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode
from Orders 
 where CustomerID like 'V%'
--where CustomerID like 'V____'   -- 限定 5 個字母
--where CustomerID like 'V___T'   -- 限定 5 個字母


select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode
from Orders 
--where CustomerID like '%V'
where CustomerID like '____V'     -- 限定 5 個字母


select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode
from Orders 
where CustomerID like '%V%'


-- 找出 CustomerID  最後2個字母為 sp 的客戶
select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode
from Orders 
where CustomerID like '%sp'

-- 找出 CustomerID 中間2個字母為 an 的客戶
select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode
from Orders 
where CustomerID like '%an%'

-- 找出 CustomerID 第1個字母為 abc 中任一字母的客戶
select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode
from Orders 
where CustomerID like '[a-c]%'  -- a to c

select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode
from Orders 
where CustomerID like '[ac]%'   -- a or c

-- 找出 CustomerID 第1個和第2個字母為 abc 中任一字母的客戶
select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode
from Orders 
where CustomerID like '[a-c][a-c]%'

-- 找出ShipPostalCode開頭為1到3的order
select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode
from Orders 
where ShipPostalCode like '[1-3]%'

-- 找出ShipPostalCode開頭為1到2,且第2個數字為0到1的order
select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode
from Orders 
where ShipPostalCode like '[1-2][0-1]%'


-- 找出 CustomerID 第1個字母不是為 t~v 中任一字母的客戶
select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode
from Orders 
where CustomerID like '[^t-v]%'


-- 找出 ShipPostalCode 開頭不是51的order
select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode
from Orders 
where ShipPostalCode not like '51%'


-- 使用 ESCAPE 子句 搜尋包含萬用字元的字串
--	萬用字元
--		%		任何含有零或多個字元的字串。
--		_      任何單一字元。
--		[ ]		在指定範圍 ([a-f]) 或集合 ([abcdef]) 中的任何單一字元。
--		[^]    不在指定範圍 ([^a-f]) 或集合 ([^abcdef]) 中的任何單一字元。

--	程式碼中的 ESCAPE 子句，所指定的字元是 !（驚嘆號），表示說，
--	在 LIKE 子句內的 ! 之後的那個字元（也就是 %）將被視為是一個常數的字元資料，
--	而不是萬用字元。

select 1 where 'AB30%CDE' like '%%%'                         -- 字中有 %
select 1 where 'AB30%CDE' like '%40%%'                     -- 字中有 40%
select 1 where 'AB30%CDE' like '%30!%%' escape '!'    -- 字中有 30%, 但不要算 !

-- 不要理會 escape 後面的字
select 1 where '^ABCDE' like '!^aBCDE' escape '!'; 
select 1 where '-ABCDE' like '!-ABCDE' escape '!'; 
select 1 where ']ABCDE' like '!]ABCDE' escape '!';  
select 1 where '%ABCDE' like '\%ABcDE' escape '\'; 
select 1 where '%ABCDE' like '!%ABCDE' escape '!'; 
select 1 where '%ABCDE' like '#%ABCDE' escape '#'; 
select 1 where '%ABCDE' like '@%ABCDE' escape '@';  
select 1 where '[ABCDE' like '![ABCDE' escape '!'; 
select 1 where ']ABCDE' like '!]ABCDE' escape '!'; 

