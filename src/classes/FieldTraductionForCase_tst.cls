@isTest
private class FieldTraductionForCase_tst {

	static testMethod void test_one()
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
		
		Case caso =new Case();
		caso.RecordTypeId = rtCase.Id;
		caso.Case_Type__c = caseType.Id;
		caso.AccountId = account.Id;
		caso.ContactId = contact.Id;
		caso.Origin='Phone123';
		//caso.Status='Aberto123';
		caso.Status='Open';
		caso.Non_attendance_reason__c='Invoice not received123';
		caso.Manufacture_Date_Month__c='january123';
		caso.Expire_Date_Month__c='april123';
		caso.Reimbursement_via__c='Product123';
		caso.Complaint_Response__c='Fitting123';
		caso.Technical_Request_Type__c='others123';
		caso.Technical_Request_subtype__c='Dependence123';
		
		try
		{
			insert caso;
			//System.assert( false );
			//System.assert( true );
		}
		catch( System.Exception e )
		{
			//System.assert( true );
			//System.assert( false );
		}
		
		caso.Origin='Phone';
		//caso.Status='Aberto';
		caso.Status = 'Open';
		caso.Non_attendance_reason__c='Invoice not received';
		caso.Manufacture_Date_Month__c='january';
		caso.Expire_Date_Month__c='april';
		caso.Reimbursement_via__c='Product';
		caso.Complaint_Response__c='Fitting';
		caso.Technical_Request_Type__c='others';
		caso.Technical_Request_subtype__c='Dependence';
		
		//insert caso;
		update caso;
	}
}