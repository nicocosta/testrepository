/**                                                     
* ===================================================================================================================================
*  Desarrollado por:    Avanxo Colombia
*  @AUTHOR:             Juan Gabriel Duarte Pacheco
*  Fecha:               Mayo 24 de 2013
*  Decripción:          Clase de prueba para las clases: CloseSubcaseOutStage_batch y Scheduler_CloseSubcaseOutStage_cls
*  @version:            1.0
* ===================================================================================================================================
*       Version     Fecha                       Desarrollador                   Observaciones
*       1.0         Mayo 24 de 2013             JGDP                            Creación
**/

@isTest(SeeAllData=true)
private class CloseSubcaseOutStage_tst {

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
        subcaso.Status = 'Open';
        insert subcaso;
        
       Test.startTest();
       CloseSubcaseOutStage_batch closeSubcase = new CloseSubcaseOutStage_batch();
       ID batchprocessid = Database.executeBatch(closeSubcase);
       Test.stopTest();
    }
    
    static testMethod void myUnitTestScheduler() 
    {
        Scheduler_CloseSubcaseOutStage_cls scheduler = new Scheduler_CloseSubcaseOutStage_cls();
        scheduler.execute(null);
    }
}