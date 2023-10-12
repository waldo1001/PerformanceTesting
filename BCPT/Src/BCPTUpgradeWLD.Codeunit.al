codeunit 69102 "BCPT Upgrade WLD"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        BCPTInstall: Codeunit "BCPT Install WLD";
    begin
        BCPTInstall.SetupSuites();
    end;
}