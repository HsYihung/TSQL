--	Module 16.   探索視窗函數(Window Functions)    
--		16-1 : 透過 OVER 子句建立 SQL 視窗 (Windows)     
--		16-2 : 次序函數(Ranking functions)-RANK()、DENSE_RANK()、ROW_NUMBER()、
--				   NTILE() 的運用     
--		16-3 : 視窗型偏移(/位移)函數-分析函數-LAG()、LEAD()、FIRST_VALUE()、
--				   LAST_VALUE() 的運用     


--	01.Demo - Ranking Functions.sql
--			用於相關的視窗函數之前，透過OVER子句來決定資料列的 "資料分割" 和 "排序"，
--			亦即OVER子句會定義查詢結果集內的視窗或使用者指定的資料列集，接著
--			視窗函數會針對視窗中的每個資料列來計算值
--			RANK : 傳回結果集分割區內，每個資料列的次序。 資料列的次序
--						等於一加上前述資料列之前的次序數目。

-- 排名等第函數(Ranking functions)的運用	Ranking Data by Using 【RANK】  的例子
--	RANK()函數與ROW_NUMBER()類似，遇到相同數值的資料會給相同排名且其後排名會跳過
--			ROW_NUMBER 會依序為所有資料列編號	(例如 1、2、3、4、5)。 
--			RANK 則為繫結提供相同的數值 (例如 1、2、2、4、5)。
--			RANK 是查詢在執行時所計算的 "暫存值"。 若要將數字保存在資料表中，
--						請參閱 IDENTITY 屬性和 SEQUENCE。

use AdventureWorks ;

select * from Production.Product
select * from Production.ProductSubCategory


select psc.Name as Category, p.Name as Product, p.ListPrice, 
         rank() over( partition by psc.Name order by p.ListPrice desc ) as Rank_Cat_ListPrice,--  只看種類後, 價格排名
         rank() over( order by p.ListPrice desc ) as Rank_ListPrice		--  只看價格排名
from Production.Product as p  
join  Production.ProductSubCategory as psc
on p.ProductSubCategoryID = psc.ProductSubCategoryID
order by psc.Name, p.ListPrice desc										-- no group by
--order by p.ListPrice desc																 --  只看價格排名


--	Ranking Data by Using 【DENSE_RANK】  的例子
--  DENSE_RANK()函數 : 與Rank()類似，遇到相同數值的資料會給相同排名
--	但其後排名不會跳過(1,1,1,2,2,2)
select psc.Name as Category, p.Name as Product, p.ListPrice,   -- partition by psc.Name
         dense_rank() over( partition by psc.Name order by p.ListPrice desc ) as PriceRank_Cat_ListPrice,
         dense_rank() over( order by p.ListPrice desc ) as PriceRank_ListPrice
from Production.Product as p  
join  Production.ProductSubCategory as psc
on p.ProductSubCategoryID = psc.ProductSubCategoryID
order by psc.Name, p.ListPrice desc
--order by p.ListPrice desc


--	Ranking Data by Using 【ROW_NUMBER】  的例子
--  依指定欄位將所有資料進行排序並提供指定序號
select row_number() over( partition by pc.Name order by ListPrice ) as row,  --  partition by pc.Name
          pc.Name as Category, p.Name Product, p.ListPrice
from Production.Product as p  
join Production.ProductSubCategory  as psc
on p.ProductSubCategoryID = psc.ProductSubCategoryID
join Production.ProductCategory as pc
on psc.ProductCategoryID = pc.ProductCategoryID ;



--  NTILE()函數  : 將以排序資料分割中的資料分佈到所有指定數目的群組中 (群組, 均等分, 排名)
--	Ranking Data by Using 【NTILE】  的例子
select NTILE(3) over( partition by pc.Name order by ListPrice ) as row,    -- NTILE(3) 將 Cat. 平均分 3 份
          pc.Name as Category, p.Name Product, p.ListPrice
from Production.Product as p   
join Production.ProductSubCategory  as psc
on p.ProductSubCategoryID = psc.ProductSubCategoryID
join Production.ProductCategory as pc
on psc.ProductCategoryID = pc.ProductCategoryID ;
go



select psc.Name as Category, p.Name as Product, p.ListPrice, 
         sum(p.ListPrice) over( partition by psc.Name order by ListPrice) as PriceSum_Cat_ListPrice,  -- by Category + ListPrice
         sum(p.ListPrice) over( partition by psc.Name) as PriceSum_Cat,      -- by Category
         sum(p.ListPrice) over(order by ListPrice) as PriceSum_ListPrice,      --sum by ListPrice order
		 sum(p.ListPrice) over() as PriceSum                                           -- no partition, no order,  just total ListPrice
from Production.Product as p  
join  Production.ProductSubCategory as psc
on p.ProductSubCategoryID = psc.ProductSubCategoryID
--order by psc.Name, p.ListPrice
order by p.ListPrice

