/* =============================================================
   Choco Delight - Seed Data (catalog + delivery zones)
   Run after 02_StoredProcedures.sql
   Admin user is created from code on first app start (see DbSeeder).
   ============================================================= */

USE Chocodelight;
GO
SET NOCOUNT ON;
GO

/* ---- Delivery zones (Alexandria) ---- */
IF NOT EXISTS (SELECT 1 FROM dbo.DeliveryZones)
BEGIN
    INSERT dbo.DeliveryZones (NameAr, NameEn, Fee, SortOrder) VALUES
    (N'محطة الرمل', N'Mahatet El Raml', 25, 1),
    (N'سموحة',      N'Smouha',          30, 2),
    (N'جليم',       N'Gleem',           35, 3),
    (N'ميامي',      N'Miami',           40, 4),
    (N'العجمي',     N'Agami',           50, 5),
    (N'أبو قير',    N'Abu Qir',         55, 6);
END
GO

/* ---- Categories ---- */
IF NOT EXISTS (SELECT 1 FROM dbo.Categories)
BEGIN
    INSERT dbo.Categories (NameAr, NameEn, Slug, SortOrder) VALUES
    (N'علب فاخرة',            N'Luxury Boxes',         'luxury',    1),
    (N'هدايا المناسبات',      N'Occasion Gifts',       'occasions', 2),
    (N'شوكولاتة بالمكسرات',   N'Nut-Filled Chocolate', 'nuts',      3),
    (N'ترافل بلجيكي',         N'Belgian Truffles',     'truffles',  4),
    (N'تشكيلة الشركات',       N'Corporate Gifting',    'corporate', 5),
    (N'كوكيز',                N'Cookies',              'cookies',   6),
    (N'تصميم خاص',            N'Custom Made',          'custom',    7);
END
GO

/* ---- Products ---- */
IF NOT EXISTS (SELECT 1 FROM dbo.Products)
BEGIN
    DECLARE @luxury INT     = (SELECT Id FROM dbo.Categories WHERE Slug='luxury');
    DECLARE @occasions INT  = (SELECT Id FROM dbo.Categories WHERE Slug='occasions');
    DECLARE @nuts INT       = (SELECT Id FROM dbo.Categories WHERE Slug='nuts');
    DECLARE @truffles INT   = (SELECT Id FROM dbo.Categories WHERE Slug='truffles');
    DECLARE @corporate INT  = (SELECT Id FROM dbo.Categories WHERE Slug='corporate');
    DECLARE @cookies INT    = (SELECT Id FROM dbo.Categories WHERE Slug='cookies');
    DECLARE @custom INT     = (SELECT Id FROM dbo.Categories WHERE Slug='custom');

    INSERT dbo.Products
        (CategoryId, NameAr, NameEn, DescriptionAr, DescriptionEn, BasePrice, WeightNoteAr, WeightNoteEn,
         IsActive, IsBestSeller, IsNew, SortOrder)
    VALUES
    (@luxury, N'صندوق لحظة سعادة', N'Moment of Joy Box',
        N'تشكيلة مختارة من الشوكولاتة اليدوية معبأة بأناقة لتليق بأعز الناس.',
        N'A curated selection of handmade chocolate, elegantly boxed for the people you love.',
        220, N'لعبوة 250 جم', N'for a 250g box', 1, 1, 0, 1),

    (@luxury, N'صندوق الفخامة المذهب', N'Gilded Luxury Box',
        N'علبة فاخرة بلمسات ذهبية وتشكيلة برالين متنوعة.',
        N'A premium box with gold accents and an assorted praline selection.',
        340, N'لعبوة 300 جم', N'for a 300g box', 1, 0, 0, 2),

    (@luxury, N'صندوق VIP الحصري', N'Exclusive VIP Box',
        N'أرقى تشكيلاتنا: قطع مميزة وتغليف استثنائي.',
        N'Our finest assortment: signature pieces with exceptional packaging.',
        480, N'لعبوة 500 جم', N'for a 500g box', 1, 0, 1, 3),

    (@occasions, N'علبة قلوب الحب', N'Sweetheart Box',
        N'قلوب شوكولاتة محشوة، هدية مثالية للمناسبات الرومانسية.',
        N'Filled chocolate hearts — the perfect gift for romantic occasions.',
        260, N'لعبوة 300 جم', N'for a 300g box', 1, 0, 0, 4),

    (@occasions, N'صندوق عيد الأم', N'Mother''s Day Box',
        N'تشكيلة رقيقة مع كرت تهنئة مجاني للأم.',
        N'A delicate assortment with a free greeting card for Mom.',
        240, N'لعبوة 250 جم', N'for a 250g box', 1, 0, 0, 5),

    (@nuts, N'لوح الفول السوداني المقرمش', N'Crunchy Peanut Bar',
        N'لوح شوكولاتة بالحليب محشو بالفول السوداني المحمص.',
        N'Milk chocolate bar loaded with roasted peanuts.',
        95, N'لوح 150 جم', N'150g bar', 1, 0, 0, 6),

    (@nuts, N'مجموعة اللوز المحمص', N'Roasted Almond Selection',
        N'حبات لوز محمص مغلفة بشوكولاتة داكنة فاخرة.',
        N'Roasted almonds coated in premium dark chocolate.',
        210, N'لعبوة 250 جم', N'for a 250g box', 1, 0, 0, 7),

    (@truffles, N'ترافل التوت البري', N'Cranberry Truffles',
        N'ترافل بلجيكي بقلب التوت البري الحامض الحلو.',
        N'Belgian truffles with a sweet-tart cranberry center.',
        180, N'لعبوة 200 جم', N'for a 200g box', 1, 0, 0, 8),

    (@truffles, N'علبة ترافل مشكلة', N'Assorted Truffle Box',
        N'تشكيلة ترافل متنوعة النكهات: كيندر، لوتس، فيريرو، كراميل، فستق.',
        N'An assorted truffle box: Kinder, Lotus, Ferrero, Caramel, Pistachio.',
        260, N'لعبوة 300 جم', N'for a 300g box', 1, 1, 0, 9),

    (@corporate, N'هدية الشركات الفاخرة', N'Premium Corporate Gift',
        N'تشكيلة مخصصة لفريق العمل والعملاء بأسعار خاصة للكميات.',
        N'A custom assortment for teams and clients, with special bulk rates.',
        450, N'لعبوة 500 جم', N'for a 500g box', 1, 0, 0, 10),

    (@cookies, N'كوكيز شوكولاتة تشيب', N'Chocolate Chip Cookies',
        N'كوكيز طري بقطع شوكولاتة غنية.', N'Soft cookies with rich chocolate chunks.',
        60, N'القطعة', N'per piece', 1, 0, 0, 11),

    (@cookies, N'كوكيز لوتس', N'Lotus Cookies',
        N'كوكيز بكريمة اللوتس وطبقة بسكوت مطحون.', N'Cookies with Lotus spread and a crushed-biscuit top.',
        60, N'القطعة', N'per piece', 1, 0, 0, 12),

    (@cookies, N'كوكيز أوريو', N'Oreo Cookies',
        N'كوكيز بقطع الأوريو المقرمشة.', N'Cookies packed with crunchy Oreo pieces.',
        60, N'القطعة', N'per piece', 1, 0, 0, 13),

    (@cookies, N'كوكيز كيندر', N'Kinder Cookies',
        N'كوكيز بحشو كيندر بيوينو.', N'Cookies with a Kinder Bueno filling.',
        60, N'القطعة', N'per piece', 1, 0, 0, 14),

    (@custom, N'لوح شوكولاتة باسمك', N'Chocolate Bar With Your Name',
        N'لوح شوكولاتة منقوش بالاسم اللي تختاره، من غير مصاريف إضافية.',
        N'A chocolate bar engraved with the name you choose, at no extra cost.',
        120, N'لوح 100 جم', N'100g bar', 1, 0, 0, 15),

    (@custom, N'صندوق هدية بالاسم والشكل', N'Personalized Gift Box',
        N'اختار الاسم والشكل ونصنعها بإيدينا خصيصًا لمن تحب.',
        N'Choose a name and a shape — handmade to order just for them.',
        260, N'لعبوة 300 جم', N'for a 300g box', 1, 0, 0, 16);
END
GO

/* ---- Weight options for a few products (price varies by size) ---- */
IF NOT EXISTS (SELECT 1 FROM dbo.ProductWeightOptions)
BEGIN
    DECLARE @joy INT   = (SELECT Id FROM dbo.Products WHERE NameEn = N'Moment of Joy Box');
    DECLARE @assort INT= (SELECT Id FROM dbo.Products WHERE NameEn = N'Assorted Truffle Box');
    DECLARE @vip INT   = (SELECT Id FROM dbo.Products WHERE NameEn = N'Exclusive VIP Box');

    INSERT dbo.ProductWeightOptions (ProductId, LabelAr, LabelEn, Weight, Price, SortOrder) VALUES
    (@joy,    N'250 جم', N'250g', N'250g', 220, 1),
    (@joy,    N'500 جم', N'500g', N'500g', 400, 2),

    (@assort, N'200 جم', N'200g', N'200g', 180, 1),
    (@assort, N'300 جم', N'300g', N'300g', 260, 2),
    (@assort, N'600 جم', N'600g', N'600g', 480, 3),

    (@vip,    N'500 جم', N'500g', N'500g', 480, 1),
    (@vip,    N'1 كجم',  N'1kg',  N'1kg',  900, 2);
END
GO

/* ---- Flavours for the assorted truffle box ---- */
IF NOT EXISTS (SELECT 1 FROM dbo.ProductFlavors)
BEGIN
    DECLARE @assortF INT = (SELECT Id FROM dbo.Products WHERE NameEn = N'Assorted Truffle Box');
    IF @assortF IS NOT NULL
        INSERT dbo.ProductFlavors (ProductId, NameAr, NameEn, SortOrder) VALUES
        (@assortF, N'كيندر',   N'Kinder',    1),
        (@assortF, N'لوتس',    N'Lotus',     2),
        (@assortF, N'فيريرو',  N'Ferrero',   3),
        (@assortF, N'كراميل',  N'Caramel',   4),
        (@assortF, N'فستق',    N'Pistachio', 5);
END
GO

PRINT 'Seed data inserted.';
GO

/* ---- Quick verification ---- */
SELECT 'Categories' AS TableName, COUNT(*) AS Rows FROM dbo.Categories
UNION ALL SELECT 'Products', COUNT(*) FROM dbo.Products
UNION ALL SELECT 'ProductWeightOptions', COUNT(*) FROM dbo.ProductWeightOptions
UNION ALL SELECT 'DeliveryZones', COUNT(*) FROM dbo.DeliveryZones;
GO
