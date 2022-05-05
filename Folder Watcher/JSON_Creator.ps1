 clear-host
 
 $BaseName = '2.0_RB1_test 6'
 $Extension = '.sql'
 $Name = '2.0_RB1_test 3.sql'
 $DirectoryName = '.\\dteksrv2022\filedrop'
 $CreationTime = '12 April 2022 13:11:01'
 $LastWriteTime = '19 April 2022 15:00:10'

$json = @"
[
    {
"BaseName": $BaseName,
"Extension": $Extension,
"Name": $Name,
"DirectoryName": $DirectoryName,
"CreationTime": $CreationTime,
"LastWriteTime": "$LastWriteTime"
}
]
"@
$JSON 

#-----------------------------------------

$service = get-service | where-object {$_.name -like 'win*'} | select-object name, status, displayname
 
convertto-json $service

#------------------------------------------
$folderPath = '\\DTEKSRV2022\FileDrop\'

$fileLoad = Get-ChildItem $folderPath | Select-Object Name, BaseName , Extension, DirectoryName, CreationTime, LastWriteTime

convertto-json $fileload 


# https://docs.microsoft.com/en-us/sql/relational-databases/json/json-data-sql-server?view=sql-server-ver15