/****************************************************************************************************
    General Information 
    -------------------
    Developed by:       Avanxo Colombia
    Author:             Giovanny Rey Cediel.
    Project:            Novartis (CRM)
    Description:        Trigger is fired after editing an SIR. If you change some data, 
                        it create a update data from associated account. 
    
    Information about version changes.
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     17-03-2011  Giovanny Rey Cediel          Create.
****************************************************************************************************/
trigger UpdateDataAccountFromSIR on Safety_Individual_Report__c (after update) {
    /***************************************************************************
         The ConsecutiveProposalProducts class defines logic from this trigger 
    **************************************************************************/
    if (Userinfo.getProfileId() == '00eA0000000tn2OIAQ') return;
    UpdateDataAccountFromSIR cttu = new UpdateDataAccountFromSIR();
    cttu.executeTrigger(Trigger.new, Trigger.old);
}