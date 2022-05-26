--	Module 6   02.Demo - WITH CHECK OPTION.sql
--			強制規定對檢視執行的所有資料修改陳述式必須遵循 select_statement 內所設定的準則。 
--			當利用檢視來修改資料列時，
--			WITH CHECK OPTION 可確保在認可修改之後，仍可以透過檢視見到資料。

use LabDB2;
go

select * into TpEmployees				-- like copy
from Northwind.dbo.Employees

drop view if exists vTpEmployee_Ms ;


--	WITH CHECK OPTION 在檢視表(Views) 的定義中使用 
create view vTpEmployee_Ms
as
select EmployeeID,  TitleOfCourtesy,  FirstName,  LastName, Title
from TpEmployees
where TitleOfCourtesy = 'Ms.'		-- 此 View 限定查看【Ms.】的資料
with check option;						-- 如果沒有 with check option 資料會被寫入 'Mr.'
go


exec sp_helptext 'vTpEmployee_Ms' ;					-- View

select * from vTpEmployee_Ms ;
select * from TpEmployees ;
go


--	加入WITH CHECK OPTION時，當資料 "透過 VIEW" 被修改或新增時會檢查檢視表
--  "建立時的條件設定"，若不符合會發生錯誤拒絕執行

-- Error : Mr.  因為目標檢視指定了 WITH CHECK OPTION 或跨越指定了
-- WITH CHECK OPTION 的檢視產生的一個或多個資料列在 CHECK OPTION 條件約束下並不合格。
insert vTpEmployee_Ms  -- View
	values ( 'Mr.', 'Andy', 'Garcia', 'Movie Star') ;  
go


-- Ms. OK
insert vTpEmployee_Ms  -- View
	values	( 'Ms.', 'Nancy', 'Francis', 'Movie Star')		
select * from vTpEmployee_Ms
select * from TpEmployees

update vTpEmployee_Ms
set Title = 'Programmer'
where FirstName = 'Nancy';
select * from vTpEmployee_Ms
select * from TpEmployees


-- Error : Mr. again因為目標檢視指定了 WITH CHECK OPTION 或跨越指定了
-- WITH CHECK OPTION 的檢視產生的一個或多個資料列在 CHECK OPTION 條件約束下並不合格。
update vTpEmployee_Ms
set TitleOfCourtesy = 'Mr.'			--Mr. is not Ms.
where FirstName = 'Janet'; 



--	WITH Encryption : 在檢視表(Views) 的定義中使用 
drop view if exists vTpEmployee_Ms_encryption ;

create view vTpEmployee_Ms_encryption
with encryption										--	加密後看不到其中的語法
as
select EmployeeID,  TitleOfCourtesy,  FirstName,  LastName, Title
from vTpEmployee_Ms				-- 從 view (table) 中 產生 view
where TitleOfCourtesy = 'Ms.'		-- 此 View 限定查看【Ms.】的資料
with check option;						-- 如果沒有 with check option 資料會被寫入 'Mr.'
go

exec sp_helptext 'vTpEmployee_Ms_encryption' ;	--	加密後看不到其中的語法

select * from vTpEmployee_Ms_encryption ;
go


insert vTpEmployee_Ms_encryption						        -- 加密後仍可增加 insert
	values	( 'Ms.', 'Mary', 'Francis', 'Great Movie Star')		-- Ms. OK
select * from vTpEmployee_Ms_encryption ;	
go


update vTpEmployee_Ms_encryption
set Title = 'Programmer'
where FirstName = 'Nancy';

select * from vTpEmployee_Ms_encryption ;
go

-- Clean up :
drop table if exists TpEmployees
drop view if exists vTpEmployee_Ms ;
drop view if exists vTpEmployee_Ms_encryption ;
