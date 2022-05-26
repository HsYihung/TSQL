--	Module 8   善用非叢集索引(Nonclustered Index) 加快查詢效率
--			8-1: 非叢集索引的結構
--			8-2: 非叢集索引的規劃與建立

--	非叢集索引(Non-Clustered):一個SQL Server資料表可有"多個非叢集索引" (一般索引
--			或唯一索引)，非叢集索引不會依照其索引鍵值的順序來 "存放" 資料，但仍能夠
--			依其設定的索引快速找到所需的資料內容, non-clustered 也會根據資料建立出 Balance Tree，

--	SQLServer 會自動將 UNIQUE 欄位建立成"非叢集索引"，其名稱通常為 UK_TableName_xxx


--	01.Lab - CREATE NONCLUSTERED INDEX.sql

-- Step 1: Use the tempdb database.
use LabDB2;
go

drop table if exists Book

-- Step 2: Create a table:  dbo.Book
create table Book(
  ISBN  nvarchar(20)  not null ,
  Title  nvarchar(50)  not null ,
  ReleaseDate  date  not null ,
  PublisherID  int  not null
) ;
go

insert book values('1', 'aaaaa', '2020-1-1', 1)
insert book values('2', 'bbbbb', '2020-1-2', 2)
insert book values('3', 'ccccc', '2020-1-3', 3)
insert book values('4', 'ddddd', '2020-1-4', 4)
insert book values('5', 'eeeee', '2020-1-5', 5)

select * from book


--   先 highlight / mark 你要估計的範圍
-- 【顯示估計執行計畫】 for a query that needs lookups
select title from Book where  ISBN='5'      -- 【顯示估計執行計畫】顯示 : 資料表掃描
select title from Book where  Title='5'

alter table book add primary key(ISBN)

--  after primary key adding【顯示估計執行計畫】 for a query that needs lookups again
select title from Book where  ISBN='5'      -- 【顯示估計執行計畫】顯示 : 叢集索引搜尋
select title from Book where  Title='5'


-- Step 3: Create a nonclustered index on PublisherID and ReleaseDate DESC
create nonclustered index IX_Book_Publisher
	on Book (PublisherID, ReleaseDate desc);
go


-- Step 4: Request an 〝estimated execution plan〞【顯示估計執行計畫】 for a query that needs lookups
select PublisherID, Title, ReleaseDate
from Book 
where ReleaseDate > DateAdd(year, -1, sysdatetime())
order by PublisherID, ReleaseDate desc;
go

select * from book

--  include 子句裡的欄位資料會擺放在非叢集索引(Nonclustered Indexes)的分葉層級頁面(leaf-level pages)裡
-- Step 5: Replace the index with one that includes the Title column
--	Index covers the Query
create nonclustered index IX_Book_Publisher
	on Book (PublisherID, ReleaseDate desc)
	include (Title)                             -- include Title : index on PublisherID, ReleaseDate & Title
	with drop_existing;
go


-- Step 6: Again, request an〝estimated execution plan〞【顯示估計執行計畫】for the query
select PublisherID, Title, ReleaseDate
from dbo.Book 
where ReleaseDate > DateAdd(year, -1, sysdatetime())
order by PublisherID, ReleaseDate desc;
go

