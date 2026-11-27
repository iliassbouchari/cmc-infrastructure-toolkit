# Set-HPBiosPassword.ps1 — Set the BIOS admin password on HP machines, via GPO
# Authors: Iliass Bouchari & Mohamed Zegui — CMC Casablanca-Settat internship, April 2026
#
# Uses HP's official BiosConfigUtility64.exe (HP Client Management Solutions),
# hosted on the network share. Only runs on HP hardware. Success is logged.
#
# SECURITY: read the BIOS password from an interactive prompt or a secured file,
# never hard-code it in a script that sits on a share.

$biosUtil = "\\SRV-DC01\apps\HP\BiosConfigUtility64.exe"
$biosPass = Read-Host "BIOS admin password" -AsSecureString
$biosPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($biosPass))

# Only HP machines expose the HP WMI provider used by the utility
$manufacturer = (Get-WmiObject Win32_ComputerSystem).Manufacturer
if ($manufacturer -like "*HP*" -or $manufacturer -like "*Hewlett*") {
    # /nspwd sets a new setup password, /cspwd passes the current one (empty here)
    $result = & $biosUtil /nspwd:"$biosPlain" /cspwd:"" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-EventLog -LogName Application -Source "CMC-Admin" `
            -EventId 9002 -Message "HP BIOS password set successfully"
    }
}
