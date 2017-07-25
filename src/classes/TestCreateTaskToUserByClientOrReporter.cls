/****************************************************************************************************
    General information. 
    -------------------
    Developed by:  		Avanxo Colombia
    Author:             Giovanny Rey Cediel.
    Project:           	Novartis (CRM)
    Descripción:        Test class to CreateTaskToUserByClientOrReporter trigger.  
    
    Information about changes (Vertions)
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     31-03-2011  Giovanny Rey Cediel          Create.
****************************************************************************************************/
@isTest
private class TestCreateTaskToUserByClientOrReporter {

	/*********************************************************
	 This method fire the trigger when is edit Account object.
	*********************************************************/
    static testMethod void testOne() {
		SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
	  	User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
	  	CreateObjects co;
	  	System.runAs ( userWhitAutorization ) {
			co = new CreateObjects();
			co.createObjects();
	  		co.reporter.Reporter_related_name__c = co.account.id;
	  		update co.reporter;
			Test.startTest();
			System.debug('ACCOUNT BEFORE UPADATE:'+ co.account);
			CreateTaskToUserByClientOrReporter.flatExe =false;
			co.account.Occupation_Specialty__pc='Nice Name';		 		
			update co.account;	
			System.debug('ACCOUNT AFTER UPADATE:'+ co.account);
			CreateTaskToUserByClientOrReporter ct = new CreateTaskToUserByClientOrReporter();
			ct.isAccountReporterSIR_giv('id inexistente');
			ct.getMemberLeader('id inexistente');
			Test.stopTest();
	  	}
    }
    
}