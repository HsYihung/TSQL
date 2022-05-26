--	Module 7   04-1.Lab - Heap size.sql

--	Heap 的資料表很容易有虛胖情形(明明資料量很少但卻占掉很大的空間)
-- 同時開啟【04-2.Lab - Clustered size】視窗並排

use LabDB2;
go

--	建立一個測試資料表
drop table if exists heapTB;
go

create table heapTB (
	id int identity(1, 1)  not null,
	name varchar(20)
);

insert heapTB values ('john')
go 10000


--  利用DBCC SHOWCONTIG來檢視一下資料表的頁面配置
dbcc showContig('heapTB')

--  將TABLE的資料全部刪除(注意 : 請使用Delete而非Truncate Table)
delete from heapTB


--  利用DBCC SHOWCONTIG來檢視一下資料表的頁面配置, 比較一下
dbcc showContig('heapTB')


--  利用sp_spaceused來檢視資料表可以更明顯看出，表的rows欄位都是0了，但 data...
exec sp_spaceused 'heapTB'


--  去Rebuild該Table，但是也有其他方式有相同作用。
--			1.  例如在HeapTB上建立Clustered Index或是
--			2.  重新產生一張空的資料表並將 HeapTB 的資料倒進去等等，
--	不外乎都是重建資料的動作。經過Rebuild後，我們可以看見HeapTable的頁數下降為1個Page。

alter table heapTB rebuild

dbcc showContig('heapTB')
exec sp_spaceused 'heapTB'