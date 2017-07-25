public class CreateObjects {
	public Flow_Type__c flowType;
	public Stage__c stage;
	public Contact contact;
	public Account account;
	public Case_Type__c caseType; 	
	public Case caseOpen;
	public Case caseClose;
	public Case subCase;	
	public Safety_Individual_Report__c safetyIndividualReport;	
	public Reporter__c reporter;
	public Medicines_in_use__c medicinesInUse;
	public Product2 product2;
	public Task task;
	public Adverse_Event__c adverseEvent;
	
	
	public String accountName ='AccountDubai';
	public boolean editInfoDisable = true;
	public String firstNameContact = 'Alexandre';
	public String lastNameContact = 'Dumas Dubai'; 
	public String statusCaseOpen= 'Open';
	public String statusSubCaseOpen= 'Open';
	public String stageName = 'stageNameDubai';
	public String statusTask = 'Open';
	public String reporterNameFrozen= 'nameReporterDubai';
	//public String reporterLastNameFrozen='lastNameDubai';
	public String reporterProfessionFrozen='professsionDubai';	
	public String caseCloseStage = 'Closed';
	public String caseOpenStage = 'Open';
	public String taskCloseStatus = 'Closed';
	public String taskOpenStatus = 'Open';
	public Boolean createTask = true;
	
	public void createObjects(){
		account = this.createAccount(accountName);
		caseType = this.createCaseType(editInfoDisable);
		flowType =  this.createFlowType();
		contact = this.createContact(firstNameContact, lastNameContact);		
		caseOpen = this.createCase(caseType, account, flowType, contact, statusCaseOpen);		
		subCase=this.createSubCase(caseOpen,caseType, account, flowType, contact, statusSubCaseOpen);
		stage = this.createStage(stageName, flowType);
		safetyIndividualReport=this.createSafetyIndividualReport(caseOpen,subCase, account);
		reporter = this.createReporter(reporterNameFrozen, null, reporterProfessionFrozen, safetyIndividualReport);
		product2= this.createProduct2();
		medicinesInUse=this.createMedicinesInUse(safetyIndividualReport,account,product2);		
		adverseEvent = this.createAdverseEvent(safetyIndividualReport);
		task =  this.createTask(caseOpen.id, stage.id, statusTask);
	}
	/**********************************************  
		Create Account object.		
	**********************************************/
	public Account createAccount(String accountName){
		Account a = new Account();
		//a.Name = accountName;
		a.fName__c=accountName;		
		//a.FirstName = accountName;		
		a.LastName = accountName;
		a.Gender__pc='Male';
		a.PersonBirthdate= Date.parse('01/01/1700'); 
        	a.Type__c='Patient/Product user'; 
		a.RecordTypeId = [Select r.Name, r.Id From RecordType r Where r.Name = 'Person Account'].Id;
		insert a;
		return a;
	}	
	
	
	/************************************************************
		Create a Case_Type__ object.
	*************************************************************/
	public Case_Type__c createCaseType(Boolean editInfoDisable){
		Case_Type__c ct = new Case_Type__c();
		ct.EditInfoDisable__c = editInfoDisable;
		insert ct;
		return ct; 
	}
	
	/***********************************************************
		Create Flow_Type__c object
	***********************************************************/
	public Flow_Type__c createFlowType(){
		Flow_Type__c ft = new Flow_Type__c();
		insert ft;
		return ft;
	}
	
	/***********************************************************
		Create Contact object.
	************************************************************/
	public Contact createContact(String firstNameContact, String lastNameContact){
		Contact c = new Contact();
		c.FirstName = firstNameContact;
		c.LastName = lastNameContact;		
		insert c;
		return c;
	}
	
	/**************************************************************
		Create Case object.
	***************************************************************/
	public Case createCase(Case_Type__c caseType, Account account, Flow_Type__c flowType, Contact contact, String status){
		Case c = new Case();
		c.Case_Type__c = caseType.Id;
		c.Flow_Type__c = flowType.Id;
		c.AccountId = account.Id;
		c.Patient_Name__c = account.Id;
		c.ContactId = contact.Id;
		c.Status = Status;
		c.RecordTypeId =  [Select Id From RecordType  where Name ='Case' limit 1].Id;
		c.RecordType=[Select Id From RecordType  where Name ='Case' limit 1];		
		insert c;
		return c;
	}
	
	/****************************************************************************
		Create SubCase, this is a Case type object. 
	****************************************************************************/		
	public Case createSubCase(Case caseParent,Case_Type__c caseType, Account account, Flow_Type__c flowType, Contact contact, String status){
		Case c = new Case();
		c.Case_Type__c = caseType.Id;
		c.Flow_Type__c = flowType.Id;
		c.AccountId = account.Id;
		c.Patient_Name__c = account.Id;
		c.ContactId = contact.Id;
		c.Status = Status;
		c.ParentId = caseParent.Id;
		c.Receipt_date_of_report__c = System.today();
		c.RecordTypeId =  [Select r.Name, r.Id From RecordType r Where r.Name = 'SubCase' limit 1].Id;	
		c.RecordType = [Select r.Name, r.Id From RecordType r Where r.Name = 'SubCase' limit 1];		
		insert c;
		return c;
	}
	
	/**********************************************
		Create Safety_Individual_Report__c object. 
	**********************************************/	
	public Safety_Individual_Report__c createSafetyIndividualReport(Case caseObj, Case subCase, Account account){
		Safety_Individual_Report__c s = new Safety_Individual_Report__c();
		s.Receipt_date_of_report__c = System.today();
		s.Cause__c= 'causeDubai';
		s.Duration__c='10';
		s.Patient_Name__c = account.id;
		s.Subcase_Number__c=subCase.id;		
		s.Hospitalized__c = 'No';
		s.Subcase_seriousness__c = 'Non serious';		
		insert s;	
		return s;
	}
	
	/*************************************************************
		Create Reporter__c object.
	*************************************************************/
	public Reporter__c createReporter(String reporterNameFrozen, String reporterLastNameFrozen, String reporterProfessionFrozen, Safety_Individual_Report__c sir ){
		Reporter__c reporter = new Reporter__c();
		//reporter.CreatedById=Userinfo.getUserId(); no escribible
		reporter.Reporter_Name_Frozen__c=reporterNameFrozen;
		//reporter.Reporter_Last_Name_Frozen__c= Tes;
		reporter.Reporter_Profession_Frozen__c=reporterProfessionFrozen;
		reporter.Safety_Individual_Report__c = sir.id;
		insert reporter;
		return reporter;
	}
		
	/*******************************************************
		Create Product2
	*******************************************************/
	public Product2 createProduct2(){
		Product2 product = new Product2();		
		product.Name ='ProductNovartisDubai';
		product.SAP_code__c=0123456789;
		insert product;
		return product;	
	}	

	/***************************************************
		Create Medicines_In_Use__c object.
	***************************************************/
	public Medicines_in_use__c createMedicinesInUse(Safety_Individual_Report__c sir, Account account,Product2 product2){
		Medicines_in_use__c miu = new Medicines_in_use__c();			 		
		miu.Safety_Individual_Report__c = sir.id;
		miu.Safety_Individual_Report__r = sir;		
		miu.Client_Name__c =account.id;
		miu.Product_from_other_labs__c = 'Product Test';
		miu.Posology__c = 'Test';
		miu.Indication__c = 'Test';
		//miu.Novartis_Product_Name__c=product2.Id;
		//miu.Name='MedicineDubai';
		//miu.Product_name__c=product2.Id;//Not writeable
				
		insert miu;
		return miu;	
	}
	
	public Medicines_in_use__History createMedicinesInUseHistory(String fieldIdSir){
		Medicines_in_use__History med = new Medicines_in_use__History();
		//med.CreatedById=Userinfo.getUserId();
		//med.CreatedDate = System.today();
		//med.Field=fieldIdSir;
		//med.IsDeleted=false;
		//med.OldValue='sd';
		//med.NewValue='zxcxc';
		insert med;
		return med;			
	}
	
	
	/*******************************************************
		Create Adverse_Event___c object.
	*******************************************************/	
	public Adverse_Event__c createAdverseEvent(Safety_Individual_Report__c sir){
		Adverse_Event__c a = new Adverse_Event__c();
		a.PV_number_SINA__c = sir.Id;
		a.Evolution__c = 'Test Text';
		a.Start__c = 'Test Text';
		insert a;	
		return a;
	}
	
	/********************************************************
		Create Task object.
	********************************************************/
	public Task createTask(String whatId, id idStage, String status){
		Task t = new Task();
		t.WhatId = subCase.id;
		t.Status = status;
		t.OwnerId = UserInfo.getUserId();
		t.StageId__c=idStage;
		insert t;
		return t; 
	}
	
	
	
	/**************************************************************
		Create Stage__c object		
	**************************************************************/
	public Stage__c createStage(String stageName, Flow_Type__c flowType){
		Stage__c s = new Stage__c();
		s.Name = stageName;
		s.Assigned_to__c = Userinfo.getUserId();
		s.Flow_Type__c = flowType.Id;
		s.Maxim_Duration__c = 120;
		insert s;
		return s;
	}		
	
}