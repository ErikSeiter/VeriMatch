page 60100 "VRM Field Mapping Subform"
{
    PageType = ListPart;
    SourceTable = "VRM Field Map";
    Caption = 'Field Mappings';
    DelayedInsert = true;
    AutoSplitKey = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Project Code"; Rec."Project Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

                field("Source Column Index"; Rec."Source Column Index")
                {
                    ApplicationArea = All;
                    ToolTip = 'The column number in your CSV file (e.g., 3 for Phone No).';
                }
                field("Dest. Field ID"; Rec."Dest. Field ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'The field in Business Central to update.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Fld: Record Field;
                        Project: Record "VRM Reconciliation Project";
                        TableID: Integer;
                        ProjCode: Code[20];
                    begin
                        TableID := Rec."Dest. Table ID";

                        if TableID = 0 then begin
                            ProjCode := Rec."Project Code";

                            // Fallback if Rec is not yet initialized
                            if (ProjCode = '') and (Rec.GetFilter("Project Code") <> '') then
                                ProjCode := Rec.GetRangeMin("Project Code");

                            if Project.Get(ProjCode) then
                                TableID := Project."Target Table ID";
                        end;

                        if TableID = 0 then
                            Error('Target Table not defined. Please select a Target Table on the Project Card.');

                        Fld.SetRange(TableNo, TableID);
                        Fld.SetFilter("No.", '<2000000000');
                        Fld.SetFilter(Type, '<>%1', Fld.Type::BLOB);

                        if Page.RunModal(Page::"Fields Lookup", Fld) = Action::LookupOK then begin
                            Rec.Validate("Dest. Field ID", Fld."No.");

                            if Rec."Dest. Table ID" = 0 then
                                Rec."Dest. Table ID" := TableID;
                        end;
                    end;
                }
                field("Dest. Field Caption"; Rec."Dest. Field Caption")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    ToolTip = 'The name of the field in Business Central to update.';
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Rec.GetFilter("Project Code") <> '' then
            Rec."Project Code" := Rec.GetRangeMin("Project Code");


        if Rec.GetFilter("Dest. Table ID") <> '' then
            Rec."Dest. Table ID" := Rec.GetRangeMin("Dest. Table ID");
    end;
}