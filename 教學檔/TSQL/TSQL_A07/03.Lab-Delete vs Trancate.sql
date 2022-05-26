--	Module 7 - Lab03 DELETE 指令與 TRUNCATE TABLE 指令的差別

--	DELETE 指令會一筆一筆的移除資料，識別欄位編號不會歸 0。
--	DELETE 速度比較慢，因為交易紀錄 log file 會記錄每一筆被刪除的資料。

--	TRUNCATE TABLE 指令會移除所有資料，但會保留資料表結構、欄位、條件約束、索引。
--	若要刪除資料表中的所有資料列，請使用 TRUNCATE TABLE。 TRUNCATE TABLE 的速度比 DELETE 快。
--	TRUNCATE TABLE 有點像 "不含 WHERE 條件式的 DELETE 陳述式"，不過 TRUNCATE TABLE 速度較快。
--	TRUNCATE TABLE 會保留資料表結構、欄位、條件約束、索引。
--	識別編號會重設初始值。
--	FOREIGN KEY 條件約束或參與索引檢視所參考的資料表，無法使用 TRUNCATE TABLE。
--	TRUNCATE TABLE 無法啟動 DELETE 觸發程序，因為不同於資料表的刪除動作。

--	DROP TABLE 會移除整個資料表內的所有資料和資料表結構、欄位、條件約束、索引
--	DROP TABLE 後如果要重新使用資料表，須要重新 CREATE TABLE。

use LabDB;
go

select * from TempEmployees

--	刪除 TempEmployees 所有的資料
delete TempEmployees;
go

--	新增2筆測試資料並查看識別欄位 EmployeeID 的值
insert TempEmployees( LastName, FirstName, TitleofCourtesy)
	values	('Karin', 'Josephs', 'Mr.'),
				('Angelina', 'Jolie', 'Ms.');
go

select * from TempEmployees;
go

--  使用 TRUNCATE TABLE 再重覆上面的新增測試資料,再查看識別欄位 EmployeeID 的值
--  指令會移除所有資料，但會保留資料表結構、欄位、條件約束、索引
truncate table TempEmployees;
insert TempEmployees( LastName, FirstName, TitleOfCourtesy)
	values	('Karin', 'Josephs', 'Mr.'),
				('Angelina', 'Jolie', 'Ms.');
go 5

select * from TempEmployees;

--	使用 DROP TABLE 將資料表缷除
--	DROP TABLE TempEmployees;
GO

--	使用 SELECT...INTO 建立測試資料表(2155筆資料)

select * into TempOrderDetails
from Northwind.dbo.[Order Details];
go

select * from TempOrderDetails

--	用 DELETE 刪除 2155 筆資料, 並顯示執行時間
set statistics time ON;
	delete from TempOrderDetails;
set statistics time OFF;  
go

--	缷除測試資料表並重覆上面SELECT...INTO的動作,重建測試資料表
drop table if exists TempOrderDetails;
go

select * into TempOrderDetails
from Northwind.dbo.[Order Details];
go


--	使用 TRUNCATE TABLE 並比較花費的時間
set statistics time ON;
	truncate table TempOrderDetails;
set statistics time OFF;  
go
