# Join-Domain.ps1 — Automated domain join for new workstations
# Authors: Iliass Bouchari & Mohamed Zegui — CMC Casablanca-Settat internship, April 2026
#
# Runs from a USB key on each new machine. In order, it:
#   1. Points the active NIC's DNS at the domain controller (required to locate the AD SRV records)
#   2. Asks the operator for the naming fields (floor / pole / room / PC id)
#   3. Renames the computer and joins it to the domain, directly into the right OU
#
# All infrastructure identifiers are placeholders — adapt the parameters to your environment.

param(
    [string]$DomainName = "domain.local",                                   # AD domain FQDN
    [string]$DnsServer  = "192.0.2.10",                                     # Domain controller IP (TEST-NET-1 placeholder)
    [string]$BaseOU     = "OU=CMC_Computers,DC=domain,DC=local"             # Parent OU for computer accounts
)

# 1. DNS configuration (must come first: the client locates the DC via _ldap._tcp SRV records)
$adapter = Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | Select-Object -First 1
Set-DnsClientServerAddress -InterfaceAlias $adapter.Name -ServerAddresses $DnsServer,"8.8.8.8"
Write-Host "[OK] DNS configured to $DnsServer"

# 2. Naming fields (convention: [Floor 2c][Pole 3c][Room 3c][ID 2c], e.g. E1DIAS0400 = teacher PC)
$etage = Read-Host "Etage (E1, E2, RDC...)"
$pole  = Read-Host "Pole (DIA, LSS, GES, ART, THR...)"
$salle = Read-Host "Salle (S01, S02, S03...)"
$id    = Read-Host "ID PC (00=Prof, 01-20=Stagiaire)"
$newName = "$etage$pole$salle$id".ToUpper()
$ouPath  = "OU=$salle,OU=$pole,$BaseOU"

# 3. Connectivity check, then join
if (-not (Test-Connection $DnsServer -Count 1 -Quiet)) {
    Write-Error "Cannot reach the DC. Check the network connection."
    exit 1
}

$cred = Get-Credential -Message "Domain admin credentials (ex: DOMAIN\admin)"
Add-Computer -DomainName $DomainName -NewName $newName `
    -OUPath $ouPath -Credential $cred -Force
Write-Host "[OK] Machine $newName joined to $DomainName in $ouPath"
Restart-Computer -Force
