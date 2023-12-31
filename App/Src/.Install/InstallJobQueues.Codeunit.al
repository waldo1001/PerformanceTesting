codeunit 68100 InstallJobQueues
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        CreateJobQueues();
    end;

    procedure CreateJobQueues()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.ScheduleRecurrentJobQueueEntryWithFrequency(5, codeunit::"ReadItemsInAWeirdWay JQ", JobQueueEntry.RecordId, 1);
        JobQueueEntry.ScheduleRecurrentJobQueueEntryWithFrequency(5, codeunit::"ReadBigTableVeryBadly JQ", JobQueueEntry.RecordId, 1);
    end;

}