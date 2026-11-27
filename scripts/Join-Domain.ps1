<#
.SYNOPSIS
    Join-Domain.ps1 - USB script that sets DNS, renames a workstation and joins it to the domain.

.DESCRIPTION
    Runs from a USB key on each new machine. In order, it:
      1. Points the active network adapter's DNS at the domain controller
      2. Asks the operator for the naming fields (floor, pole, room, PC id)
      3. Checks that the DC answers, then renames the PC and joins the domain
         directly into the right OU, then restarts.
    Poles: the pole is typed at the prompt and used as-is for the OU name and the machine
    name, so no pole is hard-coded and none was lost in the merge. Pole codes named in the
    report: DIA, LSS, GES, ART, AGR, THR (chapter 3.3). Pole OUs named in chapter 3.2: DIA,
    AGRO, ART, GESTION, LSS-FS, plus ADMINISTRATION as a separate root OU. The report does
    not list the other poles' codes, so none are invented here.
    Per the report, this cut the work per machine from about 20 minutes to under 3 minutes.

.NOTES
    Source  : Rapport_Stage_CMC.pdf, chapter 4.1 (PDF p. 9, short version) and
              Annexe A.1 (PDF p. 14, complete version, used here).
    Authors : Iliass Bouchari & Mohamed Zegui (CMC Casablanca-Settat internship)
    WARNING : LAB-ONLY. This renames the computer, changes its DNS settings, joins a
              domain and restarts the machine. Test in a lab VM first, never on a
              production machine. Run in an elevated PowerShell.
    Sanitized: domain.local, 192.0.2.10 (TEST-NET-1) and the OU path are placeholders.
    Safe test: supports -WhatIf (Add-Computer and Restart-Computer are not executed).

.EXAMPLE
    .\Join-Domain.ps1
    # Etage E1, Pole DIA, Salle S04, ID PC 00 -> machine E1DIAS0400, joined to domain.local in
    # OU=S04,OU=DIA,OU=CMC_Computers,DC=domain,DC=local
.EXAMPLE
    .\Join-Domain.ps1 -WhatIf
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$DomainName = "domain.local",

    [string]$DnsServer = "192.0.2.10",

    [string]$BaseOU = "OU=CMC_Computers,DC=domain,DC=local"
)

# Configuration DNS
$adapter = Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | Select-Object -First 1
Set-DnsClientServerAddress -InterfaceAlias $adapter.Name -ServerAddresses $DnsServer,"8.8.8.8"
Write-Host "[OK] DNS configure vers $DnsServer"

# Collecte des paramètres de nommage
$etage = Read-Host "Etage (E1, E2, RDC...)"
$pole = Read-Host "Pole (DIA, LSS, GES, ART, THR...)"
$salle = Read-Host "Salle (S01, S02, S03...)"
$id = Read-Host "ID PC (00=Prof, 01-20=Stagiaire)"
$newName = "$etage$pole$salle$id".ToUpper()
$ouPath = "OU=$salle,OU=$pole,$BaseOU"

# Vérification de la connectivité AD
if (-not (Test-Connection $DnsServer -Count 1 -Quiet)) {
    Write-Error "Impossible de joindre le DC. Verifier la connexion reseau."
    exit 1
}

# Jonction au domaine
$cred = Get-Credential -Message "Credentials Admin Domaine (ex: domain\admin)"
Add-Computer -DomainName $DomainName -NewName $newName `
    -OUPath $ouPath -Credential $cred -Force
Write-Host "[OK] Machine $newName jointe au domaine $DomainName dans $ouPath"
Restart-Computer -Force
