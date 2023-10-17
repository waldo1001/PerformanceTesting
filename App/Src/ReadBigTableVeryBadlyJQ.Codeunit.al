codeunit 68104 "ReadBigTableVeryBadly JQ"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        JustSomeTableWPT: Record "Just Some Table WPT";
        i: integer;
    begin
        JustSomeTableWPT.Reset();
        JustSomeTableWPT.SetRange(Color, 'RED');
        if JustSomeTableWPT.FindSet() then
            repeat
                i += 1;
            until JustSomeTableWPT.next < 1;

        JustSomeTableWPT.Reset();
        JustSomeTableWPT.SetFilter(Message, 'd*');
        if JustSomeTableWPT.FindSet() then
            repeat
                i += 1;
            until JustSomeTableWPT.next < 1;

        JustSomeTableWPT.Reset();
        JustSomeTableWPT.SetCurrentKey(Message);
        JustSomeTableWPT.SetFilter(Message, 'a*');
        if JustSomeTableWPT.FindSet() then
            repeat
                i += 1;
            until JustSomeTableWPT.next < 1;
    end;
}