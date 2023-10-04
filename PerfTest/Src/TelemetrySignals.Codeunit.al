codeunit 70100 "Telemetry Signals"
{
    SingleInstance = true;

    var
        TelemetryCustomDimensions: Dictionary of [Text, Text];
        DurationMs: Duration;

    #region TestSuiteSignals
    var
        StartTestSuiteSignal: DateTime;
        StartTestSuiteNoOfSqlStatements: Integer;
        StartTestSuiteNoOfReads: Integer;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Test Runner - Mgt", OnRunTestSuite, '', false, false)]
    local procedure OnRunTestSuite(var TestMethodLine: Record "Test Method Line");
    begin
        StartTestSuiteSignal := CurrentDateTime;
        StartTestSuiteNoOfSqlStatements := SessionInformation.SqlStatementsExecuted;
        StartTestSuiteNoOfReads := SessionInformation.SqlRowsRead;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Test Runner - Mgt", OnAfterRunTestSuite, '', false, false)]
    local procedure OnAfterRunTestSuite(var TestMethodLine: Record "Test Method Line");
    var
        AfterRunTestSuiteLbl: Label 'Test Suite Finished.';
    begin
        GetBasicTelemetryCustomDimensions(TestMethodLine, TelemetryCustomDimensions);

        TelemetryCustomDimensions.Add('NoOfSqlStatements', format(SessionInformation.SqlStatementsExecuted - StartTestSuiteNoOfSqlStatements));
        TelemetryCustomDimensions.Add('NoOfReads', format(SessionInformation.SqlRowsRead - StartTestSuiteNoOfReads));
        TelemetryCustomDimensions.Add('DurationMs', format((CurrentDateTime - StartTestSuiteSignal) / 1));

        Session.LogMessage('WLD00001', AfterRunTestSuiteLbl, Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::All, TelemetryCustomDimensions);
    end;
    #endregion

    #region TestTestCodeunitSignals
    var
        StartTestCodeunit: DateTime;
        StartTestCodeunitNoOfSqlStatements: Integer;
        StartTestCodeunitNoOfReads: Integer;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Test Runner - Mgt", OnBeforeCodeunitRun, '', false, false)]
    local procedure OnBeforeCodeunitRun(var TestMethodLine: Record "Test Method Line");
    begin
        StartTestCodeunit := CurrentDateTime;
        StartTestCodeunitNoOfSqlStatements := SessionInformation.SqlStatementsExecuted;
        StartTestCodeunitNoOfReads := SessionInformation.SqlRowsRead;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Test Runner - Mgt", OnAfterCodeunitRun, '', false, false)]
    local procedure OnAfterCodeunitRun(var TestMethodLine: Record "Test Method Line");
    var
        AfterRunTestCodeunitLbl: Label 'Test Codeunit Finished.';
    begin
        GetBasicTelemetryCustomDimensions(TestMethodLine, TelemetryCustomDimensions);

        TelemetryCustomDimensions.Add('NoOfSqlStatements', format(SessionInformation.SqlStatementsExecuted - StartTestCodeunitNoOfSqlStatements));
        TelemetryCustomDimensions.Add('NoOfReads', format(SessionInformation.SqlRowsRead - StartTestCodeunitNoOfReads));
        TelemetryCustomDimensions.Add('DurationMs', format((CurrentDateTime - StartTestCodeunit) / 1));

        Session.LogMessage('WLD00002', AfterRunTestCodeunitLbl, Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::All, TelemetryCustomDimensions);
    end;
    #endregion

    #region TestMethodSignals
    var
        StartTestMethod: DateTime;
        StartTestMethodNoOfSqlStatements: Integer;
        StartTestMethodNoOfReads: Integer;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Test Runner - Mgt", OnBeforeTestMethodRun, '', false, false)]
    local procedure OnBeforeTestMethodRun(var CurrentTestMethodLine: Record "Test Method Line"; CodeunitID: Integer; CodeunitName: Text[30]; FunctionName: Text[128]; FunctionTestPermissions: TestPermissions);
    begin
        StartTestMethod := CurrentDateTime;
        StartTestMethodNoOfSqlStatements := SessionInformation.SqlStatementsExecuted;
        StartTestMethodNoOfReads := SessionInformation.SqlRowsRead;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Test Runner - Mgt", OnAfterTestMethodRun, '', false, false)]
    local procedure OnAfterTestMethodRun(var CurrentTestMethodLine: Record "Test Method Line"; CodeunitID: Integer; CodeunitName: Text[30]; FunctionName: Text[128]; FunctionTestPermissions: TestPermissions; IsSuccess: Boolean);
    var
        AfterRunTestMethodLbl: Label 'Test Method Finished.';
    begin
        GetBasicTelemetryCustomDimensions(CurrentTestMethodLine, TelemetryCustomDimensions);

        TelemetryCustomDimensions.Add('NoOfSqlStatements', format(SessionInformation.SqlStatementsExecuted - StartTestCodeunitNoOfSqlStatements));
        TelemetryCustomDimensions.Add('NoOfReads', format(SessionInformation.SqlRowsRead - StartTestCodeunitNoOfReads));
        TelemetryCustomDimensions.Add('DurationMs', format((CurrentDateTime - StartTestCodeunit) / 1));

        Session.LogMessage('WLD00003', AfterRunTestMethodLbl, Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::All, TelemetryCustomDimensions);
    end;
    #endregion

    local procedure GetBasicTelemetryCustomDimensions(var TestMethodLine: Record "Test Method Line"; var TelemetryCustomDimensions: Dictionary of [Text, Text]);
    begin
        clear(TelemetryCustomDimensions);
        TelemetryCustomDimensions.Add('TestSuiteName', TestMethodLine."Test Suite");
        TelemetryCustomDimensions.Add('Result', format(TestMethodLine.Result));
        if TestMethodLine.result = TestMethodLine.Result::Failure then begin
            TelemetryCustomDimensions.Add('Error Message', TestMethodLine."Error Message Preview");
            TelemetryCustomDimensions.Add('Error Code', TestMethodLine."Error Code");
        end;
        TelemetryCustomDimensions.Add('Name', TestMethodLine.Name);
        if TestMethodLine."Test Codeunit" <> 0 then
            TelemetryCustomDimensions.Add('CodeunitId', format(TestMethodLine."Test Codeunit"));
        if TestMethodLine.Function <> '' then
            TelemetryCustomDimensions.Add('MethodName', TestMethodLine.Function);
        TelemetryCustomDimensions.Add('StartTime', format(TestMethodLine."Start Time"));
        TelemetryCustomDimensions.Add('EndTime', format(TestMethodLine."Finish Time"));
    end;
}