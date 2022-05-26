--	Module 14 預存程序(Stored Procedure)的進階觀念、設計與實作
--		14-1 : 如何建立實作帶有參數的預存程序    
--		14-2 : 如何執行帶有參數的預存程序    
--		14-3 : 如何從預存程序將資料傳回給應用程式

--		Procedure 有三個參數 :
--			Input parameters (arguments)
--			Output parameters (arguments)
--			Return code

use LabDB2
-- drop table if exists Book

---- Step 2: Create a table:  dbo.Book

/* create table Book(
ISBN  nvarchar(20)  primary key ,
Title  nvarchar(50)  not null ,
ReleaseDate  date  not null ,
PublisherID  int  not null
) ;*/

select * from Book

-- Proc_C Encryption 傳參數進入 proc
drop proc if exists Proc_C

create proc Proc_C
	@ISBN nvarchar(20), @title nvarchar(50), @ReleaseDate date, @Publisher int
with Encryption									--	Encryption
as
insert Book values (@ISBN, @title, @ReleaseDate, @Publisher)

exec Proc_C '6', 'Tommy story', '2000-1-1', '45'
select * from Book



-- Proc_D 傳參數出來 proc
drop proc if exists Proc_D

create proc Proc_D  @total int output					--  定義 total 是 output,  未傳入任何參數
as
select @total =sum(UnitPrice) from Northwind.dbo.[Order Details]


declare @sum int		
exec Proc_D @sum output									-- @sum 接傳回的 @total int output
print 'total price : ' + cast(@sum as varchar)

exec sp_helptext 'Proc_C'		--  Encryption
exec sp_helptext 'Proc_D'		--  non Encryption

select * from sys.sql_modules where object_id =object_id ('Proc_C')
select * from sys.sql_modules where object_id =object_id ('Proc_D')



--  例二

--	01.Lab - Stored Procedure with parameters.sql

-- Step 1: Open a new query window to the AdventureWorks database
use  LabDB2 


-- Step 2: Drop stored procedure if it already exists
drop proc if exists GetReviews ;


-- Step 3: Create procedure to output number of reviews and check product exists
--  create proc 程序名稱  @傳入參數, @傳出參數 output
 create proc GetReviews 	@ProductID int = 0, @NumberOfReviews int output	   -- default values
 as
 if (@ProductID) = 0								--	傳入預設值 0 值 或 使用  0
	 select p.Name, pr.ReviewDate, pr.ReviewerName, pr.Rating, pr.Comments, p.ProductID
	 from AdventureWorks.Production.ProductReview as pr
	 join AdventureWorks.Production.Product as p
	 on p.ProductID = pr.ProductID
	 order by p.Name, pr.ReviewDate desc
else
	if exists (select 1 from AdventureWorks.Production.Product where ProductID = @ProductID )
		 select p.Name, pr.ReviewDate, pr.ReviewerName, pr.Rating, pr.Comments, p.ProductID
		 from AdventureWorks.Production.ProductReview as pr
		 join AdventureWorks.Production.Product as p
		 on p.ProductID = pr.ProductID
		 where pr.ProductID = @ProductID					--	只 join @ProductID
		 order by p.Name, pr.ReviewDate desc
	else
		return -1
set @NumberOfReviews = @@rowcount 
return 0


-- Test 1-1: Test output and return values (positional arguments)
declare		@NumReviews int,	@ReturnValue int
exec			@ReturnValue = GetReviews 600,	@NumReviews output  --用ReturnValue 接住 reture 0 or -1 值
if (@ReturnValue =0)			--		ReturnValue as an index 0
	select @NumReviews as NumberOfReviews
else
	select 'ProductID does not exist' as ErrorMessage



-- Test 1-2: Test output and return values (keyword arguments)
declare		@NumReviews int,  @ReturnValue int
exec			@ReturnValue = GetReviews  @NumberOfReviews=@NumReviews output,  @ProductID = 937  
if (@ReturnValue =0)
	select @NumReviews as NumberOfReviews
else
	select 'ProductID does not exist' as ErrorMessage



-- Test 2: Test output and return values(@ProductID = 937 → 600)
declare		@NumReviews int,	@ReturnValue int
exec			@ReturnValue = GetReviews 600,  @NumReviews output  
if (@ReturnValue =0)
	select @NumReviews as NumberOfReviews
else
	select 'ProductID does not exist' as ErrorMessage



-- Test 3: Test output and return values (Remove OUTPUT )(positional arguments)
declare		@NumReviews int,  @ReturnValue int
exec			@ReturnValue = GetReviews 937,	@NumReviews		-- remove 'output' 無法回傳@NumReviews
if (@ReturnValue =0)
	select @NumReviews as NumberOfReviews
else
	select 'ProductID does not exist' as ErrorMessage



-- Test 4: Test output and return values(@ProductID = 937 → Default (ProductID=0) )
declare		@NumReviews int,  @ReturnValue int
exec			@ReturnValue = GetReviews default,	 @NumReviews output					
if (@ReturnValue =0)
	select @NumReviews as NumberOfReviews
else
	select 'ProductID does not exist' as ErrorMessage



-- Test 4-1 : remove @ProdcutID in order to use default,  keyword on @NumberOfReviews
declare		@NumReviews int,  @ReturnValue int
exec			@ReturnValue = GetReviews							 -- remove default, same as defualt
				@NumberOfReviews=@NumReviews output  -- key argument 必須使用, 不然位置會傳錯
if (@ReturnValue =0)
	select @NumReviews as NumberOfReviews
else
	select 'ProductID does not exist' as ErrorMessage



select * from AdventureWorks.Production.ProductReview
select * from AdventureWorks.Production.Product

-- Step 5: Drop the procedure
drop proc  if exists GetReviews ; 
go

