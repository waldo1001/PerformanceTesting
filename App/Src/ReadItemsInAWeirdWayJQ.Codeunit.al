codeunit 68101 "ReadItemsInAWeirdWay JQ"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        Item: Record Item;
    begin
        Item.SetRange("Assembly BOM", false);
        item.FindSet();

        item.SetRange(Comment, false);
        item.FindSet();
    end;
}