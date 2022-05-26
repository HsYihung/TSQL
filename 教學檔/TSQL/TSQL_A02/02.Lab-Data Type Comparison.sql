--	Module 2 - Lab02	比較三種數值資料類型的誤差值 / 日期類型資料轉換

--	用二進位方法存: float，real
--			用二進位存十進位小數時由於無法精確的轉換，所以存進去的值都會是近似值
--			由於使用二進位方法存所以可以存比較長的資料比較不會占空間
--			float 和 real 用來搭配浮點數值資料使用的近似數值資料類型。
--			float 和 real 都是不精確的數值類型，轉換時都會有誤差。

--	用十進位方法存: decimal
--			用十進位方法存必須記錄小數點右邊的位數有幾位，會比較精準
--			相比二進位儲存，位數較少(總位數小於等於38位)需要占較大空間

--	real：可儲存七位有效數
--	float：可儲存十五位有效數
--	decimal：可儲存三十七位數（包含小數點前面跟後面）ex：decimal(10,2)代表小數點前8位數，
--			小數點後2位數雖然decimal所占用的空間比較大，但為了保存數值的正確性上，
--			還是比使用real、float來的好大部分時候其實都用decimal紀錄資料就足夠了


use LabDB;
go


-- 建立一測試資料表,並以10000筆資料來加總
-- 比較三種資料類型的誤差值
create table Test (
	n1 real,
	n2 float,
	n3 decimal(14, 8)
);
go


declare @CNT int;
set @CNT=0;
while (@CNT<10000)
begin
	insert into Test VALUES(0.1, 0.1, 0.1)
	set @CNT=@CNT+1
end
select n1, n2, n3 from Test;
go

select sum(n1) as [real] , sum(n2) as [float], sum(n3) as [decimal] from Test;		-- 近似值
go
-- 可以看出Real跟Float分別都產生了誤差，Float因為有效位數較長所以誤差比較小

drop table if exists Test

--  data type : image (p7-7) 
--	check Northwind Emloyees column : Photo