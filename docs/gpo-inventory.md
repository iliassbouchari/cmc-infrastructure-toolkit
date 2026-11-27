# Deployed GPO inventory

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
| 365 | Uninstall Office 365 | CMC_Computers (all) |
| CMC-LocalAccount | Create local technical admin account | CMC_Computers (all) |
| Profile_cleanup | Remove profiles inactive 30+ days | CMC_Computers (all) |
| Bloque-CMD-BIOS | Block WinRE and system CMD access | CMC_Computers (all) |
| VAMT-WMI-Firewall | Firewall rules for VAMT/WMI | Whole domain |

MSI packages are deployed natively (Computer Configuration -> Policies ->
Software Settings -> Software installation, mode "Assigned"). EXE installers go
through PowerShell startup scripts (see `scripts/Deploy-App.ps1`) hosted on the
domain share.
