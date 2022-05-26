--	Module 10  03-1.Demo - Isolation Level (1st window).sql

--	交易隔離等級(Transaction Isolation Level) 的設定
--			隔離性(Isolation) : 表示在各交易的過程中所會用到的資料，必須各交易間資料獨立各自交易，
--			才不會造成各資料間互相影響，資料錯亂，可透過交易鎖定的方式來達成，
--			隔離性越高其並行性(多交易同時處理)就越低，為取得其交易	運作平衡與效率，可透過設定隔離的等級來完成

--	交易隔離等級 :	用來設定交易讀取資料的隔離狀態，依隔離性的高低可區分為5個等級
--		1.ReadUncommitted :			(Isolation Level 0)
--				完全無隔離，讀取的資料隨時有被更動(更新或刪除)的機會，	也"可能讀取到尚未全部更新的資料"

--		2.ReadCommitted(預設) :	(Isolation Level 1)
--				不允許讀取尚未Commit的資料，因此不會讀取到尚未全部更新的資料，資料被更新的機會也較低

--		3.RepeatableRead :			(Isolation Level 2)
--				交易時所讀取的資料不允許被更動(更新或刪除)，確保每次交易中所取得相同資料內容，
--				但交易進行 "重複讀取資料" 時，可能會因其他交易進行新增資料產生資料增加的情形

--		4.Snapshot :						(Isolation Level 3)
--				快照資料庫(Database Snapshots)可以提供資料庫特定時間點的靜態檢視，
--				它是唯讀的資料庫，經常被使用在報表用途，由於資料靜止在指定的時間點，
--				可以有效避免新交易造成報表間的數字差異。資料庫快照(Snapshot)
--				是一個可以將資料庫快速的產生一個資料庫的 "複本" 的一種技術，
--				而從SQL Server 2005開始

--		5.Serializable :						(Isolation Level 4)
--				需要進行的交易必須排隊，將所用到的資料全部進行鎖定，不允許其他的交易進行
--				新增、修改或刪除的動作，等目前的交易完成後其他交易才能進行


use  AdventureWorks ;

-- Use the SPID to identify the connection 傳回目前使用者處理序的工作階段識別碼。

select @@spid as 'id', system_user as 'login name', user as 'user name';
--	select * from sys.schemas


dbcc useroptions ;					-- isolation level: Read Committed (預設)

set tran isolation level serializable

dbcc useroptions ; -- isolation level: Serializable (Level 4)
--	SERIALIZABLE: Prevent other users from accessing rows  that match the criteria in a WHERE clause.

--  Step 1
begin tran
	select * from Person.Person 
	where  BusinessEntityID = 6 ;
	 

--  Step 2 Open 【2nd window】
--	for the purpose of the exercise, 
--  commit transaction or rollback transaction are not used 


--	Step 5 run rollacb tran觀察 windows2 是否解除可 update
rollback tran;

-- Step 6 回復 read committed
set tran isolation level read committed

dbcc useroptions ; -- isolation level: Read Committed