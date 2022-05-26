 --	Module 9   資料庫的交易 (Transactions) 控制簡介
--			9-1: 交易(Transactions) 的 A.C.I.D. 四種屬性
--			9-2: SQL Server 主要的交易管理模式 (Transaction Management Mode)
--			9-3: @@TRANCOUNT 的值與 COMMIT、ROLLBACK 的關係

--	A. C. I. D.
--		不可部份完成性（Atomicity）: 交易必須全部完成執行all，要不就是全部不執行nothing。
--		一致性（Consistency）: 交易完成時，全部的資料必須維持一致性的狀態。
--		隔離性（Isolation）: 交易中的資料會處於隔離狀態，無法被其它交易存取。
--		耐久性（Durability）:	交易完成之後，其作用便永遠存在於系統之中


--	SQL Server本身提供3個交易模式:
--			1. 自動認可交易 (Autocommit transaction) : "預設" 模式
--				當 "每個 T-SQL 敘述執行" 時都自動視為 "一個" 交易，當敘述執行完成時自動認可交易，
--				若有錯誤發生交易便會自動回復 (回滾) rollback (不過並非所有 T-SQL 指令都支援自動認可交易)，
--				目前有支援的指令如下:
--				Alter Table, Create, Delete, Drop, Fetch, Grant, Insert, Open, Revoke,
--				Select, Truncate Table, Update

--			2. 外顯交易(Explicit transaction):
--				必須透過 Begin Tran、Commit Tran 與 Rollback Tran 等指令敘述完成交易的方式

--			3. 隱含交易(Implicit transaction default OFF) : 
--				工具 → 選項 → 查詢執行 → SQL Server → ANSI  →  Set_Implicit_Transaction，
--				透過 Set IMPLICIT_TRANSACTIONS ON 或 OFF 的方式啟動與關閉隱含交易，
--				當資料庫進入此模式有開始交易便 TRANCOUNT=1，"直到執行 COMMIT TRAN 
--				或 ROLLBACK Tran指令" 自動進行下個交易

--	2017/ 2019 SQL Server p 13-4

--	當 SET XACT_ABORT 是 ON 時，如果 Transact-SQL 陳述式產生執行階段錯誤，
--			就會終止和"回復" rollback 整個交易。
--	當 SET XACT_ABORT 是 OFF 時，在某些情況下，只會"回復"產生錯誤的 Transact-SQL 陳述式，
--			交易會繼續進行。

set xact_abort on

use LabDB2;
go

--	Create and populate a test table
drop table if exists NewTable ;

create table NewTable (
		Id int primary key, 
		Info char(10)
)

rollback tran			--  將 transaction count 歸 0,  要求沒有對應的 BEGIN TRANSACTION

--	 case 1: 【Compile Errors】 All Rollback 完全無法寫入
select @@trancount
insert NewTable values (1, 'aaa') ;
insert NewTable values (2, 'bbb') ;
insert NewTable VALUSE (3, 'ccc') ;		-- Syntax error. (語法錯誤!)

select * from NewTable ;							-- 完全無法寫入.



--	case 2: 自動認可交易(Autocommit transaction) : "預設" 模式  Partial commit, Partial rollback
select @@trancount
insert NewTable values (1, 'aaa') ;			-- 部分寫入 Partial commit
insert NewTable values (2, 'bbb') ;          -- 部分寫入 Partial commit
insert NewTbl	   values (3, 'ccc')				-- Table name error. (物件解析錯誤!)
insert NewTable values (4, 'bbb') ;
select @@trancount

select * from NewTable ;							-- 僅寫入兩筆



-- case 2.1  外顯交易(Explicit transaction)  all rollback
--  當一段指令被 begin tran ..... commit tran 包覆時, 是處於交易中, 有 "任何一個錯誤" , 整包回滾 rollback
begin tran
	select @@trancount
	insert NewTable values (10, 'aaa') ;
	insert NewTable values (20, 'bbb') ;
	insert NewTbl    values (30, 'ccc')				-- Table name error. (物件解析錯誤!)整包回滾 rollback
	insert NewTable values (40, 'bbb') ;
	select @@trancount
commit tran

select * from NewTable ;	



--	case 3: 自動認可交易(Autocommit transaction) : "預設" 模式  Partial commit, Partial rollback
select * from NewTable 

insert NewTable values (3, 'aaa') ;
insert NewTable values (4, 'bbb') ;
insert NewTable values (2, 'bbb') ;		-- Duplicate key error.
insert NewTable values (5, 'bbb') ;

select * from NewTable 



--	case 3.1 : 外顯交易(Explicit transaction)  all rollback
begin tran
		select @@trancount
		insert NewTable values (30, 'aaa') ;
		insert NewTable values (40, 'bbb') ;
		insert NewTable values (2, 'bbb') ;		-- Duplicate key error.
		insert NewTable values (50, 'bbb') ;
		select @@trancount
commit tran

select * from NewTable 

set xact_abort off

