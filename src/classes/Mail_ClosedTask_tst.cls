@isTest(SeeAllData=true)
private class Mail_ClosedTask_tst {

    static testMethod void myUnitTest() {
        RecordType rtCases = MockObject.getRecordType('Case');
        RecordType rtSubcases = MockObject.getRecordType('Subcase');
        
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
        
        List<RecordType> lstRecordType = [ Select Id, Name From RecordType Where Name = 'Case' or Name = 'Subcase' order by Name ];
        
        Case caso = new Case();
        caso.Flow_Type__c = flowType.Id;        
        caso.AccountId = account.Id;
        caso.ContactId = contact.Id;
        caso.Case_Type__c = caseType.Id;
        caso.RecordTypeId = lstRecordType.get( 0 ).Id;
        caso.RecordType = lstRecordType.get( 0 );
        insert caso;
        
        Case subcaso = new Case();       
        subcaso.AccountId = account.Id;
        subcaso.ContactId = contact.Id;
        subcaso.Case_Type__c = caseType.Id;
        subcaso.RecordTypeId = lstRecordType.get( 1 ).Id;
        subcaso.RecordType = lstRecordType.get( 1 );
        subcaso.ParentId = caso.Id;
        subcaso.Flow_Type__c = flowType.Id;
        subcaso.Receipt_date_of_report__c = System.today();
        insert subcaso;
        
        Stage__c stage = new Stage__c();
        stage.Name = '1';
        stage.Flow_Type__c = flowType.Id;
        stage.Subject__c = 'Test';
        stage.Description__c = 'Test';
        stage.Close_task_when_user_sends_an_email__c = true;
        stage.Assigned_to__c = UserInfo.getUserId();
        stage.Maxim_Duration__c = 1.0;
        insert stage;
        
        Task openActivitie = new Task();
        openActivitie.WhatId = subcaso.Id;
        openActivitie.StageId__c = stage.Id;
        openActivitie.Status = 'Open';
        openActivitie.Priority = 'Normal';
        openActivitie.Subject = '1-selecionar email-template de pedido de ajuda';
        openActivitie.Description = '1-selecionar email-template de pedido de ajuda';
        insert openActivitie;
        
        Test.startTest();
        Task sendMail = new Task();
        sendMail.WhatId = subcaso.Id;
        sendMail.StageId__c = stage.Id;
        sendMail.Status = 'Closed';
        sendMail.Priority = 'Normal';
        sendMail.Subject = 'Correo electrónico: URGENTE';
        insert sendMail;
        Test.stopTest();
    }
}