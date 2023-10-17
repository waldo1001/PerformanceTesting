codeunit 70504 TableInfoSignals
{
    var
        TableInformation: Record "Table Information"; //Scope: OnPrem 🙄

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Telemetry Management", OnSendDailyTelemetry, '', false, false)]
    local procedure OnSendDailyTelemetry();
    begin
        EmitTableInformationSignal();
    end;

    procedure EmitTableInformationSignal();
    var
        TableInfo: Record "Table Information";
        TableInfoJsonArray: JsonArray;
        Telemetry: Codeunit Telemetry;
        CustomDimensions: Dictionary of [Text, Text];
        JsonText: Text;
        TableInfoJsonObj: JsonObject;
        TotalSize, TotalNoOfRecords : decimal;
        i: Integer;
    begin
        TotalNoOfRecords := 0;
        TotalSize := 0;
        i := 0;

        TableInfo.SetCurrentKey("Size (KB)");
        TableInfo.SetAscending("Size (KB)", false);
        if TableInfo.Find('-') then
            repeat
                i += 1;

                clear(TableInfoJsonObj);
                TableInfoJsonObj.Add('CompanyName', TableInfo."Company Name");
                TableInfoJsonObj.Add('TableName', TableInfo."Table Name");
                TableInfoJsonObj.Add('TableNo', TableInfo."Table No.");
                TableInfoJsonObj.Add('NoOfRecords', TableInfo."No. of Records");
                TableInfoJsonObj.Add('SizeKB', TableInfo."Size (KB)");

                TotalNoOfRecords += TableInfo."No. of Records";
                TotalSize += TableInfo."Size (KB)";

                if i <= 10 then
                    TableInfoJsonArray.Add(TableInfoJsonObj);
            until TableInfo.Next() < 1;


        TableInfoJsonArray.WriteTo(JsonText);
        CustomDimensions.Add('TableInfo', JsonText);
        CustomDimensions.Add('TotalNoOfRecords', Format(TotalNoOfRecords, 0, 9));
        CustomDimensions.Add('TotalSizeKB', Format(TotalSize, 0, 9));

        Telemetry.LogMessage('WLD0009', 'Table Information (Top 10)', Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::All, CustomDimensions);
    end;

}