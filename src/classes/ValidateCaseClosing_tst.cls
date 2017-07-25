/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Pablo Gracia
	Project:			Novartis Brazil
	Description: 		ValidateCaseClosing's Test.
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		14-03-2011	Juan Pablo Gracia			Create class.
	****************************************************************************************************/


@isTest
private class ValidateCaseClosing_tst {

	static testmethod void generalTest(){
	  SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
	  User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
	  System.runAs ( userWhitAutorization ) {
	  	CreateTestObjects co = new CreateTestObjects();
	    co.createObjects();
	    
	    Test.startTest();
	    co.caseOpen.Status = co.caseCloseStage;
	    //No se puede cerrar por que tiene subcasos abiertos.
	    try{
	    	update co.caseOpen;
	    	System.assert(false);
	    }catch(Exception e){
	    }
	    
	    //co.caseType.Validate_closing_with_open_tasks__c = true;
	    //update co.caseType;
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
	    //Valida cerrar el caso
	    co.caseType.Validate_closing_with_open_tasks__c = true;
	    update co.caseType;
	     
	    //No se puede cerrar por que tiene tareas abiertas
	    co.caseOpen.Status = co.caseCloseStage;
	    try{
	    	update co.caseOpen;
	    	System.assert(false);
	    }catch(Exception e){
	    }
	    Test.stopTest();
	  }
	}

}