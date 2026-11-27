# CMC workstation naming convention

General format: `[Floor][Pole][Room][PC_ID]` — 10 characters total.

| Field | Size | Description | Examples |
|-------|------|-------------|----------|
| Floor | 2 chars | Building floor identifier | E1, E2, RDC |
| Pole | 3 chars | Sectorial pole code | DIA, LSS, GES, ART, THR, AGR |
| Room | 3 chars | Room number | S01, S04, S15, S18 |
| PC ID | 2 chars | Machine number (**00 = teacher**) | 00, 01, 12, 20 |

Examples:
- `E1DIAS0400` — teacher PC, room 04, DIA pole, 1st floor
- `E2LSSS0112` — trainee PC n°12, room 01, LSS pole, 2nd floor

Why the trailing `00` matters: teacher machines always end in `00`, so a WMI or
security filter on the computer name can include or exclude teacher PCs from any GPO.
