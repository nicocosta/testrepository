/****************************************************************************************************
    General Information
    -------------------
    Developed by :   	Avanxo Colombia
    Author:             Giovanny Rey Cediel.
    Project:            Novartis (CRM)
    Description:        After insert trigger logical.When SIR is created, insert your id in Case.
    
    Information about change  (Vertions)
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     17-03-2011  Giovanny Rey Cediel          Create.
****************************************************************************************************/
	public with sharing class InsertIdSirOnCase {
		
		/*****************************************************************************
			Exceucte trigger logical 
		*****************************************************************************/
		public void executeTrigger(List<Safety_Individual_Report__c> listNewInMemory, List<Safety_Individual_Report__c> listOldInDb){						
			//Se obtiene el campo LookupSir__c del objeto "Case" a partir del id del SIR
		 	String idCase = this.getCase_giv(listNewInMemory.get(0).id);		 						
			//Se establece el campo lookupSir, en el objeto Case obtenido aneriormente.
			this.updateCase_giv(idCase, listNewInMemory.get(0).id);												
		}
	
	/*****************************************************************************
		Gets the idCase from id Safety_Individual_Report__c
		@param String idSIR
		@return String idCase		  		
	*****************************************************************************/
	public String  getCase_giv(String idSIR){
		//Selecciona subcase que es referencia a el objecto Case
		List<Safety_Individual_Report__c> sir= 
		[Select Subcase_Number__r.Id, Subcase_Number__r.LookupSir__c 
		From Safety_Individual_Report__c
		where id=:idSIR];	
		if(sir.size()>0){
			return sir.get(0).Subcase_Number__r.Id;			
		}
		return null;								
	}

	/*****************************************************************************
		Set the Case.LookupSir__c from  id Safety_Individual_Report.
		@param String idSIR  		
	*****************************************************************************/
	public void updateCase_giv(String idCase, String lookupSir){
		//seleciona el Case y le asigna el id del nuevo sir al campo lookupSir
		List<Case> cas= 
		[SELECT Id,LookupSir__c 
		FROM Case
		WHERE id =:idCase];			
		if(cas.size()>0){
			cas.get(0).LookupSir__c=lookupSir;
			update cas.get(0);			
		}										
	}
		
}