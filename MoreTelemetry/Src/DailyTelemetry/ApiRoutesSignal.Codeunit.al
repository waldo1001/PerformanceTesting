codeunit 70505 ApiRoutesSignal
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Telemetry Management", OnSendDailyTelemetry, '', false, false)]
    local procedure OnSendDailyTelemetry();
    begin
        EmitApiRoutes();
    end;

    local procedure EmitApiRoutes()
    var
        APIWebhookEntity: Record "API Webhook Entity"; //Scope: OnPrem 🙄
        Route: Text;
        APIRoutes: TextBuilder;
        APIRouteList: list of [Text];
        APIPublishers: TextBuilder;
        APIPublisherList: list of [Text];
        Telemetry: Codeunit Telemetry;
        CustomDimensions: Dictionary of [Text, Text];
    begin
        if not APIWebhookEntity.FindSet() then exit;

        repeat
            Route := GetRoute(ApiWebhookEntity);
            if not APIRouteList.Contains(Route) then begin
                if Route <> '' then begin
                    APIRoutes.AppendLine(Route);
                    APIRouteList.Add(Route);
                end;
            end;

            if not APIPublisherList.Contains(ApiWebhookEntity.Publisher) then begin
                if ApiWebhookEntity.Publisher <> '' then begin
                    APIPublishers.AppendLine(ApiWebhookEntity.Publisher);
                    APIPublisherList.Add(ApiWebhookEntity.Publisher);
                end
            end;

        until APIWebhookEntity.Next() < 1;

        if APIRouteList.count <= 0 then exit;

        CustomDimensions.Add('apiRoutes', APIRoutes.ToText());
        CustomDimensions.Add('NoOfRoutes', format(APIRouteList.Count, 0, 9));
        CustomDimensions.Add('apiPublishers', APIPublishers.ToText());
        CustomDimensions.Add('NoOfPublishers', format(APIPublisherList.Count, 0, 9));

        Telemetry.LogMessage('WLD0010', 'API Routes', Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::All, CustomDimensions);

    end;

    local procedure GetRoute(var ApiWebhookEntity: Record "Api Webhook Entity"): Text
    begin
        if (ApiWebhookEntity.Publisher <> '') and (ApiWebhookEntity.Group <> '') then
            exit(StrSubstNo('%1/%2/%3',
                ApiWebhookEntity.Publisher, ApiWebhookEntity.Group, ApiWebhookEntity.Version));
        exit(ApiWebhookEntity.Version);
    end;
}