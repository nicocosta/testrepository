/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Mario Chaves (MCH)
	Project:			Novartis Brazil
	Description: 		Asign Account from Sefety_individual_Report__C on AdverseEvent field. 
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		24-09-2010	Mario Chaves (MCH)		Create Trigger.
	****************************************************************************************************/
trigger AdverseEventAsignAccount_tgr on Adverse_Event__c (before insert) {
	
	List<String> lstNumbers = new List<String>();
	for( Adverse_Event__c newAdverseEvent : trigger.new )
	{
		lstNumbers.add( newAdverseEvent.PV_number_SINA__c );
	}
	
	Map<String, Safety_Individual_Report__c> mapSirs = new Map<String, Safety_Individual_Report__c> ([	Select	patient_name__c, Client_Name__c, id 
																										From	Safety_Individual_Report__c 
																										Where 	id IN :lstNumbers ]); 
	
	for( Adverse_Event__c newAdverseEvent : trigger.new )
	{
		if( mapSirs.containsKey( newAdverseEvent.PV_number_SINA__c ) )
		{
			Safety_Individual_Report__c sir = mapSirs.get( newAdverseEvent.PV_number_SINA__c );
			newAdverseEvent.Client_Name__c = Sir.Client_Name__c;
			newAdverseEvent.Patient_Name__c = Sir.patient_name__c;
		}
	}
	
}