# Remove-Office365.ps1 — Complete removal of Microsoft 365 (Click-to-Run)
# Authors: Iliass Bouchari & Mohamed Zegui — CMC Casablanca-Settat internship, April 2026
#
# Used before deploying a licensed Office via GPO. Four phases:
#   1. Stop the Click-to-Run service and every running Office process
#   2. Uninstall through the Office Deployment Tool (ODT) with an uninstall XML
#   3. Remove residual Appx packages (Store OneNote survives the main uninstall)
#   4. Clean the registry leftovers

# Phase 1: stop services and processes
Stop-Service "ClickToRunSvc" -Force -ErrorAction SilentlyContinue
$officeProcs = @("WINWORD","EXCEL","POWERPNT","OUTLOOK","ONENOTE","MSACCESS")
$officeProcs | ForEach-Object { Stop-Process -Name $_ -Force -EA SilentlyContinue }

# Phase 2: ODT uninstall (path points to the network share)
$odtPath = "\\SRV-DC01\apps\ODT\setup.exe"
Start-Process $odtPath -ArgumentList "/configure uninstall.xml" -Wait

# Phase 3: OneNote Appx cleanup
Get-AppxPackage -AllUsers "*OneNote*" | Remove-AppxPackage -ErrorAction SilentlyContinue

# Phase 4: registry cleanup
$regPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Office",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Office"
)
$regPaths | ForEach-Object {
    if (Test-Path $_) { Remove-Item $_ -Recurse -Force -EA SilentlyContinue }
}
