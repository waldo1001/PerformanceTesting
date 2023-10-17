codeunit 68101 "ReadItemsInAWeirdWay JQ"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        Item: Record Item;
        ItemLedgerEntries: record "Item Ledger Entry";
        i: Integer;
    begin
        item.Reset();
        Item.SetRange("Assembly BOM", false);
        item.FindSet();
        if item.FindSet() then
            repeat
                i += 1;
            until item.Next() = 0;

        item.Reset();
        item.SetRange(Comment, false);
        item.FindSet();
        if item.FindSet() then
            repeat
                i += 1;
            until item.Next() = 0;

        ItemLedgerEntries.Reset();
        ItemLedgerEntries.SetRange("Location Code", '01');
        if ItemLedgerEntries.FindSet() then
            repeat
                i += 1;
            until ItemLedgerEntries.Next() = 0;

        ItemLedgerEntries.Reset();
        ItemLedgerEntries.SetFilter(Description, '*C');
        if ItemLedgerEntries.FindSet() then
            repeat
                i += 1;
            until ItemLedgerEntries.Next() = 0;
    end;
}