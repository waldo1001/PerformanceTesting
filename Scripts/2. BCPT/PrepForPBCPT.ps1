
install-packageprovider -name NuGet -MinimumVersion 2.8.5.201 -Force
install-module MSAL.PS -force

Set-NAVServerConfiguration -ServerInstance "BC" `
                            -KeyName  EnableDeadlockMonitoring  `
                            -KeyValue $true

Set-NAVServerConfiguration -ServerInstance "BC" `
                            -KeyName  EnableLockTimeoutMonitoring  `
                            -KeyValue $true

Set-NAVServerConfiguration -ServerInstance "BC" `
                            -KeyName  SqlLongRunningThresholdForApplicationInsights  `
                            -KeyValue 500

Set-NAVServerConfiguration -ServerInstance "BC" `
                            -KeyName  ALLongRunningFunctionTracingThresholdForApplicationInsights  `
                            -KeyValue 10000

Set-NAVServerConfiguration -ServerInstance "BC" -KeyName "ApplicationInsightsConnectionString" -KeyValue $bcpt_appinsights -ApplyTo All

Set-NAVServerInstance -ServerInstance "BC" -Restart
