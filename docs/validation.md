# Data quality and validation checklist

1. PO_ID must not be blank in either fact table for linked transactions.
2. LINE_NBR must be normalized to one numeric format.
3. POLineKey must be unique in DimPOLine.
4. Encumbrance grain must be confirmed. If it contains repeated snapshots/distribution rows, do not blindly SUM MERCHANDISE_AMT; first identify the authoritative line amount.
5. Voucher_ID may repeat across voucher lines; use voucher-line grain where required.
6. Verify whether MERCHANDISE_AMT in Expenses is signed or always positive.
7. Flag unmatched expense lines where Expenses[POLineKey] is not found in DimPOLine/Encumbrance.
8. Do not use a direct many-to-many Encumbrance <-> Expenses relationship.
9. Use a central DimFecha for day/week/month/quarter/semester/year analysis.
10. Dates should be Date values, not text, and presentation format should be dd/MM/yyyy.

## Reconciliation test
Create a matrix:
PO_ID > LINE_NBR
Values:
- Encumbrance Amount
- Expense Amount
- Available Amount

Then add Voucher_ID from Expenses as a slicer or table and verify exact line filtering.
