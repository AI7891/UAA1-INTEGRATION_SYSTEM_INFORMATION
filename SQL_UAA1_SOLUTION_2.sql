USE EvalDevUAA1
GO

DECLARE @JASON_CONTENT NVARCHAR(MAX)

SELECT @JASON_CONTENT = BulkColumn
FROM OPENROWSET (BULK 'C:\reviews-data.json', SINGLE_CLOB) AS J; 

INSERT INTO [dbo].[Review]([ProductId],[Rating],[Comment],[CreationDate]) 
SELECT *
	FROM OPENJSON(@JASON_CONTENT)

	WITH
	(
		PRODUCT_ID INT '$.ProductId',
		RATING INT '$.Rating',
		COMMENT NVARCHAR(250) '$.Comment',
		CREATION_DATE DATETIME '$.CreationDate'
	)	

GO
CREATE VIEW V_PRODUCT_AND_CATEGORY
AS
SELECT *
FROM
[dbo].[Product] P 
JOIN
[dbo].[Review] R ON R.Id = P.Id 
