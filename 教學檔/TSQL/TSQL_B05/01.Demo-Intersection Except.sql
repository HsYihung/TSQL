--	Module 5	集合運算子的使用
--		5-1: 使用UNION(聯集)、UNION ALL 運算子撰寫查詢
--		5-2: 使用INTERSECT(交集) 運算子撰寫查詢
--		5-3: 使用EXCEPT(差集) 運算子撰寫查詢

--		在資料庫執行多個資料表查詢時，除了使用 Join 的合併查詢外，
--		也可以使用集合運算 : 聯集 Union、交集 Intersect、差集 Except 來執行兩個資料表的合併。
--		當兩集合之間要進行比較運算時, 必須具備 :
--				欄位個數, 欄位順序, 欄位定序方式要相同, 欄位的資料型態要相容

--	reference : 
--  https://docs.microsoft.com/zh-tw/sql/t-sql/language-elements/set-operators-union-transact-sql?view=sql-server-ver15

--	01.Demo - Using Set Operators.sql

use LabDB2 ;
go

drop table  if exists table1
drop table  if exists table2

create table table1(column1 int, column2 int);
go

create table table2(column1 int, column2 int);
go

insert table1 values ( 1, 1), (2, 2), (2, 2), (3, 3), (5, 2), (3, 5)
insert table2 values ( 1, 1), (2, 2), (5, 5)
go

select * from table1
select * from table2


--  【交集 INTERSECT】 : 將兩個資料表相同的紀錄取出來，且有重複的資料只會顯示其中一筆。
--		Using the 【INTERSECT】 Operators  的例子

select column1 from  table1 
intersect										--取交集-- it different with inner join (where)
select column1 from table2 ; 
go

select * from  table1 
intersect										--取交集-- it different with inner join (where)
select * from table2 ; 
go



--	差集 【EXCEPT】: 只取出第一個select指令但是不存在第二個select指令的紀錄。
--		Using the 【EXCEPT】 Operators   的例子

select * from table1
select * from table2

select * from  table1 
except											--取 table1 差集 table 1 - table 2
select * from table2 ; 
go


select * from table1
select * from table2

select * from  table2 
except											--取 table2 差集 table 2 - table 1
select * from table1 ; 
go



--  聯集【UNION】 : 將2個資料表的紀錄 "垂直" 結合再一起，有重複的資料只會顯示其中一筆，
--	Using the 【UNION】 Operators  的例子 

select * from table1
select * from table2

select * from table1 
union											 
select * from table2 ;
go



--	【UNION ALL】 : Union all 與 Union的差異在於，Union 會將重複的自動踢掉，
--	  而 Union all將會保留重複的。
--	Using the 【UNION ALL】 Operators  的例子

select * from table1
select * from table2

select * from table1 
union all										--	including duplicates
select * from table2 ;
go



--	UNION  vs.  JOIN
--		UNION 與 JOIN 不同的地方在於，JOIN 是作橫向結合 (合併多個資料表的各欄位)；
--				而 UNION 則是作垂直結合 (合併多個資料表中的紀錄)。

--		UNION 會串連來自兩個查詢的結果集。但 UNION 不會從收集自兩個資料表的資料行建立個別的"資料列"。
--		JOIN 會比較來自兩個資料表的資料行，以建立由來自兩個資料表的資料行所組成的結果資料列。

select 23 as bah
union
select 45 as bah;

select * from 
(select 23 as bah) as foo 
join
(select 45 as bah) as bar
on (33=33);