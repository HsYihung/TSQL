--	Module 3 - Lab02 使用結構描述
--		使用結構描述與資料庫角色可以限制資料庫使用者的作用範圍。
--		結構描述(Schema)是資料庫物件(Table、View、Triggers…等等)的一個集合。
--		可以透過結構描述來設計物件的存取權限

--	.\STUDENT-PC  ●  LabDB  ●  [dbo]Schema  ● student
--	dbo = db owner

--	https://www.itread01.com/content/1550139669.html

--  使用schema 好處是 :
--	1.	同一資料庫中只要以 schema 區分，便可以使用同一資料表名稱
--			Ex: sales.employees、rd.employees 或 fab.employees

--	2.	要設定權限時，可以以 schema 為 Group 對象，給予不同的權限等級與使用者，
--		意即當某一新進 RD 需要存取整個RD部門的資料表時，DBA只需要將該RD加入到 RD schema 中
--		及完成權限的設定，不再需要一個一個資料表慢慢設。

--  https://matthung0807.blogspot.com/2020/12/database-schema-meaning.html

use LabDB;
go

-- 創建結構描述 schema
create schema lab;    -- check : LabDB →  安全性 → 結構描述
go

-- 建立一資料表使用 lab 結構描述
create table lab.Teachers (
	id int,
	name varchar(10)
);
go

-- 檢視此資料庫的結構描述
select * from sys.schemas;　　				-- LabDB → 檢視 → sys.schemas
select * from information_schema.schemata  --針對目前資料庫中每個結構描述

-- 建立二個測試使用者
create user student01 without login;		-- check : LabDB → 安全性 → 使用者 → student01 → 屬性 → 安全性實體 (授權/拒絕)
create user student02 without login;
go

grant select on schema ::lab to student01  -- check 安全性 → 使用者 → student01 → 屬性 → 安全性實體 (授權/拒絕)
deny select on schema ::lab to student02;
go

drop user if exists student01;
drop user if exists student02;

-- 修改結構描述 schema 由 lab.Teachers 改變為 dbo.Teachers
alter schema dbo transfer lab.Teachers;
go

--	刪除結構描述
--		如果發生錯誤其他物件正在參考它必須先移除參考才能刪除
drop schema if exists  lab;          -- check LabDB → 安全性 → 結構描述
go

