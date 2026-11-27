<#
.SYNOPSIS
    Deploy-App.ps1 - Silent EXE installation through a GPO computer startup script (GNS3 example).

.DESCRIPTION
    Pattern from the report: installers and their PowerShell scripts sit on a network
    share (\\SRV-DC01\apps\), and a GPO runs the script as a computer startup script.
    The script installs only if the application is missing, logs the install, and
    copies the shortcut to the public desktop so every user sees it.

    The report shows the script for GNS3. The other applications use the same pattern
    with their own silent arguments (listed in the report, chapter 4.2.2):

        GNS3            /VERYSILENT /SUPPRESSMSGBOXES /NORESTART
        Packet Tracer   /quiet /norestart
        Postman         --silent
        Power BI        -quiet -norestart -log C:\Windows\Temp\powerbi_install.log
        Python          /quiet InstallAllUsers=1 PrependPath=1
        VMware          /s /v"/qn REBOOT=ReallySuppress"
        VS Code         /VERYSILENT /MERGETASKS="!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath"
        XAMPP           --mode unattended --unattendedmodeui none

.NOTES
    Source  : Rapport_Stage_CMC.pdf, chapter 4.2.2 (PDF p. 10), "Exemple : Script de deploiement GNS3".
    Authors : Iliass Bouchari & Mohamed Zegui (CMC Casablanca-Settat internship)
    Sanitized: \\SRV-DC01\apps\ is a placeholder share. Needs an elevated or SYSTEM context.
    Safe test: supports -WhatIf (Start-Process and Copy-Item are not executed).

.EXAMPLE
    .\Deploy-App.ps1 -WhatIf
#>
[CmdletBinding(SupportsShouldProcess)]
param()

$installer = "\\SRV-DC01\apps\GNS3\GNS3-installer.exe"
$logFile = "C:\Windows\Temp\GNS3_install.log"

# Vérification si déjà installé
if (-not (Test-Path "C:\Program Files\GNS3\gns3.exe")) {
    Start-Process -FilePath $installer `
        -ArgumentList "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /LOG=$logFile" `
        -Wait -NoNewWindow

    # Copie raccourci bureau public
    Copy-Item "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\GNS3\GNS3.lnk" `
        "C:\Users\Public\Desktop\" -Force
}
