page 60104 "VRM Project API"
{
    PageType = API;
    Caption = 'VeriMatch Project API';
    APIPublisher = 'contoso';
    APIGroup = 'verimatch';
    APIVersion = 'v1.0';
    EntityName = 'project';
    EntitySetName = 'projects';
    SourceTable = "VRM Reconciliation Project";
    DelayedInsert = true;
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId) { Caption = 'SystemId'; Editable = false; }
                field(code; Rec.Code) { Caption = 'Code'; }
                field(description; Rec.Description) { Caption = 'Description'; }
                field(targetTableId; Rec."Target Table ID") { Caption = 'TargetTableID'; }
                field(targetFieldId; Rec."Target Field ID") { Caption = 'TargetFieldID'; }
                field(minConfidence; Rec."Min. Confidence %") { Caption = 'MinConfidence'; }
                field(csvKeyColumnNo; Rec."CSV Key Column No.") { Caption = 'KeyColumnNo'; }
                field(status; Rec.Status) { Caption = 'Status'; Editable = false; }
            }
        }
    }


    [ServiceEnabled]
    procedure RunAnalysis()
    var
        JobQ: Record "Job Queue Entry";
    begin
        if Rec.Status = Rec.Status::Analysis_Running then
            Error('Analysis is already running.');

        JobQ.Init();
        JobQ."Object Type to Run" := JobQ."Object Type to Run"::Codeunit;
        JobQ."Object ID to Run" := Codeunit::"VRM Processor";
        JobQ."Parameter String" := Rec.Code;
        JobQ."Run in User Session" := false;
        Codeunit.Run(Codeunit::"Job Queue - Enqueue", JobQ);
    end;
}