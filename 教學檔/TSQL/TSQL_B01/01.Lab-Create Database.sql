 --	Module 01  建立資料庫
--		1-1 : 如何建立與刪除資料庫
--		1-2 : 如何卸離與附加資料庫
--		1-3 : 如何匯入與匯出資料

--  SQL Server 為資料庫檔案共使用三個副檔名，包括.mdf、ndf 及 ldf 等，
--			其中.mdf 是主要資料庫檔案，資料庫的定義及系統物件都儲存在此，
--			.ndf 是可有可無的次要檔案，.ldf 是交易記錄檔，一個資料庫至少會有.mdf 及 .ldf 檔案。


--	1-1: 如何建立與刪除資料庫

use master;
go

--  檢視 : DB :  model(右鍵) → 檢視 →  系統檢視表 → sys.databases

if db_id ('LabDB2') is null   
--	begin         
		create database LabDB2;		-- 不能用這種寫法 : create database if not exists LabDB2
--	end
else
	print 'db exists'
go

--  再次檢視 : 資料庫 model(右鍵) → 檢視 → 系統檢視表 → sys.databases (右鍵)

--	建立一個結構描述(Schema)名稱:  HR, 
use LabDB2

create schema HR					-- 檢視 : LabDB2下 → 檢視 → 系統檢視表 → sys.schemas (右鍵) → 編輯200
	--authorization dbo ;
go

select  * from sys.schemas		-- LabDB2下 → 安全性 → 結構描述 → HR


--	建立部門資料表(Department Table)
use LabDB2
create table  HR.Department(
	deptno       int ,
	dname       nvarchar (20) ,
	loc              nvarchar(10) ,
	constraint PK_Department  primary key (deptno)
) ;
go


--	建立員工資料表(Employee Table)  table-constraint
create table  HR.Employee(
	empno		int identity (100, 1) ,
	ename		nvarchar(20) ,
	gender		nvarchar(1) ,
	job           nvarchar(18) ,
	birthday   datetime ,
	salary      int ,
	bonus      int ,
	deptno     int ,
   constraint	PK_Employee  primary key (empno),
   constraint FK_Employee_Department  foreign key (deptno) references  HR.Department (deptno)
) ;
go


use LabDB2
go

-- Create DataBase
drop database if exists Class

create database Class
on primary 
		(name ='class', filename = 'c:\Temp\Class.mdf' , 
			size = 6MB , maxsize = unlimited, filegrowth = 1MB ),
filegroup secondary 
		(name = 'class_ndf', filename = 'c:\Temp\Class_ndf.ndf' , 
			size = 6MB , maxsize = unlimited )     --filegrowth = 1MB,      64MB
log on -- 自動產生
		(name = 'class_ldf', filename = 'c:\Temp\Class_ldf.ldf' , 
			size = 6MB , maxsize = 2GB , filegrowth = 1MB )
go

-- check : Class (右鍵) → 屬性  → 檔案

-- check : 物件總管 → 管理 → SQL Server 記錄檔(右鍵) → 檢視 → SQL Server 記錄檔

