--	Module 01 : 02.Lab - DROP DATABASE.sql

-- 1-2 : 如何卸離與附加資料庫
use master
go

--  可以將資料庫的資料和交易記錄檔卸離，然後再重新附加至相同或不同的 SQL Server執行個體。
--  若要將資料庫變更至同一台電腦上的不同 SQL Server 執行個體，或要移動資料庫，
--  卸離和附加資料庫相當有用。

--	"卸離" 資料庫 (xxxxx 資料庫 (右鍵) → 工作 → 卸離),  
--  "附加"資料庫 (資料庫 → 附加 → 加入 → ......) 

-- "卸離" 資料庫
-- skipchecks 設為 true 的資料庫卸離, 指定是否略過或執行更新統計資料。
exec sp_detach_db 'Class', 'true'			-- sp : Stored Procedure,      sys.databases


--  透過附加可將目前未使用呈現卸離狀態的資料庫加入，如果不需要時可將其卸離，
--	避免消耗系統資源，提升管理效率，(若該資料庫 "使用中" 會無法卸離，例如:查詢視窗使用中)


--  "附加"資料庫
exec sp_attach_db @dbname = 'Class',
@filename1 = 'c:\Temp\Class.mdf',
@filename2 = 'c:\Temp\Class_ndf.ndf'


--	Drop the  TestDB  Database if it already exists 
if db_id('class') is not null
begin
	drop database Class;
end


drop database if exists Class		-- 資料庫也可以這樣 drop

--  檢視 C:\Temp,  Class.mdf, ndf, ldf 消失了


--	2017/ 2019 SQL Server  (p19-23)

--  1-3 : 如何匯入與匯出資料

--	資料庫匯出
--		資料庫LabDB2(右鍵) → 工作 → 匯出資料
--		資料來源 : SQL server Native Client 11.0
--		目的地 : Microsoft Excel / csv Flat File Source → 路徑 → 檔名


--	資料庫匯入
--		資料庫LabDB2(右鍵) → 工作 → 匯入資料 (P19-12)
--		資料來源 : Microsoft Excel / csv Flat File Source → 檔案路徑
--		目的地 : SQL server Native Client 11.0
--		目的地 : [dbo].[xxxx打入table 名稱] table 名稱
--		目的地建新的名字(不可用以存在的檔名, 因為不是 append)


--	資料庫附加
--		資料庫 → 附加 → 加入

--  資料庫備份
--		資料庫LabDB(右鍵) → 工作 →備份
