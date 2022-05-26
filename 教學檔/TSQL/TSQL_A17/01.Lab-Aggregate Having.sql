--	Module 17 資料的分群以及彙總函數的使用
--		17-1 : 使用彙總函數(Aggregate Functions)
--		17-2 : 使用 GROUP BY 子句與 HAVING 子句
--		17-3 : SELECT敘述的進階查詢–使用 TOP 以及 OFFSET-FETCH 來篩選資料

--		彙總函數是用於資料計算的函數。使用時會根據一組資料值計算並傳回數值。
--		只有在 SELECT 和 HAVING 才可以使用彙總函數。
--		除了 COUNT 之外，彙總函式會忽略 Null 值。
--		彙總函式經常用來搭配 SELECT 陳述式的 GROUP BY 子句使用。

--	彙總函式 :
--		https://docs.microsoft.com/zh-tw/sql/t-sql/functions/aggregate-functions-transact-sql?view=sql-server-ver15

--	數值計算函數 :		SUM 總和,   AVG 平均, 	STDEV 統計標準差,  STDEVP 母體統計標準差
--								VAR 統計變異數,  VARP 母體統計變異數
--	計算數量函數 :		Count 總數 回傳 int,  Count_BIG 總數 回傳 bigint,
--								APPROX_COUNT_DISTINCT 計算非 NULL 的總數，近似值，不精準
--	挑選特殊數值函數 :	MAX 最大值,  MIN 最小值,  	CHECKSUM_AGG 生成用於檢查資料表是否有變更的數值


--	Lab01 使用彙總函數(Aggregate Functions)使用 GROUP BY / HAVING 子句
use Northwind;
go

select * from Orders

--	傳回訂單資料表的訂單總數 -- 可看成 "所有" 資料 Groupby 成一筆資料
select count(*) from Orders

--	送貨城市可能擁有的數個名稱 -- 可看成 "相同" 資料 Groupby 成一筆資料
select distinct ShipCity 
from Orders

select count(distinct ShipCity)
from Orders

--	列出所有運費數，最高價，最低價，平均定價及總價
select count(*), max(Freight), min(Freight), avg(Freight), sum(Freight), stdev(Freight)
from Orders

--	將 MIN、MAX、AVG 和 COUNT 函數與 OVER 子句搭配使用，
--		OVER 子句會先執行查詢，再根據查詢結果資料列集中的每個資料列來計算函數。
--		OVER 子句內可以搭配 ORDER BY 使用，以達成累加值或是查詢中途結果的效果。
--		使用 OVER 子句比使用子查詢來衍生彙總值更有效率。

--		PARTITION BY 將查詢結果集分成幾個資料分割。 視窗函數會分別套用至每個資料分割，
--		並且針對每個資料分割重新開始計算。

select distinct ShipCity,					-- 70 records								ShipCity
		count(*)			over (partition by ShipCity) as CountRecord, --	ShipCity
		min(Freight)		over (partition by ShipCity) as MinFreight,
		max(Freight)	over (partition by ShipCity) as MaxFreight,
		avg(Freight)		over (partition by ShipCity) as AvgFreight,
		sum(Freight)	over (partition by ShipCity) as SumFreight
from Orders

--	GROUP BY 子句可將查詢結果，根據一或多個資料行運算式的清單值，
--		分成多個資料列群組。	SELECT 陳述式會將每個群組傳回一個資料列。
--		GROUP BY 子句可用於配合彙總函數使用。
--		將資料根據 GROUP BY 分群之後，彙總函數才可以計算每一群組中的資料。
--		如果群組資料包含 NULL 值，系統會把所有 NULL 收集成單一群組。

select * from Orders

select ShipCity from orders				--  70 records
group by ShipCity


--	傳回訂單的CustomerID群組資料
select * from Orders

select CustomerID from Orders		-- 90 records
group by CustomerID;


--	傳回訂單的CustomerID及群組數量
select CustomerID, count(*) as customerCount
from Orders                                                       -- 90 records
group by CustomerID;

select * from Orders

--	使用 SUM 函式+GROUP BY子句,傳回訂單客戶的摘要資料。
select CustomerID, sum(Freight) as Freight_Sum, count(*) as customerCount		--  CustomerID
from Orders  
where CustomerID is not null and Freight != 0.00 and CustomerID like '[h-v]%'  
group by CustomerID																			--  CustomerID
order by CustomerID desc;  
go


--	HAVING 是指定資料群組或彙總的搜尋條件。HAVING 子句只可搭配 SELECT 陳述式時使用。
--	HAVING 子句通常會與 GROUP BY 子句搭配使用。
--	HAVING 子句類似 WHERE 子句，但是只適用於 "分群"。

--	查詢可以同時包含 WHERE 子句和 HAVING 子句，使用上應注意以下幾點：
--	沒有 GROUP BY 時，只使用 WHERE 子句，而不使用 HAVING 子句。
--	有 GROUP BY 時，WHERE 子句在 HAVING 子句的前面。
--	HAVING 子句只用在跟 GROUP BY 相關的函數條件上。


--	下列範例會使用簡單 HAVING 子句,擷取每筆金額超過100的訂單編號
select CustomerID, sum(Freight) as Freight_Sum, count(*) as customerCount 	--	CustomerID
from Orders  
where CustomerID is not null and Freight != 0.00 and CustomerID like '[h-v]%'  
group by CustomerID																	--	CustomerID
having sum(Freight)>100
--having sum(Freight)>100 and count(*)>10
order by CustomerID;  
go

--	2017/ 2019  SQL Server		p 8-28


--	下列範例使用 HAVING 子句,並搭配 WHERE 條件式
select * from Products

select ProductID, sum(UnitPrice), sum(UnitsInStock)
from Products
where SupplierID <6
group by ProductID
having sum(UnitPrice)>15
order by sum(UnitPrice)
