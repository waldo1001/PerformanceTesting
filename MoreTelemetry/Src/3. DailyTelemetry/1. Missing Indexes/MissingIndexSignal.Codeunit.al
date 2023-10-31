codeunit 70500 "Missing Index Signal"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Telemetry Management", OnSendDailyTelemetry, '', false, false)]
    local procedure OnSendDailyTelemetry();
    begin
        EmitMissingIndexSignal();
    end;

    local procedure EmitMissingIndexSignal()
    var
        DatabaseMissingIndexes: Record "Database Missing Indexes";
        CustomDimensions: Dictionary of [Text, Text];
        Telemetry: Codeunit Telemetry;
    begin
        DatabaseMissingIndexes.ReadIsolation := IsolationLevel::ReadUncommitted;
        if DatabaseMissingIndexes.FindSet() then
            repeat
                SetCustomDimensions(DatabaseMissingIndexes, CustomDimensions);

                Telemetry.LogMessage('WLD0004', 'Missing Index', Verbosity::Warning, DataClassification::SystemMetadata, TelemetryScope::All, CustomDimensions);
            until DatabaseMissingIndexes.next < 1;

    end;

    local procedure SetCustomDimensions(var DatabaseMissingIndexes: Record "Database Missing Indexes"; var CustomDimensions: Dictionary of [Text, Text])
    var
        index: Integer;
        ExtensionInfo: ModuleInfo;
        ExtensionName: Text;
    begin
        clear(CustomDimensions);

        if NavApp.GetModuleInfo(DatabaseMissingIndexes."Extension Id", ExtensionInfo) then begin
            ExtensionName := ExtensionInfo.Name;
        end;

        CustomDimensions.Add('IndexHandle', format(DatabaseMissingIndexes."Index Handle"));
        CustomDimensions.Add('TableName', DatabaseMissingIndexes."Table Name");
        CustomDimensions.Add('ExtensionId', format(DatabaseMissingIndexes."Extension Id"));
        CustomDimensions.Add('ExtensionName', ExtensionName);
        CustomDimensions.Add('EqualityColumns', DatabaseMissingIndexes."Index Equality Columns");
        CustomDimensions.Add('InequalityColumns', DatabaseMissingIndexes."Index Inequality Columns");
        CustomDimensions.Add('IncludeColumns', DatabaseMissingIndexes."Index Include Columns");
        CustomDimensions.Add('Statement', DatabaseMissingIndexes."Statement");
    end;

}