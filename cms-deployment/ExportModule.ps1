<#
.SYNOPSIS
   Export DXA Module zip from CMS
.DESCRIPTION
   For CI/CD integration - Export of CMS items related to a DXA Module version/release from target CMS server
.EXAMPLE
   & .\ExportModule.ps1 -cmsUrl "http://tridion-development/" -moduleName "myModule" -moduleVersion "1.2.345" -sourcePublication "200 DXA Modules"
.INPUTS
   cmsUrl, moduleName, moduleVersions, sourcePublication
#>

[CmdletBinding( SupportsShouldProcess=$true, PositionalBinding=$false)]
param (
    [Parameter(Mandatory=$true, HelpMessage="CMS URL - eg http://svbcms-o.svb.org/")]
    [string]$cmsUrl,
    [Parameter(Mandatory=$true, HelpMessage="Module name")]
    [string]$moduleName,
    [Parameter(Mandatory=$true, HelpMessage="Module version")]
    [string]$moduleVersion,
    # Title of CMS publication where the release bundle is located
    [Parameter(Mandatory=$false, HelpMessage="Source publication")]
    [string]$sourcePublication = "100 Master",
    
    # By default, the current Windows user's credentials are used, but it is possible to specify alternative credentials:
    [Parameter(Mandatory=$false, HelpMessage="CMS User name")]
    [string]$cmsUserName,
    [Parameter(Mandatory=$false, HelpMessage="CMS User password")]
    [string]$cmsUserPassword,
    [Parameter(Mandatory=$false, HelpMessage="CMS Authentication type")]
    [ValidateSet("Windows", "Basic")]
    [string]$cmsAuth = "Windows"
)

#Terminate script on first occurred exception
$ErrorActionPreference = "Stop"

#Include functions from ContentManagerUtils.ps1 - this is copied from DXA standard install 
$importExportFolder = "F:\Apps\DeploymentRemote\lib"
. (Join-Path $importExportFolder "ContentManagerUtils.ps1")

#Change this to be the location where your build tool will
$targetFile = "F:\Apps\DeploymentRemote\Export\$moduleName-CMP-$moduleVersion.zip"

#Initialization
$IsInteractiveMode = !((gwmi -Class Win32_Process -Filter "ProcessID=$PID").commandline -match "-NonInteractive") -and !$NonInteractive

#Format data
$cmsUrl = $cmsUrl.TrimEnd("/") + "/"
$tempFolder = Get-TempFolder "Test"

# Standard functions from DXA script: ContentManagerUtils.ps1
Initialize-ImportExport $importExportFolder $tempFolder
# Assumption is that you create a Release Bundles folder under Building Blocks root folder
$bundleId = Encode-Webdav "$sourcePublication/Building Blocks/Release Bundles/$moduleName"
$simpleSelection = New-Object  Tridion.ContentManager.ImportExport.SubtreeSelection $bundleId,$false
$selections = @($simpleSelection)
$exportInstruction = New-Object Tridion.ContentManager.ImportExport.ExportInstruction
$exportInstruction.BluePrintMode = [Tridion.ContentManager.ImportExport.BluePrintMode]::ExportSharedItemsFromOwningPublication
$exportInstruction.ExpandDependenciesOfTypes = [Tridion.ContentManager.ImportExport.DependencyType[]]@()
Export-CmPackage $targetFile $selections $exportInstruction

