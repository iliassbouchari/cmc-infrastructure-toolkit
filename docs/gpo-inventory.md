# Deployed GPO inventory

Source: Rapport_Stage_CMC.pdf, chapters 3.4, 4.2 and 4.5 (PDF p. 8, 10, 12).

Main Group Policy Objects of the domain, their purpose and target OU.

| GPO name | Purpose | Target OU |
|----------|---------|-----------|
| AlgoBox.msi | Install AlgoBox (algorithmics) | CMC_Computers (all) |
| MySQL.msi | Install MySQL Server | CMC_Computers (all) |
| Workbench MySQL.msi | Install MySQL Workbench | CMC_Computers (all) |
| GNS3.exe | Install GNS3 network simulator | DIA/INFRA_S07-14 |
| PacketTracer.exe | Install Cisco Packet Tracer | DIA/INFRA_S07-14 |
| Postman(64).exe | Install Postman API client | DIA/DEV_S01-06 |
| PowerBI.exe | Install Microsoft Power BI | DIA / GESTION |
| python.exe | Install Python + PATH | DIA (all) |
| VMWare.exe | Install VMware Workstation | DIA/INFRA_S07-14 |
| VsCode.exe | Install Visual Studio Code | DIA (all) |
| Xampp.exe | Install XAMPP | DIA/DEV_S01-06 |
| Npcap.exe | Install Npcap (packet capture) | DIA (all) |
| office2016 | Deploy Microsoft Office 2016 | CMC_Computers (all) |
| 365 | Uninstall Office 365 (`scripts/Remove-Office365.ps1`) | CMC_Computers (all) |
| CMC-LocalAccount | Create local technical admin account (`scripts/Manage-LocalUsers.ps1`) | CMC_Computers (all) |
| Profile_cleanup | Remove profiles inactive 30+ days (`scripts/Profile-Cleanup.ps1`) | CMC_Computers (all) |
| Bloque-CMD-BIOS | Block WinRE and system CMD access | CMC_Computers (all) |
| VAMT-WMI-Firewall | Firewall rules for VAMT/WMI | Whole domain |

## How software is deployed

MSI packages are deployed natively, with the package on a network share reachable by
all domain PCs: Computer Configuration -> Policies -> Software Settings -> Software
installation -> New -> Package. Mode "Assigned" installs the software at the next
computer startup, even if nobody is logged on. Two MSI deployments: AlgoBox, and MySQL
Server with MySQL Workbench.

EXE installers are not compatible with native GPO deployment. They go through PowerShell
install scripts stored on `\\SRV-DC01\apps\`, run as computer startup scripts by a GPO
(see `scripts/Deploy-App.ps1`). Silent arguments used per application:

| Application (installer) | Silent arguments |
|-------------------------|------------------|
| GNS3 (`GNS3.exe`) | `/VERYSILENT /SUPPRESSMSGBOXES /NORESTART` |
| Cisco Packet Tracer (`PacketTracer.exe`) | `/quiet /norestart` |
| Postman x64 (`Postman(64).exe`) | `--silent` |
| Power BI Desktop (`PowerBI.exe`) | `-quiet -norestart -log C:\Windows\Temp\powerbi_install.log` |
| Python (`python.exe`) | `/quiet InstallAllUsers=1 PrependPath=1` |
| VMware Workstation (`VMware.exe`) | `/s /v"/qn REBOOT=ReallySuppress"` |
| VS Code (`VsCode.exe`) | `/VERYSILENT /MERGETASKS="!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath"` |
| XAMPP (`Xampp.exe`) | `--mode unattended --unattendedmodeui none` |

Every script copies the application shortcut to the public desktop
(`C:\Users\Public\Desktop\`) so all users see it at first logon.

## Other GPO features

- Security: `Bloque-CMD-BIOS` is set under Computer Configuration -> Windows Settings ->
  Security Settings -> Local Policies -> Security Options.
- Printers: network printers are deployed with Print Management GPOs, with the driver
  stored on a print server hosted on `SRV-DC01` (see `docs/helpdesk.md`).
- Wallpaper: institutional wallpapers come from `\\SRV-DC01\wallpaper\`.
