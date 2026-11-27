# Helpdesk, printers, audiovisual and FortiGate

Source: Rapport_Stage_CMC.pdf, chapters 5.1 and 5.2 (PDF p. 13). This page has no code:
the report gives procedures in prose only.

> Rapport_Stage_CMC.pdf is the original as submitted. It says 650 workstations and names supervisors. Repo text uses the corrected 850+ workstations, confirmed by the author on 27 Nov 2026. The PDF was left unchanged on purpose.

## Network printers (chapter 5.1.1)

Mostly HP LaserJet and Canon ImageRunner models. Two steps:

1. Configure the printer: static IP from the addressing plan set by the network team,
   and the print protocol: JetDirect/RAW on TCP 9100, or LPD/LPR on TCP 515.
2. Deploy the driver and print queue to the client PCs with Print Management GPOs, which
   set which printers install automatically and which one is the default for an OU.
   The driver sits on a print server hosted on `SRV-DC01`.

## Audiovisual equipment (chapter 5.1.2)

Only the IT side: installing drivers of USB audio interfaces, setting Windows Audio so
microphones are recognized, and testing with Microsoft Teams and Zoom.

## Common incidents (chapter 5.1.3)

| Incident | Resolution in the report |
|----------|--------------------------|
| Cannot join the domain (error 0xC000005E) | Check the DNS configuration, or reset the secure channel between the PC and the DC with `netdom resetpwd` |
| No access to shares or printers | Check membership of the right AD groups |
| Faulty screens, keyboards, network cables | Replace from spare stock |

## FortiGate introduction (chapter 5.2)

A hands-on session given by the external supervisor on the campus FortiGate firewall.
Covered: the FortiOS web interface, reading connection logs (FortiLogs) to spot suspicious
traffic, how Security Policies allow traffic between zones (WAN, LAN, DMZ), and the
Dashboard for live connections and security alerts. This was an introduction, not a
configuration project.

## Procedures with no code in the report

Three procedures are only described in prose in the report. None of them has a script, so
there is no `.ps1` file for any of them in `scripts/`.

### 1. Secure-channel reset with `netdom resetpwd` (chapter 5.1.3, PDF p. 13)

Procedure documented from report text - no code block in the report, so no .ps1 file for this.

- When to use it: a PC fails to join or log on to the domain with error 0xC000005E. First check
  the DNS configuration. If DNS is correct, reset the secure channel between the PC and the
  domain controller (`SRV-DC01`, domain `domain.local`).
- Command as described in the report: `netdom resetpwd`. The report names the command only.
  It gives no arguments and no example line, so none are shown here.
- What a good result looks like: the report does not describe it. The implied outcome is that
  the PC can join or log on to `domain.local` again.

### 2. MSI software deployment by GPO (chapter 4.2.1, PDF p. 10)

Procedure documented from report text - no code block in the report, so no .ps1 file for this.

- Native MSI packages only. This is done from the GPMC console, with no intermediate script.
- The MSI package must be on a network share that every PC in the domain can reach.
- Two deployments in the report:
  - GPO `AlgoBox.msi` (AlgoBox), linked to the root OU `CMC_Computers`.
  - GPOs `MySQL.msi` and `Workbench MySQL.msi` (MySQL Server and its graphical interface).
    The report does not name the OU these two are linked to.
- GPO steps: Computer Configuration > Policies > Software Settings > Software installation >
  New > Package, then pick the MSI from the share.
- Deployment mode: Assigned. The software installs at the next startup, even if nobody is
  logged on.
- The report adds that MSI supports silent installs through transform (MST) files.

### 3. Printer deployment by GPO (chapter 5.1.1, PDF p. 13)

Procedure documented from report text - no code block in the report, so no .ps1 file for this.

1. Configure the printer: static IP from the addressing plan, and JetDirect/RAW on TCP 9100
   or LPD/LPR on TCP 515.
2. Store the driver on the print server hosted on `SRV-DC01`.
3. In a Print Management GPO (available since Windows Server 2008), define which printers
   install automatically and which one is the default, for the users or computers of a
   given OU. Windows downloads and installs the driver on the client PCs.

The report does not name the printer GPO or its target OU.
