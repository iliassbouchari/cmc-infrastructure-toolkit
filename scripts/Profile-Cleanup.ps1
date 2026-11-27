# Profile-Cleanup.ps1 — Delete stale local user profiles
# Authors: Iliass Bouchari & Mohamed Zegui — CMC Casablanca-Settat internship, April 2026
#
# Shared training rooms accumulate dozens of domain profiles per machine. This script
# removes profiles unused for more than 30 days, while protecting system profiles,
# the Administrator and the technical admin account. Disk freed is reported per profile.

$cutoffDate = (Get-Date).AddDays(-30)   # profiles unused for 30+ days
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
    Write-Output "Removing profile: $($profile.LocalPath) - $([math]::Round($size,1)) MB"
    $profile | Remove-CimInstance
}
