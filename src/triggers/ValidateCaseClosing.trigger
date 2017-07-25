/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Pablo Gracia
	Project:			Novartis Brazil
	Description: 		Validate whether the Case can be closed.
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		08-03-2011	Juan Pablo Gracia			Create class.
	****************************************************************************************************/
trigger ValidateCaseClosing on Case (before update) {
	ValidateCaseClosing vcc = new ValidateCaseClosing();
	Map<ID,String> validationMap = vcc.validateClose(Trigger.new);
	for(Case c:Trigger.new){
		String error = validationMap.get(c.Id);
		if(error!=null) c.addError(error);
	}
}