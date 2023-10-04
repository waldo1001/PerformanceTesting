codeunit 70100 "Telemetry Signals"
{
    SingleInstance = true;

    var
        DurationMs: Duration;
        SignalCollection: List of [Dictionary of [Text, Text]];

    #region TestSuiteSignals
    var
        StartTestSuiteSignal: DateTime;
        StartTestSuiteNoOfSqlStatements: Integer;
        StartTestSuiteNoOfReads: Integer;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Test Runner - Mgt", OnRunTestSuite, '', false, false)]
    local procedure OnRunTestSuite(var TestMethodLine: Record "Test Method Line");
    begin
        clear(SignalCollection);

        StartTestSuiteSignal := CurrentDateTime;
        StartTestSuiteNoOfSqlStatements := SessionInformation.SqlStatementsExecuted;
        StartTestSuiteNoOfReads := SessionInformation.SqlRowsRead;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Test Runner - Mgt", OnAfterRunTestSuite, '', false, false)]
    local procedure OnAfterRunTestSuite(var TestMethodLine: Record "Test Method Line");
    var
        AfterRunTestSuiteLbl: Label 'Test Suite Finished.';
        TelemetryCustomDimensions: Dictionary of [Text, Text];
    begin
        GetBasicTelemetryCustomDimensions(TestMethodLine, TelemetryCustomDimensions);

        TelemetryCustomDimensions.Add('eventId', 'WLD00001');
        TelemetryCustomDimensions.Add('message', AfterRunTestSuiteLbl);
        TelemetryCustomDimensions.Add('NoOfSqlStatements', format(SessionInformation.SqlStatementsExecuted - StartTestSuiteNoOfSqlStatements));
        TelemetryCustomDimensions.Add('NoOfReads', format(SessionInformation.SqlRowsRead - StartTestSuiteNoOfReads));
        TelemetryCustomDimensions.Add('DurationMs', format((CurrentDateTime - StartTestSuiteSignal) / 1));

        SignalCollection.Add(TelemetryCustomDimensions);

        SendTelemetry();
    end;
    #endregion

    #region TestTestCodeunitSignals
    var
        StartTestCodeunit: DateTime;
    // StartTestCodeunitNoOfSqlStatements: Integer;
    // StartTestCodeunitNoOfReads: Integer;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Test Runner - Mgt", OnBeforeCodeunitRun, '', false, false)]
    local procedure OnBeforeCodeunitRun(var TestMethodLine: Record "Test Method Line");
    begin
        StartTestCodeunit := CurrentDateTime;
        TestMethodLine."Start No. Of SQL Statements" := SessionInformation.SqlStatementsExecuted;
        TestMethodLine."Start No. Of Reads" := SessionInformation.SqlRowsRead;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Test Runner - Mgt", OnAfterCodeunitRun, '', false, false)]
    local procedure OnAfterCodeunitRun(var TestMethodLine: Record "Test Method Line");
    var
        AfterRunTestCodeunitLbl: Label 'Test Codeunit Finished.';
        TelemetryCustomDimensions: Dictionary of [Text, Text];
    begin
        GetBasicTelemetryCustomDimensions(TestMethodLine, TelemetryCustomDimensions);

        TelemetryCustomDimensions.Add('eventId', 'WLD00002');
        TelemetryCustomDimensions.Add('message', AfterRunTestCodeunitLbl);
        TelemetryCustomDimensions.Add('NoOfSqlStatements', format(SessionInformation.SqlStatementsExecuted - StartTestCodeunitNoOfSqlStatements));
        TelemetryCustomDimensions.Add('NoOfReads', format(SessionInformation.SqlRowsRead - StartTestCodeunitNoOfReads));
        TelemetryCustomDimensions.Add('DurationMs', format((TestMethodLine."Finish Time" - TestMethodLine."Start Time") / 1));

        SignalCollection.Add(TelemetryCustomDimensions);
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
        TelemetryCustomDimensions: Dictionary of [Text, Text];
    begin
        GetBasicTelemetryCustomDimensions(CurrentTestMethodLine, TelemetryCustomDimensions);

        TelemetryCustomDimensions.Add('eventId', 'WLD00003');
        TelemetryCustomDimensions.Add('message', AfterRunTestMethodLbl);
        TelemetryCustomDimensions.Add('NoOfSqlStatements', format(SessionInformation.SqlStatementsExecuted - StartTestCodeunitNoOfSqlStatements));
        TelemetryCustomDimensions.Add('NoOfReads', format(SessionInformation.SqlRowsRead - StartTestCodeunitNoOfReads));
        TelemetryCustomDimensions.Add('DurationMs', format((CurrentTestMethodLine."Finish Time" - CurrentTestMethodLine."Start Time") / 1));

        SignalCollection.Add(TelemetryCustomDimensions);
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

    local procedure SendTelemetry()
    var
        Signal: Dictionary of [Text, Text];
        eventId, message : Text;
    begin
        foreach Signal in SignalCollection do begin
            eventId := Signal.Get('eventId');
            Signal.Remove('eventId');

            message := Signal.Get('message');
            Signal.Remove('message');

            Session.LogMessage(eventId, message, Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::All, Signal);
        end;
    end;
}