# Enable-PsExecSharing.ps1 — Enable remote administration (PsExec / WMI / SMB)
# Authors: Iliass Bouchari & Mohamed Zegui — CMC Casablanca-Settat internship, April 2026
#
# Prepares domain machines for remote administration from the admin workstation:
# enables the SMB server service, opens the firewall ports PsExec needs
# (TCP 445 SMB, TCP 135 RPC), and sets LocalAccountTokenFilterPolicy so local
# admin accounts keep their full privileges over network logons.

# Services
Set-Service -Name LanmanServer -StartupType Automatic
Start-Service -Name LanmanServer
Set-Service -Name RemoteRegistry -StartupType Automatic
Start-Service -Name RemoteRegistry

# SMB file sharing
Set-SmbServerConfiguration -EnableSMB2Protocol $true -Force

# File and printer sharing + Windows remote management firewall groups
Set-NetFirewallRule -DisplayGroup "Partage de fichiers et d imprimantes" -Enabled True
Set-NetFirewallRule -DisplayGroup "Gestion a distance de Windows" -Enabled True

# PsExec ports
New-NetFirewallRule -DisplayName "Allow SMB 445" -Direction Inbound `
    -Protocol TCP -LocalPort 445 -Action Allow -ErrorAction SilentlyContinue
New-NetFirewallRule -DisplayName "Allow RPC 135" -Direction Inbound `
    -Protocol TCP -LocalPort 135 -Action Allow -ErrorAction SilentlyContinue

# Let local admin accounts keep elevated tokens on network logons
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" `
    -Name "LocalAccountTokenFilterPolicy" -Value 1 -PropertyType DWord -Force
