 --	Module 4 產生流水號的方法
--		4-1:透過使用資料表中的識別欄位-IDENTITY屬性
--		4-2:如何取得識別欄位的值:	@@IDENTITY vs. SCOPE_IDENTITY vs. IDENT_CURRENT
--		4-3:透過順序物件(Sequences) 來產生序號

--		建立資料表中的識別欄位。 這個屬性會搭配 CREATE TABLE 和 ALTER TABLE T-SQL 陳述式使用。
--		語法 : IDENTITY [ (seed , increment) ]
--						seed  裝載到表中的第一個行所使用的值。
--						increment  增量值，該值被新增到前一個已裝載的行的標識值上。
--						必須同時指定種子和增量，或者二者都不指定。如果二者都未指定，則取預設值 (1,1)。

--		如果在經常進行刪除操作的表中存在著標識列，那麼在標識值之間可能會產生差距。
--		如果這構成了問題，那麼請不要使用 IDENTITY 屬性。但是，為了確保未產生差距，
--		或者為了彌補現有的差距，在用 SET IDENTITY_INSERT ON 顯式地輸入標識值之前，
--		請先對現有的標識值進行計算。
--	01.Demo - IDENTITY.sql

--	Step 0: Open a new query window to the tempdb database
use  LabDB2  ;
go

--	Step 1-1: Create the dbo.Opportunity table
create table Opportunity ( 
	  OpportunityID  int identity (1,1) not null ,
	  Requirements  nvarchar(50)  not null  ,
	  ReceivedDate  date  not null  ,
	  LikelyClosingDate  date  null ,
	  SalespersonID  int  null ,
	  Rating  int  not null 
) ;

create table Opportunity01 ( 
	  OpportunityID  int identity (1,1) not null ,
	  Requirements  nvarchar(50)  not null  ,
	  ReceivedDate  date  not null  ,
	  LikelyClosingDate  date  null ,
	  SalespersonID  int  null ,
	  Rating  int  not null 
) ;
--	Step 1-2: Populate the table with 2 rows
insert Opportunity 
values ('n.d.', sysdatetime(), DateAdd (month,1, sysdatetime()), 34, 9) ,
           ('n.d.', sysdatetime(), DateAdd (month,2, sysdatetime()), 37, 2) ;


--	Step 1-3: Check the identity values added
select * from Opportunity ;
select  ident_current ('Opportunity'),  scope_identity (), @@identity  ;


--	 ident_current : 會傳回在任意工作階段、任意範圍中，產生給 「特定資料表」的最後一個識別值。
--	scope_identity	: 會傳回在 「目前工作階段」以及「目前範圍」中，「任意資料表」 產生的最後一個識別值。
--	@@identity		: 會傳回「目前工作階段」 中「所有的範圍」，「任意資料表」所產生的最後一個識別值。


-- Step 1-4: Try to insert a specific value for OpportunityID. This will
--         "fail"  as you cannot insert an explicit identity column value in this way.
insert Opportunity   
	(OpportunityID, Requirements, ReceivedDate, LikelyClosingDate, SalespersonID, Rating)
values (5, 'n.d.', sysdatetime(), DateAdd (month,1, sysdatetime()), 34, 9) ;
select * from Opportunity ;					-- error 


--	流水號欄位改成人為手動給值方式
set identity_insert Opportunity on ;			--	identity_insert on
insert Opportunity 
	(OpportunityID, Requirements, ReceivedDate, LikelyClosingDate, SalespersonID, Rating)
values (6, 'n.d.', sysdatetime(), DateAdd (month,1, sysdatetime()), 34, 9) ;

select * from Opportunity ;

insert Opportunity  
	( Requirements, ReceivedDate, LikelyClosingDate, SalespersonID, Rating)
values ('n.d.', sysdatetime(), DateAdd (month,1, sysdatetime()), 34, 9) ;				-- error 

select * from Opportunity ;

--流水號欄位改回系統自動給值方式
set identity_insert Opportunity off ;			--	identity_insert off



insert Opportunity 
	( Requirements, ReceivedDate, LikelyClosingDate, SalespersonID, Rating)
values ('n.d.', sysdatetime(), DateAdd (month,1, sysdatetime()), 34, 9) ;
go 5

select * from Opportunity ;

select  ident_current ('Opportunity'),  scope_identity (), @@identity  ;


--	Opportunity 01
insert Opportunity01 
values ('n.d.', sysdatetime(), DateAdd (month,1, sysdatetime()), 34, 9) ,
           ('n.d.', sysdatetime(), DateAdd (month,2, sysdatetime()), 37, 2) ;

select * from Opportunity
select * from Opportunity01
select  ident_current ('Opportunity'),   ident_current ('Opportunity01'), scope_identity (), @@identity  ;




--	scope_identity (), @@identity 的差別
create table t1(id int identity(1, 1));  
create table t2(id int identity(150,10));

insert t1 default values
go 5

select * from t1
select  @@identity, scope_identity (), ident_current ('t1'), ident_current ('t2') ;

insert t2 default values
go 5

select * from t2
select  @@identity, scope_identity (), ident_current ('t1'), ident_current ('t2') ;


--  建立一觸發 程序 當t1 insert 就自動在 t2 也insert default
create trigger tg_t1_insert on t1
for insert
as
begin
	insert t2 default values
end;

--  在t1中 insert values 
insert t1 default values;
select * from t1;
select * from t2;
select  @@identity, scope_identity (), ident_current ('t1'), ident_current ('t2') ;

drop table if exists t1, t2
