codeunit 68100 InstallJobQueues
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.ScheduleRecurrentJobQueueEntryWithFrequency(5, codeunit::"ReadItemsInAWeirdWay JQ", JobQueueEntry.RecordId, 10);
    end;
}