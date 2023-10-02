codeunit 69509 "Test Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        SALESPURCHTestInstall: Codeunit "Test Install";
    begin
        SALESPURCHTestInstall.SetupTestSuite();
    end;
}