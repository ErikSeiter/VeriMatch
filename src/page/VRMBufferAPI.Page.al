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
            }
        }
    }
}