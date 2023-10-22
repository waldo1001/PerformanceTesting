page 70500 "Media"
{
    Caption = 'Media';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Media;

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
                field(Content; Rec.Content)
                {
                    ToolTip = 'Specifies the value of the Content field.';
                }
                field("Creating User"; Rec."Creating User")
                {
                    ToolTip = 'Specifies the value of the Creating User field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ToolTip = 'Specifies the value of the Expiration Date field.';
                }
                field("File Name"; Rec."File Name")
                {
                    ToolTip = 'Specifies the value of the File Name field.';
                }
                field(Height; Rec.Height)
                {
                    ToolTip = 'Specifies the value of the Height field.';
                }
                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.';
                }
                field("Mime Type"; Rec."Mime Type")
                {
                    ToolTip = 'Specifies the value of the Mime Type field.';
                }
                field("Prohibit Cache"; Rec."Prohibit Cache")
                {
                    ToolTip = 'Specifies the value of the Prohibit Cache field.';
                }
                field("Security Token"; Rec."Security Token")
                {
                    ToolTip = 'Specifies the value of the Security Token field.';
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
                field(Width; Rec.Width)
                {
                    ToolTip = 'Specifies the value of the Width field.';
                }
            }
        }
    }
}