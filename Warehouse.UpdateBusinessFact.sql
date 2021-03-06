USE [PRAXIS_STAGING]
GO
/****** Object:  StoredProcedure [Warehouse].[UpdateBusinessFact]    Script Date: 10/8/2015 8:53:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [Warehouse].[UpdateBusinessFact]
	
AS
BEGIN
	
	BEGIN TRAN

	DECLARE @Physical INT = 1
	DECLARE @Mailing INT = 2
	Declare @BusinessRegistration INT = 1

	TRUNCATE TABLE Warehouse.BusinessFact

	INSERT INTO Warehouse.BusinessFact
	(BusinessId,
	 BusinessName,
	 LegalEntityName,
	 Dba,
	 Ubi,
	 FirstActivityDate,
	 CancelDate,
	 LegalEntityType,
	 Naic,
	 ProductsAndServices,
	 FilingFrequency)
	SELECT DISTINCT
	 b.BusinessId,
	 LTRIM(RTRIM(b.Name)),
	 LTRIM(RTRIM(le.Name)),
	 [dbo].[GetDbas](b.BusinessId),
	 le.UBI + ISNULL(b.BusinessUBI, '') + ISNULL(b.LocationUBI, ''),
	 CONVERT(NVARCHAR, b.FirstActivityDate, 101),
	 CONVERT(NVARCHAR, l.CancelDate, 101),
	 let.Description,
	 b.NAIC,
	 LTRIM(RTRIM(b.ProductsAndServices)),
	 (SELECT TOP 1 fft.FilingFrequency FROM Bellevue.FilingFrequency ff 
		INNER JOIN dbo.FilingFrequencyType fft ON ff.FilingFrequencyTypeId = fft.FilingFrequencyTypeId ORDER BY ff.StartDate DESC) AS FilingFrequency
	FROM Bellevue.Business b
	--INNER JOIN Bellevue.FilingFrequency ff ON b.BusinessID = ff.BusinessId --AND GETDATE() BETWEEN ff.StartDate AND ff.EndDate --DATEADD (year , -1 , GETDATE() )
	--INNER JOIN dbo.FilingFrequencyType fft ON ff.FilingFrequencyTypeId = fft.FilingFrequencyTypeId
	INNER JOIN Bellevue.LegalEntity le ON b.LegalEntityID = le.LegalEntityID
	INNER JOIN Bellevue.License l ON b.BusinessID = l.BusinessID AND l.LicenseTypeID = @BusinessRegistration
	LEFT JOIN dbo.LegalEntityType let ON le.LegalEntityTypeID = let.LegalEntityTypeID
	WHERE l.IssueDate IS NOT NULL
	--ORDER BY LTRIM(RTRIM(b.Name))


	UPDATE b
	SET 
		b.FilingFrequency = fft.FilingFrequency
	FROM Warehouse.BusinessFact b
	INNER JOIN Bellevue.FilingFrequency ff ON b.BusinessID = ff.BusinessId AND GETDATE() BETWEEN ff.StartDate AND ff.EndDate
	INNER JOIN dbo.FilingFrequencyType fft ON ff.FilingFrequencyTypeId = fft.FilingFrequencyTypeId
	
	UPDATE b
	SET 
		b.PhysicalAddressId = a.AddressID,
		b.PhysicalAddressLine1 = a.AddressLine1,
		b.PhysicalAddressLine2 = a.AddressLine2,
		b.PhysicalCity = a.City,
		b.PhysicalState =  
				CASE WHEN a.StateID IS NULL THEN a.Province
				ELSE u.Name
				END,
		b.PhysicalPostalCode = a.PostalCode,
		b.PhysicalZip4 = a.Zip4
	FROM Warehouse.BusinessFact b
	INNER JOIN Bellevue.BusinessAddress ba ON b.BusinessId = ba.BusinessID
	INNER JOIN Bellevue.Address a ON ba.AddressID = a.AddressID
	LEFT JOIN dbo.USStates u ON a.StateID = u.StateID
	WHERE a.Retired = 0 AND a.AddressTypeID = @Physical

	UPDATE b
	SET 
		b.MailingAddressId = a.AddressID,
		b.MailingAddressLine1 = a.AddressLine1,
		b.MailingAddressLine2 = a.AddressLine2,
		b.MailingCity = a.City,
		b.MailingState =  
				CASE WHEN a.StateID IS NULL THEN a.Province
				ELSE u.Name
				END,
		b.MailingPostalCode = a.PostalCode,
		b.MailingZip4 = a.Zip4
	FROM Warehouse.BusinessFact b
	INNER JOIN Bellevue.BusinessAddress ba ON b.BusinessId = ba.BusinessID
	INNER JOIN Bellevue.Address a ON ba.AddressID = a.AddressID
	LEFT JOIN dbo.USStates u ON a.StateID = u.StateID
	WHERE a.Retired = 0 AND a.AddressTypeID = @Mailing

	
	COMMIT TRAN

END
