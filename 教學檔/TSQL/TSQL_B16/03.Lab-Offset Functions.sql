 --  Module 16.    03.Lab - Offset Functions.sql


use AdventureWorks
go

select * from Sales.SalesPersonQuotaHistory

--  LAG 會提供對於目前資料列之前給定實體位移之資料列的存取。 
--			在 SELECT 陳述式中使用這個分析函數，比較目前資料列中的值與前一個資料列中的值。
--	LAG(): 取得目前資料表之前的資料紀錄提供比對之用,  例如算報酬率

select	BusinessEntityID, QuotaDate, year(QuotaDate), SalesQuota,
			lag(SalesQuota, 1, 0) over (order by (QuotaDate)) as PreSalesQuota,
			SalesQuota-lag(SalesQuota, 1, 0) over (order by (QuotaDate))
from Sales.SalesPersonQuotaHistory
where BusinessEntityID = 280 and year(QuotaDate) in ('2006', '2007', '2008')



-- LEAD 在跟隨目前資料列的已指定實體 "位移" 中，提供存取資料列。 
--		在 SELECT 陳述式中使用這個分析函數，比較目前資料列中的值與下列資料列中的值。
--	LEAD() : 取得目前資料表之後的資料列提供比對之用
select	BusinessEntityID, QuotaDate, year(QuotaDate), SalesQuota,
			lead(SalesQuota, 1, 0) over (order by (QuotaDate)) as PostSalesQuota,
			lead(SalesQuota, 1, 0) over (order by (QuotaDate)) - SalesQuota
from Sales.SalesPersonQuotaHistory
where BusinessEntityID = 280 and year(QuotaDate) in ('2006', '2007', '2008')


---------------------- first compare with previous record, cheaper ----------------------------------
select * from Production.Product

select ProductSubcategoryID, name, ListPrice
from Production.Product
where ProductSubcategoryID = 17
order by ListPrice


--	FIRST_VALUE(): 傳回已排序值 "集中" 的第一個值。
select ProductSubcategoryID, name, ListPrice, 
			First_value(name) over (order by ListPrice asc) as cheap
--			First_value(name) over (order by ListPrice desc) as expansive
from Production.Product
where ProductSubcategoryID = 17
order by ListPrice
------------------------------------- subcategory cheap---------------


select ProductSubcategoryID, name, ListPrice, 
			First_value(name) over (partition by ProductSubcategoryID order by ListPrice asc) as Cate_cheap,
			First_value(name) over (partition by ProductSubcategoryID order by ListPrice desc) as Cate_expensive
from Production.Product
where ProductSubcategoryID is not null
order by ProductSubcategoryID, ListPrice


--	LAST_VALUE() : 取得資料表排序值 "集" 的最後一個值
--  排序後的資料我們預設要取出從第一筆到目前我這一筆，
--  所以當 FIRST_VALUE 沒有加入 RANGE 條件的時候，因為會從第一筆取，所以沒有問題。
--  但 LAST_VALUE 沒有加入 RANGE，預設就是從第一筆抓到該筆資料，所以看起來會跟自己同樣的值。
--  換言之，如果加入 RANGE 限制從目前我這一筆資料取到最後一筆的時候，
--  則 FIRST_VALUE 出來的值就會類似 LAST_VALUE 沒有加入 RANGE 的狀況了。因此上述的語法會得到以下的結果。
select ProductSubcategoryID, name, ListPrice, 
			Last_value(name) over (order by ListPrice 
													range between unbounded preceding and 
													unbounded following) as expensive
from Production.Product
where ProductSubcategoryID = 17
order by ListPrice



select ProductSubcategoryID, name, ListPrice, 
			Last_value(name) over (partition by ProductSubcategoryID order by ListPrice
													range between unbounded preceding and 
													unbounded following) as expensive
from Production.Product
where ProductSubcategoryID is not null
order by ProductSubcategoryID, ListPrice