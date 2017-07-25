/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Pablo Gracia
	Project:			Novartis Brazil
	Description: 		EditBusinessAccount_ctr's Test.
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		10-06-2011	Juan Pablo Gracia			Create class.
	****************************************************************************************************/
@isTest
private class EditBusinessAccount_tst {
	
	static testmethod void generalTest(){
		PageReference pageRef = Page.EditAccount;
		
		SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
	  	User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
	  	CreateTestObjects co;
	  	System.runAs ( userWhitAutorization ) {
	    	co = new CreateTestObjects();
	    	co.createTask=false;
	    	co.createAdverseEvent=false;
	    	
	    	co.createObjects();
	  	}
		
		Test.setCurrentPageReference(pageRef);
		ApexPages.StandardController sc = new ApexPages.standardController(co.Account);
		Test.startTest();
		
		EditBusinessAccount_ctr myPageCon = new EditBusinessAccount_ctr(sc);
		
		myPageCon.btnSave();
		
		myPageCon.btnSaveAndNewPA();
		
		myPageCon.btnSaveAndNewBA();
		
		myPageCon.btnCancel();
		
		System.Pagereference pr = Apexpages.currentPage();
		pr.getParameters().put('id','Test');
		pr.getParameters().put('NewSC','1');
		
		myPageCon.btnSave();
		
		myPageCon.btnSaveAndNewPA();
		
		myPageCon.btnSaveAndNewBA();
		
		
		myPageCon.btnCancel();
		
		Test.stopTest();
	}
	
	static testmethod void generalTest2(){
		PageReference pageRef = Page.EditAccount;
		Test.setCurrentPageReference(pageRef);
		
		ApexPages.StandardController sc = new ApexPages.standardController(new Account());
		Test.startTest();
		
		EditBusinessAccount_ctr myPageCon = new EditBusinessAccount_ctr(sc);
		
		myPageCon.btnSave();
		
		myPageCon.btnSaveAndNewPA();
		
		myPageCon.btnSaveAndNewBA();
		
		myPageCon.btnCancel();
	
		Test.stopTest();
	}
	
}