CREATE DATABASE Manufacturer;
--Use Manufacturer;

CREATE TABLE Products
(
	[ProductID] [int] CONSTRAINT pk_productID PRIMARY KEY identity(1,1) NOT NULL,
	[ProductName] [nvarchar](20) NULL,
	[ProductQuantity][int] NULL
);

CREATE TABLE MeasurementTypes
(
	[MeasurementID] [int] PRIMARY KEY identity(1,1)  NOT NULL,
	[MeasurementType] [char] (10) NOT NULL,
);

CREATE TABLE Components
(
	[ComponentID] [int] PRIMARY KEY identity(1,1) NOT NULL,
	[ComponentName] [nvarchar](20) NULL,
	[Description][text] NULL,
	[SupplyOrderQuantity][decimal](10,2) NULL,
	[SupplierID] [int] NOT NULL,
	[SupplyDate] [datetime],
	--[ProductID] [int] NOT NULL,
	--[MeasurementID] [int] NOT NULL,
	[MeasurementID] [int] NOT NULL CONSTRAINT fk_measurementID FOREIGN KEY References MeasurementTypes ([MeasurementID]),
	[ProductID] [int] NOT NULL CONSTRAINT fk_ProductID FOREIGN KEY References Products ([ProductID])
	--FOREIGN KEY ([MeasurementID]) REFERENCES MeasurementTypes([MeasurementID]),
	--FOREIGN KEY ([ProductID]) REFERENCES Products
);
--

CREATE TABLE ComponentStock
(
	[ComponentStockID] [int] PRIMARY KEY identity(1,1) NOT NULL,
	[ComponentName] [nvarchar](50) NULL,
	[ComponentStockQuantity] [decimal](10,2) NULL,
	--[QuantityID] [int] NOT NULL,
	--[ProductID] [int] NOT NULL,
	[MeasurementID] [int] NOT NULL CONSTRAINT fk_measurement2ID FOREIGN KEY References MeasurementTypes ([MeasurementID]),
	[ProductID] [int] NOT NULL CONSTRAINT fk_supplierID FOREIGN KEY References Products ([ProductID])
	--FOREIGN KEY ([QuantityID]) REFERENCES QuantityTypes,
	--FOREIGN KEY ([ProductID]) REFERENCES Products
);

CREATE TABLE Supplier
(
	[SupplierID] [int] PRIMARY KEY identity(1,1) NOT NULL,
	[SupplierName] [nvarchar](50) NULL,
	[ActivationStatus] [bit] NOT NULL,
	[Adress] [nvarchar](50) NULL,
	[Phone] [int] NULL,
	[Referans] [text] NULL
);


CREATE TABLE SupplierComponents
(
	[SupplierComponentID] [int] PRIMARY KEY identity(1,1) NOT NULL,
	[SupplyComponentName] [varchar] (50) NOT NULL,
	--[SupplierID][int] NOT NULL,
	[SupplierID] [int] NOT NULL CONSTRAINT fk_supplier2ID FOREIGN KEY References Supplier ([SupplierID])
	--FOREIGN KEY ([SupplierID]) REFERENCES Supplier,
);


ALTER TABLE [Components] ADD CONSTRAINT fk_supplycomponentname FOREIGN KEY ([ComponentName]) REFERENCES [SupplierComponents] ([SupplierComponentID])
ON UPDATE NO ACTION 
ON DELETE NO ACTION 