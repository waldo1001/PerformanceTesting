codeunit 69100 "BCPT Install WLD"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        SetupSuites();

    end;

    procedure SetupSuites()
    begin
        SetupPOSSuite();
    end;

    local procedure SetupPOSSuite()
    var
        BCPTTestSuite: Codeunit "BCPT Test Suite";

    begin
        BCPTTestSuite.CreateTestSuiteHeader('BCPT', 'Actions with a focus on POS', 1, 100, 1000, 20, 'Sales Suite');
        BCPTTestSuite.AddLineToTestSuiteHeader('BCPT', codeunit::"BCPT Createsalesorder", 10, 'Create Sales Orders', 100, 1000, 5, false, '');
    end;

}