/* =============================================================
   Choco Delight - Database Schema
   Target: SQL Server 2025  |  Database: Chocodelight
   Run order: 01_Schema.sql -> 02_StoredProcedures.sql -> 03_SeedData.sql
   ============================================================= */

USE Chocodelight;
GO

SET NOCOUNT ON;
GO

/* -------------------------------------------------------------
   Drop existing objects (safe re-run during development)
   ------------------------------------------------------------- */
IF OBJECT_ID('dbo.sp_Order_Create','P') IS NOT NULL DROP PROCEDURE dbo.sp_Order_Create;
IF OBJECT_ID('dbo.ProductFlavors','U')     IS NOT NULL DROP TABLE dbo.ProductFlavors;
IF OBJECT_ID('dbo.OrderStatusHistory','U') IS NOT NULL DROP TABLE dbo.OrderStatusHistory;
IF OBJECT_ID('dbo.OrderItems','U')         IS NOT NULL DROP TABLE dbo.OrderItems;
IF OBJECT_ID('dbo.Orders','U')             IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Addresses','U')          IS NOT NULL DROP TABLE dbo.Addresses;
IF OBJECT_ID('dbo.ProductWeightOptions','U') IS NOT NULL DROP TABLE dbo.ProductWeightOptions;
IF OBJECT_ID('dbo.Products','U')           IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Categories','U')         IS NOT NULL DROP TABLE dbo.Categories;
IF OBJECT_ID('dbo.DeliveryZones','U')      IS NOT NULL DROP TABLE dbo.DeliveryZones;
IF OBJECT_ID('dbo.Customers','U')          IS NOT NULL DROP TABLE dbo.Customers;
IF OBJECT_ID('dbo.AdminUsers','U')         IS NOT NULL DROP TABLE dbo.AdminUsers;
IF OBJECT_ID('dbo.ContactMessages','U')    IS NOT NULL DROP TABLE dbo.ContactMessages;
GO

/* -------------------------------------------------------------
   Categories
   ------------------------------------------------------------- */
CREATE TABLE dbo.Categories
(
    Id          INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Categories PRIMARY KEY,
    NameAr      NVARCHAR(100)  NOT NULL,
    NameEn      NVARCHAR(100)  NOT NULL,
    Slug        NVARCHAR(60)   NOT NULL CONSTRAINT UQ_Categories_Slug UNIQUE,
    SortOrder   INT            NOT NULL CONSTRAINT DF_Categories_SortOrder DEFAULT(0),
    IsActive    BIT            NOT NULL CONSTRAINT DF_Categories_IsActive DEFAULT(1),
    CreatedAt   DATETIME2(0)   NOT NULL CONSTRAINT DF_Categories_CreatedAt DEFAULT(SYSUTCDATETIME())
);
GO

/* -------------------------------------------------------------
   Products
   ------------------------------------------------------------- */
CREATE TABLE dbo.Products
(
    Id              INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Products PRIMARY KEY,
    CategoryId      INT            NOT NULL CONSTRAINT FK_Products_Categories REFERENCES dbo.Categories(Id),
    NameAr          NVARCHAR(150)  NOT NULL,
    NameEn          NVARCHAR(150)  NOT NULL,
    DescriptionAr   NVARCHAR(2000) NULL,
    DescriptionEn   NVARCHAR(2000) NULL,
    BasePrice       DECIMAL(10,2)  NOT NULL CONSTRAINT CK_Products_BasePrice CHECK (BasePrice >= 0),
    WeightNoteAr    NVARCHAR(100)  NULL,
    WeightNoteEn    NVARCHAR(100)  NULL,
    ImageUrl        NVARCHAR(300)  NULL,
    IsActive        BIT            NOT NULL CONSTRAINT DF_Products_IsActive DEFAULT(1),
    IsBestSeller    BIT            NOT NULL CONSTRAINT DF_Products_IsBestSeller DEFAULT(0),
    IsNew           BIT            NOT NULL CONSTRAINT DF_Products_IsNew DEFAULT(0),
    SortOrder       INT            NOT NULL CONSTRAINT DF_Products_SortOrder DEFAULT(0),
    CreatedAt       DATETIME2(0)   NOT NULL CONSTRAINT DF_Products_CreatedAt DEFAULT(SYSUTCDATETIME()),
    UpdatedAt       DATETIME2(0)   NULL
);
GO
CREATE INDEX IX_Products_CategoryId ON dbo.Products(CategoryId) INCLUDE (IsActive);
GO

/* -------------------------------------------------------------
   Product weight / size options (price varies by weight)
   ------------------------------------------------------------- */
CREATE TABLE dbo.ProductWeightOptions
(
    Id          INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ProductWeightOptions PRIMARY KEY,
    ProductId   INT            NOT NULL CONSTRAINT FK_PWO_Products REFERENCES dbo.Products(Id) ON DELETE CASCADE,
    LabelAr     NVARCHAR(100)  NOT NULL,
    LabelEn     NVARCHAR(100)  NOT NULL,
    Weight      NVARCHAR(50)   NULL,
    Price       DECIMAL(10,2)  NOT NULL CONSTRAINT CK_PWO_Price CHECK (Price >= 0),
    SortOrder   INT            NOT NULL CONSTRAINT DF_PWO_SortOrder DEFAULT(0)
);
GO
CREATE INDEX IX_PWO_ProductId ON dbo.ProductWeightOptions(ProductId);
GO

/* -------------------------------------------------------------
   Optional flavour choices for a product (no price impact)
   ------------------------------------------------------------- */
CREATE TABLE dbo.ProductFlavors
(
    Id          INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ProductFlavors PRIMARY KEY,
    ProductId   INT            NOT NULL CONSTRAINT FK_ProductFlavors_Products REFERENCES dbo.Products(Id) ON DELETE CASCADE,
    NameAr      NVARCHAR(60)   NOT NULL,
    NameEn      NVARCHAR(60)   NOT NULL,
    SortOrder   INT            NOT NULL CONSTRAINT DF_ProductFlavors_SortOrder DEFAULT(0)
);
GO
CREATE INDEX IX_ProductFlavors_ProductId ON dbo.ProductFlavors(ProductId);
GO

/* -------------------------------------------------------------
   Delivery zones (Alexandria) with per-zone fee
   ------------------------------------------------------------- */
CREATE TABLE dbo.DeliveryZones
(
    Id          INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_DeliveryZones PRIMARY KEY,
    NameAr      NVARCHAR(100)  NOT NULL,
    NameEn      NVARCHAR(100)  NOT NULL,
    Fee         DECIMAL(10,2)  NOT NULL CONSTRAINT CK_DeliveryZones_Fee CHECK (Fee >= 0),
    IsActive    BIT            NOT NULL CONSTRAINT DF_DeliveryZones_IsActive DEFAULT(1),
    SortOrder   INT            NOT NULL CONSTRAINT DF_DeliveryZones_SortOrder DEFAULT(0)
);
GO

/* -------------------------------------------------------------
   Customers (site accounts)
   ------------------------------------------------------------- */
CREATE TABLE dbo.Customers
(
    Id                  INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Customers PRIMARY KEY,
    FullName            NVARCHAR(150)  NOT NULL,
    Email               NVARCHAR(256)  NOT NULL CONSTRAINT UQ_Customers_Email UNIQUE,
    PasswordHash        NVARCHAR(255)  NOT NULL,
    Phone               NVARCHAR(20)   NULL,
    IsActive            BIT            NOT NULL CONSTRAINT DF_Customers_IsActive DEFAULT(1),
    ResetToken          NVARCHAR(100)  NULL,
    ResetTokenExpiry    DATETIME2(0)   NULL,
    FailedLoginCount    INT            NOT NULL CONSTRAINT DF_Customers_FailedLoginCount DEFAULT(0),
    LockoutEndUtc       DATETIME2(0)   NULL,
    CreatedAt           DATETIME2(0)   NOT NULL CONSTRAINT DF_Customers_CreatedAt DEFAULT(SYSUTCDATETIME()),
    LastLoginAt         DATETIME2(0)   NULL
);
GO

/* -------------------------------------------------------------
   Customer saved addresses
   ------------------------------------------------------------- */
CREATE TABLE dbo.Addresses
(
    Id          INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Addresses PRIMARY KEY,
    CustomerId  INT            NOT NULL CONSTRAINT FK_Addresses_Customers REFERENCES dbo.Customers(Id) ON DELETE CASCADE,
    Label       NVARCHAR(50)   NULL,
    ZoneId      INT            NOT NULL CONSTRAINT FK_Addresses_Zones REFERENCES dbo.DeliveryZones(Id),
    Details     NVARCHAR(500)  NOT NULL,
    Landmark    NVARCHAR(200)  NULL,
    Phone       NVARCHAR(20)   NOT NULL,
    IsDefault   BIT            NOT NULL CONSTRAINT DF_Addresses_IsDefault DEFAULT(0),
    CreatedAt   DATETIME2(0)   NOT NULL CONSTRAINT DF_Addresses_CreatedAt DEFAULT(SYSUTCDATETIME())
);
GO
CREATE INDEX IX_Addresses_CustomerId ON dbo.Addresses(CustomerId);
GO

/* -------------------------------------------------------------
   Orders  (payment method is Cash on Delivery only)
   Status: Review | Confirmed | Preparing | Delivering | Delivered | Cancelled
   ------------------------------------------------------------- */
CREATE TABLE dbo.Orders
(
    Id                  INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Orders PRIMARY KEY,
    OrderNumber         NVARCHAR(30)   NOT NULL CONSTRAINT UQ_Orders_OrderNumber UNIQUE,
    CustomerId          INT            NULL CONSTRAINT FK_Orders_Customers REFERENCES dbo.Customers(Id),
    RecipientName       NVARCHAR(150)  NOT NULL,
    RecipientPhone      NVARCHAR(20)   NOT NULL,
    ZoneId              INT            NOT NULL CONSTRAINT FK_Orders_Zones REFERENCES dbo.DeliveryZones(Id),
    ZoneNameSnapshot    NVARCHAR(100)  NOT NULL,
    AddressDetails      NVARCHAR(500)  NOT NULL,
    Landmark            NVARCHAR(200)  NULL,
    Subtotal            DECIMAL(10,2)  NOT NULL,
    DeliveryFee         DECIMAL(10,2)  NOT NULL,
    Total               DECIMAL(10,2)  NOT NULL,
    GiftMessage         NVARCHAR(500)  NULL,
    PaymentMethod       NVARCHAR(20)   NOT NULL CONSTRAINT DF_Orders_PaymentMethod DEFAULT('COD'),
    Status              NVARCHAR(20)   NOT NULL CONSTRAINT DF_Orders_Status DEFAULT('Review'),
    CustomerNote        NVARCHAR(500)  NULL,
    AdminNote           NVARCHAR(500)  NULL,
    CreatedAt           DATETIME2(0)   NOT NULL CONSTRAINT DF_Orders_CreatedAt DEFAULT(SYSUTCDATETIME()),
    UpdatedAt           DATETIME2(0)   NULL,
    CONSTRAINT CK_Orders_Status CHECK (Status IN ('Review','Confirmed','Preparing','Delivering','Delivered','Cancelled'))
);
GO
CREATE INDEX IX_Orders_CustomerId ON dbo.Orders(CustomerId);
CREATE INDEX IX_Orders_Status ON dbo.Orders(Status) INCLUDE (CreatedAt);
GO

/* -------------------------------------------------------------
   Order line items (name/price captured as snapshot)
   ------------------------------------------------------------- */
CREATE TABLE dbo.OrderItems
(
    Id                  INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_OrderItems PRIMARY KEY,
    OrderId             INT            NOT NULL CONSTRAINT FK_OrderItems_Orders REFERENCES dbo.Orders(Id) ON DELETE CASCADE,
    ProductId           INT            NULL CONSTRAINT FK_OrderItems_Products REFERENCES dbo.Products(Id),
    ProductNameAr       NVARCHAR(150)  NOT NULL,
    ProductNameEn       NVARCHAR(150)  NOT NULL,
    WeightLabel         NVARCHAR(100)  NULL,
    UnitPrice           DECIMAL(10,2)  NOT NULL,
    Quantity            INT            NOT NULL CONSTRAINT CK_OrderItems_Qty CHECK (Quantity > 0),
    LineTotal           DECIMAL(10,2)  NOT NULL
);
GO
CREATE INDEX IX_OrderItems_OrderId ON dbo.OrderItems(OrderId);
GO

/* -------------------------------------------------------------
   Order status change audit trail
   ------------------------------------------------------------- */
CREATE TABLE dbo.OrderStatusHistory
(
    Id                  INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_OrderStatusHistory PRIMARY KEY,
    OrderId             INT            NOT NULL CONSTRAINT FK_OSH_Orders REFERENCES dbo.Orders(Id) ON DELETE CASCADE,
    OldStatus           NVARCHAR(20)   NULL,
    NewStatus           NVARCHAR(20)   NOT NULL,
    ChangedByAdminId    INT            NULL,
    Note                NVARCHAR(300)  NULL,
    ChangedAt           DATETIME2(0)   NOT NULL CONSTRAINT DF_OSH_ChangedAt DEFAULT(SYSUTCDATETIME())
);
GO
CREATE INDEX IX_OSH_OrderId ON dbo.OrderStatusHistory(OrderId);
GO

/* -------------------------------------------------------------
   Admin (back-office) users - separate from Customers
   ------------------------------------------------------------- */
CREATE TABLE dbo.AdminUsers
(
    Id              INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_AdminUsers PRIMARY KEY,
    Username        NVARCHAR(50)   NOT NULL CONSTRAINT UQ_AdminUsers_Username UNIQUE,
    PasswordHash    NVARCHAR(255)  NOT NULL,
    FullName        NVARCHAR(150)  NOT NULL,
    Email           NVARCHAR(256)  NULL,
    Role            NVARCHAR(30)   NOT NULL CONSTRAINT DF_AdminUsers_Role DEFAULT('Admin'),
    IsActive        BIT            NOT NULL CONSTRAINT DF_AdminUsers_IsActive DEFAULT(1),
    FailedLoginCount INT           NOT NULL CONSTRAINT DF_AdminUsers_FailedLoginCount DEFAULT(0),
    LockoutEndUtc   DATETIME2(0)   NULL,
    CreatedAt       DATETIME2(0)   NOT NULL CONSTRAINT DF_AdminUsers_CreatedAt DEFAULT(SYSUTCDATETIME()),
    LastLoginAt     DATETIME2(0)   NULL
);
GO

/* -------------------------------------------------------------
   Contact form submissions
   ------------------------------------------------------------- */
CREATE TABLE dbo.ContactMessages
(
    Id          INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ContactMessages PRIMARY KEY,
    Name        NVARCHAR(150)  NOT NULL,
    Email       NVARCHAR(256)  NOT NULL,
    Phone       NVARCHAR(20)   NULL,
    Subject     NVARCHAR(200)  NULL,
    Message     NVARCHAR(2000) NOT NULL,
    IsHandled   BIT            NOT NULL CONSTRAINT DF_ContactMessages_IsHandled DEFAULT(0),
    CreatedAt   DATETIME2(0)   NOT NULL CONSTRAINT DF_ContactMessages_CreatedAt DEFAULT(SYSUTCDATETIME())
);
GO

/* -------------------------------------------------------------
   Table-valued parameter type used by sp_Order_Create
   ------------------------------------------------------------- */
IF TYPE_ID('dbo.OrderItemTVP') IS NOT NULL DROP TYPE dbo.OrderItemTVP;
GO
CREATE TYPE dbo.OrderItemTVP AS TABLE   -- referenced by dbo.sp_Order_Create
(
    ProductId       INT            NULL,
    ProductNameAr   NVARCHAR(150)  NOT NULL,
    ProductNameEn   NVARCHAR(150)  NOT NULL,
    WeightLabel     NVARCHAR(100)  NULL,
    UnitPrice       DECIMAL(10,2)  NOT NULL,
    Quantity        INT            NOT NULL
);
GO

PRINT 'Schema created.';
GO
