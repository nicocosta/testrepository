@IsTest
private class InvokeChangeRequestWS_tst {
	
	static testMethod void test_one() {
		
		RecordType rtCase    = MockObject.getRecordType('Case');
		RecordType rtSubcase = MockObject.getRecordType('Subcase');
		RecordType rTPersonAccount = MockObject.getRecordType('Person Account');
		
		// Account creation		
		
		Account account = MockObject.getNewAccount(new Map<String, Object>{'LastName' => 'Homer J Simpson', 'RecordTypeId' => rTPersonAccount.Id });
		insert account;
		account = MockObject.getAccount(account.id);
		
		// Contact creation
		
		Contact contact = MockObject.getNewContact(new Map<String, Object>{'LastName' => 'Marge Simpson'});
		insert contact;
		contact = MockObject.getContact(contact.Id);
		
		// Creating Address
		Address__c address = MockObject.getNewAddress(new Map<String, Object>{'Type__c' => 'Residencial', 'Address_Name__c' => 'R JOAQUIM MURTINHO, 4136',
			'District__c' => 'VILA BOSSI', 'City__c' => 'LOUVEIRA', 'State__c' => 'SP', 'Status__c' => 'ativo', 'Post_code_number__c' => '10000000', 
			'Is_Main_Address__c' => true, 'Account__c' => account.Id});
		insert address;
		address = MockObject.getAddress(address.id);
		
		// Phone
		Phone__c phone = MockObject.getNewPhone(new Map<String, Object>{'Account__c' => account.Id, 'Exten__c' => 3070,
			'Local_Code__c' => 61, 'Phone_Number__c' => '32033204', 'Status__c' => 'ativo', 'Type__c' => 'bina', 'Main_Phone__c' => 'Telefone 1'}); 		
		insert phone;
		phone = MockObject.getPhone(phone.id);
		
		// Account creation (patient)
		
		Account patient = MockObject.getNewAccount(new Map<String, Object>{'LastName' => 'Bart Simpson', 'RecordTypeId' => rTPersonAccount.Id });		
		insert patient;
		patient = MockObject.getAccount(patient.id);
		
		// Product creation
		
		Product2 product = MockObject.getNewProduct(new Map<String, Object>{'Bar_Code__c' => 0, 
			'SAP_code__c' => 123456, 'Subgroup__c' => 'GALVUS', 'Family' => 'METABOLISMO', 'Name' => 'GALVUS 50MG 7CE'});		
		insert product;
		product = MockObject.getProduct(product.id);
		
		// Flow Types
		
		Flow_Type__c flowType1 = MockObject.getNewDummyFlowType();
		insert flowType1;	
		
		Flow_Type__c flowType2 = MockObject.getNewDummyFlowType();
		insert flowType2;
		
		// Case creation				
		
		Case_Type__c caseType = MockObject.getNewDummyCaseType();		
		insert caseType;
		
		caseType = MockObject.getCaseType(caseType.id);
		
		System.debug(':::: After insert Case Type:...');
		System.debug(':::: Case Type[Theme:' + caseType.Theme__c + ']');
		
		Case myCase = new Case(
			ContactId = contact.Id,
			AccountId = account.Id,
			Flow_Type__c  = flowType1.Id,
			Case_Type__c = caseType.Id,
			RecordTypeId = rtCase.Id,
			RecordType = rtCase,
			Status = 'Open',
			Person_identification_number_CPF__c = '0'
		);
		
		
		insert myCase;
		myCase = [select Case_Type__c, RecordType.Id, Status from Case where Id = :myCase.Id];
		
		System.debug(':::: After insert Case:...');
		System.debug(':::: Case [RecordTypeId:' + myCase.RecordType.Id + ',' +
			'Status:' + myCase.Status + ']');
		
		Case subcase = new Case (
			Flow_Type__c  = flowType2.Id,
			RecordTypeId = rtSubcase.Id,
			Case_Type__c = caseType.Id,
			RecordType = rtSubcase,
			ParentId = myCase.Id,
			Status = 'Open',
			AccountId = account.Id,
			Number_of_complained_packages__c = 2,
			Patient_Name__c = patient.Id,
			Request_Numbers__c = 3,
			Product__c = product.Id,
			Copy_data_from_client__c = false,
			Reimbursement_via__c = 'Dinheiro',
			Bank_Name__c = 'World Bank',
			Agency_Number__c = '00',
			Bank_Account_number__c = '0000000001',
			Bank_Account_Name__c = 'Bank Account Name Test',
			Person_identification_number_CPF__c = '0',
			Phone__c = '3492384',
			Address__c = 'akdsjja',
			Receipt_date_of_report__c = System.today()
		);
		
		
		
		insert subcase;
		
		subcase = [select RecordTypeId, Case_Type__c, ParentId, Status, AccountId, Number_of_complained_packages__c, Patient_Name__c, Request_Numbers__c, Reimbursement_via__c from Case where Id = :subcase.Id];
		
		System.debug(':::: After insert Subcase:...');
		System.debug(':::: Subcase [RecordTypeId:' + subcase.RecordTypeId + ',' +
			'Status:' + myCase.Status + ',Reimbursement_via__c:' + subcase.Reimbursement_via__c + ']');		
		
		// Stage creation 
		
		Flow_Type__c flowType = new List<Flow_Type__c>([select Name from Flow_Type__c where Description__c = 'PRUEBA'])[0];		
		
		Stage__c stage = new Stage__c(
			Change_Request__c = true,
			Description__c = 'Test Stage Description...',
			Assigned_to__c = UserInfo.getUserId(),
			Maxim_Duration__c = 1.0,
			Flow_Type__c = flowType.Id
		);
		
		insert stage;
		
		// Task creation
		
		Task task = new Task(
			StageId__c = stage.Id,
			WhatId = subcase.Id,
			Subject = 'Test Task 1'
		);
				
		insert task;
		
		subcase = [select RecordTypeId, Case_Type__c, ParentId, Status, AccountId, Number_of_complained_packages__c, Patient_Name__c, Request_Numbers__c, Reimbursement_via__c from Case where Id = :subcase.Id];
		System.debug(':::: After insert Task:...');
		System.debug(':::: Subcase [RecordTypeId:' + subcase.RecordTypeId + ',' +
			'Status:' + myCase.Status + ',Reimbursement_via__c:' + subcase.Reimbursement_via__c + ']');
		
		
		subcase.Product__c = product.Id;
		update subcase;
		
		update task;
	}
	
	static testMethod void test_two() {
		
		// Account creation
		
		RecordType rTPersonAccount = [select name from RecordType where name = 'Person Account'];
		
		Account account = new Account(
			LastName = 'Homer J Simpson',
			RecordTypeId = rTPersonAccount.Id
		);
		
		insert account;
		account = [select LastName, RecordTypeId from Account where Id = :account.Id];
		
		// Contact creation
		
		Contact contact = MockObject.getNewContact(new Map<String, Object>{'LastName' => 'Marge Simpson'});
		insert contact;
		contact = MockObject.getContact(contact.Id);
		
		// Creating Address
		Address__c address = new Address__c(
			Type__c         = 'Residencial',
			Address_Name__c = 'R JOAQUIM MURTINHO, 4136',
			District__c     = 'VILA BOSSI',
			City__c         = 'LOUVEIRA',
			State__c        = 'SP',
			Status__c       = 'ativo',
			Is_Main_Address__c = true,
			Account__c = account.Id,
			Post_code_number__c = '10000000'
		);
		
		insert address;
		address = [select Type__c , Name, District__c, City__c, State__c, Status__c, Is_Main_Address__c, Account__c from Address__c where Id = :address.Id];
		account = [select LastName, RecordTypeId, Main_Address__c from Account where Id = :account.Id];
		
		System.assert(account.Main_Address__c == address.Id);
		
		// Account creation (patient)
		
		Account patient = new Account(
			LastName = 'Bart Simpson',
			RecordTypeId = rTPersonAccount.Id
		);		
		
		insert patient;
		patient = [select LastName, RecordTypeId from Account where Id = :patient.Id];
		
		// Product creation
		
		Product2 product = new Product2(
			Bar_Code__c = 0,
			SAP_code__c = 123456,
			Subgroup__c = 'GALVUS',
			Family = 'METABOLISMO',
			Name = 'GALVUS 50MG 7CE'
		);
		
		insert product;
		product = [select Bar_Code__c, SAP_code__c, Subgroup__c, Family, Name from Product2 where Id = :product.Id];
		
		// Flow Types
		
		Flow_Type__c flowType1 = MockObject.getNewDummyFlowType();
		insert flowType1;	
		
		Flow_Type__c flowType2 = MockObject.getNewDummyFlowType();
		insert flowType2;		
		
		// Case creation
		
		RecordType rtCase    = [select Name from RecordType where Name = 'Case'];
		RecordType rtSubcase = [select Name from RecordType where Name = 'Subcase'];
		
		Case_Type__c caseType = new Case_Type__c(
			Name = 'Case Type Test',
			Script__c = 'Script Test',
			Theme__c = 'Confirmação lote/val/fab/dcb/cód barras/ip'
		);
		
		insert caseType;
		caseType = [select Name, Script__c, Theme__c from Case_Type__c where Id = :caseType.Id];
		
		System.debug(':::: After insert Case Type:...');
		System.debug(':::: Case Type[Theme:' + caseType.Theme__c + ']');
		
		Case myCase = new Case(
			ContactId = contact.Id,
			AccountId = account.Id,
			Flow_Type__c = flowType1.Id,
			Case_Type__c = caseType.Id,
			RecordTypeId = rtCase.Id,
			RecordType = rtCase,
			Status = 'Open'
		);
		
		insert myCase;
		myCase = [select Case_Type__c, RecordType.Id, Status from Case where Id = :myCase.Id];
		
		System.debug(':::: After insert Case:...');
		System.debug(':::: Case [RecordTypeId:' + myCase.RecordType.Id + ',' +
			'Status:' + myCase.Status + ']');
		
		Case subcase = new Case (		
			Flow_Type__c = flowType2.Id,
			RecordTypeId = rtSubcase.Id,
			Case_Type__c = caseType.Id,
			RecordType = rtSubcase,
			ParentId = myCase.Id,
			Status = 'Open',
			AccountId = account.Id,
			Number_of_complained_packages__c = 2,
			Patient_Name__c = patient.Id,
			Request_Numbers__c = 3,
			Product__c = product.Id,
			Reimbursement_via__c = 'Produto',
			Receipt_date_of_report__c = System.today()
		);
		
		insert subcase;
		
		System.debug(':::: After insert Case:...');
		System.debug(':::: Case [RecordTypeId:' + myCase.RecordType.Id + ',' +
			'Status:' + myCase.Status + ']');		
		
		// Stage creation 
		
		Flow_Type__c flowType = new List<Flow_Type__c>([select Name from Flow_Type__c where Description__c = 'PRUEBA'])[0];		
		
		Stage__c stage = new Stage__c(
			Change_Request__c = true,
			Description__c = 'Test Stage Description...',
			Assigned_to__c = UserInfo.getUserId(),
			Maxim_Duration__c = 1.0,
			Flow_Type__c = flowType.Id
		);
		
		insert stage;
		
		// Task creation
		
		Task task = new Task(
			StageId__c = stage.Id,
			WhatId = subcase.Id,
			Subject = 'Test Task 1'
		);
				
		insert task;		
	}
	
	static testMethod void test_three() {
		InvokeChangeRequestWS.invokeChangeRequestWS(null);
	}
	
	/**
	static testMethod void test_four() {
		Change_Request__c changeRequest = new Change_Request__c();
		insert changeRequest;
		System.assert(changeRequest.Id != null);
		InvokeChangeRequestWS.invokeChangeRequestWS(changeRequest.Id);
	}*/
}