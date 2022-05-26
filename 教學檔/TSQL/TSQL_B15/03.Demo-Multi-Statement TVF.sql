--	Module 15.   03.Demo - Multi-Statement TVF.sql

--  多重語句資料表值函數 (Multi-Statement TVFs) : 此類函數內容包含 "多個敘述"，
--  會回傳 table 型別的資料集

--	要宣告一個 "資料表變數的結構", 並將程式執行過程中的中途資料先行暫存到此一資料表變數中,
--  等程序都完成後, 在傳回單一 Table 資料型態的最終結果集

drop function if exists tvf_Book

create function tvf_Book(@ISBN as int)
returns @myBook Table(							-- return table variable
	myISBN nvarchar(20),
	myTitle nvarchar(50),
	myRleaseDate date,
	myPublishID int
)
as
begin
    Insert @myBook			-- 將下列 select 出來的值 insect 到 @ myBook 中 (insert table values)
	select ISBN, Title, ReleaseDate, PublisherID
	from Book 

	delete @myBook
	where myISBN = @ISBN
	return
end;
go

select * from tvf_Book(1)
select * from Book



-- Demo

-- Step 1 - Open a new query window to the MarketDev database on the Marketing server
use  MarketDev ;

--  check : MarketDev → 可程式性 → 函數 → 資料表值函數 → dbo.StringListToTable(右鍵) → 修改

-- Step 2 - Select from the dbo.StringListToTable function
declare  @CustomerList  nvarchar(200) ;
set  @CustomerList = '12, 15, 99, 214, 228, 917' ;
select  *  from  dbo.StringListToTable(@CustomerList, ',')   -- MarketDev 已建好的 TVF function



-- Step 3 - Try a different delimiter
declare @CustomerList nvarchar(200) ;
set  @CustomerList = '12|15|99|214|228|917' ;
select  *  from  dbo.StringListToTable(@CustomerList , '|')  ;
go

