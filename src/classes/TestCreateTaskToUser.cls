/****************************************************************************************************
    General information. 
    -------------------
    Developed by:  		Avanxo Colombia
    Author:             Giovanny Rey Cediel.
    Project:           	Novartis (CRM)
    Descripción:        Test class to CreateTaskUser trigger.  
    
    Information about changes (Vertions)
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     31-03-2011  Giovanny Rey Cediel          Create.
****************************************************************************************************/
@isTest
private class TestCreateTaskToUser {


	/*************************************************************
		This method fire trigger when is edit Account object
	************************************************************/
	static testMethod void testOne() {
		
		SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
	  	User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
	  	CreateObjects co;
	  	System.runAs ( userWhitAutorization ) {
			co = new CreateObjects();
			co.createObjects();
	  		co.safetyIndividualReport.Patient_Name__c = co.account.Id;
	  		update co.safetyIndividualReport;
			Test.startTest();
			CreateTaskToUser.flatExe = false;
			System.debug('ACCOUNT BEFORE UPADATE:'+ co.account);
			co.account.LastName='Nice Name';
			co.account.Occupation_Specialty__pc = 'Test';
			update co.account;	
			CreateTaskToUser ct = new CreateTaskToUser();
			ct.isAccountPatientSIR_giv('id inexistente');
			ct.getMemberLeader('id inexistente');
			System.debug('ACCOUNT AFTER UPADATE:'+ co.account);
			Test.stopTest();
	  	}
	}


	/********************************************
		Test method isAccountPatientSIR_giv
 	*******************************************/
    static testMethod void testTwo() {
		SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
	  	User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
	  	CreateObjects co;
	  	System.runAs ( userWhitAutorization ) {
			co = new CreateObjects();
			co.createObjects();
	  	}
	  	Test.startTest();
		CreateTaskToUser ctu = new CreateTaskToUser();		
		System.debug('TEST TRUE:'+ctu.isAccountPatientSIR_giv(co.account.id));				
		System.debug('TEST FALSE:'+ctu.isAccountPatientSIR_giv(''));
		Test.stopTest();		            
    }
    
	/*****************************************************
		Test method inner class TriggerOperationException.
 	******************************************************/
    static testMethod void testTree() {
		SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
	  	User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
	  	CreateObjects co;
	  	System.runAs ( userWhitAutorization ) {
			co = new CreateObjects();
			co.createObjects();
	  	}
		Test.startTest();
		CreateTaskToUser.TriggerOperationException toe= new CreateTaskToUser.TriggerOperationException();		
    }
    
    
    	
}