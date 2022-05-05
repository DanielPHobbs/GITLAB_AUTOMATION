DECLARE @json NVARCHAR(MAX);
SET @json = N'[
    {
        "Name":  "2.0_RB1_Export-SCO-Tests.ois_export",
        "BaseName":  "2.0_RB1_Export-SCO-Tests",
        "Extension":  ".ois_export",
        "DirectoryName":  "\\\\DTEKSRV2022\\FileDrop",
        "CreationTime":  "\/Date(1649765538853)\/",
        "LastWriteTime":  "\/Date(1645610252517)\/"
    },
    {
        "Name":  "2.0_RB1_test 1.sql",
        "BaseName":  "2.0_RB1_test 1",
        "Extension":  ".sql",
        "DirectoryName":  "\\\\DTEKSRV2022\\FileDrop",
        "CreationTime":  "\/Date(1649765485485)\/",
        "LastWriteTime":  "\/Date(1649764809921)\/"
    },
    {
        "Name":  "2.0_RB1_test 2.sql",
        "BaseName":  "2.0_RB1_test 2",
        "Extension":  ".sql",
        "DirectoryName":  "\\\\DTEKSRV2022\\FileDrop",
        "CreationTime":  "\/Date(1649765391362)\/",
        "LastWriteTime":  "\/Date(1649764809921)\/"
    },
    {
        "Name":  "2.0_RB1_test 3.sql",
        "BaseName":  "2.0_RB1_test 3",
        "Extension":  ".sql",
        "DirectoryName":  "\\\\DTEKSRV2022\\FileDrop",
        "CreationTime":  "\/Date(1649765461287)\/",
        "LastWriteTime":  "\/Date(1649764809921)\/"
    }
]';

--Create Temp table
If OBJECT_ID (N'tempdb..#Tempdata') is not null drop table [#TempData]
Create Table [#TempData] ([BaseName] nvarchar (50), [Extension] nvarchar (10), [Name] nvarchar (50),[DirectoryName] nvarchar (100),[CreationTime] nvarchar (50),[LastWriteTime] nvarchar (50))

--Insert into Temp table
INSERT INTO [#TempData]
            (BaseName, 
            Extension, 
            Name, 
            DirectoryName, 
            creationtime, 
            LastWriteTime
            )
SELECT *

FROM OPENJSON(@json)
  WITH (
    BaseName NVARCHAR(50) '$.BaseName',
    Extension NVARCHAR(10) '$.Extension',
    Name NVARCHAR(50) '$.Name',
    DirectoryName NVARCHAR(100) '$.DirectoryName',
    CreationTime nvarchar (50) '$.CreationTime',
    LastWriteTime nvarchar (50) '$.LastWriteTime'
	)

--remove unwanted characters from JSON epoch time
UPDATE [#TempData]
SET CreationTime = REPLACE(REPLACE(CreationTime, '/Date(', ''),')/','')
WHERE CreationTime is not Null
UPDATE [#TempData]
SET LastWriteTime = REPLACE(REPLACE(LastWriteTime, '/Date(', ''),')/','')
WHERE CreationTime is not Null

ALTER TABLE [#TempData] 
ALTER COLUMN CreationTime BIGINT;
ALTER TABLE [#TempData] 
ALTER COLUMN LastWriteTime BIGINT

select * from  [#TempData]

--convert from JSON epoch time to Datetime string

Declare @creationTime DateTime;
Declare @LastWriteTime DateTime;
Select
@creationTime=TRY_CAST(DATEADD(s, CAST(RIGHT(creationTime,3) AS BIGINT),DATEADD(s, creationTime / 1000, '1970-01-01')) AS DATETIME2(3))
from [#TempData]
Where creationTime is not Null

SELECT 
@LastWriteTime=TRY_CAST(DATEADD(s, CAST(RIGHT(LastWriteTime,3) AS BIGINT),DATEADD(s, LastWriteTime / 1000, '1970-01-01')) AS DATETIME2(3)) 
from [#TempData]
Where LastWriteTime is not Null


--Update [#TempData]
--SET
--creationTime=@creationTime,
--LastWriteTime=@LastWriteTime



-- Write new Data to production Table [dbo.Filewatch]

--remove Tempdb datatable
--If OBJECT_ID (N'tempdb..#Tempdata') is not null drop table [#TempData]

