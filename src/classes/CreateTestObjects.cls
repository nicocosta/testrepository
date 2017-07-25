/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Pablo Gracia
	Project:			Novartis Brazil
	Description: 		Create Test Objects .
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		07-04-2011	Juan Pablo Gracia			Create class.
	****************************************************************************************************/
public class CreateTestObjects {
	public Flow_Type__c flowType;
	public Stage__c stage;
	public Contact contact;
	public Account account;
	public Case_Type__c caseType; 	
	public Case caseOpen;
	public Case caseClose;
	public Case subCase;
	public Task task;
	public Safety_Individual_Report__c safetyIndividualReport;
	
	
	public Adverse_Event__c adverseEvent;
	public String caseCloseStage = 'Closed';
	public String caseOpenStage = 'Open';
	public String taskCloseStatus = 'Closed';
	public String taskOpenStatus = 'Open';
	public Boolean createTask = true;
	public Boolean createAdverseEvent= true;
	

	public void createObjects(){
		contact = createContact('lastNameTest');
		System.debug('--->contact:' + contact.Id);
		caseType = createCaseType(false);
		System.debug('--->caseType:' + caseType.Id);
		account = createAccount('AccountNameTest');
		System.debug('--->account:' + account.Id);
		flowType = createFlowType();
		System.debug('--->flowType:' + flowType.Id);
		stage = createStage('StageTest',flowType);
		System.debug('--->stage:' + stage.Id);
		
		caseClose = createCase(caseType, account, flowType, contact, caseCloseStage);
		caseOpen = createCase(caseType, account, flowType, contact, caseOpenStage);
		
		
		List<Case> lst = new Case[]{caseClose,caseOpen};
		insert lst;
		
		System.debug('--->caseClose:' + caseClose.Id);
		System.debug('--->caseOpen:' + caseOpen.Id);
		
		if (createTask){
			task = createTask(caseOpen.Id, stage.Id,taskOpenStatus);
			System.debug('--->task:' + task.Id);
		}
		
		subCase = createSubCase(caseOpen, caseType, account, flowType, contact, caseOpenStage);
		System.debug('--->subCase:' + subCase.Id);
		
		safetyIndividualReport = createSafetyIndividualReport(subCase, account);
		System.debug('--->safetyIndividualReport:' + safetyIndividualReport.Id);
		if(createAdverseEvent){
			adverseEvent = createAdverseEvent(safetyIndividualReport);
			System.debug('--->adverseEvent:' + adverseEvent.Id);
		}
	}
	

	
	public Stage__c createStage(String stageName, Flow_Type__c flowType){
		Stage__c s = new Stage__c();
		s.Name = stageName;
		s.Assigned_to__c = Userinfo.getUserId();
		s.Flow_Type__c = flowType.Id;
		s.Maxim_Duration__c = 120;
		s.Not_Edit_SIR__c = true;
		insert s;
		return s;
	}
	
	public Contact createContact(String lastname){
		Contact c = new Contact();
		c.LastName = lastname;
		insert c;
		return c;
	}
	
	public Case_Type__c createCaseType(Boolean editInfoDisable){
		Case_Type__c ct = new Case_Type__c();
		ct.EditInfoDisable__c = editInfoDisable;
		insert ct;
		return ct; 
	}
	
	
	public Case createCase(Case_Type__c caseType, Account account, Flow_Type__c flowType, Contact contact, String status){
		Case c = new Case();
		c.Case_Type__c = caseType.Id;
		c.Flow_Type__c = flowType.Id;
		c.AccountId = account.Id;
		c.Patient_Name__c = account.Id;
		c.ContactId = contact.Id;
		c.Status = Status;
		c.RecordTypeId =  [Select r.Name, r.Id From RecordType r Where r.Name = 'Case'].Id;
		//insert c;
		return c;
	}
	
	public Case createSubCase(Case caseParent, Case_Type__c caseType, Account account, Flow_Type__c flowType, Contact contact, String status){
		Case c = new Case();
		c.Case_Type__c = caseType.Id;
		c.Flow_Type__c = flowType.Id;
		c.AccountId = account.Id;
		c.Patient_Name__c = account.Id;
		c.ContactId = contact.Id;
		c.Status = Status;
		c.ParentId = caseParent.Id;
		c.Receipt_date_of_report__c = System.today();
		c.RecordTypeId =  [Select r.Name, r.Id From RecordType r Where r.Name = 'SubCase'].Id;
		insert c;
		return c;
	}
	
	public Task createTask(id whatId, String stageId, String status){
		Task t = new Task();
		t.WhatId = whatId;
		t.StageId__c = stageId;
		t.Status = status;
		//t.OwnerId = Userinfo.getUserId();
		insert t;
		return t; 
	}
	
	
	
	public Account createAccount(String name){
		Account a = new Account();
		//a.Name = name;
		//a.FirstName = name;
		a.LastName = name;
		a.fName__c=name;
        a.Type__c='Patient/Product user'; 
		a.RecordTypeId = [Select r.Name, r.Id From RecordType r Where r.Name = 'Person Account'].Id;
		insert a;
		System.debug('*****--->' + [Select a.Type__c From Account a Where a.id =:a.Id ]);
		return a;
	}
	
	public Flow_Type__c createFlowType(){
		Flow_Type__c ft = new Flow_Type__c();
		insert ft;
		return ft;
	}
	
	public Safety_Individual_Report__c createSafetyIndividualReport(Case caseObj, Account account){
		Safety_Individual_Report__c s = new Safety_Individual_Report__c();
		s.Subcase_Number__c = caseObj.Id;
		s.Receipt_date_of_report__c = System.today();
		s.Patient_Name__c = account.id;
		insert s;
		s.Subcase_Number__r = caseObj;
		return s;
	}
	
	public Adverse_Event__c createAdverseEvent(Safety_Individual_Report__c sir){
		Adverse_Event__c a = new Adverse_Event__c();
		a.PV_number_SINA__c = sir.Id;
		a.Evolution__c = 'Test Text';
		a.Start__c = 'Test Text';
		insert a;	
		return a;
	}
	
}