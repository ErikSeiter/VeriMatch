page 60107 "VRM Mapping API"
{
    PageType = API;
    Caption = 'VeriMatch Mapping API';
    APIPublisher = 'contoso';
    APIGroup = 'verimatch';
    APIVersion = 'v1.0';
    EntityName = 'fieldMap';
    EntitySetName = 'fieldMaps';
    SourceTable = "VRM Field Map";
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
                field(sourceColumnIndex; Rec."Source Column Index") { Caption = 'SourceColumnIndex'; }
                field(destTableId; Rec."Dest. Table ID") { Caption = 'DestTableId'; }
                field(destFieldId; Rec."Dest. Field ID") { Caption = 'DestFieldId'; }
            }
        }
    }
}