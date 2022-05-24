/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [FileIndex]
      ,[BaseName]
      ,[Extension]
      ,[Name]
      ,[DirectoryName]
      ,[creationtime]
      ,[LastWriteTime]
      ,[IsNew]
      ,[IsProcessed]
      ,[RowInserted]
  FROM [GitLab_Automation].[dbo].[FileWatchData]

  --delete from [GitLab_Automation].[dbo].[FileWatchData]