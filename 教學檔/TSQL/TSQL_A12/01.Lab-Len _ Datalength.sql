 --	Module 12 系統內建函數字串函數介紹
--		12-1 : LEN() 與DATALENGTH() 
--		12-2 : 使用SUBSTRING()、LEFT()、RIGHT()傳回部份字元、文字的運算式
--		12-3 : 使用STR()將數值資料轉換成字元資料 

--	LEN 函數是用來計算運算式長度的函數，運算式可以是字串、數字或資料行。
--	LEN 函數會自動忽略 "字尾" 的空格。
--	中文字儲存時使用 2 位元，不過 LEN 計算時只會算 1。
--	若要傳回運算式的位元組數目，要使用 DATALENGTH 函數。


-- Lab01 LEN()與DATALENGTH()

-- 傳回指定字串運算式的字元數，但尾端空格不算。
select len('TESTSTRING');
select len(1234567890);

--	中文字儲存時使用2位元，不過LEN計算時只會算1
select len('中文字串123');

--	LEN 會排除字串尾端的空格
select len('   中文字串123   ');

--	DATALENGTH 會計算運算式的"位元長度"。
--	DATALENGTH 會計算字串尾部空格。
--	中文字占 2 位元，所以使用 DATALENGTH 計算時會是2。
--	使用 LEN 字串運算式的字元數目，使用 DATALENGTH 則傳回所給定字串運算式的大小 (以位元組為單位)。

select Len('abc'), Len('a b c'), Len('a b c ')
select DataLength('abc'), DataLength('a b c'), DataLength('a b c ')   -- 會計算字串尾部空格

select Len('apple蘋果')
select Len(N'apple蘋果')

select datalength('apple蘋果')
select datalength(N'apple蘋果')

--	針對 NULL 值，LEN 及 DATALENGTH 都會傳回 NULL
select len(null);
select DataLength (null);

--	使用 DATALENGTH 則傳回所給定字串運算式的大小 (以位元組為單位)。
select DataLength('Hello!');
select DataLength(N'Hello!');

--	下列的範例會示範 LEN 和 DATALENGTH 二種函數，對於有尾端空白的回傳值，
--	以及欄位類型為 Unicode 時回傳值的差異。

declare @val1 varchar(40),  @val2 nvarchar(40);  
set @val1 = 'Test of 22 characters ';						--  varchar(40)
set @val2 = 'Test of 22 characters ';						--	nvarchar(40)
select len(@val1) as varchar_Len ,  DataLength(@val1) as varchar_DataLength;  
select len(@val2) as nvarchar_Len,  DataLength(@val2) as nvarchar_DataLength;  