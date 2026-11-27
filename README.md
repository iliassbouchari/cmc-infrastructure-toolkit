<div align="center">

<img src="assets/cmc-banner.svg" width="100%" alt="WABI - CMC Infrastructure Toolkit, PowerShell, Active Directory, GPO">

# CMC Infrastructure Toolkit

**Deployment, administration and support of a 650+ workstation campus**

<img src="https://img.shields.io/badge/POWERSHELL-8%20SCRIPTS-fbefd5?style=for-the-badge&labelColor=7d0000" alt="8 PowerShell scripts">
<img src="https://img.shields.io/badge/ACTIVE%20DIRECTORY-GPO%20DRIVEN-ffd98a?style=for-the-badge&labelColor=7d0000" alt="Active Directory, GPO driven">
<img src="https://img.shields.io/badge/SANITIZED-NO%20REAL%20DATA-fbefd5?style=for-the-badge&labelColor=7d0000" alt="Sanitized, no real data">
<a href="https://github.com/iliassbouchari"><img src="https://img.shields.io/badge/PROFILE-ILIASSBOUCHARI-ffd98a?style=for-the-badge&labelColor=7d0000" alt="Profile"></a>
<a href="https://iliassbouchari.github.io/"><img src="https://img.shields.io/badge/PORTFOLIO-ILIASSBOUCHARI.GITHUB.IO-fbefd5?style=for-the-badge&labelColor=7d0000" alt="Portfolio"></a>

</div>

---

## About this repo

PowerShell scripts and procedures built during our end-of-studies internship at the
**Cité des Métiers et des Compétences (CMC) Casablanca-Settat** (Feb–Apr 2026):
deployment, administration and support of the systems and network infrastructure —
a 650+ workstation park across 10 training poles, centralized under a single
Active Directory domain with GPO-driven software deployment and hardening.

**Authors:** Iliass Bouchari & Mohamed Zegui — DTS Digital Infrastructure,
Systems & Networks option, class IDOSR201.

> **Sanitized for publication.** Every real identifier has been replaced by a
> placeholder: domain name (`domain.local`), DC IP (`192.0.2.10`, TEST-NET-1),
> server hostname (`SRV-DC01`), account names (`TECH_ADMIN`) and all passwords
> (interactive prompts). Adapt them to your own environment before use.

## The toolkit at a glance

<div align="center">
<img src="assets/cmc-terminal.svg" width="100%" alt="PowerShell terminal listing the toolkit scripts and the main projects">
</div>

## Infrastructure it runs on

<div align="center">
<img src="assets/cmc-network.svg" width="100%" alt="Animated network topology: Internet, FortiGate, Cisco core, Active Directory, Wazuh, Proxmox, Zabbix and PC sectors">
</div>

## Tech stack

<div align="center">
<img src="assets/cmc-stack.svg" width="100%" alt="Tech stack: Cisco, Fortinet, Windows Server, Active Directory, PowerShell, Docker, Proxmox, Ubuntu, Red Hat, Zabbix, Wazuh, VMware ESXi">
</div>

## What's inside

### Scripts (`scripts/`)

| Script | What it does |
|--------|--------------|
| `Join-Domain.ps1` | USB-run domain join: sets DNS to the DC, asks for the naming fields, renames the PC and joins the domain directly into the right OU. Cut per-machine setup from ~20 min to under 3 min. |
| `Deploy-App.ps1` | Generic silent EXE deployment via GPO startup scripts, with presence check, logging and public-desktop shortcut. Includes the silent arguments for GNS3, Packet Tracer, Postman, Power BI, Python, VMware, VS Code, XAMPP. |
| `Remove-Office365.ps1` | Complete Click-to-Run Office 365 removal in 4 phases (services, ODT uninstall, Appx leftovers, registry). |
| `AdvancedStartup.ps1` | Disables WinRE entry points, countering the `utilman.exe` → `cmd.exe` SYSTEM-prompt attack. |
| `Manage-LocalUsers.ps1` | Idempotent local-account hygiene: creates the technical admin account and removes unauthorized local users (event-logged). |
| `Set-HPBiosPassword.ps1` | Sets the BIOS admin password on HP machines via HP BiosConfigUtility64, GPO-deployable. |
| `Enable-PsExecSharing.ps1` | Enables remote administration: SMB service, firewall ports 445/135, `LocalAccountTokenFilterPolicy`. |
| `Profile-Cleanup.ps1` | Removes local profiles inactive 30+ days (protecting admin accounts) and reports freed space. |

### Documentation (`docs/`)

- `ad-architecture.md` — OU tree, DNS/SRV logic, software matrix per pole
- `naming-convention.md` — the 10-character workstation naming charter
- `gpo-inventory.md` — every deployed GPO with purpose and target OU
- `boot-repair.md` — Hiren's Boot CD PE boot repair, BIOS lock bypass, utilman-swap countermeasures
- `Rapport_Stage_CMC.pdf` — the full internship report (French), sanitized

## Highlights of the work

- Designed the AD architecture: single domain, 3-level OU tree (administration /
  poles / rooms) enabling per-pole GPO targeting.
- Automated workstation onboarding from ~20 minutes to under 3 minutes per machine.
- Deployed software to 650+ machines by GPO (native MSI + PowerShell for EXE).
- Hardened the park against a password-reset attack actively exploited by students
  (WinRE + utilman.exe swap) with script + GPO + NTFS ACLs.
- Day-to-day helpdesk: network printers, AV equipment, domain incidents
  (secure-channel resets with `netdom resetpwd`, permissions).
- Introduction to perimeter security on the site's Fortinet FortiGate firewall
  (policies, logs, dashboard).

---

<div align="center">

<a href="https://github.com/iliassbouchari"><img src="https://img.shields.io/badge/MORE%20WORK-GITHUB.COM%2FILIASSBOUCHARI-fbefd5?style=for-the-badge&labelColor=7d0000" alt="More work on my profile"></a>

</div>
