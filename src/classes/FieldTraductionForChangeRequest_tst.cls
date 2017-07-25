public with sharing class FieldTraductionForChangeRequest_tst {
	static testMethod void test_one()
	{
		Account account = MockObject.getNewDummyPersonAccount();
		insert account;
		account = MockObject.getAccount(account.id);
		
		Account patient = MockObject.getNewDummyPersonAccount();
		patient.Type__c = 'Patient/Product user';
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
			
		Case caso =new Case();
		//caso.CaseNumber = '00332463';
		caso.RecordTypeId = rtCase.Id; 
		caso.AccountId = account.Id;
		caso.ContactId = contact.Id;
		caso.Flow_Type__c = flowType.Id;
		caso.Origin='Phone';
		caso.Status='Aberto';
		caso.Non_attendance_reason__c='Invoice not received';
		caso.Manufacture_Date_Month__c='january';
		caso.Expire_Date_Month__c='april';
		caso.Reimbursement_via__c='Product';
		caso.Complaint_Response__c='Fitting';
		caso.Technical_Request_Type__c='others';
		caso.Technical_Request_subtype__c='Dependence';
		caso.Case_Subcase_Number__c='12.3';
		
		insert caso; 
		System.debug('Objeto'+caso.Id);
		 
		Change_Request__c objChange =new Change_Request__c();
		objChange.Subcase_number__c = caso.Id;
		objChange.Status__c='Open123';
		objChange.Visit_type__c='withdrawal123';
						
		try
		{
			insert objChange;
			//System.assert( false );
		}
		catch( System.exception e )
		{
			//System.assert( true );
		}
		
		objChange.Status__c='Open';
		objChange.Visit_type__c='withdrawal';
		
		//insert objChange;
	}
}