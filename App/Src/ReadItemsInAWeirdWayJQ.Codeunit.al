codeunit 68101 "ReadItemsInAWeirdWay JQ"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        Item: Record Item;
        ItemLedgerEntries: record "Item Ledger Entry";
        GLEntry: Record "G/L Entry";
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

        item.Reset();
        item.setcurrentkey("Block Reason");
        if item.FindSet() then
            repeat
                i += 1;
            until item.Next() = 0;

        item.Reset();
        item.setcurrentkey("Block Reason");
        item.setfilter("Block Reason", 'B*');
        if item.FindSet() then
            repeat
                i += 1;
            until item.Next() = 0;

        item.Reset();
        item.setcurrentkey("Block Reason");
        item.setfilter("Block Reason", 'C*');
        if item.FindSet() then
            repeat
                i += 1;
            until item.Next() = 0;

        ItemLedgerEntries.Reset();
        ItemLedgerEntries.SetCurrentKey("Location Code");
        ItemLedgerEntries.SetRange("Location Code", 'B*');
        if ItemLedgerEntries.FindSet() then
            repeat
                i += 1;
            until ItemLedgerEntries.Next() = 0;

        ItemLedgerEntries.Reset();
        ItemLedgerEntries.SetCurrentKey(Description);
        ItemLedgerEntries.SetFilter(Description, 'T*');
        if ItemLedgerEntries.FindSet() then
            repeat
                i += 1;
            until ItemLedgerEntries.Next() = 0;

        GLEntry.Reset();
        GLEntry.SetCurrentKey(Description);
        GLEntry.SetFilter(Description, 'D*');
        if GLEntry.FindSet() then
            repeat
                i += 1;
            until GLEntry.Next() = 0;

        GLEntry.Reset();
        GLEntry.SetCurrentKey(Description);
        GLEntry.SetFilter(Description, 'F*');
        if GLEntry.FindSet() then
            repeat
                i += 1;
            until GLEntry.Next() = 0;

    end;
}