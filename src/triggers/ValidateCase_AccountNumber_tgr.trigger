/****************************************************************************************************
    Information general 
    -------------------
    Developed by:        Avanxo Colombia
    Author:              Juan Gabriel Duarte Pacheco
    Project:             Novartis (CRM)
    Description:         Validate fields CPF and CNPJ         
    
    Information about  version changes.
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     12-12-2012  Juan Gabriel Duarte P.          Create.
****************************************************************************************************/
trigger ValidateCase_AccountNumber_tgr on Case (before insert, before update) {
	ValidateCase_AccountNumber van = new ValidateCase_AccountNumber();
	if(!Test.isRunningTest())
		van.executeLogic(Trigger.new, Trigger.old);	 
}