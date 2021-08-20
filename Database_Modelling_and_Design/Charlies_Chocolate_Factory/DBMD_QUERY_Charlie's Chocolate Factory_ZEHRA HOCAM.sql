CREATE DATABASE Manufacturer;
Use Manufacturer;
CREATE TABLE Products
(
	[product_ID] [int] PRIMARY KEY NOT NULL,
	[product_Name] [nvarchar](50) NULL,
	[quantity][decimal](10,2)NULL
);
CREATE TABLE Components
(
	[component_ID] [int] PRIMARY KEY NOT NULL,
	[component_Name] [nvarchar](50) NULL,
	[description][text]NULL,
	[quantity][decimal](10,2)NULL
);
CREATE TABLE Supplier
(
	[supplier_ID] [int] PRIMARY KEY NOT NULL,
	[supplier_Name] [nvarchar](50) NULL,
	activation_status[nvarchar](50)NULL
);
CREATE TABLE ProductComponents
(
	[product_ID] [int]  NOT NULL,
	[component_ID] [int] NOT NULL,
	[quantity][decimal](10,2)NULL,
	PRIMARY KEY (product_ID,component_ID),
	FOREIGN KEY ([product_ID]) REFERENCES Products,
	FOREIGN KEY ([component_ID]) REFERENCES Components
);
CREATE TABLE ComponentSupplier
(
	[supplier_ID] [int] NOT NULL,
	[component_ID] [int] NOT NULL,
	[quantity][decimal](10,2)NULL,
	[price][decimal](10,2)NULL,
	PRIMARY KEY ([supplier_ID],component_ID),
	FOREIGN KEY ([supplier_ID]) REFERENCES Supplier,
	FOREIGN KEY ([component_ID]) REFERENCES Components
);

