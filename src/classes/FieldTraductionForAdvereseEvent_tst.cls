@IsTest
private class FieldTraductionForAdvereseEvent_tst {
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
		caso.RecordTypeId = rtCase.Id;
		caso.AccountId = account.Id;
		caso.ContactId = contact.Id;
		caso.Case_Type__c = caseType.Id;
		caso.Origin='Phone';
		caso.Status='Open';
		caso.Non_attendance_reason__c='Invoice not received';
		caso.Manufacture_Date_Month__c='january';
		caso.Expire_Date_Month__c='april';
		caso.Reimbursement_via__c='Product';
		caso.Complaint_Response__c='Fitting';
		caso.Technical_Request_Type__c='others';
		caso.Technical_Request_subtype__c='Dependence';
			
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
			//Product__c = product.Id,
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
						
		Safety_Individual_Report__c sir = new Safety_Individual_Report__c();
		sir.Second_level_description__c = 'descrinao';
		sir.Receipt_date_of_report__c = date.newInstance(2009, 04, 01);
		sir.Hospitalized__c = 'Não'; 	
		sir.Subcase_Number__c = caso.Case_Subcase_Number__c;
		sir.Subcase_Number__c = subcase.Id;
		
		insert sir; 
		
		Adverse_Event__c adverseE = new Adverse_Event__c();
		adverseE.Event_Seriousness__c = 'Grave123';
		adverseE.PV_number_SINA__c = sir.Id; 
		adverseE.Start__c='Grave'; 
		adverseE.Evolution__c='Grave';
		
		try
		{
			insert adverseE;
			//System.debug( false );
		}
		catch( System.exception e )
		{
			//System.debug( true );
		}
		
		adverseE.Event_Seriousness__c = 'Grave';
		
		//insert adverseE;
	}
}