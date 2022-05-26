--	Module 8 - Lab02 使用欄位(Column) 的別名


--	傳回特定欄位並設定別名
--		的別名(Alias)，是暫時給予 table 或 column 的臨時名稱。
--		使用別名是為了增加可讀性。
--		別名不會影響到原始欄位名稱。
--		別名也用來指定運算式結果的名稱。
--		當查詢跨越多個 table 時使用別名會很方便。

use Northwind;
go

select * from Products

--	未加 Alias
select	ProductName			as '產品名稱',
			QuantityPerUnit		as '每單位數量',
			UnitPrice					as '美金售價',
			UnitPrice * 32			as '台幣售價',
			UnitsInStock			as '在庫數量',
			UnitsOnOrder			as '在途數量',
			UnitsInStock+UnitsOnOrder as '在庫+在途數量'
from Products;

--	一半加 Alias
select	p.ProductName			as '產品名稱',
			p.QuantityPerUnit		as '每單位數量',
			p.UnitPrice					as '美金售價',
			p.UnitPrice * 32			as '台幣售價',
			UnitsInStock			    as '在庫數量',
			UnitsOnOrder			    as '在途數量',
			UnitsInStock+UnitsOnOrder as '在庫+在途數量'
from Products as p;


--	合併欄位資料
select ProductName + ' /  ' + QuantityPerUnit as 'Name', UnitPrice 
from Products;

--	搭配 ROW_NUMBER 函數,顯示資料列號碼
select row_number() over (order by ProductName desc) as rowid, *		--  order by ProductName
from Products;

select * from Customers
select Address+', '+City as ship_to from Customers

select getdate() as '今天 日期'