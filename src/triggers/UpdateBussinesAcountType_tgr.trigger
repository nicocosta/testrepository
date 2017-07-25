/****************************************************************************************************
    Information general 
    -------------------
    Developed by:        Avanxo Colombia
    Author:              Juan Gabriel Duarte Pacheco
    Project:             Novartis (CRM)
    Description:         Copy the value of the field Bussines_Type in Type
    
    Information about  version changes.
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     07-03-2013  Juan Gabriel Duarte P.          Create.
****************************************************************************************************/
trigger UpdateBussinesAcountType_tgr on Account (before insert, before update) {
    UpdateBussinesAcountType_cls acountType = new UpdateBussinesAcountType_cls();
    acountType.executeLogic(Trigger.new, Trigger.old);
}