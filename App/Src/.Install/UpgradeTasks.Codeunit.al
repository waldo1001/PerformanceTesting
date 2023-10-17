codeunit 68105 "Upgrade Tasks"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        InstallJobQueues: Codeunit InstallJobQueues;
        InstallDemoData: codeunit "Install Demo Data WPT";
        InstallMediaSetOrphans: Codeunit InstallMediaSetOrphans;
    begin
        InstallJobQueues.CreateJobQueues();
        installDemoData.FillData();
        InstallMediaSetOrphans.CauseSomeOrphans();
    end;
}