@isTest
private class AutoCaseClose_tst
{

	static testMethod void triggerTest()
	{
		RecordType rtCase    = MockObject.getRecordType('Case');
		RecordType rtSubcase = MockObject.getRecordType('Subcase');
		RecordType rTPersonAccount = MockObject.getRecordType('Person Account');
		
		// Account creation		
		
		Account account = MockObject.getNewDummyPersonAccount();
		insert account;
		account = MockObject.getAccount(account.id);
		
		Contact contact = MockObject.getNewDummyContact();
		insert contact;
		contact = MockObject.getContact(contact.Id);
		
		Flow_Type__c flowType1 = MockObject.getNewDummyFlowType();
		insert flowType1;
		flowType1 = MockObject.getFlowType(flowType1.id);
		
		Case caso, subcaso1, subcaso2;
		Case_Type__c ct;
		Flow_Type__c ft;
		Case_Type_x_Flow_Type__c ctxft;
		List<RecordType> lstRecordType = [ Select Id, Name From RecordType Where Name = 'Case' or Name = 'Subcase' order by Name ];
		
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
		caso.ContactId = contact.Id;
		caso.AccountId = account.Id;
		caso.Flow_Type__c = flowType1.Id;
		caso.Case_Type__c = ct.Id;
		caso.RecordTypeId = lstRecordType.get( 0 ).Id;
		caso.RecordType = lstRecordType.get( 0 );
		caso.Status = 'Open';
		insert caso;
		
		Test.startTest();
		
		System.assertEquals( false, [Select isClosed From Case Where id = :caso.Id ].isClosed );
		
		subcaso1 = new Case();
		subcaso1.Flow_Type__c = flowType1.Id;
		subcaso1.AccountId = account.Id;
		subcaso1.ContactId = contact.Id;
		subcaso1.Case_Type__c = ct.Id;
		subcaso1.RecordTypeId = lstRecordType.get( 1 ).Id;
		subcaso1.RecordType = lstRecordType.get( 1 );
		subcaso1.ParentId = caso.Id;
		subcaso1.Status = 'Open';
		subcaso1.Receipt_date_of_report__c = System.today();
		insert subcaso1;
		
		System.assertEquals( false, [Select isClosed From Case Where id = :subcaso1.Id ].isClosed );
		
		subcaso2 = new Case();
		subcaso2.Flow_Type__c = flowType1.Id;
		subcaso2.AccountId = account.Id;
		subcaso2.ContactId = contact.Id;
		subcaso2.Case_Type__c = ct.Id;
		subcaso2.RecordTypeId = lstRecordType.get( 1 ).Id;
		subcaso2.RecordType = lstRecordType.get( 1 );
		subcaso2.ParentId = caso.Id;
		subcaso2.Status = 'Open';
		subcaso2.Receipt_date_of_report__c = System.today();
		insert subcaso2;
		
		System.assertEquals( false, [Select isClosed From Case Where id = :subcaso2.Id ].isClosed );
		
		subcaso1.Status = 'Closed';
		update subcaso1;
		
		System.assertEquals( true, [Select isClosed From Case Where id = :subcaso1.Id ].isClosed );
		System.assertEquals( false, [Select isClosed From Case Where id = :caso.Id ].isClosed );
		
		subcaso2.Status = 'Closed';
		update subcaso2;
		
		System.assertEquals( true, [Select isClosed From Case Where id = :subcaso2.Id ].isClosed );
		System.assertEquals( true, [Select isClosed From Case Where id = :caso.Id ].isClosed );
		
		Test.stopTest();
	}
}