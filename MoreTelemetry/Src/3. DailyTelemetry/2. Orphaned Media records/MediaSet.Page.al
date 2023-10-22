page 70501 MediaSet
{
    Caption = 'Media Set';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Media Set";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Specifies the value of the Company Name field.';
                }
                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.';
                }
                field("Media ID"; Rec."Media ID")
                {
                    ToolTip = 'Specifies the value of the Media ID field.';
                }
                field("Media Index"; Rec."Media Index")
                {
                    ToolTip = 'Specifies the value of the Media Index field.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                }
            }
        }
    }
}