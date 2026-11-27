# Boot repair and low-level maintenance procedures

## Repairing corrupted boot sectors (Hiren's Boot CD PE)

For machines showing "BOOTMGR is missing", "Operating System not found" or
"Error Loading Operating System" (corrupted MBR/VBR/BCD after power cuts or
failed installs):

1. Boot the machine on Hiren's Boot CD PE (USB).
2. Rebuild the boot components:

```bat
bootrec /fixmbr
bootrec /fixboot
bootrec /rebuildbcd
chkdsk /f /r
```

## Bypassing a locked BIOS for diagnostics (HP)

- HP EliteDesk towers: move the motherboard **PSWD jumper** from pins 1-2 to 2-3,
  boot (BIOS ignores the password), make the changes (VT-x, boot order, TPM),
  then move the jumper back.
- HP All-in-One / laptops: temporarily remove the CR2032 CMOS battery to reset
  BIOS settings to factory defaults.

## Countering the utilman.exe -> cmd.exe swap

Students exploited WinRE / Shift+Restart to replace `utilman.exe` with `cmd.exe`
and get a SYSTEM prompt from the login screen (then reset local passwords).

1. Boot compromised machines on Hiren's Boot CD PE, restore the genuine
   `utilman.exe` from a clean Windows image, and apply NTFS ACLs so
   non-administrators cannot modify it.
2. Deploy `scripts/AdvancedStartup.ps1` (disables WinRE) plus the
   `Bloque-CMD-BIOS` GPO (blocks recovery tools at policy level).
