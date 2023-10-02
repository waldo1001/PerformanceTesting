codeunit 69508 "Test Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        SetupTestSuite();
    end;

    procedure SetupTestSuite()
    var
        ALTestSuite: Record "AL Test Suite";
        TestSuiteMgt: Codeunit "Test Suite Mgt.";
        SuiteName: Code[10];
        Me: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(Me);
        SuiteName := 'DEFAULT';

        if ALTestSuite.Get(SuiteName) then
            ALTestSuite.DELETE(true);

        TestSuiteMgt.CreateTestSuite(SuiteName);
        Commit();
        ALTestSuite.Get(SuiteName);

        // TestSuiteMgt.SelectTestMethodsByExtension(ALTestSuite, me.Id());
        TestSuiteMgt.SelectTestMethodsByRange(ALTestSuite, '50000..99999');

    end;
}