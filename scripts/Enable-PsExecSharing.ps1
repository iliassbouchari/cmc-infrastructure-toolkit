<#
.SYNOPSIS
    Enable-PsExecSharing.ps1 - Prepare a workstation for remote administration (PsExec, WMI, SMB).

.DESCRIPTION
    Lets the administrator manage domain machines from one workstation. It:
      - enables the SMB server service (LanmanServer) and RemoteRegistry
      - opens the firewall for file sharing, remote management, TCP 445 (SMB), TCP 135 (RPC)
      - sets LocalAccountTokenFilterPolicy = 1 so local admin accounts (like TECH_ADMIN)
        keep their full privileges on network logons

.NOTES
    Source  : Rapport_Stage_CMC.pdf, chapter 4.4.4 (PDF p. 12).
    Authors : Iliass Bouchari & Mohamed Zegui (CMC Casablanca-Settat internship)
    WARNING : LAB-ONLY. This opens firewall ports and lowers a Windows security default
              (UAC token filtering for local accounts). Test in a lab VM first, never on
              a production machine. Run elevated.
    Note    : The firewall group names are the French display names used in the report
              (French Windows). Adapt them to your OS language.
    Safe test: supports -WhatIf (all cmdlets below honor it).

.EXAMPLE
    .\Enable-PsExecSharing.ps1 -WhatIf
#>
[CmdletBinding(SupportsShouldProcess)]
param()

# Configure SMB et services nécessaires
Set-Service -Name LanmanServer -StartupType Automatic
Start-Service -Name LanmanServer
Set-Service -Name RemoteRegistry -StartupType Automatic
Start-Service -Name RemoteRegistry

# Configure SMB (partage fichiers)
Set-SmbServerConfiguration -EnableSMB2Protocol $true -Force

# Active le partage de fichiers et d'imprimantes
Set-NetFirewallRule -DisplayGroup "Partage de fichiers et d imprimantes" -Enabled True

# Active la gestion à distance Windows (WinRM/WMI)
Set-NetFirewallRule -DisplayGroup "Gestion a distance de Windows" -Enabled True

# Autorise PsExec : ports RPC et SMB
New-NetFirewallRule -DisplayName "Allow SMB 445" -Direction Inbound `
    -Protocol TCP -LocalPort 445 -Action Allow -ErrorAction SilentlyContinue
New-NetFirewallRule -DisplayName "Allow RPC 135" -Direction Inbound `
    -Protocol TCP -LocalPort 135 -Action Allow -ErrorAction SilentlyContinue

# Configure UAC pour accès admin distant avec compte local
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" `
    -Name "LocalAccountTokenFilterPolicy" -Value 1 -PropertyType DWord -Force
