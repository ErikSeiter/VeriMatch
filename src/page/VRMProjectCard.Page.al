page 60102 "VRM Project Card"
{
    PageType = Card;
    SourceTable = "VRM Reconciliation Project";
    Caption = 'VeriMatch Project';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Project Settings';
                field("Code"; Rec.Code) { ApplicationArea = All; ToolTip = 'The unique code for this reconciliation project.'; }
                field(Description; Rec.Description) { ApplicationArea = All; ToolTip = 'Description of what data is being matched.'; }
                field("Target Table ID"; Rec."Target Table ID")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'The Business Central table ID being matched against.';
                }
                field("Target Field ID"; Rec."Target Field ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'The field in the target table to match against.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Fld: Record Field;
                    begin
                        Fld.SetRange(TableNo, Rec."Target Table ID");
                        Fld.SetFilter(Type, '%1|%2', Fld.Type::Text, Fld.Type::Code);
                        if Page.RunModal(Page::"Fields Lookup", Fld) = Action::LookupOK then begin
                            Rec.Validate("Target Field ID", Fld."No.");
                            Rec."Target Field Name" := Fld."Field Caption";
                        end;
                    end;
                }
                field("CSV Key Column No."; Rec."CSV Key Column No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Which column in the CSV contains the Name to match against?';
                }
                field("Min. Confidence %"; Rec."Min. Confidence %") { ApplicationArea = All; ToolTip = 'The minimum confidence percentage required to consider a match candidate for approval.'; }
                field(Status; Rec.Status) { ApplicationArea = All; Style = Strong; ToolTip = 'The current status of the reconciliation project.'; }
                field("CSV Delimiter"; Rec."CSV Delimiter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the character used to separate columns in your CSV file.';
                }
                field("CSV Encoding"; Rec."CSV Encoding")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the encoding format of your CSV file.';
                }
            }
            part(Mappings; "VRM Field Mapping Subform")
            {
                Caption = 'Update Mapping';
                SubPageLink = "Project Code" = field("Code"), "Dest. Table ID" = field("Target Table ID");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Import)
            {
                Caption = '1. Import CSV';
                Image = ImportCodes;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Import data from a CSV file into the reconciliation project.';

                trigger OnAction()
                begin
                    ImportFile();
                end;
            }
            action(Process)
            {
                Caption = '2. Run Analysis';
                Image = Start;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Run analysis on the imported data to identify potential matches.';

                trigger OnAction()
                var
                    JobQ: Record "Job Queue Entry";
                begin
                    if Confirm('Send to Job Queue?') then begin
                        JobQ.Init();
                        JobQ."Object Type to Run" := JobQ."Object Type to Run"::Codeunit;
                        JobQ."Object ID to Run" := Codeunit::"VRM Processor";
                        JobQ."Parameter String" := Rec.Code;
                        JobQ."Run in User Session" := false;
                        Codeunit.Run(Codeunit::"Job Queue - Enqueue", JobQ);
                    end;
                end;
            }
            action(Results)
            {
                Caption = '3. Review Candidates';
                Image = CheckList;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "VRM Match Worksheet";
                RunPageLink = "Project Code" = field("Code");
                ToolTip = 'Review the match candidates identified by the analysis process.';
            }
        }
    }

    local procedure ImportFile()
    var
        Buf: Record "VRM Import Buffer";
        Blob: Codeunit "Temp Blob";
        InStr: InStream;
        OutStr: OutStream;
        FileName: Text;
        Cols: List of [Text];
        LineTxt: Text;
        Delimiter: Text;
        TabChar: Char;
        i: Integer;
        KeyColIndex: Integer;
    begin
        if not UploadIntoStream('Select CSV File', '', '', FileName, InStr) then
            exit;

        case Rec."CSV Delimiter" of
            Rec."CSV Delimiter"::Semicolon:
                Delimiter := ';';
            Rec."CSV Delimiter"::Comma:
                Delimiter := ',';
            Rec."CSV Delimiter"::Pipe:
                Delimiter := '|';
            Rec."CSV Delimiter"::Colon:
                Delimiter := ':';
            Rec."CSV Delimiter"::Tilde:
                Delimiter := '~';
            Rec."CSV Delimiter"::Tab:
                begin
                    TabChar := 9;
                    Delimiter := Format(TabChar);
                end;
        end;

        KeyColIndex := Rec."CSV Key Column No.";
        if KeyColIndex = 0 then KeyColIndex := 2;

        Buf.SetRange("Project Code", Rec.Code);
        Buf.DeleteAll();

        Blob.CreateOutStream(OutStr);
        CopyStream(OutStr, InStr);

        case Rec."CSV Encoding" of
            Rec."CSV Encoding"::UTF8:
                Blob.CreateInStream(InStr, TextEncoding::UTF8);
            Rec."CSV Encoding"::UTF16:
                Blob.CreateInStream(InStr, TextEncoding::UTF16);
            Rec."CSV Encoding"::MSDOS:
                Blob.CreateInStream(InStr, TextEncoding::MSDOS);
            Rec."CSV Encoding"::Windows:
                Blob.CreateInStream(InStr, TextEncoding::Windows);
        end;

        while InStr.ReadText(LineTxt) > 0 do begin
            Cols := LineTxt.Split(Delimiter);

            Buf.Init();
            Buf."Project Code" := Rec.Code;
            Buf."Line No." += 1;

            for i := 1 to Cols.Count do
                if i <= 20 then
                    case i of
                        1:
                            Buf.Col_1 := CopyStr(Cols.Get(i), 1, 250);
                        2:
                            Buf.Col_2 := CopyStr(Cols.Get(i), 1, 250);
                        3:
                            Buf.Col_3 := CopyStr(Cols.Get(i), 1, 250);
                        4:
                            Buf.Col_4 := CopyStr(Cols.Get(i), 1, 250);
                        5:
                            Buf.Col_5 := CopyStr(Cols.Get(i), 1, 250);
                        6:
                            Buf.Col_6 := CopyStr(Cols.Get(i), 1, 250);
                        7:
                            Buf.Col_7 := CopyStr(Cols.Get(i), 1, 250);
                        8:
                            Buf.Col_8 := CopyStr(Cols.Get(i), 1, 250);
                        9:
                            Buf.Col_9 := CopyStr(Cols.Get(i), 1, 250);
                        10:
                            Buf.Col_10 := CopyStr(Cols.Get(i), 1, 250);
                        11:
                            Buf.Col_11 := CopyStr(Cols.Get(i), 1, 250);
                        12:
                            Buf.Col_12 := CopyStr(Cols.Get(i), 1, 250);
                        13:
                            Buf.Col_13 := CopyStr(Cols.Get(i), 1, 250);
                        14:
                            Buf.Col_14 := CopyStr(Cols.Get(i), 1, 250);
                        15:
                            Buf.Col_15 := CopyStr(Cols.Get(i), 1, 250);
                        16:
                            Buf.Col_16 := CopyStr(Cols.Get(i), 1, 250);
                        17:
                            Buf.Col_17 := CopyStr(Cols.Get(i), 1, 250);
                        18:
                            Buf.Col_18 := CopyStr(Cols.Get(i), 1, 250);
                        19:
                            Buf.Col_19 := CopyStr(Cols.Get(i), 1, 250);
                        20:
                            Buf.Col_20 := CopyStr(Cols.Get(i), 1, 250);
                    end;


            if (KeyColIndex > 0) and (KeyColIndex <= Cols.Count) then
                Buf."Search Key" := CopyStr(Cols.Get(KeyColIndex), 1, 250);

            Buf.Insert();
        end;

        Rec.Status := Rec.Status::Data_Imported;
        Rec.Modify();
        Message('Imported %1 lines using delimiter: "%2"', Buf.Count, Rec."CSV Delimiter");
    end;
}
