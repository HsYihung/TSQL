 --  Module 3 暫存資料表(Temporary Table)與通用資料表運算式
--				(Common Table Expressions,CTE)的使用
--				3-1: 區域暫存資料表(Local Temporary Tables)
--				3-2: 全域暫存資料表(Global Temporary Tables)
--				3-3: 使用通用資料表運算式(Common Table Expressions)

--		用來提供臨時性需求使用所產生的資料表, 記憶體存在於 tempdb，

--		暫存表 [#Table]
--			可建立索引(index)，當SQL Server關閉時，#Table會自動DROP，但最好自己手動DROP。

--		暫存表 [##Table]
--			## 兩者均在tempdb資料庫中建立起資料表(存於DISK中)，可利用 DROP TABLE 刪除暫存資料表，
--			或是建立該暫存資料表的 "連線結束" 時，SQL Server 會自動將其刪除。兩者的差異在於，
--			#Table只有建立者可以使用，其他人不可使用(其他資料庫)，
--			而##Table則是 "全域" 的資料表，所有人均可取用(其他資料庫也可使用)。

--		暫存表變數 [@Table]
--			稱為資料表變數，將資料表當作是一個變數來使用，當批次指令執行完成後即自動從記憶體中被刪除。
--			@Table 與 #Table & ##Table的差異在於，前者不需使用DROP指令，當此次指令執行完後會自動被刪除；
--			後者可使用DROP或是待連線結束後暫存表才會消失。


--	01.Lab - Temporary Tables.sql : 當工作階段中斷時, 刪除資料表

--	create 一Local Temporary資料表
use LabDB2

create table #Customer (					
	CustomerID	int,
	CustomerName nvarchar(12),
	Address nvarchar(100)
);

insert #Customer 
values(1, 'Apple', 'Taiwan, Taipei')

select * from #Customer


--	insert into 一Local Temporary資料表
select * into #Department				
from AdventureWorks.HumanResources.Department ;
go

select * from #Department


--Global Temporary Tables

--	create 一Global Temporary資料表
create table ##Customer(				
	CustomerID	int,
	CustomerName nvarchar(12),
	Address nvarchar(100)
);
insert ##Customer values(1, 'Apple', 'Taiwan, Taipei')
select * from ##Customer


--	insert into 一Global Temporary資料表
select * into ##Department
from AdventureWorks.HumanResources.Department ;
go
insert ##Department						
values ('Test', 'Test', getdate());
go

select * from 	##Department	;
go



--  Demo --

use AdventureWorks;

select * from Sales.SalesOrderHeader

--	2007年客戶加總購買金額
select customerID, sum(subTotal) as sum2007 into #yr2007   --  select into
from Sales.SalesOrderHeader
where year(orderdate) =2007
group by CustomerID

select * from #yr2007

--	2008年客戶加總購買金額
select customerID, sum(subTotal) as sum2008 into #yr2008
from Sales.SalesOrderHeader
where year(orderdate) =2008
group by CustomerID

select * from #yr2008
select * from #yr2007

--	#yr2007 full join #yr2008, 但 storeID 在 SalesCustomer DB 內
select	y7.CustomerID, y8.sum2008, y7.sum2007,
			coalesce ((y8.sum2008 - y7.sum2007) /	y7.sum2007 *100., 0) as percentgrow
from #yr2007 as y7
full join #yr2008 as y8 on y7.CustomerID = y8.CustomerID    -- 18691 records
where y7.CustomerID is not null and y8.CustomerID is not null
--order by y7.CustomerID     
order by percentgrow desc


--	#yr2007 join #yr2008 join SalesCustomer 取得 storeID, 
--		但 store Name 在 Sales.Store 內......  storeid in Sales.Customer table
select	c.CustomerID,	c.StoreID, y8.sum2008, y7.sum2007,
			coalesce ((y8.sum2008 - y7.sum2007) /	y7.sum2007 *100., 0) as percentgrow
from Sales.Customer as c                       -- from Customer and join with 2007 & 2008 by customer ID
right join #yr2008 as y8 on c.customerid = y8.CustomerID
right join #yr2007 as y7 on c.customerid = y7.CustomerID
where c.CustomerID is not null and c.StoreID is not null
order by c.customerid, c.storeid ;


--	@Table 變數 :
--		建立的語法類似於臨時 @Table，區別就在於建立的時候，必須要為之命名。
--		@Table變數是變數的一種，@Table變數也分為本機及全域的兩種，
--		本機Table變數的名稱都是以“@”為首碼，只有在本機當前的用戶連接中才可以訪問。
--		全域的Table變數的名稱都是以“@@”為首碼，一般都是系統的總體變數，像我們常用到的，
--		如@@Error代Table錯誤的號，@@RowCount代Table影響的行數。

declare @Customer table (			-- 變數 @Customer table 不再是純量值;  like create table
	CustomerID	int,
	CustomerName nvarchar(12),
	Address nvarchar(100)
)
insert @Customer values(1, 'Apple', 'Taiwan, Taipei')
select * from @Customer

--	Error : 與 declare 一個變數一樣, 單獨 select 訪問會出錯
select * from @Customer				-- 必須宣告資料表變數 "@Customer"


--	@@Table 變數 :
declare @@Customer table (
	CustomerID	int,
	CustomerName nvarchar(12),
	Address nvarchar(100)
)
insert @@Customer values(1, 'Apple', 'Taiwan, Taipei')
select * from @@Customer

--	Error : 與 declare 一個變數一樣 單獨 select 訪問會出錯
select * from @@Customer			-- 必須宣告資料表變數 "@@Customer"


