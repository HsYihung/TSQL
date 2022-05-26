--	Module 9   01.Demo-1 - TranCount.sql

--	@@TRANCOUNT 的值與COMMIT、ROLLBACK 的關係
--	@@TRANCOUNT : 取得目前連線執行 BEGIN TRAN 敘述的交易個數，
--			當執行 COMMIT TRAN 會遞減1，當執行 ROLLBACK TRAN 會歸 0

use  LabDB2 ;

--	START TRANSACTION HERE
select @@trancount  as  Tran_Count ;							--    0

begin tran																		--	1st
		select @@trancount  as  Tran_Count ;
		begin tran																--	2nd
				select  @@trancount  as  Tran_Count ;
				begin tran														--	3rd
						select @@trancount  as  Tran_Count ;
----------------------------------------------------------------------------------
				commit tran ;													--	2nd
				select @@trancount  as  Tran_Count ;
		commit tran ;															--  1st		
		select @@trancount  as  Tran_Count ;
commit tran ;																	--    0
select @@trancount  as  Tran_Count ;
----------------------------------------------------------------------------------
rollback tran ;													            	--	rollback transaction  all become 0
select @@trancount  as  Tran_Count ;