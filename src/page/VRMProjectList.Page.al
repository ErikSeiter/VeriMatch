
page 60103 "VRM Project List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "VRM Reconciliation Project";
    CardPageId = "VRM Project Card";
    Caption = 'VeriMatch Projects';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'The unique code for this reconciliation project.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Description of what data is being matched.';
                }
                field("Target Table ID"; Rec."Target Table ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'The Business Central table ID being matched against.';
                }
                field("Min. Confidence %"; Rec."Min. Confidence %")
                {
                    ApplicationArea = All;
                    ToolTip = 'The minimum confidence percentage required to consider a match candidate for approval.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    StyleExpr = StatusStyle;
                    ToolTip = 'The current status of the reconciliation project.';
                }
            }
        }
    }

    var
        StatusStyle: Text;

    trigger OnAfterGetRecord()
    begin
        case Rec.Status of
            Rec.Status::Analysis_Complete:
                StatusStyle := 'Favorable';
            Rec.Status::Analysis_Running:
                StatusStyle := 'Ambiguous'; // Yellow/Orange
            else
                StatusStyle := 'Standard';
        end;
    end;
}