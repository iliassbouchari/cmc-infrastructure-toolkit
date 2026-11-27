<#
.SYNOPSIS
    AdvancedStartup.ps1 - Block the Windows Recovery Environment (WinRE) entry point.

.DESCRIPTION
    Counters the utilman.exe -> cmd.exe swap: students reached a SYSTEM command prompt
    from the login screen through WinRE (Shift + Restart) and reset local admin passwords.
    The report describes two complementary measures:
      - this script: disables WinRE with reagentc.exe /disable
      - the "Bloque-CMD-BIOS" GPO: blocks the recovery and diagnostic tools
        (Computer Configuration > Windows Settings > Security Settings >
        Local Policies > Security Options)

.NOTES
    Source  : Rapport_Stage_CMC.pdf, chapter 4.4.1 (PDF p. 11) and chapter 2.3.3 (PDF p. 5-6).
    Authors : Iliass Bouchari & Mohamed Zegui (CMC Casablanca-Settat internship)
    WARNING : LAB-ONLY. This turns off the Windows recovery environment. Test in a lab
              VM first, never on a production machine. Run elevated.
    Extraction note: AdvancedStartup was rebuilt from report text, no code block in the
              report. Hibernate setting omitted because it was not in the report: the
              prose mentions a HibernateEnabled registry key but gives no value, so no
              registry change is made here.
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

