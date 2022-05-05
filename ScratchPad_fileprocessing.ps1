#------ File Format scripts ----



#$filename ='2.0_RB1_SQLSP1.sql'
$Filename='2.0_RB1_DOSOMETHING1.ois_export'
if ($filename -cmatch '\.[^.]+$') {
  $extension = $matches[0]
}
$extension

#https://extendsclass.com/regex-tester.html



#### --- Works ok ----
$file="2.0_RB1_SQL1_SP2.sql"

[regex]$reg='^\d{1}\.\d{1}_[a-zA-Z0-9]{1,10}_[a-zA-Z0-9]{1,10}_[a-zA-Z0-9]{1,10}\.sql'

If (($reg.match($file)).Success -eq $True) { Write-output "it Matches"} else {Write-output "it doesnt Match"}




$files = Get-ChildItem "C:\users\proxb\downloads\TEMP" | Where-Object {$_.PSIsContainer -eq $False}
[regex]$reg = "^\d{8}_[a-zA-Z]{3,4}_[a-zA-Z]{1}\.jpg"
ForEach ($file in $files) {
  If (($reg.match($file)).Success -eq $True) {
    $newname = [string]($file.name).ToLower()
    Rename-Item $file.fullname -NewName $newname
    Move-Item -path "$($file.directory)\$newname" -Destination "$FTP\Goodlocation" 
    }
  Else {
    #Attempt to clean out spaces in file name if exists
    $newname = ($file.name).replace(" ","")
    $newname = $newname.ToLower()
    Rename-Item $file.fullname -NewName $newname
    If (($reg.match($newname)).Success -eq $True) {
        Move-Item -path "$($file.directory)\$newname" -Destination "$FTP\Goodlocation" 
        }
    Else {
        Move-Item -path "$($file.directory)\$newname" -Destination "$FTP\Exceptions" 
        }        
    }    
  }