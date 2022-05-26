--	Module 11 系統內建函數數學、日期與時間等函數介紹
--		11-1 : 數學函數 
--		11-2 : 日期與時間函數 
--		11-3 : 如何取得SQL Server主機上的日期和時間 

--	函數會執行計算，通常是以輸入值為基礎，並傳回數值。
--	SQL 內建的數學函數 : 
--		三角函數類 :			SIN，COS，TAN，COT，ASIN，ACOS，ATAN
--		弧度相關處理 :		DEGRESS，RADIANS，ATN2反正切
--		近似值 :				ROUND，FLOOR，CEILING
--		次方 :					SQUARE，POWER，SQRT
--		數學符號 :			PI，EXP，LOG，LOG10
--		正負號 :				ABS，SIGN
--		隨機數 :				RAND

-- Lab01 數學函數

-- 三角函數
select sin(pi()), cos(pi()), tan(pi()/4), asin(1);  


-- ABS 取絕對(正)值
select abs(-1.0), abs(0.0), abs(1.0);  


-- Error : int 資料型別值的範圍在 -2,147,483,648 到 2,147,483,647
declare @i int;  
set @i = -2147483648;    -- error
select  abs(@i);                  
go


-- 傳回大於等於最小整數值,俗稱天花板函數，盡量往大的取整
select  ceiling ($123.45),  ceiling($-123.45),  ceiling($0.0);		-- with $ sign
select  ceiling(123.45),  ceiling(-123.45),  ceiling(0.0);			-- without $ sign

-- 傳回小於等於最大整數值,俗稱地板函數，盡量往小的取整
select  floor($123.45), floor($-123.45), floor($123.45); 
select  floor(123.45), floor(-123.45), floor(123.45); 

-- 傳回介於 0 到 1 (不含) 之間的似隨機 float
-- 不指定種子值，RAND函數將隨機產生結果。
select  rand(100), rand(15), rand(), rand()  ;
go 5

select rand(100), rand(), rand(), rand()
go 10

select rand()

--	如何產生  0 ~ 10 之間的亂數 ??


--	如何產生10 ~ 15 之間的亂數 ??


--	如何產生 -1 ~ 1 之間的亂數 ??



-- 指定小數點後幾位並四捨五入
select  round(123.9194, 2), round(123.9995, 3), round(123.456789, -2)    -- -2

-- 傳回指定運算式的正 (+1)、零 (0) 或負 (-1) 號。
select  sign(-125), sign(0), sign(564);   

-- 傳回2的10次方=1024
select power(2.0, 10), power(2.5, 5),  round(power(2.5, 0.5), 5);  

declare @input1 float;  
declare @input2 float;  
set @input1= 2.;  
set @input2 = 2.5;  
select power(@input1, 3), power(@input2, .5) ;

select   
power(cast (2 as float), -100.0) as FloatResult,  
power(2, -100.0) as IntegerResult,  
power(cast (2.0 as int), -100.0) as IntegerResult,  
power(2.0, -100.0) as Decimal1Result,  
power(2.0000000, -100.0) as Decimal2Result,  
power(cast (2.0 as decimal (5,2)), -100.0) as Decimal2Result;  
go

-- 返回指定浮點數的平方
select square(5.0)

-- 返回指定浮點數的平方根
select sqrt(25)

-- 傳回圓周率 PI 的常數值
select pi(), pi()*5; 


select * from Northwind.dbo.orders
select Freight, sin(Freight) from Northwind.dbo.orders

