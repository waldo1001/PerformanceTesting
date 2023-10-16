codeunit 68105 "Upgrade JobQueues"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        InstallJobQueues: Codeunit InstallJobQueues;
    begin
        InstallJobQueues.CreateJobQueues();
    end;
}