--	04.Lab - AFTER DROP, ALTER, CREATE Trigger.sql

use LabDB2


--  誰執行了 DROP_TABLE, ALTER_TABLE, CREATE_TABLE
drop trigger tg_MoniterTables on database

create trigger tg_MoniterTables on database　　--套用在目前 "資料庫"
for drop_table, alter_table, create_table
as
    declare @user nvarchar(50);
    set @user = system_user;
	print '誰在執行 DDL : '+@user

-- 位置不同
--  check :   LabDB2 → 可程式性 → 資料庫觸發程序 

--Create
create table  Department(
	deptno       int ,
	dname       nvarchar (20) ,
	loc              nvarchar(10) ,
	constraint PK_Department  primary key (deptno)
) ;
go


-- Alter
alter table Department add birthday date


-- Drop
drop table  dbo.Department

drop trigger tg_MoniterTables on database

