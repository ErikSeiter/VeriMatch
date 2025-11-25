page 60105 "VRM Buffer API"
{
    PageType = API;
    Caption = 'VeriMatch Buffer API';
    APIPublisher = 'contoso';
    APIGroup = 'verimatch';
    APIVersion = 'v1.0';
    EntityName = 'bufferLine';
    EntitySetName = 'bufferLines';
    SourceTable = "VRM Import Buffer";
    DelayedInsert = true;
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId) { Caption = 'SystemId'; Editable = false; }
                field(projectCode; Rec."Project Code") { Caption = 'ProjectCode'; }
                field(lineNo; Rec."Line No.") { Caption = 'LineNo'; }
                field(searchKey; Rec."Search Key") { Caption = 'SearchKey'; }
                field(col1; Rec.Col_1) { Caption = 'Col1'; }
                field(col2; Rec.Col_2) { Caption = 'Col2'; }
                field(col3; Rec.Col_3) { Caption = 'Col3'; }
                field(col4; Rec.Col_4) { Caption = 'Col4'; }
                field(col5; Rec.Col_5) { Caption = 'Col5'; }
                field(col6; Rec.Col_6) { Caption = 'Col6'; }
                field(col7; Rec.Col_7) { Caption = 'Col7'; }
                field(col8; Rec.Col_8) { Caption = 'Col8'; }
                field(col9; Rec.Col_9) { Caption = 'Col9'; }
                field(col10; Rec.Col_10) { Caption = 'Col10'; }
                field(col11; Rec.Col_11) { Caption = 'Col11'; }
                field(col12; Rec.Col_12) { Caption = 'Col12'; }
                field(col13; Rec.Col_13) { Caption = 'Col13'; }
                field(col14; Rec.Col_14) { Caption = 'Col14'; }
                field(col15; Rec.Col_15) { Caption = 'Col15'; }
                field(col16; Rec.Col_16) { Caption = 'Col16'; }
                field(col17; Rec.Col_17) { Caption = 'Col17'; }
                field(col18; Rec.Col_18) { Caption = 'Col18'; }
                field(col19; Rec.Col_19) { Caption = 'Col19'; }
                field(col20; Rec.Col_20) { Caption = 'Col20'; }

            }
        }
    }
}