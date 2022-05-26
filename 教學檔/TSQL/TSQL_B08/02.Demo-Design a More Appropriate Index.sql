--	Module 8   02.Demo - Design a more appropriate index.sql


use MarketDev;
go

--  check : Marketing.PostalCode → 索引 

drop index if exists  IX_PostalCode_Perf_A on Marketing.PostalCode
drop index if exists  IX_PostalCode_Perf_B on Marketing.PostalCode

select * from Marketing.PostalCode

--  check : MarketDev  →  table  Marketing.PostalCode  →  索引   →  屬性 (主鍵是由 country & postalCode 組成)

--【顯示估計執行計畫】 & 【包括實際執行計畫】:
select PostalCode, Country
from Marketing.PostalCode 
where StateCode = 'KY'                   -- search on StateCode
order by StateCode, PostalCode;  -- 【顯示估計執行計畫】顯示 : 排序,  叢集索引搜尋 Clustered
go
-- check :【包括實際執行計畫】  【執行計畫】的秒數


-- INDEX IX_PostalCode_Perf_A
create nonclustered index IX_PostalCode_Perf_A
on Marketing.PostalCode (StateCode)              -- check 索引 -> 屬性
include (Country, PostalCode);
go


--【顯示估計執行計畫】 & 【包括實際執行計畫】:
select PostalCode, Country
from Marketing.PostalCode 
where StateCode = 'KY'        -- 【顯示估計執行計畫】顯示 : 排序,  索引搜尋 NonClustered, StateCode 不是索引
order by StateCode, PostalCode;
go
-- check :【包括實際執行計畫】 【執行計畫】的秒數


--INDEX IX_PostalCode_Perf_B
create nonclustered index IX_PostalCode_Perf_B
on Marketing.PostalCode (StateCode, PostalCode)
include (Country);
go


--【顯示估計執行計畫】 & 【包括實際執行計畫】:
select PostalCode, Country
from Marketing.PostalCode 
where StateCode = 'KY'  -- 【顯示估計執行計畫】顯示 : [沒有排序],  索引搜尋 NonClustered
order by StateCode, PostalCode;
go
-- check :【包括實際執行計畫】  【執行計畫】的秒數