/****************************************************************************************************
    General Information 
    -------------------
    Developed by:       Avanxo Colombia
    Author:             Giovanny Rey Cediel.
    Project:            Novartis (CRM)
    Description:        Trigger is fired after insert a SIR. add the idSIR in, 
                        field Case lookup to SIR. 
    
    Information about version changes.
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     23-03-2011  Giovanny Rey Cediel          Create.
****************************************************************************************************/
trigger insertIdSirOnCase on Safety_Individual_Report__c (after insert) {
    if (Userinfo.getProfileId() == '00eA0000000tn2OIAQ') return;
    InsertIdSirOnCase iisoc = new InsertIdSirOnCase();
    iisoc.executeTrigger(Trigger.new, Trigger.old);
}