/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Pablo Gracia
	Project:			Novartis Brazil
	Description: 		Medicines_In_Use_Edit_Check's Test.
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		08-04-2011	Juan Pablo Gracia			Create class.
	****************************************************************************************************/



@isTest
private class Medicines_In_Use_Edit_Check_tst
{
	

	static testMethod void  myUnitTest(){
      SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
	  User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
	  Attachment t;
	  System.runAs ( userWhitAutorization ) {
	  	CreateTestObjects co = new CreateTestObjects();
	    co.createObjects();
	    
	    Test.startTest();
	    Medicines_in_use__c m = new Medicines_in_use__c();
	    m.Product_from_other_labs__c = 'Test';
	    m.Safety_Individual_Report__c = co.safetyIndividualReport.Id; 
	    m.Indication__c = 'test';
	    m.Posology__c = 'test';
	    insert m;
	    co.safetyIndividualReport.Subcase_Number__r.Status =  co.caseCloseStage;
	    co.safetyIndividualReport.Subcase_seriousness__c = 'Non serious';
	    update co.safetyIndividualReport;
	    update co.safetyIndividualReport.Subcase_Number__r;
	    
	    //No se puede actualizar por que el caso esta cerrado
	    try{
	    	update m;
	    	System.assert(false);
	    }catch(Exception e){
	    }
		
	  }
	  Test.stopTest();
	}
	
	static testMethod void  myUnitTest2(){
      SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
	  User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
	  Attachment t;
	  Medicines_in_use__c m;
	  System.runAs ( userWhitAutorization ) {
	  	CreateTestObjects co = new CreateTestObjects();
	    co.createObjects();
	    
	    Test.startTest();
	    m = new Medicines_in_use__c();
	    m.Product_from_other_labs__c = 'Test';
	    m.Safety_Individual_Report__c = co.safetyIndividualReport.Id; 
	    m.Indication__c = 'test';
	    m.Posology__c = 'test';
	    insert m;
	   	update m;
	   	
	   	co.createTask(co.subCase.Id,co.stage.Id,co.taskOpenStatus);
	   	
	   	co.caseType.EditInfoDisable__c = true;
	   	update co.caseType;
	   	
	   	update m;
	  
	  }
	  
	  
	  
	  Test.stopTest();
	}
	

	static testMethod void  myUnitTest3(){
      SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
	  User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
	  Attachment t;
	  Medicines_in_use__c m;
	  System.runAs ( userWhitAutorization ) {
	  	CreateTestObjects co = new CreateTestObjects();
	  	co.createTask=false;
	    co.createObjects();
	    
	    	    
	    Test.startTest();
	    m = new Medicines_in_use__c();
	    m.Product_from_other_labs__c = 'Test';
	    m.Safety_Individual_Report__c = co.safetyIndividualReport.Id;
	    m.Indication__c = 'test';
	    m.Posology__c = 'test'; 
	    insert m;
	   
	    //Se genera una tarea por triggers para el sub caso
	  	//le cambio el stage para que no cuente
	  	ValidateCaseEdition vc = new ValidateCaseEdition();
	   	List<Task> tasks = vc.getTasksByIDsForValidateCaseEdition(new List<Id>{co.subCase.Id} );
	    tasks[0].StageId__c = null;
	    update tasks[0]; 
	   	
	   	co.caseType.EditInfoDisable__c = true;
	   	update co.caseType;
	   	
		//No se puede actualizar por que no tiene tareas para este perfil
		try{
			update m;
		   	System.assert(false);
		}catch(Exception e){
		}
	  
	  }
	  
	  Test.stopTest();
	}
	
	
	static testMethod void  myUnitTest4(){
      SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
	  User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
	  Attachment t;
	  Medicines_in_use__c m;
	  System.runAs ( userWhitAutorization ) {
	  	CreateTestObjects co = new CreateTestObjects();
	  	co.createTask=false;
	    co.createObjects();
	    
	    	    
	    Test.startTest();
	    List<Medicines_in_use__c> lstm = new List<Medicines_in_use__c>(); 
	    m = new Medicines_in_use__c();
	    m.Product_from_other_labs__c = 'Test';
	    m.Safety_Individual_Report__c = co.safetyIndividualReport.Id; 
	    m.Indication__c = 'test';
	    m.Posology__c = 'test'; 
	    insert m;
	    lstm.add(m); 
	    
	    m = new Medicines_in_use__c();
	    m.Product_from_other_labs__c = 'Test';
	    m.Safety_Individual_Report__c = co.safetyIndividualReport.Id;
	    m.Indication__c = 'test';
	    m.Posology__c = 'test';  
	    insert m;
	    lstm.add(m); 
	    
	    //Update Masivo
	    update lstm;
	   
	  
	  }
	  
	  Test.stopTest();
	}
}