/****************************************************************************************************
    Information general 
    -------------------
    Developed by:   	Avanxo Colombia
    Author:             Giovanny Rey Cediel.
    Project:           	Novartis (CRM)
    Description:        Trigger is fired after editing an Account. If you change the name or
     					birthday or genre, it create a task for a user registered in a
     					"Custom Settings ".
    
    Information about  version changes.
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     17-03-2011  Giovanny Rey Cediel          Create.
****************************************************************************************************/
trigger createTaskToUser on Account (after update) {
	/***************************************************************************
 		 The ConsecutiveProposalProducts class defines logic from this trigger 
   	**************************************************************************/
	CreateTaskToUser cttu = new CreateTaskToUser();
	cttu.executeTrigger(Trigger.new, Trigger.old);
}