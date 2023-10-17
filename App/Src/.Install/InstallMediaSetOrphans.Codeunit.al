codeunit 68106 InstallMediaSetOrphans
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        CauseSomeOrphans();
    end;

    internal procedure CauseSomeOrphans()
    var
        MediaRec, MediaRec2 : Record Media;

    begin
        MediaRec.FindFirst();

        MediaRec2 := MediaRec;
        MediaRec2.ID := CreateGuid();
        MediaRec2.Insert();


        // if Item.findset() then
        //     repeat
        //         if Item.Picture.Count > 0 then begin
        //             clear(Item.Picture);
        //             Item.Picture.Remove(item.Picture.MediaId);
        //             Item.modify(false);
        //             exit;
        //         end
        //     until Item.next() < 1;
    end;
}