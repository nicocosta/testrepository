/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Pablo Gracia
	Project:			Novartis Brazil
	Description: 		SIRDEdit_ctr's Test.
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		07-04-2011	Juan Pablo Gracia			Create class.
	****************************************************************************************************/
@isTest
private class SIREdit_tst {

	static testmethod void generalTest(){
		PageReference pageRef = Page.SIRDisplay;
		Test.setCurrentPageReference(pageRef);
		SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
	  	User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
	  	CreateTestObjects co;
	  	System.runAs ( userWhitAutorization ) {
	    	co = new CreateTestObjects();
	    	co.createTask=false;
	    	co.createObjects();
	  	
	  		ApexPages.StandardController sc = new ApexPages.standardController(co.safetyIndividualReport);
			Test.startTest();
			SIREdit_ctr myPageCon = new SIREdit_ctr(sc);
			
			myPageCon.btnAddAdverseEvent();
			myPageCon.btnAddMedicineInUse();
			myPageCon.btnAddReporter();
			
			myPageCon.selectedIndex = 0;
			
			myPageCon.reporters[0].objReporter.Reporter_related_name__c = co.account.id;
			myPageCon.changeReporterRelatedName();
			
			myPageCon.deleteAdverseEvent();
			myPageCon.deleteMedicineInUse();
			myPageCon.deleteReporter();
			
			myPageCon.btnAddAdverseEvent();
			for(SIREdit_ctr.AdverseEventWrapper ae: myPageCon.adverseEvents){
				ae.objAdverseEvent.Evolution__c = 'test' ;
				ae.objAdverseEvent.Start__c= 'test';
			}
			myPageCon.btnAddMedicineInUse();
			for(SIREdit_ctr.MedicinesInUseWrapper mu: myPageCon.medicinesInUses){
				mu.objMedicinesInUse.Product_from_other_labs__c	 = 'test' ;
				mu.objMedicinesInUse.Indication__c = 'test';
	    		mu.objMedicinesInUse.Posology__c = 'test';
			}
			myPageCon.btnAddReporter();
			
			//Guarda correctamente
			myPageCon.btnSave();
			
			for(SIREdit_ctr.MedicinesInUseWrapper mu: myPageCon.medicinesInUses){
				mu.objMedicinesInUse.Product_from_other_labs__c	 = null ;
			}
			
			//Falla por que faltan campos obligatorios
			myPageCon.btnSave();
			
			
			myPageCon.btnCancel();
			myPageCon.getItems();
			
			Test.stopTest();
		
	  	}
	}
	
	static testmethod void generalTest2(){
		PageReference pageRef = Page.SIRDisplay;
		Test.setCurrentPageReference(pageRef);
		SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
	  	User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
	  	CreateTestObjects co;
	  	System.runAs ( userWhitAutorization ) {
	    	co = new CreateTestObjects();
	    	co.createTask=false;
	    	//No crea adverse event
	    	co.createAdverseEvent=false;
	    	
	    	co.createObjects();
	    	
	    	Test.startTest();
	    	
	    	//Crear varias Medicines in use
	    	List<Medicines_in_use__c> lstmiu = new List<Medicines_in_use__c>();
	    	Medicines_in_use__c miu = new Medicines_in_use__c();
	    	miu.Product_from_other_labs__c	 = 'test' ;
	    	miu.Safety_Individual_Report__c = co.safetyIndividualReport.id;
	    	miu.Indication__c = 'test';
	    	miu.Posology__c = 'test';
	    	lstmiu.add(miu);
	    	
	    	miu = new Medicines_in_use__c();
	    	miu.Product_from_other_labs__c	 = 'test' ;
	    	miu.Safety_Individual_Report__c = co.safetyIndividualReport.id;
	    	miu.Indication__c = 'test';
	    	miu.Posology__c = 'test';
	    	lstmiu.add(miu);
	    	
	    	insert lstmiu;
	    	
	    	//Crear varios Reporter
	    	List<Reporter__c> lstr= new List<Reporter__c>();
	    	Reporter__c r = new Reporter__c();
	    	r.Safety_Individual_Report__c = co.safetyIndividualReport.id;
	    	lstr.add(r);
	    	
	    	r = new Reporter__c();
	    	r.Safety_Individual_Report__c = co.safetyIndividualReport.id;
	    	lstr.add(r);
	    	
	    	insert lstr;
	    	
	    	
	    	ApexPages.StandardController sc = new ApexPages.standardController(co.safetyIndividualReport);
			SIREdit_ctr myPageCon = new SIREdit_ctr(sc);
			
			myPageCon.selectedIndex = 0;
	    	myPageCon.deleteMedicineInUse();
			myPageCon.deleteReporter();
	  	}
		

		Test.stopTest();
	}
	
	static testmethod void generalTest3(){
		SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
	  	User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
	  	CreateTestObjects co;
	  	System.runAs ( userWhitAutorization ) {
	    	co = new CreateTestObjects();
	    	co.createTask=false;
	    	//No crea adverse event
	    	co.createAdverseEvent=false;
	    	
	    	co.createObjects();
	    	
	    	Test.startTest();
		
			PageReference pageRef = Page.SIRDisplay;
			Test.setCurrentPageReference(pageRef);
			
			System.Pagereference pr = Apexpages.currentPage();
			pr.getParameters().put('_lkid',co.caseOpen.Id);
			ApexPages.StandardController sc = new ApexPages.standardController(new Safety_Individual_Report__c());
		    SIREdit_ctr myPageCon = new SIREdit_ctr(sc);
		    
		    
		    myPageCon.btnCancel();
		    
		    myPageCon.getCase('Case Not Exist');
		    
		    Test.stopTest();
	  	}
	}
	
	static testmethod void generalTest4(){
		System.Pagereference pr = Apexpages.currentPage();
		ApexPages.StandardController sc = new ApexPages.standardController(new Safety_Individual_Report__c());
		SIREdit_ctr myPageCon = new SIREdit_ctr(sc);
		myPageCon.btnCancel();
	}
	
}