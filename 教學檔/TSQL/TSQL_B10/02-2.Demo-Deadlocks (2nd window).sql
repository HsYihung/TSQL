--	 Module 10  02-2.Demo - Deadlocks (2nd window).sql

use  LabDB2 ;
go
select  @@spid  AS  'spid' ;
begin tran
	  update DeadlockProduct set ProductName = 'Prod 1 Modified 2'
	  where ProductID = 1 ;

	  waitfor delay '00:00:08' ;

	  update DeadlockProduct set ProductName = 'Prod 2 Modified 2'
	  where ProductID = 2 ;
commit ;

select * from DeadlockProduct

