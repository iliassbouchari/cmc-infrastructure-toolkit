<#
.SYNOPSIS
    Manage-LocalUsers.ps1 - Standardize local accounts on domain workstations.

.DESCRIPTION
    Idempotent (safe to run several times). It:
      1. creates the technical account TECH_ADMIN if it does not exist
      2. adds it to the local Administrators group
      3. removes every local account that is not in the authorized list,
         writing an event log entry for each removal

.NOTES
    Source  : Rapport_Stage_CMC.pdf, chapter 4.4.2 (PDF p. 11), script "ManageLocalUsers.ps1".
    Authors : Iliass Bouchari & Mohamed Zegui (CMC Casablanca-Settat internship)
    WARNING : LAB-ONLY. This deletes local user accounts. Test in a lab VM first, never on
              a production machine. Run elevated.
    SECURITY: the password is always typed at a prompt, never stored in the script.
    Note    : Write-EventLog needs the event source "CMC-Admin" to exist. The report does
              not show how it is registered.
    Sanitized: TECH_ADMIN is the placeholder account name.
    Safe test: supports -WhatIf (New-LocalUser, Add-LocalGroupMember, Remove-LocalUser).

.EXAMPLE
    .\Manage-LocalUsers.ps1 -WhatIf
#>
[CmdletBinding(SupportsShouldProcess)]
param()

# 1. Création du compte technique TECH_ADMIN (s'il n'existe pas)
$cmcUser = "TECH_ADMIN"
$cmcPass = Read-Host -AsSecureString "Enter the technical account password"
if (-not (Get-LocalUser -Name $cmcUser -EA SilentlyContinue)) {
    New-LocalUser -Name $cmcUser -Password $cmcPass `
        -Description "Compte technique CMC - DIA" -PasswordNeverExpires
}

# 2. Ajout au groupe Administrateurs locaux
Add-LocalGroupMember -Group "Administrators" -Member $cmcUser -EA SilentlyContinue

# 3. Suppression des comptes non autorisés
$authorizedUsers = @("Administrator","TECH_ADMIN","DefaultAccount","Guest","WDAGUtilityAccount")
Get-LocalUser | Where-Object { $_.Name -notin $authorizedUsers } | ForEach-Object {
    Remove-LocalUser -Name $_.Name
    Write-EventLog -LogName Application -Source "CMC-Admin" `
        -EventId 9001 -Message "Compte supprimé : $($_.Name)"
}
