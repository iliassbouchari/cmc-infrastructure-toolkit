<#
.SYNOPSIS
    Profile-Cleanup.ps1 - Delete local user profiles unused for 30+ days.

.DESCRIPTION
    Shared training rooms collect many domain profiles per machine. The script uses the
    WMI class Win32_UserProfile to find profiles whose last use is older than 30 days,
    skips special (system) profiles, the Administrator and TECH_ADMIN, then removes each
    one and prints the size it frees.

.NOTES
    Source  : Rapport_Stage_CMC.pdf, chapter 4.4.5 (PDF p. 12), script "Profile_cleanup.ps1".
    Authors : Iliass Bouchari & Mohamed Zegui (CMC Casablanca-Settat internship)
    WARNING : LAB-ONLY. This permanently deletes user profiles and their files. Test in a
              lab VM first, never on a production machine. Run elevated.
    Sanitized: TECH_ADMIN is the placeholder account name.
    Safe test: supports -WhatIf (Remove-CimInstance lists what it would delete).

.EXAMPLE
    .\Profile-Cleanup.ps1 -WhatIf
#>
[CmdletBinding(SupportsShouldProcess)]
param()

$cutoffDate = (Get-Date).AddDays(-30) # Profils non utilisés depuis 30 jours
$profiles = Get-CimInstance -ClassName Win32_UserProfile |
    Where-Object {
        -not $_.Special -and
        $_.LastUseTime -lt $cutoffDate -and
        $_.LocalPath -notlike "*Administrator*" -and
        $_.LocalPath -notlike "*TECH_ADMIN*"
    }

foreach ($profile in $profiles) {
    $size = (Get-ChildItem $profile.LocalPath -Recurse -ErrorAction SilentlyContinue |
        Measure-Object -Property Length -Sum).Sum / 1MB
    Write-Output "Suppression profil : $($profile.LocalPath) - $([math]::Round($size,1)) MB"
    $profile | Remove-CimInstance
}
