codeunit 70502 "Telemetry On Tests"
{
    SingleInstance = true;

    var
        SignalCollection: List of [Dictionary of [Text, Text]];
        NoOfSQLStatements: Dictionary of [Text, Integer];
        NoOfReads: Dictionary of [Text, Integer];
        DateTimes: Dictionary of [Text, DateTime];
        TestSuiteEventIdLbl: label 'WLD00001', Locked = true;
        AfterRunTestSuiteLbl: Label 'Test Suite Finished.';
        TestCodeunitEventIdLbl: label 'WLD00002', Locked = true;
        AfterRunTestCodeunitLbl: Label 'Test Codeunit Finished.';
        TestMethodEventIdLbl: label 'WLD00003', Locked = true;
        AfterRunTestMethodLbl: Label 'Test Method Finished.';
        TotalNoOfSQL, TotalNoOfRds : Integer;
        TotalDuration: Duration;

    #region TestSuiteSignals
    var
        TestSuiteIdentifier: Text;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Test Runner - Mgt", OnRunTestSuite, '', false, false)]
    local procedure OnRunTestSuite(var TestMethodLine: Record "Test Method Line");
    begin
        clear(SignalCollection);

        TestSuiteIdentifier := GetMeasureIdentifier(TestMethodLine, TestSuiteEventIdLbl);

        StartMeasure(TestSuiteIdentifier);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Test Runner - Mgt", OnAfterRunTestSuite, '', false, false)]
    local procedure OnAfterRunTestSuite(var TestMethodLine: Record "Test Method Line");
    begin
        EndMeasure(TestMethodLine, TestSuiteEventIdLbl, AfterRunTestSuiteLbl, TestSuiteIdentifier);

        SendTelemetry();
    end;
    #endregion

    #region TestCodeunitSignals
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Test Runner - Mgt", OnBeforeCodeunitRun, '', false, false)]
    local procedure OnBeforeCodeunitRun(var TestMethodLine: Record "Test Method Line");
    begin
        StartMeasure(GetMeasureIdentifier(TestMethodLine, TestCodeunitEventIdLbl));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Test Runner - Mgt", OnAfterCodeunitRun, '', false, false)]
    local procedure OnAfterCodeunitRun(var TestMethodLine: Record "Test Method Line");
    begin
        EndMeasure(TestMethodLine, TestCodeunitEventIdLbl, AfterRunTestCodeunitLbl);
    end;
    #endregion

    #region TestMethodSignals
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Test Runner - Mgt", OnBeforeTestMethodRun, '', false, false)]
    local procedure OnBeforeTestMethodRun(var CurrentTestMethodLine: Record "Test Method Line"; CodeunitID: Integer; CodeunitName: Text[30]; FunctionName: Text[128]; FunctionTestPermissions: TestPermissions);
    begin
        StartMeasure(GetMeasureIdentifier(CurrentTestMethodLine, TestMethodEventIdLbl));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Test Runner - Mgt", OnAfterTestMethodRun, '', false, false)]
    local procedure OnAfterTestMethodRun(var CurrentTestMethodLine: Record "Test Method Line"; CodeunitID: Integer; CodeunitName: Text[30]; FunctionName: Text[128]; FunctionTestPermissions: TestPermissions; IsSuccess: Boolean);
    begin
        EndMeasure(CurrentTestMethodLine, TestMethodEventIdLbl, AfterRunTestMethodLbl);
    end;
    #endregion

    local procedure EndMeasure(var TestMethodLine: Record "Test Method Line"; EventId: Text; message: Text)
    var
        MeasureIdentifier: Text;
    begin
        MeasureIdentifier := GetMeasureIdentifier(TestMethodLine, EventId);

        EndMeasure(TestMethodLine, EventId, message, MeasureIdentifier);
    end;

    local procedure EndMeasure(var TestMethodLine: Record "Test Method Line"; EventId: Text; message: Text; MeasureIdentifier: Text)
    var
        TelemetryCustomDimensions: Dictionary of [Text, Text];
        OldStartTime: DateTime;
    begin
        if DateTimes.Get(MeasureIdentifier, OldStartTime) then
            TotalDuration := CurrentDateTime - OldStartTime
        else
            TotalDuration := 0;

        if NoOfSQLStatements.Get(MeasureIdentifier, TotalNoOfSQL) then
            TotalNoOfSQL := SessionInformation.SqlStatementsExecuted - TotalNoOfSQL
        else
            TotalNoOfSQL := 0;

        if NoOfReads.Get(MeasureIdentifier, TotalNoOfRds) then
            TotalNoOfRds := SessionInformation.SqlRowsRead - TotalNoOfRds
        else
            TotalNoOfRds := 0;

        if TotalDuration = 0 then
            TotalDuration := TestMethodLine."Finish Time" - TestMethodLine."Start Time";

        AddTelemetryToCollection(TestMethodLine, EventId, message, TelemetryCustomDimensions);
    end;

    local procedure AddTelemetryToCollection(var TestMethodLine: Record "Test Method Line"; EventId: Text; message: Text; var TelemetryCustomDimensions: Dictionary of [Text, Text]);
    begin
        clear(TelemetryCustomDimensions);
        TelemetryCustomDimensions.Add('eventId', EventId);
        TelemetryCustomDimensions.Add('message', message);

        TelemetryCustomDimensions.Add('TestSuiteName', TestMethodLine."Test Suite");
        TelemetryCustomDimensions.Add('Result', format(TestMethodLine.Result));
        if TestMethodLine.result = TestMethodLine.Result::Failure then begin
            TelemetryCustomDimensions.Add('ErrorMessage', TestMethodLine."Error Message Preview");
            TelemetryCustomDimensions.Add('ErrorCode', TestMethodLine."Error Code");
        end;
        TelemetryCustomDimensions.Add('Name', TestMethodLine.Name);
        if TestMethodLine."Test Codeunit" <> 0 then
            TelemetryCustomDimensions.Add('CodeunitId', format(TestMethodLine."Test Codeunit"));
        if TestMethodLine.Function <> '' then
            TelemetryCustomDimensions.Add('MethodName', TestMethodLine.Function);
        TelemetryCustomDimensions.Add('StartTime', format(TestMethodLine."Start Time", 0, 9));
        TelemetryCustomDimensions.Add('EndTime', format(TestMethodLine."Finish Time", 0, 9));
        TelemetryCustomDimensions.Add('NoOfSQLStatements', format(TotalNoOfSQL, 0, 9));
        TelemetryCustomDimensions.Add('NoOfReads', format(TotalNoOfRds, 0, 9));
        TelemetryCustomDimensions.Add('DurationMs', format(TotalDuration / 1, 0, 9));

        SignalCollection.Add(TelemetryCustomDimensions);
    end;

    local procedure SendTelemetry()
    var
        Telemetry: Codeunit Telemetry;
        Signal: Dictionary of [Text, Text];
        eventId, message : Text;
    begin
        foreach Signal in SignalCollection do begin
            eventId := Signal.Get('eventId');
            Signal.Remove('eventId');

            message := Signal.Get('message');
            Signal.Remove('message');

            Telemetry.LogMessage(eventId, message, Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::All, Signal);
        end;
    end;

    local procedure GetMeasureIdentifier(var TestMethodLine: Record "Test Method Line"; Identifier: Text): Text
    var
        IdentifierLbl: Label '%1-%2-%3', Locked = true, comment = '%1=Identifier, %2=TestSuite, %3=LineNo';
    begin
        exit(StrSubstNo(IdentifierLbl, Identifier, TestMethodLine."Test Suite", TestMethodLine."Line No."));
    end;

    local procedure StartMeasure(MeasureIdentifier: Text)
    var
        OldStartTime: DateTime;
        OldSQLCount, OldReadCount : Integer;
    begin
        if DateTimes.Get(MeasureIdentifier, OldStartTime) then
            DateTimes.Set(MeasureIdentifier, CurrentDateTime)
        else
            DateTimes.Add(MeasureIdentifier, CurrentDateTime);

        if NoOfSQLStatements.Get(MeasureIdentifier, OldSQLCount) then
            NoOfSQLStatements.Set(MeasureIdentifier, SessionInformation.SqlStatementsExecuted)
        else
            NoOfSQLStatements.Add(MeasureIdentifier, SessionInformation.SqlStatementsExecuted);

        if NoOfReads.Get(MeasureIdentifier, OldReadCount) then
            NoOfReads.Set(MeasureIdentifier, SessionInformation.SqlRowsRead)
        else
            NoOfReads.Add(MeasureIdentifier, SessionInformation.SqlRowsRead);
    end;


}