codeunit 60101 "VRM Processor"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        Project: Record "VRM Reconciliation Project";
    begin
        if Project.Get(Rec."Parameter String") then
            ProcessProject(Project);
    end;

    procedure ProcessProject(var Project: Record "VRM Reconciliation Project")
    var
        Buffer: Record "VRM Import Buffer";
        Candidate: Record "VRM Match Candidate";
        Algo: Codeunit "VRM Algorithm Lib";
        BestRecId: RecordId;
        TargetRecRef: RecordRef;
        TargetFldRef: FieldRef;

        TargetVal: Text;
        BestScore: Decimal;
        CurrentScore: Decimal;

    begin
        Project.Status := Project.Status::Analysis_Running;
        Project.Modify();

        Candidate.SetRange("Project Code", Project.Code);
        Candidate.DeleteAll();

        TargetRecRef.Open(Project."Target Table ID");

        Buffer.SetRange("Project Code", Project.Code);
        if Buffer.FindSet() then
            repeat
                BestScore := 0;
                Clear(BestRecId);


                if TargetRecRef.FindSet() then
                    repeat
                        TargetFldRef := TargetRecRef.Field(Project."Target Field ID");
                        TargetVal := Format(TargetFldRef.Value);

                        if Abs(StrLen(Buffer."Search Key") - StrLen(TargetVal)) < 5 then begin

                            CurrentScore := Algo.GetSimilarity(Buffer."Search Key", TargetVal);

                            if (CurrentScore >= Project."Min. Confidence %") and (CurrentScore > BestScore) then begin
                                BestScore := CurrentScore;
                                BestRecId := TargetRecRef.RecordId;
                            end;
                        end;
                    until TargetRecRef.Next() = 0;


                if BestScore > 0 then
                    CreateCandidate(Project, Buffer, BestRecId, BestScore);

            until Buffer.Next() = 0;


        TargetRecRef.Close();
        Project.Status := Project.Status::Analysis_Complete;
        Project.Modify();
    end;

    local procedure CreateCandidate(Proj: Record "VRM Reconciliation Project"; Buf: Record "VRM Import Buffer"; RecID: RecordId; Score: Decimal)
    var
        Cand: Record "VRM Match Candidate";
        RR: RecordRef;
        FR: FieldRef;
    begin
        Cand.Init();
        Cand."Project Code" := Proj.Code;
        Cand."Buffer Line No." := Buf."Line No.";
        Cand."Match Score" := Score;
        Cand."Suggested RecordId" := RecID;
        Cand."Imported Value" := Buf."Search Key";

        if RR.Get(RecID) then begin
            FR := RR.Field(Proj."Target Field ID");
            Cand."Existing Value" := CopyStr(Format(FR.Value), 1, 250);
        end;

        Cand.Insert();
    end;


    procedure ApplyApprovedChanges(ProjectCode: Code[20])
    var
        Cand: Record "VRM Match Candidate";
        Map: Record "VRM Field Map";
        Buf: Record "VRM Import Buffer";
        TargetRR: RecordRef;
        TargetFR: FieldRef;
        SourceVal: Text;
    begin
        Cand.SetRange("Project Code", ProjectCode);
        Cand.SetRange("User Decision", Cand."User Decision"::"Update Record");
        Cand.SetRange("Sync Status", Cand."Sync Status"::Pending);

        if Cand.FindSet() then
            repeat
                if Buf.Get(ProjectCode, Cand."Buffer Line No.") then
                    if TargetRR.Get(Cand."Suggested RecordId") then begin

                        Map.SetRange("Project Code", ProjectCode);
                        if Map.FindSet() then begin
                            repeat
                                SourceVal := GetColValue(Buf, Map."Source Column Index");
                                TargetFR := TargetRR.Field(Map."Dest. Field ID");

                                if not SafeValidate(TargetFR, SourceVal) then begin
                                    Cand."Sync Status" := Cand."Sync Status"::Error;
                                    Cand."Error Log" := CopyStr(GetLastErrorText(), 1, 250);
                                end;
                            until Map.Next() = 0;

                            TargetRR.Modify(true);
                            Cand."Sync Status" := Cand."Sync Status"::Success;
                        end;
                    end else begin
                        Cand."Sync Status" := Cand."Sync Status"::Error;
                        Cand."Error Log" := 'Record deleted by another user.';
                    end;

                Cand.Modify();
            until Cand.Next() = 0;
    end;


    [TryFunction]
    local procedure SafeValidate(var Fld: FieldRef; Val: Text)
    begin
        Fld.Validate(Val);
    end;

    local procedure GetColValue(Buf: Record "VRM Import Buffer"; Idx: Integer): Text
    begin
        case Idx of
            1:
                exit(Buf.Col_1);
            2:
                exit(Buf.Col_2);
            3:
                exit(Buf.Col_3);
            4:
                exit(Buf.Col_4);
            5:
                exit(Buf.Col_5);
            6:
                exit(Buf.Col_6);
            7:
                exit(Buf.Col_7);
            8:
                exit(Buf.Col_8);
            9:
                exit(Buf.Col_9);
            10:
                exit(Buf.Col_10);
            11:
                exit(Buf.Col_11);
            12:
                exit(Buf.Col_12);
            13:
                exit(Buf.Col_13);
            14:
                exit(Buf.Col_14);
            15:
                exit(Buf.Col_15);
            16:
                exit(Buf.Col_16);
            17:
                exit(Buf.Col_17);
            18:
                exit(Buf.Col_18);
            19:
                exit(Buf.Col_19);
            20:
                exit(Buf.Col_20);
        end;
    end;
}