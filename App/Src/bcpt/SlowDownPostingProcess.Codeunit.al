codeunit 68107 "Slow Down Posting Process"
{
    //Slowing down
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Page Management", 'OnAfterGetPageID', '', false, false)]
    local procedure OnAfterGetPageID(var PageID: Integer)
    begin
        if PageID = page::"Sales Invoice" then
            Insert500Waldos();
    end;

    [EventSubscriber(ObjectType::Page, page::"Sales Invoice", 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenPageEvent()
    begin
        Insert500Waldos();
    end;

    [EventSubscriber(ObjectType::Page, page::"Sales Invoice", 'OnAfterGetCurrRecordEvent', '', false, false)]
    local procedure OnAfterGetCurrRecordEvent()
    begin
        Insert500Waldos();
    end;

    [EventSubscriber(ObjectType::Page, page::"Sales Invoice", 'OnAfterOnAfterGetRecord', '', false, false)]
    local procedure OnAfterOnAfterGetRecord()
    begin
        Insert500Waldos();
    end;

    [EventSubscriber(ObjectType::Page, page::"Sales Invoice Subform", 'OnAfterGetRecordEvent', '', false, false)]
    local procedure OnAfterGetRecordEvent()
    begin
        Insert500Waldos();
    end;


    //slow down posting
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterPostGLAcc', '', false, false)]
    local procedure OnAfterPostGLAcc(var Sender: Codeunit "Gen. Jnl.-Post Line"; var GenJnlLine: Record "Gen. Journal Line"; var TempGLEntryBuf: Record "G/L Entry"; var NextEntryNo: Integer; var NextTransactionNo: Integer; Balancing: Boolean);
    begin
        Insert500Waldos();
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterCheckSalesApprovalPossible', '', false, false)]
    local procedure OnAfterCheckSalesApprovalPossible(var SalesHeader: Record "Sales Header");
    begin
        Insert500Waldos();
    end;

    local procedure Insert500Waldos()
    var
        EmptyTableWPT: Record "EmptyTable WPT";
        i: integer;
        cnt: Integer;
    begin
        cnt := 500;

        for i := 1 to cnt do
            EmptyTableWPT.InsertWaldo(false, format(i));
    end;

}