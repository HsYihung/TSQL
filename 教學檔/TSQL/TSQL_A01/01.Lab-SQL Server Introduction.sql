 --	Module 01 關聯式資料庫的基本概念與 SQL Server 簡介
--		1-1 : 關聯模型與關聯運算子(operators)
--		1-2 : SQL 指令的分類-DDL、DML、DCL 
--		1-3 : SQL Server 開發工具簡介


--  安裝 SQL Server 2017dev and SMSS 參考影片
--  https://www.youtube.com/watch?v=F6YDfgIJoBA
--  https://www.796t.com/article.php?id=14457

--  下載, 安裝 SQL Server
--	SQL server 下載 : 開發人員 → SQL開發人員工具  → 下載 2017 dev edition
--  https://www.microsoft.com/zh-tw/sql-server/developer-tools


-- SSMS 下載 (SQL server 安裝結束時也可連結到 SMSS 安裝)
--  https://docs.microsoft.com/zh-tw/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15

--  查詢 SQL Server 的產品版本、版本編號
select right (left(@@version, 25), 4) N'產品版本編號' , 
serverProperty ('ProductVersion') N'版本編號',
serverProperty ('ProductLevel') N'版本層級',
serverProperty ('Edition') N'執行個體產品版本',
databasePropertyEx ('master', 'Version') N'資料庫的內部版本號碼',
@@version N'相關的版本編號、處理器架構、建置日期和作業系統'

--	附加三資料庫 : Northwind, AdvantureWorks, MarketDev

--  在 C:槽下建一  C: \Temp\

--  Most Popular Databases In The World
--		https://www.c-sharpcorner.com/article/what-is-the-most-popular-database-in-the-world/

--	Structure Quary Language (SQL)
--		https://zh.wikipedia.org/zh-tw/SQL

--	Transact-SQL（又稱T-SQL）
--		https://zh.wikipedia.org/zh-tw/Transact-SQL

--- SQL Server 2017/2019
--		p 6-1	SQL 結構化查詢語言
--		p 6-5	SQL語言的指令種類
--		p 2-6	關聯式資料庫模型 Excel file,  (p2-8)
--		p 2-15	關聯式代數 (p2-16)
--		p 4-5	工具 (Tools)
--		p 1-2	資料庫系統的基礎	(p1-3, p1-28) 
--		p 4-17	SQL Server 管理工具的使用

--  2017/2019 SQL Server書 下載網址 :  http://books.gotop.com.tw/download/AED003900


--  介紹 SQL Server Management Studio (SSMS)
--	環境設定：
--		工具 → 選項 → 環境 → 字型和色彩 → 字型,  大小
--		工具 → 選項 → 文字編輯器 → (click) Transact-SQL → 行號
--		檢視 → 物件總管 / 方案總管


--  參考 : (p 4-28)
-- 物件總管 → 資料庫 →系統資料庫 :
--			master		資料庫	記錄 SQL Server 執行個體的所有系統層級資訊。
--							DataBase 觀察  master → 檢視view → 系統檢視表 → sys.databases (滑鼠右鍵)
--							→ 1000 個資料列

--			model		資料庫	用來當作 SQL Server 執行個體上建立之所有資料庫的範本。 
--							對 model 資料庫進行的修改 (例如，資料庫大小、定序、復原模式和其他資料庫選項) 
--							會套用到之後建立的任何資料庫。
--			msdb		資料庫	由 SQL Server Agent 用於排程警示和作業。
--			tempdb	資料庫	是保存暫存物件或中繼結果集的工作空間。


--	伺服器名稱			●	資料庫名稱	●  結構描述名稱	● 資料表名稱  (p 6-4)
--	.\STUDENT-PC	●	LabDB	    	●	[dbo]Schema	●	student

--		1.  伺服器名稱 Server		: [.\STUDENT-PC] , 非本機 用 IP(192 . 168 . xx . xxx)]
--		2.  資料庫名稱 DbName	: [LabDB]
--					手動建置資料庫 : LabDB
--					物件總管 → 資料庫(滑鼠右鍵) → 新增資料庫 → LabDB (觀察, 資料庫成長, 屬性...)
--		3.  結構描述     Schema	: [dbo]  -- 預設 dbo : DataBase Owner (p 1-14)
--					Schemas 介紹 - LabDB → 安全性→ 結構描述
--					手動建置 schemas  安全性 → 結構描述(滑鼠右鍵) → 結構描述
--		4.  資料表名稱 Table		:  student
--					手動建置  LabDB →  資料表 (滑鼠右鍵) → 新增 → 資料表  
--							練習建置student 資料表
--									student_id :			varchar(10)
--									studentName :		nvarchar(20)
--									birthday :				date
--									height :					tinyint

--		Table 觀察  LabDB → view →系統檢視表 → sys.tables

--	手動建置資料庫
--		資料庫dbname  : LabDB (p 6-7, p 6-15) 屬性觀察
--			LabDB(滑鼠右鍵) → 屬性
--		一般選項 : Chinese_Taiwan_Stroke_CI_AS (p 6-20) 台灣地區的繁體中文
--			https://docs.microsoft.com/zh-tw/sql/t-sql/statements/windows-collation-name-transact-sql?view=sql-server-ver15

--				Stroke		:表示按筆畫順序排列
--				Bopomofo: 表示按注音順序排列
--				CI				:表示Case Insensitive(不區分大小寫)
--				CS			:表示Case Sensitive(區分大小寫)
--				AS			:表示Accent Sensitive(區分重音節)
--				AI				:表示Accent Insensitive(不區分重音節)
--				90或100	:表示較新的版本

--			檔案群組 : mdf, ndf, ldf
--			https://docs.microsoft.com/zh-tw/sql/relational-databases/databases/database-files-and-filegroups?view=sql-server-ver15


--  附加上課用資料庫
--			先解除 TSQL_DB 資料權限 Northwind, AdventureWorks, MarketDev
--			資料庫(滑鼠右鍵) → 附加 → 加入 → TSQL_DB資料夾下選取



use LabDB
select * from student    --- dbo.student

--		set Primary Key PK
--				dbo.student(滑鼠右鍵) → 設計 → student_id(滑鼠右鍵)  
--		set Foreign Key FK 
--				Northwind → dbo.Orders → 設計 → OrderID(滑鼠右鍵) → 關聯性


-- 補充資料：DDL, DML, DQL, DCL (p 6-5)
-- https://social.technet.microsoft.com/wiki/contents/articles/34477.sql-server-commands-dml-ddl-dcl-tcl.aspx
--		SQL語言共分四個類別的指令：
--			DDL (Data Definition Language) 資料定義語言
--				用作開新資料表、設定欄位、刪除資料表、刪除欄位，管理所有有關資料庫結構的東西，
--				常見的指令有
--				● Create	：建立資料庫的物件。
--				● Alter		：變更資料庫的物件。
--				● Drop		：刪除資料庫的物件。

--			DML (Data Manipulation Language) 資料操作語言
--				用作新增一筆資料，刪除、更新等工作，常見的指令有
--				● Insert	：新增資料到 Table 中。
--				● Update	：更改 Table 中的資料。
--				● Delete	：刪除 Table 中的資料。

--			DQL (Data Query Language) 資料查詢語言
--				只能取回查詢結果，指令只有1個
--				● Select	：選取資料庫中的資料。

--			DCL (Data Control Language) 資料控制語言
--				用作處理資料庫權限及安全設定，常見的指令有
--				● Grant	：賦予使用者使用物件的權限。
--				● Revoke	：取消使用者使用物件的權限。
--				● Commit	：Transaction 正常作業完成。
--				● Rollback：Transaction 作業異常，異動的資料回復到 Transaction 開始的狀態


-- 補充資料：使用 SQL Server Management Studio (SSMS) 連線至 SQL Server 執行個體並進行查詢
-- https://docs.microsoft.com/zh-tw/sql/ssms/tutorials/connect-query-sql-server?view=sql-server-ver15


--	修改 student 結構
--		工具 → 選項 → 設計師 → 取消   防止儲存........


--	Steve 老師的提問社團 iCoding : https://www.facebook.com/groups/icoding
--  email : jungan0914@gmail.com
