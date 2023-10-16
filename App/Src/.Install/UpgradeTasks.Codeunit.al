codeunit 68105 "Upgrade Tasks"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        InstallJobQueues: Codeunit InstallJobQueues;
        InstallDemoData: codeunit "Install Demo Data WPT";
    begin
        InstallJobQueues.CreateJobQueues();
        installDemoData.FillData();
    end;
}