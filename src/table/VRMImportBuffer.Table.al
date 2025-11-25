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
        field(15; "Col_6"; Text[250]) { }
        field(16; "Col_7"; Text[250]) { }
        field(17; "Col_8"; Text[250]) { }
        field(18; "Col_9"; Text[250]) { }
        field(20; "Col_10"; Text[250]) { }
        field(21; "Col_11"; Text[250]) { }
        field(22; "Col_12"; Text[250]) { }
        field(23; "Col_13"; Text[250]) { }
        field(24; "Col_14"; Text[250]) { }
        field(25; "Col_15"; Text[250]) { }
        field(26; "Col_16"; Text[250]) { }
        field(27; "Col_17"; Text[250]) { }
        field(28; "Col_18"; Text[250]) { }
        field(29; "Col_19"; Text[250]) { }
        field(30; "Col_20"; Text[250]) { }

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