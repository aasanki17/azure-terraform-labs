IF OBJECT_ID('dbo.Inventory', 'U') IS NOT NULL
BEGIN
   DROP TABLE dbo.Inventory;
END;
GO

CREATE TABLE dbo.Inventory
(
   ProductID int,
   ProductName varchar(1000),
   Quantity int
);
GO

INSERT INTO dbo.Inventory
   (ProductID, ProductName, Quantity)
VALUES
   (1, 'Mobile', 100),
   (2, 'Laptop', 200),
   (3, 'Headphones', 300);
GO