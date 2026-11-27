# Helpdesk, printers, audiovisual and FortiGate

Source: Rapport_Stage_CMC.pdf, chapters 5.1 and 5.2 (PDF p. 13). This page has no code:
the report gives procedures in prose only.

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
