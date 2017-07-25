/****************************************************************************************************
    Information general 
    -------------------
    Developed by:        Avanxo Colombia
    Author:              Giovanny Rey Cediel.
    Project:              Novartis (CRM)
    Description:        Trigger is fired before  insert or update  a Task when it is closed. If you perfil is equal to owner perfil.
    
    Information about  version changes.
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     25-04-2011  Giovanny Rey Cediel          Create.
****************************************************************************************************/
trigger EventClosedTask on Task ( after update) {
     EventClosedTask ect = new EventClosedTask();
     ect.executeTrigger(Trigger.new, Trigger.old) ;
}