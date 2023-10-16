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
        RecRef: RecordRef;
    begin
        RecRef.Open(149000);
        RecRef.DeleteAll(true);

        BCPTTestSuite.CreateTestSuiteHeader('BCPT', 'Actions with a focus on POS', 1, 100, 1000, 20, 'Sales Suite');
        BCPTTestSuite.AddLineToTestSuiteHeader('BCPT', codeunit::"BCPT Createsalesorder", 10, 'Create Sales Orders', 100, 1000, 5, false, '');
        BCPTTestSuite.AddLineToTestSuiteHeader('BCPT', codeunit::"BCPT Post Sales Order", 10, 'Create Sales Invoices', 100, 1000, 5, false, '');
    end;

}