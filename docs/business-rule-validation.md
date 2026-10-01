# PO / Voucher Business Rule Validation

## Required rule

The semantic grain is **Purchase Order + Line Number**.

For a PO with:
- Line 1 = $5
- Line 2 = $3

The PO encumbrance is $8.

If a voucher of $1 is posted to line 2:
- PO available = $7.
- PO line 2 available = $2.
- Selecting that voucher must show only the matched PO line on the PO/encumbrance side.

## Implemented model

`DimPOLine[POLineKey]` is the common PO-line dimension. Both facts relate through the exact PO-line key.

- Expenses -> DimPOLine uses bidirectional propagation so selecting a voucher identifies its exact PO line.
- DimPOLine -> Encumbrance filters the encumbrance fact to that line.
- Business filters on the analysis page use DimPOLine attributes so Vendor, PO Status, PO, PO Line, Business Unit and Budget Date filter both facts consistently.

## Runtime validation against Budget_PowerBI.xlsx

Voucher `00011113`:
- PO_ID: `0000004567`
- LINE_NBR: `2`
- Encumbrance: $12,335.10
- Expense: $2,000.00
- Available: $10,335.10

PO `0000004567` total:
- Encumbrance: $23,735.20
- Expense: $16,820.00
- Available: $6,915.20

This confirms:
1. the voucher resolves to one exact PO line;
2. line availability is calculated at PO-line grain;
3. PO availability is the sum of all PO lines after their expenses.

## Data quality note

In the source workbook, the description associated with PO `0000004567`, line 2 currently contains text ending in “TEST PO Line 1”. The relationship and arithmetic use `PO_ID + LINE_NBR`, so the model still resolves the correct line; the description itself should be corrected upstream if it is intended to identify the line textually.
