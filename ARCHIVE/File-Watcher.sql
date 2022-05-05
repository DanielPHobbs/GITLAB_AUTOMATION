/*
    Return File Attributes about a single file.

WARNING: Uses the sp_OACreate method, which should be SA use only.

(Note: much of this is copied from Jeff Moden's routines)

TEST:
  SELECT * FROM pps.fnFileInfo('C:\install.exe')

*/
ALTER FUNCTION [pps].[fnFileInfo]( @FileName As VARCHAR(255) )
RETURNS @FileInfo TABLE
(
    RowNum           INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    Name             VARCHAR(128), --File Name and Extension
    Path             VARCHAR(128), --Full path including file name
    ShortName        VARCHAR(12),  --8.3 file name
    ShortPath        VARCHAR(100), --8.3 full path including file name
    DateCreated      DATETIME,     --Date file was created
    DateLastAccessed DATETIME,     --Date file was last read
    DateLastModified DATETIME,     --Date file was last written to
    Attributes       INT,          --Read only, Compressed, Archived
    ArchiveBit       AS CASE WHEN Attributes&  32=32   THEN 1 ELSE 0 END,
    CompressedBit    AS CASE WHEN Attributes&2048=2048 THEN 1 ELSE 0 END,
    ReadOnlyBit      AS CASE WHEN Attributes&   1=1    THEN 1 ELSE 0 END,
    Size             INT,          --File size in bytes
    Type             VARCHAR(100)  --Long Windows file type (eg.'Text Document',etc)
) As
BEGIN
    Declare @CurrentName As Varchar(255); SET @CurrentName = @FileName;
    DECLARE @ObjFile          INT          --File object
    DECLARE @ObjFileSystem    INT          --File System Object  

    --===== Create a file system object and remember the "handle"
    EXEC dbo.sp_OACreate 'Scripting.FileSystemObject', @ObjFileSystem OUT

    --===== These variable names match the sp_OAGetProperty options
    DECLARE @Attributes       INT          --Read only, Hidden, Archived, etc, as a bit map
    DECLARE @DateCreated      DATETIME     --Date file was created
    DECLARE @DateLastAccessed DATETIME     --Date file was last read (accessed)
    DECLARE @DateLastModified DATETIME     --Date file was last written to
    DECLARE @Name             VARCHAR(128) --File Name and Extension
    DECLARE @Path             VARCHAR(128) --Full path including file name
    DECLARE @ShortName        VARCHAR(12)  --8.3 file name
    DECLARE @ShortPath        VARCHAR(100) --8.3 full path including file name
    DECLARE @Size             INT          --File size in bytes
    DECLARE @Type             VARCHAR(100) --Long Windows file type (eg.'Text Document',etc)

    --===== Create an object for the path/file and remember the "handle"
    EXEC dbo.sp_OAMethod @ObjFileSystem,'GetFile', @ObjFile OUT, @CurrentName

    --===== Get the all the required attributes for the file itself
    EXEC dbo.sp_OAGetProperty @ObjFile, 'Path',             @Path             OUT
    EXEC dbo.sp_OAGetProperty @ObjFile, 'ShortPath',        @ShortPath        OUT
    EXEC dbo.sp_OAGetProperty @ObjFile, 'Name',             @Name             OUT
    EXEC dbo.sp_OAGetProperty @ObjFile, 'ShortName',        @ShortName        OUT
    EXEC dbo.sp_OAGetProperty @ObjFile, 'DateCreated',      @DateCreated      OUT
    EXEC dbo.sp_OAGetProperty @ObjFile, 'DateLastAccessed', @DateLastAccessed OUT
    EXEC dbo.sp_OAGetProperty @ObjFile, 'DateLastModified', @DateLastModified OUT
    EXEC dbo.sp_OAGetProperty @ObjFile, 'Attributes',       @Attributes       OUT
    EXEC dbo.sp_OAGetProperty @ObjFile, 'Size',             @Size             OUT
    EXEC dbo.sp_OAGetProperty @ObjFile, 'Type',             @Type             OUT

    --===== Insert the file details into the return table        
    INSERT INTO @FileInfo
           (Path, ShortPath, Name, ShortName, DateCreated, 
            DateLastAccessed, DateLastModified, Attributes, Size, Type)
    SELECT @Path,@ShortPath,@Name,@ShortName,@DateCreated, 
        @DateLastAccessed,@DateLastModified,@Attributes,@Size,@Type

    --===== House keeping, destroy and drop the file objects to keep memory leaks from happening
    EXEC sp_OADestroy @ObjFileSystem
    EXEC sp_OADestroy @ObjFile

    RETURN
END