table 60103 "VRM Reconciliation Project"
{
    DataClassification = CustomerContent;
    Caption = 'VeriMatch Project';
    LookupPageId = "VRM Project List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Project Code';
            NotBlank = true;
        }
        field(2; "Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(3; "Target Table ID"; Integer)
        {
            DataClassification = SystemMetadata;
            Caption = 'Target BC Table';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));

            trigger OnValidate()
            begin
                if "Target Table ID" <> xRec."Target Table ID" then begin
                    "Target Field ID" := 0;
                    "Target Field Name" := '';
                end;
            end;
        }
        field(4; "Target Field ID"; Integer)
        {
            DataClassification = SystemMetadata;
            Caption = 'Match Key Field ID';
            Description = 'The internal ID of the field used for comparison (e.g. 2 for Name).';
        }
        field(5; "Target Field Name"; Text[50])
        {
            DataClassification = SystemMetadata;
            Caption = 'Match Key Field Name';
            Editable = false;
        }
        field(6; "Min. Confidence %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum Confidence %';
            MinValue = 0;
            MaxValue = 100;
            InitValue = 80;
            Description = 'The threshold below which matches are automatically discarded.';
        }
        field(7; "CSV Key Column No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'CSV Key Column No.';
            MinValue = 1;
            MaxValue = 20;
            InitValue = 2;
            Description = 'The column in the CSV that contains the value to match (e.g. Name).';
        }
        field(8; "CSV Delimiter"; Enum "VRM CSV Delimiter")
        {
            DataClassification = CustomerContent;
            Caption = 'CSV Delimiter';
            InitValue = Semicolon;
        }
        field(10; "Status"; Option)
        {
            DataClassification = SystemMetadata;
            OptionMembers = Open,Data_Imported,Analysis_Running,Analysis_Complete;
            Editable = false;
        }
        field(11; "CSV Encoding"; Option)
        {
            Caption = 'CSV Encoding';
            OptionMembers = UTF8,UTF16,MSDOS,Windows;

        }
    }

    keys
    {
        key(PK; "Code") { Clustered = true; }
    }
}
