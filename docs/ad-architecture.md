# Active Directory architecture

Source: Rapport_Stage_CMC.pdf, chapters 3.1 and 3.2 (PDF p. 6), annex C (PDF p. 15).
All IPs, hostnames and the domain name are placeholders.

## Domain and DNS

- Single forest, single domain: `domain.local`. The domain name is also the UPN suffix of every account.
- One main domain controller, `SRV-DC01` (`192.0.2.10`), Windows Server 2019, in the central server room.
- The DC also runs DNS. Clients must point at it before they can find the domain:
  to join, a client asks DNS for the SRV records `_ldap._tcp.domain.local` and
  `_kerberos._tcp.domain.local`, created automatically by the Netlogon service.
  This is why `scripts/Join-Domain.ps1` configures DNS first.
- Shares on the DC: `\\SRV-DC01\apps\` (installers and install scripts),
  `\\SRV-DC01\wallpaper\` (institutional wallpapers deployed by GPO).
- Scripts also live in SYSVOL: `\\domain.local\SYSVOL\domain.local\scripts\`.
- Group Policy refresh: every 90 minutes by default on clients, or immediately with `gpupdate /force`.

## OU tree (three levels under the domain root)

```
domain.local
├── ADMINISTRATION            # staff and direction PCs (stricter policies)
└── CMC_Computers             # all training-pole machines
    ├── DIA                   # Digital & AI pole
    │   ├── DEV_S01-06        # software development rooms
    │   ├── IA_S15-17         # AI / data science rooms
    │   ├── INFRA_S07-14      # network & systems infrastructure rooms
    │   └── SN_18             # extra network room
    ├── LSS-FS                # sub-OUs E-LEARNING 1 .. E-LEARNING 6
    └── AGRO, ART, GESTION and the other poles   # one OU per pole
```

- Level 1 separates administration from training machines, so administrative PCs
  (which reach sensitive data) can get stricter policies.
- Level 2 (one OU per pole) is the granularity for software deployment GPOs,
  because each pole needs a different software set.
- Level 3 (one OU per room or group of rooms) allows room-level targeting.
- A tree that is too flat gives coarse GPO targeting. One that is too deep is hard
  to administer and slows GPO processing.
- New computer accounts are placed directly in the right OU at join time with the
  `-OUPath` parameter of `Join-Domain.ps1`, so they never land in the default `Computers` container.

## The ten poles of the campus

DIA (Digital and Artificial Intelligence), LSS-FS (Soft Skills), Gestion et Commerce,
Diagnostic Automobile, Artisanat, Art Graphique et Design, Agriculture, Agro-industrie,
Tourisme-Hotellerie-Restauration (THR), Industrie et Mecanique.

## Software deployed per pole (report annex C)

| Pole / rooms | Software |
|--------------|----------|
| DIA Infrastructure (S07-S14) | GNS3, Cisco Packet Tracer, VMware Workstation, Npcap, Python, VS Code, MySQL + Workbench |
| DIA Development (S01-S06) | Python, VS Code, XAMPP (Apache/PHP/MySQL), Postman, AlgoBox, MySQL Workbench |
| DIA Artificial Intelligence (S15-S17) | Python, Jupyter Notebook (via pip), VS Code, Git |
| Gestion | Microsoft Office 2016, Power BI Desktop, AlgoBox |
| All poles | Microsoft Office 2016 (GPO `office2016`), AlgoBox (GPO `AlgoBox.msi`) |
