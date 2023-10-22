codeunit 70507 "Sales-Post PerfSignal"
{
    SingleInstance = true;

    var
        AppPerformanceSignal: Codeunit AppPerformanceSignal;
        ProcessIdentifier: Text;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforePostSalesDoc, '', false, false)]
    local procedure OnBeforePostSalesDoc(var Sender: Codeunit "Sales-Post"; var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean; var IsHandled: Boolean; var CalledBy: Integer);
    begin
        //Only when webclient?

        ProcessIdentifier := CreateGuid();
        AppPerformanceSignal.StartMeasure(ProcessIdentifier, StrSubstNo('Sales-Post %1', format(SalesHeader."Document Type")));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterPostSalesDoc, '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean; PreviewMode: Boolean);
    begin
        AppPerformanceSignal.StopMeasure(ProcessIdentifier);
    end;

}