/****************************************************************************************************
    General Information 
    -------------------
    Developed by:   	Avanxo Colombia
    Author:             Giovanny Rey Cediel.
    Project:           	Novartis (CRM)
    Description:        Trigger is fired after editing an Reporter object.
    
    Information about version changes.
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     31-03-2011  Giovanny Rey Cediel          Create.
****************************************************************************************************/
trigger UpdateAccountFromReporter on Reporter__c (after update) {
	/***************************************************************************
 		 The ConsecutiveProposalProducts class defines logic from this trigger 
   	**************************************************************************/
	UpdateAccountFromReporter uafr = new UpdateAccountFromReporter();
	uafr.executeTrigger(Trigger.new, Trigger.old);
}