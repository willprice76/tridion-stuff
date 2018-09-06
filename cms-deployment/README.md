# cms-deployment

Here are two scripts you can use to integrate deployment of the CMS side of DXA Modules into your application deployment automation

To use these scripts, place them on your CMS server, and add a lib folder with the following contents (you can get this from the DXA install):

* ContentManagerUtils.ps1
* Tridion.Common.dll
* Tridion.ContentManager.CoreService.Client.dll
* Tridion.ContentManager.ImportExport.Client.dll
* Tridion.ContentManager.ImportExport.Common.dll

Adjust the file locations in the scripts to suit your deployment process/tooling


