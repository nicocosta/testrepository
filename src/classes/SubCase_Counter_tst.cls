@isTest
private class SubCase_Counter_tst {
	
	static testMethod void triggerTestOneByOne()
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
		
		Case caso, subcaso1, subcaso2;
		Case_Type__c ct;
		Flow_Type__c ft;
		Case_Type_x_Flow_Type__c ctxft;
		List<Case> lstCasesToDelete;
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
		
		Test.startTest();
		
		caso = new Case();
		caso.Flow_Type__c = flowType.Id;
		caso.AccountId = account.Id;
		caso.ContactId = contact.Id;
		caso.Case_Type__c = ct.Id;
		caso.RecordTypeId = lstRecordType.get( 0 ).Id;
		caso.RecordType = lstRecordType.get( 0 );
		caso.Status = 'Open';
		insert caso;
		
		System.assertEquals( 0, [Select Total_subcases__c From Case Where id = :caso.Id ].Total_subcases__c );
		
		subcaso1 = new Case();
		subcaso1.Flow_Type__c = flowType.Id;
		subcaso1.AccountId = account.Id;
		subcaso1.ContactId = contact.Id;
		subcaso1.Case_Type__c = ct.Id;
		subcaso1.RecordTypeId = lstRecordType.get( 1 ).Id;
		subcaso1.RecordType = lstRecordType.get( 1 );
		subcaso1.ParentId = caso.Id;
		subcaso1.Status = 'Open';
		subcaso1.Receipt_date_of_report__c = System.today();
		insert subcaso1;
		
		System.assertEquals( 1, [Select Total_subcases__c From Case Where id = :caso.Id ].Total_subcases__c );
		
		subcaso2 = new Case();
		subcaso2.Flow_Type__c = flowType.Id;
		subcaso2.AccountId = account.Id;
		subcaso2.ContactId = contact.Id;
		subcaso2.Case_Type__c = ct.Id;
		subcaso2.RecordTypeId = lstRecordType.get( 1 ).Id;
		subcaso2.RecordType = lstRecordType.get( 1 );
		subcaso2.ParentId = caso.Id;
		subcaso2.Status = 'Open';
		subcaso2.Receipt_date_of_report__c = System.today();
		insert subcaso2;
		
		System.assertEquals( 2, [Select Total_subcases__c From Case Where id = :caso.Id ].Total_subcases__c );
		
		delete subcaso1;
		
		System.assertEquals( 1, [Select Total_subcases__c From Case Where id = :caso.Id ].Total_subcases__c );
		
		delete subcaso2;
		
		System.assertEquals( 0, [Select Total_subcases__c From Case Where id = :caso.Id ].Total_subcases__c );
		
		Test.stopTest();
		
	}
	
	static testMethod void triggerTest()
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
		
		Case caso, subcaso1, subcaso2;
		Case_Type__c ct;
		Flow_Type__c ft;
		Case_Type_x_Flow_Type__c ctxft;
		List<Case> lstCasesToDelete;
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
		caso.AccountId = account.Id;
		caso.ContactId = contact.Id;
		caso.Case_Type__c = ct.Id;
		caso.RecordTypeId = lstRecordType.get( 0 ).Id;
		caso.RecordType = lstRecordType.get( 0 );
		caso.Status = 'Open';
		insert caso;
		
		System.assertEquals( 0, [Select Total_subcases__c From Case Where id = :caso.Id ].Total_subcases__c );
		
		subcaso1 = new Case();
		subcaso1.Flow_Type__c = flowType.Id;
		subcaso1.AccountId = account.Id;		
		subcaso1.ContactId = contact.Id;
		subcaso1.Case_Type__c = ct.Id;
		subcaso1.RecordTypeId = lstRecordType.get( 1 ).Id;
		subcaso1.RecordType = lstRecordType.get( 1 );
		subcaso1.ParentId = caso.Id;
		subcaso1.Status = 'Open';
		subcaso1.Receipt_date_of_report__c = System.today();
		
		subcaso2 = new Case();
		subcaso2.Flow_Type__c = flowType.Id;
		subcaso2.AccountId = account.Id;
		subcaso2.ContactId = contact.Id;
		subcaso2.Case_Type__c = ct.Id;
		subcaso2.RecordTypeId = lstRecordType.get( 1 ).Id;
		subcaso2.RecordType = lstRecordType.get( 1 );
		subcaso2.ParentId = caso.Id;
		subcaso2.Status = 'Open';
		subcaso2.Receipt_date_of_report__c = System.today();
		
		lstCasesToDelete = new List<Case> { subcaso1, subcaso2 };
		
		insert lstCasesToDelete;
		
		System.assertEquals( 2, [Select Total_subcases__c From Case Where id = :caso.Id ].Total_subcases__c );
		
		lstCasesToDelete = new List<Case> { subcaso1, subcaso2 };
		
		delete lstCasesToDelete;
		
		System.assertEquals( 0, [Select Total_subcases__c From Case Where id = :caso.Id ].Total_subcases__c );
	}
}