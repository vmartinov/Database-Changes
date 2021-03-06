USE [PRAXIS]
GO
/****** Object:  UserDefinedFunction [dbo].[GetDbas]    Script Date: 10/8/2015 8:58:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Function [dbo].[GetDbas]
(
	@BusinessID int
)
Returns nvarchar(MAX)
As
Begin
	Declare @ReturnValue As nvarchar(MAX)

	Select 
		@ReturnValue = Substring(BusinessDBAs, 0, Len(BusinessDBAs)) -- Remove the trailing comma
	From 
	(
		Select
			(
				Select 
					LTRIM(RTRIM(dba.Name)) + '; '
				From Bellevue.Business b
					Inner Join Bellevue.DBA dba On b.BusinessID = dba.BusinessID And dba.Active = 1
				Where b.BusinessId = b1.BusinessId
				Group By dba.Name
				For Xml Path('')
			) As BusinessDBAs
		From Bellevue.Business b1
		Where b1.BusinessId = @BusinessID
		Group By b1.BusinessId, b1.Name
	) As Business
	
	Return @ReturnValue
End

