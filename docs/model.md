# Target relationship model

```
DimPO (1)
  |
  | 1:*
  v
DimPOLine (1) <=====> (*) Encumbrance
    ^
    ||
    || Both-direction only on DimPOLine<->facts as required
    v
Expenses (*)

DimFecha (1) --> (*) Encumbrance
DimFecha (1) --> (*) Expenses
```

## Why the current relationship fails
The current model shown in the baseline screenshot joins facts around PO_ID, while PO_ID is not the lowest common grain. Expense/voucher rows are line-level transactions. A relationship at PO only cannot uniquely identify the affected line and can also cause incorrect propagation or duplicated aggregation.

The correct common grain is:
PO_ID + LINE_NBR.

## Interaction test
Baseline:
- PO P1 line 1 encumbrance = 5
- PO P1 line 2 encumbrance = 3
- Voucher V1 is attached to P1 / line 2 for amount 1

Expected:
- P1 total encumbrance: 8
- P1 total expense: 1
- P1 total available: 7
- P1 line 2 available: 2
- Selecting V1 must leave only P1 / line 2 visible on the encumbrance table.
