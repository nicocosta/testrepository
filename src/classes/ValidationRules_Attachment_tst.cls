/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Pablo Gracia
	Project:			Novartis Brazil
	Description: 		ValidationRules_Attachment's Test.
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		08-04-2011	Juan Pablo Gracia			Create class.
	****************************************************************************************************/


@isTest
private class ValidationRules_Attachment_tst {
	static testmethod void generalTest(){
	  SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
	  User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
	  Attachment t;
	  System.runAs ( userWhitAutorization ) {
	  	CreateTestObjects co = new CreateTestObjects();
	    co.createObjects();
	    
	    Test.startTest();
	    
	    List<Attachment> lsta = new  List<Attachment>();
	    
	    //Caso Abierto
	    t = new Attachment();
	    t.ParentId = co.caseOpen.Id;
	    t.Name = 'test';
	    t.Body = Blob.valueOf(''); 
	    insert t;
	    lsta.add(t);
	    
	    t = new Attachment();
	    t.ParentId = co.caseOpen.Id;
	    t.Name = 'test';
	    t.Body = Blob.valueOf(''); 
	    insert t;
	    lsta.add(t);
	    
	    //Masivo
	    update lsta;
	    
	    //No lo puede eliminar por que es de un caso.	
	    try{
	    	delete t;
	    	System.assert(false);
	    }catch (Exception e){
	    }
	    
	    //Caso cerrado
	    t = new Attachment();
	    t.ParentId = co.caseClose.Id;
	    t.Name = 'test';
	    t.Body = Blob.valueOf(''); 
	    insert t;

	    
	  }
	  
	  //No se puede actualizar con otro perfil
	  try{
	  	update t;
	  	System.assert(false);
	  }catch(Exception e){
	  }
	  
	  Test.stopTest();
	  
	}
	
	static testmethod void generalTest2(){
	  SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
	  User userWhitAutorization = [ select Id,ProfileId, Profile.Name from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
	  Attachment t;
	  System.runAs ( userWhitAutorization ) {
	  	CreateTestObjects co = new CreateTestObjects();
	    co.createObjects();
	    
	    Test.startTest();
	    
	    //No se puede editar dado que se validan los comentarios
	    co.stage.Validate_Comments__c = true;
	    co.stage.Users_profiles__c = 'test';
	    update co.stage;
	    
	    //Crear otra tarea
	    co.createTask(co.caseOpen.Id, co.stage.Id,co.taskOpenStatus);
	    
	    t = new Attachment();
	    t.ParentId = co.caseOpen.Id;
	    t.Name = 'test';
	    t.Body = Blob.valueOf(''); 
	    try{
	    	insert t;
	    	System.assert(false);
	  	}catch(Exception e){
	  	}
	  	
	  	 //Se puede editar dado que se validan con el perfil correcto
	    co.stage.Validate_Comments__c = true;
	    co.stage.Users_profiles__c = userWhitAutorization.Profile.Name;
	    update co.stage;
	  	insert t;
    
	  }
	  
	   Test.stopTest();
	  
	}

}