codeunit 70506 AppPerformanceSignal
{
    SingleInstance = true;

    var
        ProcessIdentifier: List of [Guid];
        StartDateTime: Dictionary of [Guid, DateTime];
        StartNoOfSqlStatements: Dictionary of [Guid, Integer];
        Message: Dictionary of [Guid, Text];

    procedure StartMeasure(ProcessId: Guid; pMessage: Text)
    begin
        if ProcessIdentifier.Contains(ProcessId) then exit;

        ProcessIdentifier.Add(ProcessId);
        StartDateTime.Add(ProcessId, CurrentDateTime);
        StartNoOfSqlStatements.Add(ProcessId, SessionInformation.SqlStatementsExecuted);
        Message.Add(ProcessId, pMessage);
    end;

    procedure StopMeasure(ProcessId: Guid)
    begin
        if not ProcessIdentifier.Contains(ProcessId) then exit;

        EmitPerformanceSignal(ProcessId);

        Cleanup(ProcessId);
    end;

    local procedure EmitPerformanceSignal(ProcessId: Guid)
    var
        Telemetry: Codeunit Telemetry;
        CustomDimensions: Dictionary of [Text, Text];
        Dur: Duration;
        TotalNoOfSqlStatements: Integer;
    begin

        Dur := CurrentDateTime - StartDateTime.Get(ProcessId);
        TotalNoOfSqlStatements := SessionInformation.SqlStatementsExecuted - StartNoOfSqlStatements.Get(ProcessId);

        CustomDimensions.Add('Duration', Format(Dur / 1, 0, 9));
        CustomDimensions.Add('NoSqlStatements', Format(TotalNoOfSqlStatements, 0, 9));

        Telemetry.LogMessage('WLD0011', Message.Get(ProcessId), Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::All, CustomDimensions);
    end;

    local procedure Cleanup(ProcessId: Guid)
    begin
        ProcessIdentifier.Remove(ProcessId);
        StartDateTime.Remove(ProcessId);
        StartNoOfSqlStatements.Remove(ProcessId);
        Message.Remove(ProcessId);
    end;
}