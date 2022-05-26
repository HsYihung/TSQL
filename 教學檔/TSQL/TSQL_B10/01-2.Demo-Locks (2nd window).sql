--	 Module 10  01-2.Demo - Locks (2nd window) 


-- Step 6 - Open the【2nd window】to the Deadlock database
use  LabDB2 ;
go

-- Use the SPID to identify the connection 
select  @@spid  as  'spid' ;


-- Step 7 - Attempt to update the same product within a transaction
begin tran ;
	update DeadlockProduct 
	set  ProductName = 'Update from window 2'
	where  ProductID = 1 ;
go

-- Step 8 - Back in Activity Monitor【活動監視器】, note the lock information
--               and in particular note the process that is blocked and the other process【源頭封鎖者】
--				 that is shown as being at the head of the blocking chain


-- Step 9 - Switch to the【3rd window】


rollback
go