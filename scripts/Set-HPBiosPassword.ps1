<#
.SYNOPSIS
    Set-HPBiosPassword.ps1 - Set the BIOS administrator password on HP machines.

.DESCRIPTION
    Uses HP's official command-line tool BiosConfigUtility64.exe (HP Client Management
    Solutions), hosted on the network share. The script only acts on HP hardware and
    logs a success to the event log. The report deploys it by GPO.

.NOTES
    Source  : Rapport_Stage_CMC.pdf, chapter 4.4.3 (PDF p. 11).
    Authors : Iliass Bouchari & Mohamed Zegui (CMC Casablanca-Settat internship)
    WARNING : LAB-ONLY. A wrong BIOS password can lock you out of the machine's firmware
              setup. Test on a lab machine first, never on a production machine. Run elevated.
    SECURITY: the report keeps the password in a variable inside the script
              ($biosPass = ""). Here it is read from an interactive prompt instead, so
              no password is ever stored in the file.
    Note    : Write-EventLog needs the event source "CMC-Admin" to exist. The report does
              not show how it is registered. In the report, /cspwd (current password) is
              left empty, so this only works on machines with no BIOS password yet.
    Sanitized: \\SRV-DC01\apps\HP\ is a placeholder share.
    Safe test: supports -WhatIf (the BiosConfigUtility64.exe call is guarded explicitly).

.EXAMPLE
    .\Set-HPBiosPassword.ps1 -WhatIf
#>
[CmdletBinding(SupportsShouldProcess)]
param()

$biosUtil = "\\SRV-DC01\apps\HP\BiosConfigUtility64.exe"
$biosSecure = Read-Host -AsSecureString "BIOS admin password"
$biosPass = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($biosSecure))

# Vérification : la machine est-elle un HP ?
$manufacturer = (Get-WmiObject Win32_ComputerSystem).Manufacturer
if ($manufacturer -like "*HP*" -or $manufacturer -like "*Hewlett*") {
    # Tentative de définition du mot de passe BIOS
    if ($PSCmdlet.ShouldProcess("HP BIOS", "Set administrator password")) {
        $result = & $biosUtil /nspwd:"$biosPass" /cspwd:"" 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-EventLog -LogName Application -Source "CMC-Admin" `
                -EventId 9002 -Message "Mot de passe BIOS HP defini avec succes"
        }
    }
}
