--	Module 4 使用Keys條件約束 (Constraints)來實作資料的完整性 
--		4-1 : PRIMARY KEY 條件約束		[unique,  no null]
--		4-2 : FOREIGN KEY 條件約束	[no unique,	null]
--		4-3 : UNIQUE 條件約束				[unique,	one null]

--	CONTRAINT(條件約束) 可以用來強制執行 SQL Server 資料表中的資料完整性。
--					確保資料庫內的資料是準確、有效、一致的。
--	CONTRAINT(條件約束) 是限制資料儲存到資料表中的語法，因此寫入的資料都必須遵守這個準則。
--	CONTRAINT(條件約束) 這些限制語法可以在CREATE TABLE 或事後用 ALTER TABLE 語句來指定。


--	PRIMARY KEY(主索引鍵) 是用來辨識紀錄的欄位，確認資料表中每一筆資料都是表格中的唯一值。
--				換言之，它是用來獨一無二地確認一個表格中的每一行資料。
--	PRIMARY KEY(主索引鍵)可以實現資料庫的實體完整性。
--			主索引鍵值不可重複，並且必須定義成 NOT NULL。
--			一個資料表只能有 "一個主索引鍵的條件約束"，可以使用一個欄位，或是指定多個欄位組合起來做為複合索引鍵。
--			資料表 "可以不具有主索引鍵"，但是一般都建議最好是有。

use LabDB;
go
--	Lab01 資料表 PRIMARY KEY 條件約束
--	下列範例會建立一個資料表，並在資料行上定義主索引鍵。
--	要注意欄位必須具備 "NOT NULL" 屬性，且"沒有重複值" , NOT NULL 可寫可不寫
create table Product(
    id_identity int identity (1, 1),
    ProductID int  not null, constraint PK_ProductID primary key clustered (ProductID),
	ProdName nvarchar(50)
);
go

insert Product values(1, 'Apple')
insert Product values(2, 'Banana')
insert Product values(3, 'Cherry')

insert Product values(1, 'Apple')		-- Error PK constrain 

select * from Product

-- check : LabDB → 資料表 → dbo.Product → 資料行 → ProductID


--	刪除測試資料表的 constraint PK, not column
alter table Product  
	drop constraint PK_ProductID;
go  

insert Product values(1, 'Apple')	-- success

delete from Product where ProductID=1;
--	下列範例會在現有的資料表建立主索引鍵。
--		要注意欄位必須具備 NOT NULL 屬性，且沒有重複值

alter table Product
    add constraint PK_ProductID primary key clustered (ProductID);
go

select * from Product

update Product set ProductID=5 where ProductID=2


-- 觀察 [Order Datail] 中資料行中出現兩把黑"鑰匙"

drop table if exists Product