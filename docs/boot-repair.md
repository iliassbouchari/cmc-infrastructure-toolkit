# Boot repair and low-level maintenance procedures

Source: Rapport_Stage_CMC.pdf, chapter 2.3 (PDF p. 5-6).

> Rapport_Stage_CMC.pdf is the original as submitted. It says 650 workstations and names supervisors. Repo text uses the corrected 850+ workstations, confirmed by the author on 27 Nov 2026. The PDF was left unchanged on purpose.

## Repairing corrupted boot sectors (Hiren's Boot CD PE)

Typical on machines hit by sudden power cuts or failed installs. Symptoms:
"BOOTMGR is missing", "Operating System not found" or "Error Loading Operating System".
They point to a corrupted Master Boot Record (MBR, first sector of the disk), Volume Boot
Record (VBR) of the system partition, or the Windows boot files (BCD, bootmgr).

Hiren's Boot CD PE is a standalone Windows PE that boots from a USB key and gives full
access to the disk without starting the damaged system.

1. Boot the machine on Hiren's Boot CD PE (USB).
2. Rebuild the boot components:

```bat
bootrec /fixmbr
bootrec /fixboot
bootrec /rebuildbcd
chkdsk /f /r
```

- `bootrec /fixmbr` rebuilds the MBR
- `bootrec /fixboot` repairs the boot sector of the active volume
- `bootrec /rebuildbcd` rebuilds the Boot Configuration Data store
- `chkdsk /f /r` checks and repairs the file system

## Bypassing a locked BIOS for diagnostics (HP)

Some HP machines had the BIOS/UEFI locked by an administrator password, or the boot menu
(F9) and setup (F10) keys disabled. That blocks low-level work such as checking
virtualization settings, changing the boot order to boot from USB, or enabling the TPM
for BitLocker. Data on the disks is not touched.

- HP EliteDesk towers: move the motherboard **PSWD jumper** from pins 1-2 to 2-3,
  boot (the BIOS ignores the password), make the changes (VT-x, boot order, TPM),
  then move the jumper back to its normal position.
- HP All-in-One / laptops: temporarily remove the CR2032 CMOS battery to reset
  all BIOS settings to factory defaults.

Do this only on machines you are authorized to maintain.

## Countering the utilman.exe -> cmd.exe swap

How the attack works: the "Accessibility" button on the Windows login screen is always
available and launches `C:\Windows\System32\utilman.exe` with SYSTEM rights. Students
reached the recovery environment (WinRE, Shift + Restart or Advanced Startup Options),
got a command prompt, and replaced `utilman.exe` with `cmd.exe` (or a link to it). One
click on the accessibility button then opened a SYSTEM command prompt, which allowed
creating an admin account or changing any password.

Two-level fix:

1. Restore the genuine files: boot compromised machines on Hiren's Boot CD PE, replace
   the substituted `cmd.exe` with the real `utilman.exe` from a clean Windows image, and
   apply NTFS permissions (ACLs) so non-administrators cannot modify it.
2. Block the entry point: deploy `scripts/AdvancedStartup.ps1` (disables WinRE) and the
   `Bloque-CMD-BIOS` GPO (blocks recovery and diagnostic tools at policy level, so
   trainees cannot reach WinRE with a Shift + Restart).
