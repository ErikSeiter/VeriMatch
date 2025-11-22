page 60101 "VRM Match Worksheet"
{
    PageType = Worksheet;
    SourceTable = "VRM Match Candidate";
    Caption = 'VeriMatch Candidates';

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Match Score"; Rec."Match Score")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Higher is better.';
                }
                field("Imported Value"; Rec."Imported Value") { ApplicationArea = All; Style = Strong; ToolTip = 'The value imported from the source data file.'; }
                field("Existing Value"; Rec."Existing Value") { ApplicationArea = All; ToolTip = 'The existing value in the target system.'; }
                field("User Decision"; Rec."User Decision")
                {
                    ApplicationArea = All;
                    Style = StrongAccent;
                    StyleExpr = Rec."User Decision" = Rec."User Decision"::"Update Record";
                    ToolTip = 'The decision made by the user for this match candidate.';
                }
                field("Sync Status"; Rec."Sync Status") { ApplicationArea = All; ToolTip = 'The synchronization status of this match candidate.'; }
                field("Error Log"; Rec."Error Log") { ApplicationArea = All; Style = Attention; ToolTip = 'Details of any errors encountered during processing.'; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Apply)
            {
                Caption = 'Execute Updates';
                Image = Apply;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                ToolTip = 'Apply all approved changes to the target system.';

                trigger OnAction()
                var
                    Proc: Codeunit "VRM Processor";
                begin
                    Proc.ApplyApprovedChanges(Rec."Project Code");
                    CurrPage.Update();
                end;
            }
            action(AcceptSuggestions)
            {
                Caption = 'Accept Matches > 80%';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                ToolTip = 'Automatically sets Decision to Update for high confidence matches.';

                trigger OnAction()
                var
                    Cand: Record "VRM Match Candidate";
                begin
                    Cand.Copy(Rec);
                    Cand.SetFilter("Match Score", '>=80');
                    if Cand.FindSet() then
                        repeat
                            Cand."User Decision" := Cand."User Decision"::"Update Record";
                            Cand.Modify();
                        until Cand.Next() = 0;
                    CurrPage.Update();
                end;
            }
            action(ApproveSelection)
            {
                Caption = 'Set Selected to Update';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                ToolTip = 'Sets the Decision to "Update Record" for the highlighted lines.';

                trigger OnAction()
                var
                    SelectedCandidates: Record "VRM Match Candidate";
                    CountUpdated: Integer;
                begin
                    CurrPage.SetSelectionFilter(SelectedCandidates);

                    if SelectedCandidates.FindSet() then
                        repeat
                            SelectedCandidates."User Decision" := SelectedCandidates."User Decision"::"Update Record";
                            SelectedCandidates.Modify();
                            CountUpdated += 1;
                        until SelectedCandidates.Next() = 0;

                    CurrPage.Update(false);
                    Message('Marked %1 records to update.', CountUpdated);
                end;

            }
        }
    }


    trigger OnAfterGetRecord()
    begin
        if Rec."Match Score" > 90 then StyleTxt := 'Favorable' else StyleTxt := 'Standard';
    end;


    var
        StyleTxt: Text;
}