codeunit 68107 "Slow Down Posting Process"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforePostSalesDoc, '', false, false)]
    local procedure OnBeforePostSalesDoc(var Sender: Codeunit "Sales-Post"; var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean; var IsHandled: Boolean; var CalledBy: Integer);
    begin
        Insert500Waldos();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterPostSalesDoc, '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean; PreviewMode: Boolean);
    begin
        SlowLoopWithLotsOfSQLStatements();
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

    local procedure SlowLoopWithLotsOfSQLStatements()
    var
        JustSomeCountryWPT: Record "Just Some Country WPT";
        i: Integer;
    begin
        i := 0;
        JustSomeCountryWPT.FindSet();
        repeat
            JustSomeCountryWPT.CalcFields(TotalQuantity);
            i += 1;
            if i > 100 then exit;
        until JustSomeCountryWPT.Next() < 1;
    end;
}