codeunit 68106 InstallMediaSetOrphans
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        CauseSomeOrphans();
        CauseSomeOrphans2();
    end;

    internal procedure CauseSomeOrphans()
    var
        MediaRec, MediaRec2 : Record Media;
    begin
        MediaRec.FindFirst();

        MediaRec2 := MediaRec;
        MediaRec2.ID := CreateGuid();
        MediaRec2.Insert();

    end;

    internal procedure CauseSomeOrphans2()
    var
        MediaRec: Record Media;
        MediaSetRec: Record "Media Set";
    begin
        MediaRec.Init();
        MediaRec.ID := CreateGuid();
        MediaRec.Description := 'ShouldBe Orphan';
        MediaRec.Height := 100;
        MediaRec.Width := 100;
        MediaRec."Mime Type" := 'image/png';
        MediaRec."File Name" := 'Images\waldo.jpg';
        MediaRec.Insert(true);

        MediaSetRec.Init();
        MediaSetRec.ID := CreateGuid();
        MediaSetRec."Company Name" := CompanyName;
        MediaSetRec.Insert(true);

    end;
}