page 60106 "VRM Candidate API"
{
    PageType = API;
    Caption = 'VeriMatch Candidate API';
    APIPublisher = 'contoso';
    APIGroup = 'verimatch';
    APIVersion = 'v1.0';
    EntityName = 'candidate';
    EntitySetName = 'candidates';
    SourceTable = "VRM Match Candidate";
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId) { Caption = 'SystemId'; Editable = false; }
                field(projectCode; Rec."Project Code") { Caption = 'ProjectCode'; Editable = false; }
                field(matchScore; Rec."Match Score") { Caption = 'MatchScore'; Editable = false; }
                field(importedValue; Rec."Imported Value") { Caption = 'ImportedValue'; Editable = false; }
                field(existingValue; Rec."Existing Value") { Caption = 'ExistingValue'; Editable = false; }
                field(userDecision; Rec."User Decision") { Caption = 'UserDecision'; }
                field(syncStatus; Rec."Sync Status") { Caption = 'SyncStatus'; Editable = false; }
                field(errorLog; Rec."Error Log") { Caption = 'ErrorLog'; Editable = false; }
            }
        }
    }
}