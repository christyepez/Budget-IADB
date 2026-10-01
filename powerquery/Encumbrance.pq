let
    SourceUrl = "https://d.docs.live.net/eb1a13bb642143af/Paneles/Budget_PowerBI.xlsx",
    Wb = Excel.Workbook(Web.Contents(SourceUrl), null, true),
    // Adjust Item/Kind to the actual workbook object after first authentication.
    Raw = Wb{[Item="Encumbrance",Kind="Table"]}[Data],
    Headers = Table.PromoteHeaders(Raw, [PromoteAllScalars=true]),
    Types = Table.TransformColumnTypes(
        Headers,
        {
            {"PO_ID", type text},
            {"LINE_NBR", Int64.Type},
            {"MERCHANDISE_AMT", Currency.Type},
            {"BUDGET_DT", type date}
        }
    ),
    CleanPO = Table.TransformColumns(Types, {{"PO_ID", Text.Trim, type text}}),
    AddPOLineKey = Table.AddColumn(
        CleanPO,
        "POLineKey",
        each [PO_ID] & "|" & Text.PadStart(Text.From([LINE_NBR]), 6, "0"),
        type text
    )
in
    AddPOLineKey
