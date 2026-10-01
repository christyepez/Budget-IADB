# Semantic model design

## Keys

Create the same normalized key in Encumbrance, Expenses, and DimPOLine:

```DAX
POLineKey =
VAR PO = TRIM ( FORMAT ( [PO_ID], "" ) )
VAR Line = FORMAT ( VALUE ( [LINE_NBR] ), "000000" )
RETURN PO & "|" & Line
```

If LINE_NBR is text, normalize it in Power Query before creating the key.

## DimPOLine

Build from the union of Encumbrance and Expenses so every valid PO line used by a voucher exists in the bridge.

```DAX
DimPOLine =
DISTINCT (
    UNION (
        SELECTCOLUMNS (
            Encumbrance,
            "POLineKey", Encumbrance[POLineKey],
            "PO_ID", Encumbrance[PO_ID],
            "LINE_NBR", Encumbrance[LINE_NBR]
        ),
        SELECTCOLUMNS (
            Expenses,
            "POLineKey", Expenses[POLineKey],
            "PO_ID", Expenses[PO_ID],
            "LINE_NBR", Expenses[LINE_NBR]
        )
    )
)
```

Never use PO_ID alone to join Expenses to Encumbrance because one PO can contain multiple lines.
