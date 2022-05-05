SELECT 
       [Path] as path
	   --[id]
FROM [Orchestrator2022].[Microsoft.SystemCenter.Orchestrator].[Folders]

--ROOT folders 
--Where ParentID = '00000000-0000-0000-0000-000000000000'
FOR JSON AUTO
--FOR XML AUTO
GO


--Layer1 folders
SELECT 
       [Path] as Layer1
FROM [Orchestrator2022].[Microsoft.SystemCenter.Orchestrator].[Folders]

Where ParentID = 'B42D7500-9C58-4ECE-9BB9-6A78CA0458D1' OR ParentID = '8A44C9FC-37AD-470D-8D06-C9ABDDADC8D9'


--Layer2 folders

FOR JSON AUTO
--FOR XML AUTO
GO