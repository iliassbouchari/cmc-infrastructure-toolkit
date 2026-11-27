<#
.SYNOPSIS
    AdvancedStartup.ps1 - Block the Windows Recovery Environment (WinRE) entry point.

.DESCRIPTION
    Counters the utilman.exe -> cmd.exe swap: students reached a SYSTEM command prompt
    from the login screen through WinRE (Shift + Restart) and reset local admin passwords.
    The report describes two complementary measures:
      - this script: disables WinRE with reagentc.exe /disable and changes the
        HibernateEnabled registry value under Session Manager\Power
      - the "Bloque-CMD-BIOS" GPO: blocks the recovery and diagnostic tools
        (Computer Configuration > Windows Settings > Security Settings >
        Local Policies > Security Options)

.NOTES
    Source  : Rapport_Stage_CMC.pdf, chapter 4.4.1 (PDF p. 11) and chapter 2.3.3 (PDF p. 5-6).
    Authors : Iliass Bouchari & Mohamed Zegui (CMC Casablanca-Settat internship)
    WARNING : LAB-ONLY. This turns off the Windows recovery environment and changes a
              power registry value. Test in a lab VM first, never on a production
              machine. Run elevated.
    Extraction note: the report describes this script in prose only and shows no code
              block. The two commands below are rebuilt from that description. The
              report does not state the value written to HibernateEnabled; 0 is assumed.
    Safe test: supports -WhatIf (reagentc.exe is guarded explicitly).

.EXAMPLE
    .\AdvancedStartup.ps1 -WhatIf
#>
[CmdletBinding(SupportsShouldProcess)]
param()

# Disable Windows Recovery Environment
if ($PSCmdlet.ShouldProcess("Windows Recovery Environment", "reagentc.exe /disable")) {
    reagentc.exe /disable
}

# Registry key named in the report: HibernateEnabled
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Power" `
    -Name "HibernateEnabled" -Value 0
