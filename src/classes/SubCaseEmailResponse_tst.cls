@isTest
private class SubCaseEmailResponse_tst 
{
	static testMethod void handleInboundEmailTest()
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
		
		// Create a new email, envelope object and Attachment
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
		String strHtmlBody = '';
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
		
		Case caso = new Case();
		caso.Flow_Type__c = flowType.Id;
		caso.AccountId = account.Id;
		caso.ContactId = contact.Id;
		caso.Case_Type__c = ct.Id;
		caso.RecordTypeId = lstRecordType.get( 0 ).Id;
		caso.RecordType = lstRecordType.get( 0 );
		insert caso;
		
		strHtmlBody += '<html>';
		strHtmlBody += '<body>';
		strHtmlBody += '&lt;' + System.Label.Start_response + '&gt;';
		strHtmlBody += 'Response Test';
		strHtmlBody += '<input type="hidden" id="idCaseId" value="*SUBCASE_ID*' + caso.Id + '*END_SUBCASE_ID*"/>';
		strHtmlBody += '<input type="hidden" id="idOwnerId" value="*OWNER_ID*' + UserInfo.getUserId() + '*END_OWNER_ID*"/>';
		strHtmlBody += '&lt;' + System.Label.End_response + '&gt;';
		strHtmlBody += '</body>';
		strHtmlBody += '</html>';
		
		System.debug( '-*-*-*-*-* strHtmlBody ' + strHtmlBody );

		email.subject = 'Subject Test';
		email.fromName = 'test test';
		email.htmlBody = strHtmlBody;
		envelope.fromAddress = 'user@acme.com';

		// setup controller object
		SubCaseEmailResponse handler = new SubCaseEmailResponse();
		Messaging.InboundEmailResult result = handler.handleInboundEmail(email, envelope);
		System.assertEquals( true, result.success );
		
		// insert more than one line in the answer field
		result = handler.handleInboundEmail(email, envelope);
		System.assertEquals( true, result.success );
	}
	
	static testMethod void ErrorsTest()
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
		
		// Create a new email, envelope object and Attachment
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
		String strHtmlBody = '';
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
		
		Case caso = new Case();
		caso.Flow_Type__c = flowType.Id;
		caso.AccountId = account.Id;
		caso.ContactId = contact.Id;
		caso.Case_Type__c = ct.Id;
		caso.RecordTypeId = lstRecordType.get( 0 ).Id;
		caso.RecordType = lstRecordType.get( 0 );
		insert caso;
		
		strHtmlBody += '<html>';
		strHtmlBody += '<body>';
		strHtmlBody += '&lt;' + System.Label.Start_response + '&gt;';
		strHtmlBody += 'Response Test';
		strHtmlBody += '<input type="hidden" id="idCaseId" value="*SUBCASE_ID*AAAADDDD*END_SUBCASE_ID*"/>';
		strHtmlBody += '<input type="hidden" id="idOwnerId" value="*OWNER_ID*' + UserInfo.getUserId() + '*END_OWNER_ID*"/>';
		strHtmlBody += '&lt;' + System.Label.End_response + '&gt;';
		strHtmlBody += '</body>';
		strHtmlBody += '</html>';
		
		System.debug( '-*-*-*-*-* strHtmlBody ' + strHtmlBody );

		email.subject = 'Subject Test';
		email.fromName = 'test test';
		email.htmlBody = strHtmlBody;
		envelope.fromAddress = 'user@acme.com';

		// setup controller object
		SubCaseEmailResponse handler = new SubCaseEmailResponse();
		Messaging.InboundEmailResult result = handler.handleInboundEmail(email, envelope);
		System.assertEquals( false, result.success);
		
		strHtmlBody = '<html>';
		strHtmlBody += '<body>';
		strHtmlBody += '&lt;&gt;';
		strHtmlBody += 'Response Test';
		strHtmlBody += '<input type="hidden" id="idCaseId" value="*SUBCASE_ID*AAAADDDD*END_SUBCASE_ID*"/>';
		strHtmlBody += '<input type="hidden" id="idOwnerId" value="*OWNER_ID*' + UserInfo.getUserId() + '*END_OWNER_ID*"/>';
		strHtmlBody += '&lt;' + System.Label.End_response + '&gt;';
		strHtmlBody += '</body>';
		strHtmlBody += '</html>';
		
		System.debug( '-*-*-*-*-* strHtmlBody ' + strHtmlBody );

		email.subject = 'Subject Test';
		email.fromName = 'test test';
		email.htmlBody = strHtmlBody;
		envelope.fromAddress = 'user@acme.com';

		// setup controller object
		handler = new SubCaseEmailResponse();
		result = handler.handleInboundEmail(email, envelope);
		System.assertEquals( false, result.success );
	}
}