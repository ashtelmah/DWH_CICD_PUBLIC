SET NOCOUNT ON;

USE SSISDB;

/* 1. Check current SQL Server */
PRINT '';
PRINT '1. SQL SERVER';

SELECT
    @@SERVERNAME AS ServerName,
    SERVERPROPERTY('ProductVersion') AS ProductVersion,
    SERVERPROPERTY('ProductLevel') AS ProductLevel,
    SERVERPROPERTY('Edition') AS Edition;

/* 2. List all SSISDB folders */

SELECT DISTINCT
    name AS FolderName
FROM catalog.folders
ORDER BY name;


/* 3. Show Folder -> Project -> Package */

DECLARE @FolderName NVARCHAR(128) = 'Accounts';

PRINT '';
PRINT '3. SSIS PROJECTS AND PACKAGES';
PRINT 'Folder: ' + @FolderName;

SELECT
    f.name AS FolderName,
    p.name AS ProjectName,
    pk.name AS PackageName
FROM catalog.folders f
INNER JOIN catalog.projects p
    ON p.folder_id = f.folder_id
INNER JOIN catalog.packages pk
    ON pk.project_id = p.project_id
WHERE f.name = @FolderName
ORDER BY
    p.name,
    pk.name;