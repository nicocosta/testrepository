/****************************************************************************************************
    Information general 
    -------------------
    Developed by:        Avanxo Colombia
    Author:              Juan Gabriel Duarte Pacheco
    Project:             Novartis (CRM)
    Description:         Check fields in the stage when closed task
    
    Information about  version changes.
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     08-Jul-2013  Juan Gabriel Duarte P.          Create.
****************************************************************************************************/

trigger ValidateCloseTask_tgr on Task (before insert, before update) {
	if(!Validator_cls.hasAlreadyDone())
    {
		ValidateCloseTask_cls verify = new ValidateCloseTask_cls();
		verify.executeLogic( Trigger.new, Trigger.old );
		Validator_cls.setAlreadyDone();
    }
}