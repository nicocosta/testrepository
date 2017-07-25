@isTest
private class HistoryTrackObjects_tst {

    static testMethod void myUnitTest() 
    {
       Account Acc = new Account();
       Acc.Name='Test';
       Acc.Type='aa';
       insert Acc;
       Acc.Type='aaa';
       update Acc;
    }
    static testMethod void myUnitTest1() 
    {
       FAQ__c Faq = new FAQ__c();
       Faq.Name='Test';
       Faq.Description__c='sdfsd11a';
       insert Faq;
       Faq.Description__c='sdfsd';
       update Faq;
       
      
       
    }
    static testMethod void myUnitTest2()
    {
    	Account account = MockObject.getNewDummyPersonAccount();
		insert account;
		account = MockObject.getAccount(account.id);
		
		Contact contact = MockObject.getNewDummyContact();
		insert contact;
		contact = MockObject.getContact(contact.Id);
		
		Flow_Type__c flowType = MockObject.getNewDummyFlowType();
		insert flowType;
		flowType = MockObject.getFlowType(flowType.id);
		
		Case_Type__c caseType = MockObject.getNewDummyCaseType();		
		insert caseType;
		
		RecordType rtCase = MockObject.getRecordType('Case');
    
       	Case caso = new Case();
       	caso.AccountId = account.Id;
       	caso.ContactId = contact.Id;
       	caso.Case_Type__c = caseType.Id;
       	caso.Flow_Type__c = flowType.Id;
       	caso.RecordTypeId = rtCase.Id;
       	caso.Subcase_Description__c='fffffssaaddd';
       	insert caso;
        caso.Subcase_Description__c='fffffss';
		update caso;		
    }
    static testMethod void myUnitTest3() 
    {
    	RecordType rtPersonAccount = MockObject.getRecordType('Person Account');
    	
    	Account account = MockObject.getNewDummyPersonAccount();
		insert account;
		account = MockObject.getAccount(account.id);
		
		// Account creation (patient)
		
		Account patient = MockObject.getNewAccount(new Map<String, Object>{'LastName' => 'Bart Simpson', 'RecordTypeId' => rTPersonAccount.Id, 'Type__c' => 'Patient/Product user' });
		insert patient;
		patient = MockObject.getAccount(patient.id);
		
		Contact contact = MockObject.getNewDummyContact();
		insert contact;
		contact = MockObject.getContact(contact.Id);
		
		Flow_Type__c flowType = MockObject.getNewDummyFlowType();
		insert flowType;
		flowType = MockObject.getFlowType(flowType.id);
		
		Case_Type__c caseType = MockObject.getNewDummyCaseType();		
		insert caseType;
		
		RecordType rtCase = MockObject.getRecordType('Case');
		RecordType rtSubcase = MockObject.getRecordType('Subcase');
		
		// Product creation
		
		Product2 product = MockObject.getNewProduct(new Map<String, Object>{'Bar_Code__c' => 0, 
			'SAP_code__c' => 123456, 'Subgroup__c' => 'GALVUS', 'Family' => 'METABOLISMO', 'Name' => 'GALVUS 50MG 7CE'});		
		insert product;
		product = MockObject.getProduct(product.id);
		
    	Case caso = new Case();
    	caso.AccountId = account.Id;
    	caso.ContactId = contact.Id;
    	caso.Flow_Type__c = flowType.Id;
    	caso.Case_Type__c = caseType.Id;
    	caso.RecordTypeId = rtCase.Id;
    	
       	insert caso;
       	       	
       	Case subcase = new Case (
			ContactId = contact.Id,
			Flow_Type__c = flowType.Id,
			RecordTypeId = rtSubcase.Id,
			Case_Type__c = caseType.Id,
			RecordType = rtSubcase,
			ParentId = caso.Id,
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
    	
       	Safety_Individual_Report__c Acc = new Safety_Individual_Report__c();
       	Acc.Subcase_Number__c=subcase.Id;
       	Acc.Receipt_date_of_report__c=Date.today();
       	insert Acc;
	       
       	update Acc;
    }
}