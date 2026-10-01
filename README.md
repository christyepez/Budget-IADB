# Budget IADB

Power BI model for Purchase Order budget availability versus actual vouchers/expenses.

## Business grain
- PO Line: one row per Purchase Order + Line Number.
- Voucher Expense: one row per voucher expense transaction, linked to the exact PO + Line Number.
- A PO can contain multiple lines.
- Available amount must be calculated at PO and PO-line levels without duplicating the original encumbrance.

## Required behavior
If PO 100 has line 1 = $5 and line 2 = $3, total PO encumbrance is $8.
If a voucher for $1 is posted against line 2:
- PO available = $7.
- PO line 2 available = $2.
- Selecting that voucher must filter the encumbrance side to PO 100 / line 2 only.

## Source
Direct Power BI source:
https://d.docs.live.net/eb1a13bb642143af/Paneles/Budget_PowerBI.xlsx

The OneDrive WebDAV URL requires Microsoft authentication. Power BI Desktop should connect with Organizational/Microsoft account credentials.

## Model
Do not relate Encumbrance and Expenses directly many-to-many.
Use DimPOLine as a bridge/dimension with key PO_ID + LINE_NBR.

Relationships:
- DimPOLine[POLineKey] 1 -> * Encumbrance[POLineKey]
- DimPOLine[POLineKey] 1 -> * Expenses[POLineKey]
- DimPO[PO_ID] 1 -> * DimPOLine[PO_ID]
- DimFecha[Fecha] 1 -> * Encumbrance[BUDGET_DT]
- DimFecha[Fecha] 1 -> * Expenses[BUDGET_DT]

Cross-filter direction for the two DimPOLine relationships should be Both so a voucher selection propagates:
Expenses -> DimPOLine -> Encumbrance.
This is intentional for the PO-line interaction scenario. Keep other relationships single-direction unless a specific visual requires otherwise.
