USE [IDM_EXTENSION]
GO
EXEC sys.sp_addextendedproperty @name=N'M365_Licence_operations', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'M365_Licence_Operations'
GO
