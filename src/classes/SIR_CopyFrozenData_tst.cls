@isTest
private class SIR_CopyFrozenData_tst
{
	static testMethod void myUnitTest()
	{
		RecordType rtCases = MockObject.getRecordType('Case');
		RecordType rtSubcases = MockObject.getRecordType('Subcase');
	
		Account account = MockObject.getNewDummyPersonAccount();
		insert account;
		account = MockObject.getAccount(account.id);
		
		Account accPatient = account.clone( false, true );
		accPatient.Type__c = 'Patient/Product user';
		insert accPatient;
		
		Contact contact = MockObject.getNewDummyContact();
		insert contact;
		contact = MockObject.getContact(contact.Id);
		
		Flow_Type__c flowType = MockObject.getNewDummyFlowType();
		insert flowType;
		flowType = MockObject.getFlowType(flowType.id);
    	
    	Case_Type__c caseType = MockObject.getNewDummyCaseType();
    	insert caseType;    	
    	caseType = MockObject.getCaseType(caseType.Id);
    				
		ApexPages.Standardcontroller stc;
		Case caso, subcaso;
		SubCaseCreator_ctr controller;
		Case_Type__c ct;
		Flow_Type__c ft;
		Case_Type_x_Flow_Type__c ctxft;
		
		ct = new Case_Type__c();
		ct.Name = 'Case Type Test';
		ct.Subcase_type__c = 'Suggestion';
		ct.Subcase_subtype__c = 'Request User';
		ct.Script__c = 'Script Test';
		ct.Theme__c = 'Several references';
		ct.Scenario__c = 'Scenario Test';
		insert ct;
		
		ft = new Flow_Type__c();
		ft.Description__c = 'Description Test';
		ft.Flow_Number__c = 'Num Test';
		insert ft;
		
		ctxft = new Case_Type_x_Flow_Type__c();
		ctxft.Case_Type__c = ct.Id;
		ctxft.Flow_Type__c = ft.Id;
		insert ctxft;
		
		caso = new Case();
		caso.Flow_Type__c = flowType.Id;		
		caso.AccountId = account.Id;
		caso.ContactId = contact.Id;
		caso.Case_Type__c = ct.Id;
		caso.RecordTypeId = rtCases.Id;
		caso.RecordType = rtCases;
		insert caso;
		
		subcaso = new Case();		
		subcaso.AccountId = account.Id;
		subcaso.ContactId = contact.Id;
		subcaso.Patient_Name__c  = accPatient.Id;
		subcaso.Case_Type__c = ct.Id;
		subcaso.RecordTypeId = rtSubcases.Id;
		subcaso.RecordType = rtSubcases;
		subcaso.ParentId = caso.Id;
		subcaso.Flow_Type__c = ft.Id;
		subcaso.Receipt_date_of_report__c = System.today();
		insert subcaso;
		
		Safety_Individual_Report__c sir = new Safety_Individual_Report__c();
		sir.Client_Name__c = account.Id;
		sir.Patient_Name__c = account.Id;
		sir.Subcase_Number__c = subcaso.Id;
		sir.Receipt_date_of_report__c = System.today();
		sir.Hospitalized__c = 'No';
		sir.Subcase_seriousness__c = 'Non serious';
		insert sir;
	}
}