@isTest
private class SubcaseTask_tst 
{

    static testMethod void myUnitTest() 
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
        
        SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
        
        Task tt = new Task();
        tt.Subject='ssss';
        tt.Status='opened';
        tt.Group_Id__c=conf.GroupId__c;
        tt.WhatId=caso.Id;        
        insert tt;
        User usr = [Select Id From User Where profileid =:conf.PvProfileId__c  and isactive=true limit 1];
        system.runAs(usr)
        {
        SubcaseTask_cls ss= new SubcaseTask_cls();
        ss.CheckTask(caso);
        }
    }
}