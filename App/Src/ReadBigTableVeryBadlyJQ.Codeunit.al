codeunit 68104 "ReadBigTableVeryBadly JQ"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        JustSomeTableWPT: Record "Just Some Table WPT";
    begin
        JustSomeTableWPT.SetRange(Color, 'RED');
        JustSomeTableWPT.FindSet();

        JustSomeTableWPT.Reset();
        JustSomeTableWPT.SetFilter(Message, '*de*', 'value');
        JustSomeTableWPT.FindSet();
    end;
}