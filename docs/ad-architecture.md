# Active Directory architecture

Single-forest, single-domain AD on Windows Server 2019. The domain controller
also runs the DNS service — clients must point at it before they can locate the
`_ldap._tcp` / `_kerberos._tcp` SRV records and join the domain (this is why the
join script configures DNS first). All IPs and hostnames are placeholders here.

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
    ├── LSS-FS                # E-LEARNING 1 .. E-LEARNING 6 sub-OUs
    ├── AGRO / ART / GESTION / THR ...   # one OU per remaining pole
```

- Level 1 separates administration from training machines.
- Level 2 (one OU per pole) is the granularity for software deployment GPOs,
  because each pole needs a different software set.
- Level 3 (one OU per room) allows room-level targeting.
- New computer accounts are placed directly in the right OU at join time via
  the `-OUPath` parameter of `Join-Domain.ps1`.

## Software deployed per pole

- DIA Infrastructure (S07-S14): GNS3, Cisco Packet Tracer, VMware Workstation, Npcap, Python, VS Code, MySQL + Workbench
- DIA Development (S01-S06): Python, VS Code, XAMPP, Postman, AlgoBox, MySQL Workbench
- DIA AI (S15-S17): Python, Jupyter (via pip), VS Code, Git
- Gestion: Microsoft Office 2016, Power BI Desktop, AlgoBox
- All poles: Office 2016, AlgoBox
