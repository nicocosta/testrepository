@isTest
private class scheduledDeleteCases_tst {

    static testMethod void BasicTest() 
    {
    	RecordType rtCases = MockObject.getRecordType('Case');
    	
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
    	caseType = MockObject.getCaseType(caseType.Id);
    	    	
       	test.startTest();
       	
       	Case theCase=new Case();
       	theCase.RecordTypeId = rtCases.Id;
       	theCase.Case_Type__c = caseType.Id;
       	theCase.AccountId = account.Id;
       	theCase.ContactId = contact.Id;
       	thecase.Flow_Type__c = flowType.Id;
       	theCase.Spam__c = true;
       	database.insert(theCase);
       	
        scheduledDeleteCases sdc=new scheduledDeleteCases();
		DateTime timenow= System.now().addMinutes(1);
		Integer minuts=timenow.minute();
		Integer hour=timenow.hour();
		Integer day=timenow.day();
		integer month=timenow.month();
		Integer year=timenow.year();
		String strDate = '0 '+minuts+' '+hour+' '+day+' '+month+' ? '+year;
		id sheduledtask=System.schedule('test delete cases '+System.now(), strDate, sdc);
    	test.stopTest();
    
    }
}