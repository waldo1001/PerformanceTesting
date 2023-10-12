codeunit 69102 "BCPT Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        BCPTInstall: Codeunit "BCPT Install";
    begin
        BCPTInstall.SetupSuites();
    end;
}