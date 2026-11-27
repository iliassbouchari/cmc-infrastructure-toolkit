# Manage-LocalUsers.ps1 — Standardize local accounts on domain machines
# Authors: Iliass Bouchari & Mohamed Zegui — CMC Casablanca-Settat internship, April 2026
#
# Idempotent: safe to run repeatedly. It creates the technical admin account used by
# the IT team (if missing), makes it a local administrator, and removes every
# unauthorized local account, logging each removal to the event log.
#
# SECURITY: never hard-code the password — the script asks for it interactively.

# 1. Create the technical account (if missing)
$techUser = "TECH_ADMIN"
if (-not (Get-LocalUser -Name $techUser -EA SilentlyContinue)) {
    $techPass = Read-Host "Password for $techUser" -AsSecureString
    New-LocalUser -Name $techUser -Password $techPass `
        -Description "Technical admin account" -PasswordNeverExpires
}

# 2. Add it to the local Administrators group
Add-LocalGroupMember -Group "Administrators" -Member $techUser -EA SilentlyContinue

# 3. Remove every non-authorized local account
$authorizedUsers = @("Administrator","TECH_ADMIN","DefaultAccount","Guest","WDAGUtilityAccount")
Get-LocalUser | Where-Object { $_.Name -notin $authorizedUsers } | ForEach-Object {
    Remove-LocalUser -Name $_.Name
    Write-EventLog -LogName Application -Source "CMC-Admin" `
        -EventId 9001 -Message "Removed local account: $($_.Name)"
}
