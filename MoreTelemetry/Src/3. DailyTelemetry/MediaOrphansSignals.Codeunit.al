codeunit 70503 MediaOrphansSignals
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Telemetry Management", OnSendDailyTelemetry, '', false, false)]
    local procedure OnSendDailyTelemetry();
    begin
        EmitOrphansIndexSignal();
    end;

    local procedure EmitOrphansIndexSignal()
    var
        Telemetry: Codeunit Telemetry;
    begin
        EmitMediaOrphansIndexSignal();
        EmitMediaSetOrphansIndexSignal();
    end;

    local procedure EmitMediaOrphansIndexSignal()
    var
        MediaOrphans: List of [Guid];
        CustomDimensions: Dictionary of [Text, Text];
        Telemetry: Codeunit Telemetry;
    begin
        MediaOrphans := Media.FindOrphans();

        if MediaOrphans.count <> 0 then begin
            CustomDimensions.Add('NoOfOrphans', format(MediaOrphans.count));

            Telemetry.LogMessage('WLD0005', 'Media orphans found!', Verbosity::Warning, DataClassification::SystemMetadata, TelemetryScope::All, CustomDimensions)
        end
        else
            Telemetry.LogMessage('WLD0006', 'Media orphans not found', Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::All, CustomDimensions);
    end;

    local procedure EmitMediaSetOrphansIndexSignal()
    var
        MediaSetOrphans: List of [Guid];
        CustomDimensions: Dictionary of [Text, Text];
        Telemetry: Codeunit Telemetry;
    begin
        MediaSetOrphans := MediaSet.FindOrphans();

        if MediaSetOrphans.count <> 0 then begin
            CustomDimensions.Add('NoOfOrphans', format(MediaSetOrphans.count));

            Telemetry.LogMessage('WLD0007', 'MediaSet orphans found!', Verbosity::Warning, DataClassification::SystemMetadata, TelemetryScope::All, CustomDimensions)
        end
        else
            Telemetry.LogMessage('WLD0008', 'MediaSet orphans not found', Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::All, CustomDimensions);
    end;

}