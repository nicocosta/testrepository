/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Pablo Gracia
	Project:			Novartis Brazil
	Description: 		EditAccount_ctr's Test.
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		25-04-2011	Juan Pablo Gracia			Create class.
	****************************************************************************************************/
@isTest
private class EditAccount_tst {

	static testmethod void generalTest(){
		PageReference pageRef = Page.EditAccount;
		Test.setCurrentPageReference(pageRef);
		
		//Crear Account
		Account a = new Account();
		ApexPages.StandardController sc = new ApexPages.standardController(a);
		Test.startTest();
			
			System.Pagereference pr = Apexpages.currentPage();
			pr.getParameters().put('AccNameNew','Test');
			pr.getParameters().put('AccPhoneNew','Test');
			pr.getParameters().put('CaseId','Non-existent Case');
			
			
			EditAccount_ctr myPageCon = new EditAccount_ctr(sc);
		
			myPageCon.btnAddAddress();
			myPageCon.btnAddPhone();
			myPageCon.btnAddEmail();
			myPageCon.btnAddBAxPA();
			
			myPageCon.selectedIndex = 0;
			myPageCon.lastName = '';
			
			myPageCon.btnDeleteAddress();
			myPageCon.btnDeleteEmail();
			myPageCon.btnDeletePhone();
			myPageCon.btnDeleteBAxPA();
			
			myPageCon.btnSave();
			myPageCon.btnSaveAndNewPA();
			myPageCon.btnSaveAndNewBA();
			pr.getParameters().put('NewSC','2');
			myPageCon.btnSaveAndNewPA();
			myPageCon.btnSaveAndNewBA();
			myPageCon.btnCancel();
			
			myPageCon.URLAnalist();
			pr.getParameters().put('RecordType',RecordTypesId__c.getInstance('BusinessCustomer').RecordTypeId__c);
			myPageCon.URLAnalist();
			myPageCon.renderOPSSections = true;
			myPageCon.URLAnalist();
			myPageCon.renderOPSSections = false;
			pr.getParameters().put('id','Test Id');
			myPageCon.URLAnalist();
			myPageCon.renderOPSSections = true;
			myPageCon.URLAnalist();
			
		Test.stopTest();
	
	}
	
	static testmethod void generalTest2(){
		PageReference pageRef = Page.EditAccount;
		Test.setCurrentPageReference(pageRef);
		SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
	  	User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
	  	CreateTestObjects co;
	  	System.runAs ( userWhitAutorization ) {
	    	co = new CreateTestObjects();
	    	co.createTask=false;
	    	co.createAdverseEvent=false;
	    	
	    	co.createObjects();
	    	
	    	System.Pagereference pr = Apexpages.currentPage();
			pr.getParameters().put('CaseId',co.subCase.Id);
			pr.getParameters().put('id',co.Account.Id);
	    	
			//Create Phone
	    	Phone__c p = new Phone__c();
	    	p.Phone_Number__c = '7777777';
			p.Local_Code__c = 11; 
			p.Account__c = co.account.id;
			insert p;
			
			//Create Address
			Address__c a = new Address__c();
			a.Type__c = 'Comercial'; 
			a.Status__c= 'Active'; 
		    a.State__c = '1';
		    a.Post_code_number__c = '1'; 
			a.Number__c = '1'; 
			a.District__c = '1'; 
		    a.Complement__c = '1';
			a.City__c = '1'; 
			a.Address_Name__c = '1'; 
			a.Account__c = co.account.id; 
			insert a;
			
			//Create Email
			Email_Address__c e = new Email_Address__c();
			e.email_Address__c = '123@123.com';
			e.Account__c = co.account.id;  
			insert e;
			
			//Create BA_PA
			BA_PA__c b = new BA_PA__c();
			b.Personal_Customer__c = co.account.id;
			b.Business_Customer__c = co.account.id;	
			insert b;
			
	    	Test.startTest();
	    	
	    	
	    	
	    	//Editar Account
	    	ApexPages.StandardController sc = new ApexPages.standardController(co.Account);
	    	
	    	EditAccount_ctr myPageCon = new EditAccount_ctr(sc);
			myPageCon.searchLocalCode();
		
			myPageCon.btnAddAddress();
			myPageCon.btnAddPhone();
			myPageCon.btnAddEmail();
			myPageCon.btnAddBAxPA();
			
			myPageCon.selectedIndex = 0;
			
			myPageCon.btnDeleteAddress();
			myPageCon.btnDeleteEmail();
			myPageCon.btnDeletePhone();
			myPageCon.btnDeleteBAxPA();
			
			//Falla por que faltan campos obligatorios
			myPageCon.btnSave();
			
			myPageCon.btnCancel();
	    	
	    	Test.stopTest();
	 
	 	}
	}
	
	static testmethod void generalTest3(){
		PageReference pageRef = Page.EditAccount;
		Test.setCurrentPageReference(pageRef);
		SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
	  	User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
	  	CreateTestObjects co;
	  	System.runAs ( userWhitAutorization ) {
	    	co = new CreateTestObjects();
	    	co.createTask=false;
	    	co.createAdverseEvent=false;
	    	
	    	co.createObjects();
	    	
	    	System.Pagereference pr = Apexpages.currentPage();
			pr.getParameters().remove('AccPhoneNew');
			pr.getParameters().put('CaseId',co.subCase.Id);
	    	
	    	Test.startTest();
	    	
	    	//Editar Account
	    	ApexPages.StandardController sc = new ApexPages.standardController(co.Account);
			
			EditAccount_ctr myPageCon = new EditAccount_ctr(sc);
		
			myPageCon.btnAddAddress();
			myPageCon.btnAddPhone();
			myPageCon.btnAddEmail();
			myPageCon.btnAddBAxPA();
			
			myPageCon.selectedIndex = 0;
			myPageCon.lastName = 'testAccount';
			
			myPageCon.btnDeleteAddress();
			myPageCon.btnDeleteEmail();
			myPageCon.btnDeletePhone();
			myPageCon.btnDeleteBAxPA();
					
			//No falla
			myPageCon.btnSave();
			myPageCon.btnSaveAndNewPA();
			myPageCon.btnSaveAndNewBA();
			pr.getParameters().put('NewSC','2');
			myPageCon.btnSave();
			myPageCon.btnCancel();
	    	
	    	Test.stopTest();
	 
	 	}
	}
	
	static testmethod void generalTest4(){
		PageReference pageRef = Page.EditAccount;
		Test.setCurrentPageReference(pageRef);
		SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
	  	User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
	  	CreateTestObjects co;
	  	System.runAs ( userWhitAutorization ) {
	    	co = new CreateTestObjects();
	    	co.createTask=false;
	    	co.createAdverseEvent=false;
	    	
	    	co.createObjects();
	    	
	    	System.Pagereference pr = Apexpages.currentPage();
			pr.getParameters().remove('AccPhoneNew');
			pr.getParameters().put('CaseId',co.subCase.Id);
	    	
	    	Test.startTest();
	    	
	    	//Editar Account
	    	ApexPages.StandardController sc = new ApexPages.standardController(co.Account);
			
			EditAccount_ctr myPageCon = new EditAccount_ctr(sc);
		
			myPageCon.lastName = 'testAccount';
			
			//No falla
			myPageCon.btnSaveAndNewPA();
			myPageCon.btnSaveAndNewBA();
			pr.getParameters().put('NewSC','2');
			myPageCon.btnSaveAndNewPA();
			myPageCon.btnSaveAndNewBA();
			myPageCon.btnCancel();
	    	
	    	Test.stopTest();
	 
	 	}
	}
}