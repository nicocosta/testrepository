/****************************************************************************************************
    Information general 
    -------------------
    Developed by:        Avanxo Colombia
    Author:              Juan Gabriel Duarte Pacheco
    Project:             Novartis (CRM)
    Description:         Trigger is fired before update a Task. Validates that user can modify the task.
    
    Information about  version changes.
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     30-08-2012  Juan Gabriel Duarte P.          Create.
****************************************************************************************************/
trigger ValidateUpdateTask_trg on Task (before update) {
	ValidateUpdateTask updateTask = new ValidateUpdateTask();
	updateTask.executeLogic(Trigger.new, Trigger.old);
}