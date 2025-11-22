table 60102 "VRM Match Candidate"
{
    DataClassification = CustomerContent;
    Caption = 'Match Candidate';

    fields
    {
        field(1; "Project Code"; Code[20]) { TableRelation = "VRM Reconciliation Project"; }
        field(2; "Buffer Line No."; Integer) { TableRelation = "VRM Import Buffer"."Line No."; }

        field(3; "Match Score"; Decimal)
        {
            Caption = 'Similarity Score';
            DecimalPlaces = 1;
            MinValue = 0;
            MaxValue = 100;
        }
        field(4; "Suggested RecordId"; RecordId)
        {
            DataClassification = CustomerContent;
            Caption = 'Suggested Match';
        }
        field(5; "Existing Value"; Text[250])
        {
            Caption = 'Value in BC';
        }
        field(6; "Imported Value"; Text[250])
        {
            Caption = 'Value in CSV';
        }
        field(7; "User Decision"; Option)
        {
            OptionMembers = "No Action","Update Record";
            Caption = 'Decision';
        }
        field(8; "Sync Status"; Option)
        {
            OptionMembers = Pending,Success,Error;
            Editable = false;
        }
        field(9; "Error Log"; Text[250])
        {
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Project Code", "Buffer Line No.", "Match Score") { Clustered = true; }
        key(SortByScore; "Project Code", "Match Score") { }
    }
}