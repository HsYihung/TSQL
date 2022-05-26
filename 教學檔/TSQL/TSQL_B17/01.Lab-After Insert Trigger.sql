--	Module 17. 透過 DML觸發程序(DML Triggers)來處理相關資料     
--		17-1:如何建立 AFTER INSERT Triggers     
--		17-2:如何建立 AFTER DELETE Triggers     
--		17-3:如何建立 AFTER UPDATE Triggers     

--		觸發程序是當資料庫伺服器發生事件時，會自動執行的特殊預存程序，所謂的事件
--		可能是資料表的新增、修改或刪除的動作，當設定的事件動作發生時會執行自動觸發程序，
--		例如 : 建立	DML (與Insert、Update與Delete相關的操作)、
--							DDL (與Create、Alter、Drop與Grant相關的操作) 或登入(Logon)觸發程序

--	FOR | AFTER | INSTEAD OF
--	FOR					：同等 AFTER 。
--	AFTER				：	只在觸發的 SQL 陳述式指定的所有作業 "都執行成功" 時，
--								才引發DML 觸發程序。檢視不能定義 AFTER 觸發程序。
--	INSTEAD OF	：	指定以DML 觸發程序來 "取代觸發" 的 SQL 陳述式，
--								因此，會覆寫觸發陳述式的動作。

--		inserted 代表 insert 的資料 或 update 「後」的資料
--		deleted 代表 delete 的資料 或 update 「前」的資料
--		inserted 和 deleted  都有資料表示為 UPDATE ，
--			可以使用 IF EXISTS (select 1 from inserted) and 
--			EXISTS (select 1 from deleted)  來判斷

-- Step 1: Open a new query window and use the LabDB2 database
use LabDB2
select * from Book

-- table book 發生insert 就 select 
drop trigger if exists tg_book_insert_select

create trigger tg_book_insert_select on Book
for insert
as
begin
	declare @ISBN nvarchar(20)
	select @ISBN = ISBN from inserted			-- inserted 代表 insert 的資料 「後」的資料
	print 'insert occured ISBN no. : ' + @ISBN

	if update(PublisherID) or update(Title)
		print 'Title 或 PublisherID 欄位被更新'
	select * from Book
	select * from Book where @ISBN=ISBN				--  單筆 select 
end

--  check :   LabDB2 → 資料表 → BOOK → 觸發程序 → 修改

-- Step 3: Execute the following code to test the trigger 
insert Book values ('34', 'SQL Server ', '2010-1-1', 20)
--select * from Book


--	check : LabDB2 → dbo.Book → 觸發程序
select * from sys.objects where type = 'TR'
select * from sys.sysobjects where xtype = 'TR'




--  PublisherID 大於50  資料 rollback
drop trigger if exists tg_book_insert_rollback

create trigger tg_book_insert_rollback on Book
for insert
as
begin
	declare @PublisherID int
	select @PublisherID = PublisherID from inserted
	print 'insert occured ISBN no. with PublisherID : ' + str(@PublisherID)
	if @PublisherID >50										--  PublishID 若大於 50 就 回滾 rollback
		begin
				print 'PublisherID 大於50  資料 rollback'
				print 'tran count : '+str(@@trancount)		--  @@trancount = 1 ? 是否隱性被 on
				rollback;
		end
end


insert Book values ('69', 'SQL Server ', '2010-1-1', 80)		-- try PublisherID < 50
select * from Book


--停用 DML 觸發
disable trigger  tg_book_insert_rollback on Book;
disable trigger  tg_book_insert_select on Book;

--啟用 DML 觸發
enable trigger  tg_book_insert_rollback on Book;
-- drop trigger if exists tg_Book_insert_select ;



