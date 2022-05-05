############################################################################
#Project: Creating a Simple XML Document using XmlWriter()
#Developer: Thiyagu S (dotnet-helpers.com)
#Tools : PowerShell 5.1.15063.1155 [irp]
#E-Mail: mail2thiyaguji@gmail.com 
###########################################################################
 
# Create & Set The Formatting with XmlWriterSettings class
$xmlObjectsettings = New-Object System.Xml.XmlWriterSettings
$xmlObjectsettings.Indent = $true
$xmlObjectsettings.IndentChars = "    "
 
# Set the File path & Create The Document
$XmlFilePath = "C:\dotnet-helpers\MyXmlFile.xml"
$XmlObjectWriter = [System.XML.XmlWriter]::Create($XmlFilePath, $xmlObjectsettings)
 
# Write the XML declaration and set the XSL
$XmlObjectWriter.WriteStartDocument()
 
 
# Start the Root Element and build with child nodes
$XmlObjectWriter.WriteComment("FileWatcher File Properties XML generator.")
$XmlObjectWriter.WriteStartElement("Directory Files") 
  
    $XmlObjectWriter.WriteStartElement("$FileIndex") 
 
        $XmlObjectWriter.WriteElementString("BaseName","$BaseName")
        $XmlObjectWriter.WriteElementString("Extension","$Extension")
        $XmlObjectWriter.WriteElementString("Name","$Name")
        $XmlObjectWriter.WriteElementString("DirectoryName","$DirectoryName")
        $XmlObjectWriter.WriteElementString("CreationTime","$CreationTime")
        $XmlObjectWriter.WriteElementString("LaswriteTime","$LaswriteTime")

    $XmlObjectWriter.WriteEndElement() # <-- End ConfigSettings




$XmlObjectWriter.WriteEndElement() # <-- End BaseSettings 
$XmlObjectWriter.WriteEndDocument()
$XmlObjectWriter.Flush()
$XmlObjectWriter.Close()

#$XmlObjectWriter.WriteStartElement("ChildConfigSettings") # <-- Start ChildConfigSettings 
            #$XmlObjectWriter.WriteElementString("UK","250$")
            #$XmlObjectWriter.WriteEndElement() # <-- End ChildConfigSettings


#---------------------------------------------------

$folderPath = '\\DTEKSRV2022\FileDrop\'

$fileLoad = Get-ChildItem $folderPath | Select-Object Name, BaseName , Extension, DirectoryName, CreationTime, LastWriteTime

ConvertTo-Xml $fileload 

#---------------------------------------------------