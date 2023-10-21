# Serverinstance
Set-NAVServerConfiguration `
    -KeyName ApplicationInsightsInstrumentationKey `
    -KeyValue 'YOUR KEY HERE'
	-ApplyTo All `
    -ServerInstance BC

# Tenant
Mount-NAVTenant `
    -AadTenantId "YOUR TENANT ID HERE" `
	-DatabaseName "YOUR DATABASE HERE" `
    -Id "YOUR TENANTID" `
    -DisplayName "YOUR TENANT NAME" `
	-ApplicationInsightsKey "YOUR KEY HERE"
