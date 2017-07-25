/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Pablo Gracia
	Project:			Novartis Brazil
	Description: 		Validate whether the SIR can be edited.
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		08-03-2011	Juan Pablo Gracia			Create class.
	****************************************************************************************************/
trigger ValidateAdverseEventEdit on Adverse_Event__c (before update) {
	ValidateAdverseEventEdit vae = new ValidateAdverseEventEdit();
	Map<ID,String> validationMap = vae.validateEdition(Trigger.old, Userinfo.getProfileId());
	for(Adverse_Event__c a:Trigger.new){
		String error = validationMap.get(a.Id);
		if(error!=null) a.addError(error);
	}

}