/**
 *Test class from UpdateChangeRequest_batch 
 */
@isTest (SeeAllData=true)
private class UpdateChangeRequest_batch_test {

    static testMethod void myUnitTest() {
        
        /***** CREATE DATA, THE SAME CODE ChangeRequestSheduler_tst**********/
        
        RecordType rtCase    = MockObject.getRecordType('Case');
		RecordType rtSubcase = MockObject.getRecordType('Subcase');
		RecordType rTPersonAccount = MockObject.getRecordType('Person Account');
		
		// Account creation		
		
		Account account = MockObject.getNewAccount(new Map<String, Object>{'LastName' => 'Homer J Simpson', 'RecordTypeId' => rTPersonAccount.Id });
		insert account;
		account = MockObject.getAccount(account.id);
		
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
		
		// Case creation				
		
		Case_Type__c caseType = MockObject.getNewDummyCaseType();		
		insert caseType;
		
		caseType = MockObject.getCaseType(caseType.id);
		
		System.debug(':::: After insert Case Type:...');
		System.debug(':::: Case Type[Theme:' + caseType.Theme__c + ']');
		
		Flow_Type__c flowType1 = MockObject.getNewDummyFlowType();
		insert flowType1;	
		
		Flow_Type__c flowType2 = MockObject.getNewDummyFlowType();
		insert flowType2;
		
		Case myCase = new Case(
		 	Flow_Type__c = flowType1.Id,
		    ContactId = contact.Id,
			AccountId = account.Id,
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
			Flow_Type__c = flowType2.Id,
			Receipt_date_of_report__c = System.today()						
		);
		
		insert subcase;
		
		subcase = [select RecordTypeId, Case_Type__c, ParentId, Status, AccountId, Number_of_complained_packages__c, Patient_Name__c, Request_Numbers__c, Reimbursement_via__c from Case where Id = :subcase.Id];
		
		System.debug(':::: After insert Subcase:...');
		System.debug(':::: Subcase [RecordTypeId:' + subcase.RecordTypeId + ',' +
			'Status:' + myCase.Status + ',Reimbursement_via__c:' + subcase.Reimbursement_via__c + ']');		
		
		// Stage creation 
		
		Flow_Type__c flowType = new List<Flow_Type__c>([select Name from Flow_Type__c limit 1])[0];		
		
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
			/*StageId__c = stage.Id,*/
			WhatId = subcase.Id,
			Subject = 'Test Task 1'
		);
				
		insert task;
    	
        Change_Request__c cr = new Change_Request__c(
        	//CreatedDate = Date.today(),
        	Status__c = 'Open',
        	Subcase_number__c = subcase.Id,
        	Task_Id__c = task.Id,
        	Visit_type__c = 'Withdrawal',
        	CR_number__c = 1
        );
        
        insert cr;
		/************** END CREATE CODE **************/
		Test.startTest();
		UpdateChangeRequest_batch ucrb= new UpdateChangeRequest_batch();
		ucrb.convertirFecha('01/01/2010');
		ucrb.convertirFecha2('01/01/2010');
		ucrb.convertirFecha3('01/01/2010');
		ucrb.convertirFecha4('01/01/2010');
		ID batchprocessid = Database.executeBatch(ucrb);          
        Test.stopTest();
    }
}