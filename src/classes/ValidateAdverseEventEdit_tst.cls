/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Pablo Gracia
	Project:			Novartis Brazil
	Description: 		ValidateAdverseEventEdit's Test.
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		10-03-2011	Juan Pablo Gracia			Create class.
	****************************************************************************************************/
@isTest
private class ValidateAdverseEventEdit_tst {

	static testmethod void generalTest(){
	  SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
	  User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
	  System.runAs ( userWhitAutorization ) {
	    CreateTestObjects co = new CreateTestObjects();
	    co.createObjects();
	    Test.startTest();
	    //Actualización correcta
	    update co.adverseEvent;
	    Test.stopTest();
	  }
	}
	
	static testmethod void generalTest2(){
	  SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
	  User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
	  System.runAs ( userWhitAutorization ) {
	    CreateTestObjects co = new CreateTestObjects();
	    co.createObjects();
	    Test.startTest();
	    co.caseType.EditInfoDisable__c = true; 
	  	update co.caseType; 
	  	
	  	//Se genera una tarea por triggers para el sub caso
	  	//le cambio el stage para que no cuente
	  	ValidateCaseEdition vc = new ValidateCaseEdition();
	    List<Task> tasks = vc.getTasksByIDsForValidateCaseEdition(new List<Id>{co.subCase.Id} );
	    tasks[0].StageId__c = null;
	    update tasks[0]; 
	    
	    //Actualización falla
	    try{
	    	update co.adverseEvent;
	    	System.assert(false);
	    }catch(Exception e){
	    }
	    
	    //Validar la función llamada por el trigger con valores nulos. 
	    ValidateAdverseEventEdit vae = new ValidateAdverseEventEdit();
	    vae.validateEdition(null,null);
	    
	     Test.stopTest();
	  }
	}
}