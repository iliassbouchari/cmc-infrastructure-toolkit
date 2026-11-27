# CMC workstation naming convention

Source: Rapport_Stage_CMC.pdf, chapter 3.3 (PDF p. 7) and annex B (PDF p. 15).

> Rapport_Stage_CMC.pdf is the original as submitted. It says 650 workstations and names supervisors. Repo text uses the corrected 850+ workstations, confirmed by the author on 27 Nov 2026. The PDF was left unchanged on purpose.

General format: `[Floor][Pole][Room][PC_ID]`, 10 characters total.

| Field | Size | Description | Examples |
|-------|------|-------------|----------|
| Floor | 2 chars | Building floor identifier | E1, E2, RDC |
| Pole | 3 chars | Sectorial pole code | DIA, LSS, GES, ART, THR, AGR |
| Room | 3 chars | Room number | S01, S04, S15, S18 |
| PC ID | 2 chars | Machine number: 01 to 20 for trainee PCs, **00 = teacher PC** | 00, 01, 12, 20 |

Examples:

- `E1DIAS0400`: teacher PC, room 04, DIA pole, 1st floor (E1 + DIA + S04 + 00)
- `E1DIAS0407`: 7th trainee PC of room 04, DIA pole, 1st floor
- `E2LSSS0112`: trainee PC n°12, room 01, LSS pole, 2nd floor

Why the trailing `00` matters: teacher machines always end in `00`, so a WMI filter or
a security filter on the computer name can include or exclude teacher PCs from any GPO
(for example extra network resources for teachers, or a restrictive policy that applies
to trainee PCs only).

The name is built by `scripts/Join-Domain.ps1` from four prompts (floor, pole, room, PC id)
and converted to upper case.
