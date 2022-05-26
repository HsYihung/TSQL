-- 請練習撰寫底下指令，使用 Northwind 資料庫


-- Step1 確定打開的是 Northwind 資料庫 
use Northwind

-- Step2 列出 Products 產品資料表中欄位 ProductID, ProductName, SupplierID
select ProductID, ProductName, SupplierID from Products


-- Step3 承上題
--     請帶出該產品的供應商名稱(CompanyName)、聯絡電話(Phone)、聯絡人(ContactName)
--     相同供應商的資料請列在一起
select ProductID, ProductName, p.SupplierID, s.CompanyName, s.Phone, s.ContactName 
from Products as p
join Suppliers as s on p.SupplierID = s.SupplierID
order by SupplierID


-- Step4 承上題，請加入條件："庫存量低於再訂購量" 的產品資料
select ProductID, ProductName, p.SupplierID, 
		s.CompanyName, s.Phone, s.ContactName ,
		p.UnitsInStock, p.UnitsOnOrder
from Products as p
join Suppliers as s on p.SupplierID = s.SupplierID
where p.UnitsInStock < p.UnitsOnOrder


-- Step5 訂單的價格是否與產品的單價是否一致？
select * from Products
select * from [Order Details]

select * 
from Products as p
join [Order Details] as o on p.ProductID = o.ProductID
where p.UnitPrice != o.UnitPrice


-- Step6. 那張訂單賺最多錢(離product.UnitPrice 折扣最小的)？
select p.ProductID, p.ProductName, o.UnitPrice, p.UnitPrice, (o.UnitPrice- p.UnitPrice)/p.UnitPrice
from Products as p
join [Order Details] as o on p.ProductID = o.ProductID
order by (o.UnitPrice - p.UnitPrice)/p.UnitPrice desc


-- Step7. 找出訂單編號為10274所購買的產品清單，請找出產品名稱、產品價格
select * from Orders
select * from [Order Details]
select * from Products

select o.OrderID, p.ProductName, p.UnitPrice from Orders as o
join [Order Details] as od on o.OrderID = od.OrderID 
join Products as p on od.ProductID = p.ProductID
where o.OrderID = '10274'

