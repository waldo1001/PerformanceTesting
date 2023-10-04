tableextension 70100 "Test Method Line Ext" extends "Test Method Line"
{
    fields
    {
        field(70100; "Start No. Of SQL Statements"; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(70101; "Start No. Of Reads"; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(70102; "Finish No. Of SQL Statements"; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(70103; "Finish No. Of Reads"; Integer)
        {
            DataClassification = SystemMetadata;
        }
    }
}