--	 Module 10  01-3.Demo - Locks (3rd window).sql

-- Step 10 - Open the【3rd window】to the Deadlock database
use  LabDB2 ;
go

-- Step 11 - Query the system views to see the current locking
select  resource_type ,  request_mode ,  request_type ,  request_status ,  request_session_id
from  sys.dm_tran_locks ;  --LockList
go
--  獨佔式鎖定(Exclusive Lock)(X)
--  IntentExclusive(IX) : 表示欲進行"獨佔式鎖定" 並更改指定物件中的 "部分資源"

-- Step 12 - Make sure to locate the relevant info and explain it briefly


-- Step 13 - Cancel the query in the【2nd window】or go 【1nd window】step 15 rollback
-- 【2nd window】rollback and 【1nd window】step 15 rollback

-- Step 14 - Then return to the【1st window】
