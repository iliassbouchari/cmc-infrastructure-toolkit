<#
.SYNOPSIS
    Remove-Office365.ps1 - Complete removal of Microsoft 365 (Click-to-Run) in four phases.

.DESCRIPTION
    Used on machines where Office 365 came pre-installed but unlicensed, before
    deploying a licensed Office 2016 by GPO. Phases:
      1. Stop the ClickToRun service and every running Office process
      2. Uninstall with the Office Deployment Tool (ODT) and an uninstall XML
      3. Remove residual Appx packages (Store OneNote survives the main uninstall)
      4. Clean the Office registry keys

.NOTES
    Source  : Rapport_Stage_CMC.pdf, chapter 4.3 (PDF p. 10-11), script "delete-365.ps1".
    Authors : Iliass Bouchari & Mohamed Zegui (CMC Casablanca-Settat internship)
    WARNING : LAB-ONLY. This force-closes Office, uninstalls it and deletes registry keys.
              Test in a lab VM first, never on a production machine. Run elevated.
    Note    : The report names an "uninstall.xml" ODT configuration but does not show it.
              Provide your own file in the working directory (this repo does not include one).
    Sanitized: \\SRV-DC01\apps\ODT\ is a placeholder share.
    Safe test: supports -WhatIf for the cmdlets below (Stop-Service, Stop-Process,
               Start-Process, Remove-AppxPackage, Remove-Item).

.EXAMPLE
    .\Remove-Office365.ps1 -WhatIf
#>
[CmdletBinding(SupportsShouldProcess)]
param()

# Phase 1 : Arrêt des services et processus Office
Stop-Service "ClickToRunSvc" -Force -ErrorAction SilentlyContinue
$officeProcs = @("WINWORD","EXCEL","POWERPNT","OUTLOOK","ONENOTE","MSACCESS")
$officeProcs | ForEach-Object { Stop-Process -Name $_ -Force -EA SilentlyContinue }

# Phase 2 : Désinstallation via ODT
$odtPath = "\\SRV-DC01\apps\ODT\setup.exe"
Start-Process $odtPath -ArgumentList "/configure uninstall.xml" -Wait

# Phase 3 : Nettoyage OneNote Appx
Get-AppxPackage -AllUsers "*OneNote*" | Remove-AppxPackage -ErrorAction SilentlyContinue

# Phase 4 : Nettoyage Registre
$regPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Office",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Office"
)
$regPaths | ForEach-Object {
    if (Test-Path $_) { Remove-Item $_ -Recurse -Force -EA SilentlyContinue }
}
