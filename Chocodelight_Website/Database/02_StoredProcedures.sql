/* =============================================================
   Choco Delight - Stored Procedures
   Run after 01_Schema.sql
   ============================================================= */

USE Chocodelight;
GO
SET NOCOUNT ON;
GO

/* ============================================================
   CATEGORIES
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_Category_GetAll
    @ActiveOnly BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, NameAr, NameEn, Slug, SortOrder, IsActive, CreatedAt
    FROM dbo.Categories
    WHERE (@ActiveOnly = 0 OR IsActive = 1)
    ORDER BY SortOrder, NameAr;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Category_GetById
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, NameAr, NameEn, Slug, SortOrder, IsActive, CreatedAt
    FROM dbo.Categories WHERE Id = @Id;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Category_Insert
    @NameAr NVARCHAR(100), @NameEn NVARCHAR(100), @Slug NVARCHAR(60),
    @SortOrder INT = 0, @IsActive BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    INSERT dbo.Categories (NameAr, NameEn, Slug, SortOrder, IsActive)
    VALUES (@NameAr, @NameEn, @Slug, @SortOrder, @IsActive);
    SELECT CAST(SCOPE_IDENTITY() AS INT) AS NewId;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Category_Update
    @Id INT, @NameAr NVARCHAR(100), @NameEn NVARCHAR(100), @Slug NVARCHAR(60),
    @SortOrder INT, @IsActive BIT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Categories
       SET NameAr=@NameAr, NameEn=@NameEn, Slug=@Slug, SortOrder=@SortOrder, IsActive=@IsActive
     WHERE Id=@Id;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Category_Delete
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM dbo.Products WHERE CategoryId = @Id)
    BEGIN
        RAISERROR('Cannot delete a category that still has products.', 16, 1);
        RETURN;
    END
    DELETE dbo.Categories WHERE Id = @Id;
END
GO

/* ============================================================
   PRODUCTS
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_Product_GetList
    @CategoryId  INT = NULL,
    @CategorySlug NVARCHAR(60) = NULL,
    @Search      NVARCHAR(150) = NULL,
    @ActiveOnly  BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    SELECT p.Id, p.CategoryId, c.NameAr AS CategoryNameAr, c.NameEn AS CategoryNameEn, c.Slug AS CategorySlug,
           p.NameAr, p.NameEn, p.DescriptionAr, p.DescriptionEn,
           p.BasePrice, p.WeightNoteAr, p.WeightNoteEn, p.ImageUrl,
           p.IsActive, p.IsBestSeller, p.IsNew, p.SortOrder, p.CreatedAt
    FROM dbo.Products p
    INNER JOIN dbo.Categories c ON c.Id = p.CategoryId
    WHERE (@ActiveOnly = 0 OR p.IsActive = 1)
      AND (@CategoryId IS NULL OR p.CategoryId = @CategoryId)
      AND (@CategorySlug IS NULL OR c.Slug = @CategorySlug)
      AND (@Search IS NULL OR p.NameAr LIKE '%'+@Search+'%' OR p.NameEn LIKE '%'+@Search+'%')
    ORDER BY p.SortOrder, p.Id;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Product_GetFeatured
    @Take INT = 8
AS
BEGIN
    SET NOCOUNT ON;
    -- Best sellers / new first, then top up with other active products so the
    -- homepage grid is always full.
    SELECT TOP (@Take)
           p.Id, p.CategoryId, p.NameAr, p.NameEn, p.BasePrice,
           p.WeightNoteAr, p.WeightNoteEn, p.ImageUrl, p.IsBestSeller, p.IsNew
    FROM dbo.Products p
    WHERE p.IsActive = 1
    ORDER BY
        CASE WHEN p.IsBestSeller = 1 OR p.IsNew = 1 THEN 0 ELSE 1 END,
        p.IsBestSeller DESC,
        p.SortOrder, p.Id;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Product_GetById
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT p.Id, p.CategoryId, c.NameAr AS CategoryNameAr, c.NameEn AS CategoryNameEn, c.Slug AS CategorySlug,
           p.NameAr, p.NameEn, p.DescriptionAr, p.DescriptionEn,
           p.BasePrice, p.WeightNoteAr, p.WeightNoteEn, p.ImageUrl,
           p.IsActive, p.IsBestSeller, p.IsNew, p.SortOrder, p.CreatedAt, p.UpdatedAt
    FROM dbo.Products p
    INNER JOIN dbo.Categories c ON c.Id = p.CategoryId
    WHERE p.Id = @Id;

    SELECT Id, ProductId, LabelAr, LabelEn, Weight, Price, SortOrder
    FROM dbo.ProductWeightOptions
    WHERE ProductId = @Id
    ORDER BY SortOrder, Price;

    SELECT Id, ProductId, NameAr, NameEn, SortOrder
    FROM dbo.ProductFlavors
    WHERE ProductId = @Id
    ORDER BY SortOrder, Id;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Product_Insert
    @CategoryId INT, @NameAr NVARCHAR(150), @NameEn NVARCHAR(150),
    @DescriptionAr NVARCHAR(2000) = NULL, @DescriptionEn NVARCHAR(2000) = NULL,
    @BasePrice DECIMAL(10,2), @WeightNoteAr NVARCHAR(100) = NULL, @WeightNoteEn NVARCHAR(100) = NULL,
    @ImageUrl NVARCHAR(300) = NULL, @IsActive BIT = 1, @IsBestSeller BIT = 0, @IsNew BIT = 0, @SortOrder INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    INSERT dbo.Products (CategoryId, NameAr, NameEn, DescriptionAr, DescriptionEn, BasePrice,
                         WeightNoteAr, WeightNoteEn, ImageUrl, IsActive, IsBestSeller, IsNew, SortOrder)
    VALUES (@CategoryId, @NameAr, @NameEn, @DescriptionAr, @DescriptionEn, @BasePrice,
            @WeightNoteAr, @WeightNoteEn, @ImageUrl, @IsActive, @IsBestSeller, @IsNew, @SortOrder);
    SELECT CAST(SCOPE_IDENTITY() AS INT) AS NewId;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Product_Update
    @Id INT, @CategoryId INT, @NameAr NVARCHAR(150), @NameEn NVARCHAR(150),
    @DescriptionAr NVARCHAR(2000) = NULL, @DescriptionEn NVARCHAR(2000) = NULL,
    @BasePrice DECIMAL(10,2), @WeightNoteAr NVARCHAR(100) = NULL, @WeightNoteEn NVARCHAR(100) = NULL,
    @ImageUrl NVARCHAR(300) = NULL, @IsActive BIT = 1, @IsBestSeller BIT = 0, @IsNew BIT = 0, @SortOrder INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Products
       SET CategoryId=@CategoryId, NameAr=@NameAr, NameEn=@NameEn,
           DescriptionAr=@DescriptionAr, DescriptionEn=@DescriptionEn, BasePrice=@BasePrice,
           WeightNoteAr=@WeightNoteAr, WeightNoteEn=@WeightNoteEn, ImageUrl=@ImageUrl,
           IsActive=@IsActive, IsBestSeller=@IsBestSeller, IsNew=@IsNew, SortOrder=@SortOrder,
           UpdatedAt=SYSUTCDATETIME()
     WHERE Id=@Id;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Product_ToggleActive
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Products SET IsActive = CASE WHEN IsActive = 1 THEN 0 ELSE 1 END, UpdatedAt = SYSUTCDATETIME()
    WHERE Id = @Id;
    SELECT IsActive FROM dbo.Products WHERE Id = @Id;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Product_Delete
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM dbo.OrderItems WHERE ProductId = @Id)
    BEGIN
        -- keep history intact: soft-delete instead
        UPDATE dbo.Products SET IsActive = 0, UpdatedAt = SYSUTCDATETIME() WHERE Id = @Id;
        SELECT CAST(0 AS BIT) AS HardDeleted;
        RETURN;
    END
    DELETE dbo.Products WHERE Id = @Id;   -- weight options cascade
    SELECT CAST(1 AS BIT) AS HardDeleted;
END
GO

/* ---- Product flavours ---- */
CREATE OR ALTER PROCEDURE dbo.sp_ProductFlavor_GetByProduct
    @ProductId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, ProductId, NameAr, NameEn, SortOrder
    FROM dbo.ProductFlavors WHERE ProductId = @ProductId ORDER BY SortOrder, Id;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_ProductFlavor_ClearByProduct
    @ProductId INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE dbo.ProductFlavors WHERE ProductId = @ProductId;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_ProductFlavor_Add
    @ProductId INT, @NameAr NVARCHAR(60), @NameEn NVARCHAR(60), @SortOrder INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    INSERT dbo.ProductFlavors (ProductId, NameAr, NameEn, SortOrder)
    VALUES (@ProductId, @NameAr, @NameEn, @SortOrder);
    SELECT CAST(SCOPE_IDENTITY() AS INT) AS NewId;
END
GO

/* ---- Product weight options (admin edits: clear then re-add) ---- */
CREATE OR ALTER PROCEDURE dbo.sp_ProductWeightOption_ClearByProduct
    @ProductId INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE dbo.ProductWeightOptions WHERE ProductId = @ProductId;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_ProductWeightOption_Add
    @ProductId INT, @LabelAr NVARCHAR(100), @LabelEn NVARCHAR(100),
    @Weight NVARCHAR(50) = NULL, @Price DECIMAL(10,2), @SortOrder INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    INSERT dbo.ProductWeightOptions (ProductId, LabelAr, LabelEn, Weight, Price, SortOrder)
    VALUES (@ProductId, @LabelAr, @LabelEn, @Weight, @Price, @SortOrder);
    SELECT CAST(SCOPE_IDENTITY() AS INT) AS NewId;
END
GO

/* ============================================================
   DELIVERY ZONES
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_DeliveryZone_GetAll
    @ActiveOnly BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, NameAr, NameEn, Fee, IsActive, SortOrder
    FROM dbo.DeliveryZones
    WHERE (@ActiveOnly = 0 OR IsActive = 1)
    ORDER BY SortOrder, NameAr;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_DeliveryZone_GetById
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, NameAr, NameEn, Fee, IsActive, SortOrder
    FROM dbo.DeliveryZones WHERE Id = @Id;
END
GO

/* ============================================================
   CUSTOMERS / AUTH
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_Customer_GetByEmail
    @Email NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, FullName, Email, PasswordHash, Phone, IsActive,
           FailedLoginCount, LockoutEndUtc, CreatedAt, LastLoginAt
    FROM dbo.Customers WHERE Email = @Email;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Customer_GetById
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, FullName, Email, Phone, IsActive, CreatedAt, LastLoginAt
    FROM dbo.Customers WHERE Id = @Id;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Customer_Insert
    @FullName NVARCHAR(150), @Email NVARCHAR(256), @PasswordHash NVARCHAR(255), @Phone NVARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM dbo.Customers WHERE Email = @Email)
    BEGIN
        RAISERROR('EMAIL_EXISTS', 16, 1);
        RETURN;
    END
    INSERT dbo.Customers (FullName, Email, PasswordHash, Phone)
    VALUES (@FullName, @Email, @PasswordHash, @Phone);
    SELECT CAST(SCOPE_IDENTITY() AS INT) AS NewId;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Customer_UpdateProfile
    @Id INT, @FullName NVARCHAR(150), @Phone NVARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Customers SET FullName = @FullName, Phone = @Phone WHERE Id = @Id;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Customer_UpdatePassword
    @Id INT, @PasswordHash NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Customers
       SET PasswordHash = @PasswordHash, ResetToken = NULL, ResetTokenExpiry = NULL
     WHERE Id = @Id;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Customer_RecordLoginResult
    @Id INT, @Success BIT, @LockoutMinutes INT = 15, @MaxAttempts INT = 5
AS
BEGIN
    SET NOCOUNT ON;
    IF @Success = 1
        UPDATE dbo.Customers
           SET FailedLoginCount = 0, LockoutEndUtc = NULL, LastLoginAt = SYSUTCDATETIME()
         WHERE Id = @Id;
    ELSE
        UPDATE dbo.Customers
           SET FailedLoginCount = FailedLoginCount + 1,
               LockoutEndUtc = CASE WHEN FailedLoginCount + 1 >= @MaxAttempts
                                    THEN DATEADD(MINUTE, @LockoutMinutes, SYSUTCDATETIME())
                                    ELSE LockoutEndUtc END
         WHERE Id = @Id;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Customer_SetResetToken
    @Email NVARCHAR(256), @Token NVARCHAR(100), @ExpiryUtc DATETIME2(0)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Customers SET ResetToken = @Token, ResetTokenExpiry = @ExpiryUtc
    WHERE Email = @Email AND IsActive = 1;
    SELECT @@ROWCOUNT AS Affected;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Customer_GetByResetToken
    @Token NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, FullName, Email, ResetTokenExpiry
    FROM dbo.Customers
    WHERE ResetToken = @Token AND ResetTokenExpiry > SYSUTCDATETIME() AND IsActive = 1;
END
GO

/* ============================================================
   ADDRESSES
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_Address_GetByCustomer
    @CustomerId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT a.Id, a.CustomerId, a.Label, a.ZoneId, z.NameAr AS ZoneNameAr, z.NameEn AS ZoneNameEn, z.Fee AS ZoneFee,
           a.Details, a.Landmark, a.Phone, a.IsDefault, a.CreatedAt
    FROM dbo.Addresses a
    INNER JOIN dbo.DeliveryZones z ON z.Id = a.ZoneId
    WHERE a.CustomerId = @CustomerId
    ORDER BY a.IsDefault DESC, a.CreatedAt DESC;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Address_GetById
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT a.Id, a.CustomerId, a.Label, a.ZoneId, z.NameAr AS ZoneNameAr, z.NameEn AS ZoneNameEn, z.Fee AS ZoneFee,
           a.Details, a.Landmark, a.Phone, a.IsDefault, a.CreatedAt
    FROM dbo.Addresses a
    INNER JOIN dbo.DeliveryZones z ON z.Id = a.ZoneId
    WHERE a.Id = @Id;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Address_Insert
    @CustomerId INT, @Label NVARCHAR(50) = NULL, @ZoneId INT,
    @Details NVARCHAR(500), @Landmark NVARCHAR(200) = NULL, @Phone NVARCHAR(20), @IsDefault BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRAN;
    IF @IsDefault = 1
        UPDATE dbo.Addresses SET IsDefault = 0 WHERE CustomerId = @CustomerId;
    IF NOT EXISTS (SELECT 1 FROM dbo.Addresses WHERE CustomerId = @CustomerId)
        SET @IsDefault = 1;  -- first address becomes default
    INSERT dbo.Addresses (CustomerId, Label, ZoneId, Details, Landmark, Phone, IsDefault)
    VALUES (@CustomerId, @Label, @ZoneId, @Details, @Landmark, @Phone, @IsDefault);
    SELECT CAST(SCOPE_IDENTITY() AS INT) AS NewId;
    COMMIT;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Address_Update
    @Id INT, @CustomerId INT, @Label NVARCHAR(50) = NULL, @ZoneId INT,
    @Details NVARCHAR(500), @Landmark NVARCHAR(200) = NULL, @Phone NVARCHAR(20), @IsDefault BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRAN;
    IF @IsDefault = 1
        UPDATE dbo.Addresses SET IsDefault = 0 WHERE CustomerId = @CustomerId AND Id <> @Id;
    UPDATE dbo.Addresses
       SET Label=@Label, ZoneId=@ZoneId, Details=@Details, Landmark=@Landmark, Phone=@Phone, IsDefault=@IsDefault
     WHERE Id=@Id AND CustomerId=@CustomerId;
    COMMIT;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Address_Delete
    @Id INT, @CustomerId INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE dbo.Addresses WHERE Id = @Id AND CustomerId = @CustomerId;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Address_SetDefault
    @Id INT, @CustomerId INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRAN;
    UPDATE dbo.Addresses SET IsDefault = 0 WHERE CustomerId = @CustomerId;
    UPDATE dbo.Addresses SET IsDefault = 1 WHERE Id = @Id AND CustomerId = @CustomerId;
    COMMIT;
END
GO

/* ============================================================
   ORDERS
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_Order_Create
    @CustomerId     INT = NULL,
    @RecipientName  NVARCHAR(150),
    @RecipientPhone NVARCHAR(20),
    @ZoneId         INT,
    @AddressDetails NVARCHAR(500),
    @Landmark       NVARCHAR(200) = NULL,
    @GiftMessage    NVARCHAR(500) = NULL,
    @CustomerNote   NVARCHAR(500) = NULL,
    @Items          dbo.OrderItemTVP READONLY
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF NOT EXISTS (SELECT 1 FROM @Items)
    BEGIN
        RAISERROR('ORDER_HAS_NO_ITEMS', 16, 1);
        RETURN;
    END

    DECLARE @ZoneName NVARCHAR(100), @Fee DECIMAL(10,2);
    SELECT @ZoneName = NameAr, @Fee = Fee FROM dbo.DeliveryZones WHERE Id = @ZoneId AND IsActive = 1;
    IF @ZoneName IS NULL
    BEGIN
        RAISERROR('INVALID_ZONE', 16, 1);
        RETURN;
    END

    DECLARE @Subtotal DECIMAL(10,2) = (SELECT SUM(UnitPrice * Quantity) FROM @Items);
    DECLARE @Total DECIMAL(10,2) = @Subtotal + @Fee;

    BEGIN TRAN;

    DECLARE @Year CHAR(4) = CONVERT(CHAR(4), YEAR(SYSUTCDATETIME()));
    DECLARE @Seq INT =
        ISNULL((SELECT MAX(TRY_CONVERT(INT, RIGHT(OrderNumber, 5)))
                FROM dbo.Orders WITH (UPDLOCK, HOLDLOCK)
                WHERE OrderNumber LIKE 'CD-' + @Year + '-%'), 0) + 1;
    DECLARE @OrderNumber NVARCHAR(30) = 'CD-' + @Year + '-' + RIGHT('00000' + CAST(@Seq AS VARCHAR(5)), 5);

    INSERT dbo.Orders (OrderNumber, CustomerId, RecipientName, RecipientPhone, ZoneId, ZoneNameSnapshot,
                       AddressDetails, Landmark, Subtotal, DeliveryFee, Total, GiftMessage, PaymentMethod,
                       Status, CustomerNote)
    VALUES (@OrderNumber, @CustomerId, @RecipientName, @RecipientPhone, @ZoneId, @ZoneName,
            @AddressDetails, @Landmark, @Subtotal, @Fee, @Total, @GiftMessage, 'COD',
            'Review', @CustomerNote);

    DECLARE @OrderId INT = CAST(SCOPE_IDENTITY() AS INT);

    INSERT dbo.OrderItems (OrderId, ProductId, ProductNameAr, ProductNameEn, WeightLabel, UnitPrice, Quantity, LineTotal)
    SELECT @OrderId, ProductId, ProductNameAr, ProductNameEn, WeightLabel, UnitPrice, Quantity, UnitPrice * Quantity
    FROM @Items;

    INSERT dbo.OrderStatusHistory (OrderId, OldStatus, NewStatus, Note)
    VALUES (@OrderId, NULL, 'Review', 'Order placed');

    COMMIT;

    SELECT @OrderId AS OrderId, @OrderNumber AS OrderNumber, @Subtotal AS Subtotal, @Fee AS DeliveryFee, @Total AS Total;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Order_GetByCustomer
    @CustomerId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT o.Id, o.OrderNumber, o.Status, o.Subtotal, o.DeliveryFee, o.Total, o.CreatedAt,
           (SELECT COUNT(*) FROM dbo.OrderItems oi WHERE oi.OrderId = o.Id) AS ItemCount
    FROM dbo.Orders o
    WHERE o.CustomerId = @CustomerId
    ORDER BY o.CreatedAt DESC;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Order_GetById
    @Id INT,
    @CustomerId INT = NULL   -- when supplied, enforces ownership
AS
BEGIN
    SET NOCOUNT ON;
    SELECT o.Id, o.OrderNumber, o.CustomerId, o.RecipientName, o.RecipientPhone,
           o.ZoneId, o.ZoneNameSnapshot, o.AddressDetails, o.Landmark,
           o.Subtotal, o.DeliveryFee, o.Total, o.GiftMessage, o.PaymentMethod, o.Status,
           o.CustomerNote, o.AdminNote, o.CreatedAt, o.UpdatedAt
    FROM dbo.Orders o
    WHERE o.Id = @Id AND (@CustomerId IS NULL OR o.CustomerId = @CustomerId);

    SELECT oi.Id, oi.ProductId, oi.ProductNameAr, oi.ProductNameEn, oi.WeightLabel,
           oi.UnitPrice, oi.Quantity, oi.LineTotal
    FROM dbo.OrderItems oi
    INNER JOIN dbo.Orders o ON o.Id = oi.OrderId
    WHERE oi.OrderId = @Id AND (@CustomerId IS NULL OR o.CustomerId = @CustomerId);

    SELECT h.Id, h.OldStatus, h.NewStatus, h.Note, h.ChangedAt
    FROM dbo.OrderStatusHistory h
    WHERE h.OrderId = @Id
    ORDER BY h.ChangedAt;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Order_GetByNumber
    @OrderNumber NVARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Id INT = (SELECT Id FROM dbo.Orders WHERE OrderNumber = @OrderNumber);
    EXEC dbo.sp_Order_GetById @Id = @Id, @CustomerId = NULL;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Order_GetListAdmin
    @Status NVARCHAR(20) = NULL,
    @Search NVARCHAR(100) = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 20
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;

    SELECT COUNT(*) AS TotalCount
    FROM dbo.Orders o
    WHERE (@Status IS NULL OR o.Status = @Status)
      AND (@Search IS NULL OR o.OrderNumber LIKE '%'+@Search+'%' OR o.RecipientName LIKE '%'+@Search+'%' OR o.RecipientPhone LIKE '%'+@Search+'%');

    SELECT o.Id, o.OrderNumber, o.RecipientName, o.RecipientPhone, o.ZoneNameSnapshot,
           o.Total, o.Status, o.CreatedAt,
           (SELECT COUNT(*) FROM dbo.OrderItems oi WHERE oi.OrderId = o.Id) AS ItemCount
    FROM dbo.Orders o
    WHERE (@Status IS NULL OR o.Status = @Status)
      AND (@Search IS NULL OR o.OrderNumber LIKE '%'+@Search+'%' OR o.RecipientName LIKE '%'+@Search+'%' OR o.RecipientPhone LIKE '%'+@Search+'%')
    ORDER BY o.CreatedAt DESC
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Order_StatusCounts
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        (SELECT COUNT(*) FROM dbo.Orders) AS AllCount,
        (SELECT COUNT(*) FROM dbo.Orders WHERE Status = 'Review') AS ReviewCount,
        (SELECT COUNT(*) FROM dbo.Orders WHERE Status = 'Confirmed') AS ConfirmedCount,
        (SELECT COUNT(*) FROM dbo.Orders WHERE Status = 'Preparing') AS PreparingCount,
        (SELECT COUNT(*) FROM dbo.Orders WHERE Status = 'Delivering') AS DeliveringCount,
        (SELECT COUNT(*) FROM dbo.Orders WHERE Status = 'Delivered') AS DeliveredCount,
        (SELECT COUNT(*) FROM dbo.Orders WHERE Status = 'Cancelled') AS CancelledCount;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Order_UpdateStatus
    @Id INT, @NewStatus NVARCHAR(20), @ChangedByAdminId INT = NULL, @Note NVARCHAR(300) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF @NewStatus NOT IN ('Review','Confirmed','Preparing','Delivering','Delivered','Cancelled')
    BEGIN
        RAISERROR('INVALID_STATUS', 16, 1);
        RETURN;
    END
    DECLARE @Old NVARCHAR(20) = (SELECT Status FROM dbo.Orders WHERE Id = @Id);
    IF @Old IS NULL
    BEGIN
        RAISERROR('ORDER_NOT_FOUND', 16, 1);
        RETURN;
    END
    IF @Old = @NewStatus RETURN;

    BEGIN TRAN;
    UPDATE dbo.Orders SET Status = @NewStatus, AdminNote = COALESCE(@Note, AdminNote), UpdatedAt = SYSUTCDATETIME()
    WHERE Id = @Id;
    INSERT dbo.OrderStatusHistory (OrderId, OldStatus, NewStatus, ChangedByAdminId, Note)
    VALUES (@Id, @Old, @NewStatus, @ChangedByAdminId, @Note);
    COMMIT;
END
GO

/* ============================================================
   ADMIN USERS
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_AdminUser_GetByUsername
    @Username NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Username, PasswordHash, FullName, Email, Role, IsActive,
           FailedLoginCount, LockoutEndUtc, LastLoginAt
    FROM dbo.AdminUsers WHERE Username = @Username;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_AdminUser_Count
AS
BEGIN
    SET NOCOUNT ON;
    SELECT COUNT(*) AS Cnt FROM dbo.AdminUsers;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_AdminUser_Insert
    @Username NVARCHAR(50), @PasswordHash NVARCHAR(255), @FullName NVARCHAR(150),
    @Email NVARCHAR(256) = NULL, @Role NVARCHAR(30) = 'Admin'
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM dbo.AdminUsers WHERE Username = @Username)
    BEGIN
        SELECT CAST(0 AS INT) AS NewId;
        RETURN;
    END
    INSERT dbo.AdminUsers (Username, PasswordHash, FullName, Email, Role)
    VALUES (@Username, @PasswordHash, @FullName, @Email, @Role);
    SELECT CAST(SCOPE_IDENTITY() AS INT) AS NewId;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_AdminUser_RecordLoginResult
    @Id INT, @Success BIT, @LockoutMinutes INT = 15, @MaxAttempts INT = 5
AS
BEGIN
    SET NOCOUNT ON;
    IF @Success = 1
        UPDATE dbo.AdminUsers SET FailedLoginCount = 0, LockoutEndUtc = NULL, LastLoginAt = SYSUTCDATETIME() WHERE Id = @Id;
    ELSE
        UPDATE dbo.AdminUsers
           SET FailedLoginCount = FailedLoginCount + 1,
               LockoutEndUtc = CASE WHEN FailedLoginCount + 1 >= @MaxAttempts
                                    THEN DATEADD(MINUTE, @LockoutMinutes, SYSUTCDATETIME()) ELSE LockoutEndUtc END
         WHERE Id = @Id;
END
GO

/* ============================================================
   DASHBOARD
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_Dashboard_GetStats
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        (SELECT COUNT(*) FROM dbo.Orders) AS TotalOrders,
        (SELECT COUNT(*) FROM dbo.Orders WHERE Status = 'Review') AS PendingOrders,
        (SELECT COUNT(*) FROM dbo.Orders WHERE Status IN ('Confirmed','Preparing','Delivering')) AS ActiveOrders,
        (SELECT ISNULL(SUM(Total),0) FROM dbo.Orders WHERE Status = 'Delivered') AS DeliveredRevenue,
        (SELECT ISNULL(SUM(Total),0) FROM dbo.Orders
              WHERE Status <> 'Cancelled' AND CAST(CreatedAt AS DATE) = CAST(SYSUTCDATETIME() AS DATE)) AS TodayRevenue,
        (SELECT COUNT(*) FROM dbo.Products WHERE IsActive = 1) AS ActiveProducts,
        (SELECT COUNT(*) FROM dbo.Customers) AS TotalCustomers,
        (SELECT COUNT(*) FROM dbo.ContactMessages WHERE IsHandled = 0) AS UnreadMessages;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Dashboard_GetRecentOrders
    @Take INT = 8
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP (@Take) o.Id, o.OrderNumber, o.RecipientName, o.Total, o.Status, o.CreatedAt
    FROM dbo.Orders o
    ORDER BY o.CreatedAt DESC;
END
GO

/* ============================================================
   CONTACT MESSAGES
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_ContactMessage_Insert
    @Name NVARCHAR(150), @Email NVARCHAR(256), @Phone NVARCHAR(20) = NULL,
    @Subject NVARCHAR(200) = NULL, @Message NVARCHAR(2000)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT dbo.ContactMessages (Name, Email, Phone, Subject, Message)
    VALUES (@Name, @Email, @Phone, @Subject, @Message);
    SELECT CAST(SCOPE_IDENTITY() AS INT) AS NewId;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_ContactMessage_GetAll
    @UnhandledOnly BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Name, Email, Phone, Subject, Message, IsHandled, CreatedAt
    FROM dbo.ContactMessages
    WHERE (@UnhandledOnly = 0 OR IsHandled = 0)
    ORDER BY CreatedAt DESC;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_ContactMessage_MarkHandled
    @Id INT, @Handled BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.ContactMessages SET IsHandled = @Handled WHERE Id = @Id;
END
GO

PRINT 'Stored procedures created.';
GO
