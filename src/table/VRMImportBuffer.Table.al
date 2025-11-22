table 60101 "VRM Import Buffer"
{
    DataClassification = CustomerContent;
    Caption = 'VeriMatch Buffer';

    fields
    {
        field(1; "Project Code"; Code[20])
        {
            TableRelation = "VRM Reconciliation Project";
        }
        field(2; "Line No."; Integer) { }


        field(10; "Col_1"; Text[250]) { }
        field(11; "Col_2"; Text[250]) { }
        field(12; "Col_3"; Text[250]) { }
        field(13; "Col_4"; Text[250]) { }
        field(14; "Col_5"; Text[250]) { }

        field(100; "Search Key"; Text[250])
        {
            Caption = 'Normalized Search Key';
            Description = 'The value extracted from the specific CSV column to match against BC.';
        }
    }

    keys
    {
        key(PK; "Project Code", "Line No.") { Clustered = true; }
    }
}