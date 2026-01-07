codeunit 60100 "VRM Algorithm Lib"
{
    Access = Internal;

    procedure NormalizeText(Input: Text): Text
    begin
        if Input = '' then exit('');

        Input := UpperCase(Input);

        Input := DelChr(Input, '=', '.,-/\()&_ ');

        exit(Input);
    end;

    procedure GetSimilarity(TextA: Text; TextB: Text): Decimal
    var
        Matrix: Array[102, 102] of Integer;
        LenA, LenB, Cost, i, j, MinVal : Integer;
        MaxLen: Integer;
        Distance: Integer;
    begin
        Clear(Matrix);

        TextA := UpperCase(DelChr(TextA, '<>', ' '));
        TextB := UpperCase(DelChr(TextB, '<>', ' '));

        if TextA = TextB then exit(100);
        if (TextA = '') or (TextB = '') then exit(0);

        LenA := StrLen(TextA);
        LenB := StrLen(TextB);

        if LenA > 100 then LenA := 100;
        if LenB > 100 then LenB := 100;

        for i := 0 to LenA do Matrix[i + 1, 1] := i;
        for j := 0 to LenB do Matrix[1, j + 1] := j;

        for i := 1 to LenA do
            for j := 1 to LenB do begin
                if TextA[i] = TextB[j] then
                    Cost := 0
                else
                    Cost := 1;

                MinVal := Matrix[i, j + 1] + 1;
                if (Matrix[i + 1, j] + 1) < MinVal then
                    MinVal := Matrix[i + 1, j] + 1;
                if (Matrix[i, j] + Cost) < MinVal then
                    MinVal := Matrix[i, j] + Cost;

                Matrix[i + 1, j + 1] := MinVal;
            end;

        Distance := Matrix[LenA + 1, LenB + 1];

        if LenA > LenB then MaxLen := LenA else MaxLen := LenB;

        if MaxLen = 0 then exit(0);

        exit((1.0 - (Distance / MaxLen)) * 100);
    end;
}