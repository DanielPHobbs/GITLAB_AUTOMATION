DECLARE @BaseName nvarchar(100), @Extension NVARCHAR(10), @Name NVARCHAR(100), @DirectoryName NVARCHAR(100) ,@Creationdate Datetime, @LastWriteTime DateTime

/*
set @BaseName = '2.0_RB1_test 6'
set @Extension = '.sql'
set @Name = '2.0_RB1_test 3.sql'
set @DirectoryName = '.\\dteksrv2022\filedrop'
set @Creationdate = '12 April 2022 13:11:01'
set @LastWriteTime = '19 April 2022 15:00:10'
*/

--Pipeline Data
set @BaseName = '<>'
set @Extension = '<>'
set @Name = '<>'
set @DirectoryName = '<>'
set @Creationdate = '<>'
set @LastWriteTime = '<>'

INSERT INTO [GitLab_Automation].[dbo].[FileWatchData]
            (BaseName, 
            Extension, 
            Name, 
            DirectoryName, 
            creationtime, 
            LastWriteTime,
			IsNew
            )
    SELECT @BaseName,
           @Extension,
           @Name,
           @DirectoryName,
           @Creationdate,
           @LastWriteTime,
		   IsNew = 1
                
    ---Only insert if this clause is valid -- 
    WHERE NOT EXISTS
        (SELECT 1
         FROM [FileWatchData]
         WHERE LastWriteTime >= @LastWriteTime
		 AND name = @Name
		 )
