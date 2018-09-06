<#
.SYNOPSIS
   Import DXA Module zip into CMS
.DESCRIPTION
   For CI/CD integration - Import of CMS items related to a DXA Module version/release on target CMS server
.EXAMPLE
   & .\ExportModule.ps1 -cmsUrl "http://tridion-production/" -moduleName "myModule" -moduleVersion "1.2.345" 
.INPUTS
   cmsUrl, moduleName, moduleVersions
#>

[CmdletBinding( SupportsShouldProcess=$true, PositionalBinding=$false)]
param (
    
    [Parameter(Mandatory=$true, HelpMessage="CMS URL - eg http://svbcms-o/")]
    [string]$cmsUrl,
    [Parameter(Mandatory=$true, HelpMessage="Module name - eg svbnl-basis")]
    [string]$moduleName,
    [Parameter(Mandatory=$true, HelpMessage="Module version - eg 1.2.345")]
    [string]$moduleVersion,
    # By default, the current Windows user's credentials are used, but it is possible to specify alternative credentials:
    [Parameter(Mandatory=$false, HelpMessage="CMS User name")]
    [string]$cmsUserName,
    [Parameter(Mandatory=$false, HelpMessage="CMS User password")]
    [string]$cmsUserPassword,
    [Parameter(Mandatory=$false, HelpMessage="CMS Authentication type")]
    [ValidateSet("Windows", "Basic")]
    [string]$cmsAuth = "Windows"
)
Try{
    #Terminate script on first occurred exception
    $ErrorActionPreference = "Stop"

    #Include functions from ContentManagerUtils.ps1 - this is copied from DXA standard install 
    $importExportFolder = "F:\Apps\DeploymentRemote\lib"
    . (Join-Path $importExportFolder "ContentManagerUtils.ps1")

    #Update this to a location where your Deployment tool copies the zip
    $targetFile = "F:\Apps\DeploymentRemote\ImportScript\$moduleName-CMP-$moduleVersion.zip"

    #Initialization
    $distSource = Join-Path (Split-Path $MyInvocation.MyCommand.Path) "\"
    $distSource = $distSource.TrimEnd("\") + "\"
    $IsInteractiveMode = !((gwmi -Class Win32_Process -Filter "ProcessID=$PID").commandline -match "-NonInteractive") -and !$NonInteractive
    $tempFolder = Get-TempFolder "Test"
    $cmsUrl = $cmsUrl.TrimEnd("/") + "/"

    #Standard functions from DXA script: ContentManagerUtils.ps1
    Initialize-ImportExport $importExportFolder $tempFolder
    Import-CmPackage $targetFile $tempFolder
}
Catch{
    Write-host "Error Importing:"
    $host.SetShouldExit(666)
	Write-host $error[0]
}