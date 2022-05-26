--	Module 7   04-2.Lab - Clustered size.sql

--	Heap 的資料表很容易有虛胖情形(明明資料量很少但卻占掉很大的空間)

use LabDB2;
go

--	建立一個測試資料表
drop table if exists clusteredTB;
go

create table clusteredTB (
	id int identity(1, 1)  primary key,
	name varchar(20)
);

insert clusteredTB values ('john')
go 10000


--  利用DBCC SHOWCONTIG來檢視一下資料表的頁面配置
dbcc showContig('clusteredTB')

--  將兩張TABLE的資料全部刪除(注意 : 請使用Delete而非Truncate Table)
delete from clusteredTB


--  利用DBCC SHOWCONTIG來檢視一下資料表的頁面配置, 比較一下
dbcc showContig('clusteredTB')


--  利用sp_spaceused來檢視資料表可以更明顯看出，表的rows欄位都是0了，但 data...
exec sp_spaceused 'clusteredTB'



dbcc showContig('clusteredTB')
exec sp_spaceused 'clusteredTB'