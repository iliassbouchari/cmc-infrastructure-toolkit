# Deploy-App.ps1 — Silent EXE software deployment through GPO computer startup scripts
# Authors: Iliass Bouchari & Mohamed Zegui — CMC Casablanca-Settat internship, April 2026
#
# Pattern: installers live on a network share; a GPO runs this script at computer startup.
# The script installs only if the app is missing, logs everything, and copies the
# shortcut to the public desktop so every user sees it.
#
# Silent arguments used per application (adjust paths to your share):
#   GNS3            /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /LOG=<log>
#   Packet Tracer   /quiet /norestart
#   Postman         --silent
#   Power BI        -quiet -norestart -log C:\Windows\Temp\powerbi_install.log
#   Python          /quiet InstallAllUsers=1 PrependPath=1
#   VMware          /s /v"/qn REBOOT=ReallySuppress"
#   VS Code         /VERYSILENT /MERGETASKS="!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath"
#   XAMPP           --mode unattended --unattendedmodeui none

param(
    [string]$Installer  = "\\SRV-DC01\apps\GNS3\GNS3-installer.exe",        # path on the network share
    [string]$Arguments  = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /LOG=C:\Windows\Temp\GNS3_install.log",
    [string]$CheckPath  = "C:\Program Files\GNS3\gns3.exe",                 # presence check
    [string]$Shortcut   = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\GNS3\GNS3.lnk"
)

$logFile = "C:\Windows\Temp\GNS3_install.log"

if (-not (Test-Path $CheckPath)) {
    Start-Process -FilePath $Installer `
        -ArgumentList $Arguments `
        -Wait -NoNewWindow

    # Shortcut on the public desktop for every profile
    Copy-Item $Shortcut "C:\Users\Public\Desktop\" -Force
}
