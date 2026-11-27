# AdvancedStartup.ps1 — Block access to Windows Recovery Environment (WinRE)
# Authors: Iliass Bouchari & Mohamed Zegui — CMC Casablanca-Settat internship, April 2026
#
# Counters the utilman.exe -> cmd.exe swap attack: students were reaching a SYSTEM
# command prompt from the login screen through WinRE / Shift+Restart, then resetting
# local admin passwords. This script disables the recovery entry points; it is
# complemented by the "Bloque-CMD-BIOS" GPO (security options blocking recovery tools).

# Disable Windows Recovery Environment
reagentc.exe /disable

# Remove the "advanced startup" entry points tied to hibernation/fast boot
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Power" `
    -Name "HibernateEnabled" -Value 0
