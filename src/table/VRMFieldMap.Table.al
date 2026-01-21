table 60100 "VRM Field Map"
{
    DataClassification = CustomerContent;
    Caption = 'VeriMatch Field Map';

    fields
    {
        field(1; "Project Code"; Code[20]) { TableRelation = "VRM Reconciliation Project"; }
        field(6; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(2; "Source Column Index"; Integer)
        {
            Caption = 'CSV Column No.';
            MinValue = 1;
            MaxValue = 20;
        }
        field(3; "Dest. Field ID"; Integer)
        {
            Caption = 'Destination Field ID';
            Description = 'The Field ID in the Target Table to be updated.';
        }
        field(4; "Dest. Field Caption"; Text[80])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("Dest. Table ID"), "No." = field("Dest. Field ID")));
        }
        field(5; "Dest. Table ID"; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID";
        }
    }

    keys
    {
        key(PK; "Project Code", "Line No.") { Clustered = true; }
    }

    trigger OnInsert()
    var
        VRMFieldMap: Record "VRM Field Map";
    begin
        if "Line No." = 0 then begin
            VRMFieldMap.SetRange("Project Code", Rec."Project Code");
            if VRMFieldMap.FindLast() then
                "Line No." := VRMFieldMap."Line No." + 10000
            else
                "Line No." := 10000;
        end;
    end;
}