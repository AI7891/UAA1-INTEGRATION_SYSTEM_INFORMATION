-- =============================================
-- 0. Création de la base de données
-- =============================================
CREATE DATABASE EvalDevUAA1;
GO

USE EvalDevUAA1;
GO

-- =============================================
-- 1. Création des Tables
-- =============================================
CREATE TABLE Brand (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Logo VARBINARY(MAX) NULL
);

CREATE TABLE Category (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL
);

CREATE TABLE Product (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(150) NOT NULL,
    EAN13 CHAR(13) NOT NULL UNIQUE,
    BrandId INT NOT NULL,
    CONSTRAINT FK_Product_Brand FOREIGN KEY (BrandId) REFERENCES Brand(Id)
);

CREATE TABLE ProductCategory (
    ProductId INT NOT NULL,
    CategoryId INT NOT NULL,
    CONSTRAINT PK_ProductCategory PRIMARY KEY (ProductId, CategoryId),
    CONSTRAINT FK_PC_Product FOREIGN KEY (ProductId) REFERENCES Product(Id),
    CONSTRAINT FK_PC_Category FOREIGN KEY (CategoryId) REFERENCES Category(Id)
);

CREATE TABLE HistoryPrice (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ProductId INT NOT NULL,
    Price DECIMAL(18, 2) NOT NULL,
    EffectiveDate DATETIME NOT NULL,
    CONSTRAINT FK_HistoryPrice_Product FOREIGN KEY (ProductId) REFERENCES Product(Id)
);

CREATE TABLE Review (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ProductId INT NOT NULL,
    Rating TINYINT CHECK (Rating BETWEEN 1 AND 5),
    Comment NVARCHAR(MAX),
    CreationDate DATETIME NOT NULL,
    CONSTRAINT FK_Review_Product FOREIGN KEY (ProductId) REFERENCES Product(Id)
);

-- =============================================
-- 2. Insertion des données (Identity Seed Fixe)
-- =============================================
DECLARE @RefDate DATETIME = DATEADD(MONTH, -1, GETDATE());

-- Marques
SET IDENTITY_INSERT Brand ON;
INSERT INTO Brand (Id, Name) 
 VALUES (1, 'Alpha Corp'), (2, 'Sigma Industries');
SET IDENTITY_INSERT Brand OFF;

-- Catégories
SET IDENTITY_INSERT Category ON;
INSERT INTO Category (Id, Name)
 VALUES (1, 'Électronique'), (2, 'Maison'), (3, 'Bureau');
SET IDENTITY_INSERT Category OFF;

-- Produits
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, Name, EAN13, BrandId)
 VALUES (1, 'Ecran 27 pouces', '3401234567890', 1),
        (2, 'Clavier Mécanique', '3401234567891', 1),
        (3, 'Chaise Ergonomique', '3401234567892', 2);
SET IDENTITY_INSERT Product OFF;

-- Relations entre Produit et Catégorie
INSERT INTO ProductCategory (ProductId, CategoryId) 
 VALUES (1, 1), (1, 3), (2, 1), (2, 3), (3, 2), (3, 3);

-- Historique des Prix
SET IDENTITY_INSERT HistoryPrice ON;
INSERT INTO HistoryPrice (Id, ProductId, Price, EffectiveDate)
 VALUES (1, 1, 299.99, DATEADD(YEAR, -1, @RefDate)),
        (2, 1, 279.00, @RefDate),
        (3, 2, 89.50, DATEADD(MONTH, -6, @RefDate)),
        (4, 3, 150.00, DATEADD(YEAR, -1, @RefDate));
SET IDENTITY_INSERT HistoryPrice OFF;

-- Avis
SET IDENTITY_INSERT Review ON;
INSERT INTO Review (Id, ProductId, Rating, Comment, CreationDate) 
 VALUES (1, 1, 5, 'Excellent produit, conforme aux attentes.', DATEADD(DAY, 15, @RefDate)),
        (2, 3, 4, 'Confortable mais montage complexe.', DATEADD(MONTH, -2, @RefDate));
SET IDENTITY_INSERT Review OFF;