/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest (SeeAllData=true)
private class ChangeRequestToReturn_tst {

    static testMethod void myUnitTest() {
    
    //Creación del objeto Change Reques de acuerdo a las condiciones del Batch.
    List<RecordType> lstRecordType = [ Select Id, Name From RecordType Where Name = 'Case' or Name = 'Subcase' order by Name ];
    
    Case_Type__c objCaseType = new Case_Type__c();
    objCaseType.Name = 'OUTROS LIGAÇÃO MUDA Test';
    objCaseType.Subcase_type__c = 'Other';
    objCaseType.Subcase_subtype__c = 'Other';
    objCaseType.Theme__c = 'Other';
    objCaseType.Is_active__c=true;
    insert objCaseType;
    
    Flow_Type__c objFlowType = new Flow_Type__c();
    objFlowType.Flow_Number__c = '434';
    objFlowType.Description__c = 'FT Test';
    insert objFlowType;
    
    Account account = MockObject.getNewDummyPersonAccount();
    insert account;
    account = MockObject.getAccount(account.id);
    
    Contact contact = MockObject.getNewDummyContact();
    insert contact;
    contact = MockObject.getContact(contact.Id);
    
    Case objcaso = new Case();
    objcaso.ContactId = contact.Id;
    objcaso.AccountId = account.Id;
    objcaso.Flow_Type__c = objFlowType.Id;
    objcaso.Case_Type__c = objCaseType.Id;
    objcaso.RecordTypeId = lstRecordType.get( 0 ).Id;
    objcaso.RecordType = lstRecordType.get( 0 );
    objcaso.Status = 'Open';
    insert objcaso;
    
    Case objSubCase = new Case();
    objSubCase.ContactId = contact.Id;
    objSubCase.AccountId = account.Id;
    objSubCase.Origin = 'Email';
    objSubCase.Status = 'Closed';
    objSubCase.Case_Type__c = objCaseType.Id;
    objSubCase.Flow_Type__c = objFlowType.id;
    objSubCase.Receipt_date_of_report__c = System.today();
    objSubCase.ParentId = objcaso.Id;
    objSubCase.RecordType = lstRecordType.get( 1 );
    objSubCase.RecordTypeId = lstRecordType.get( 1 ).Id;
    insert objSubCase;
    
    Change_Request__c objCR = new Change_Request__c();
    objCR.Status__c = 'Closed';
    objCR.CR_number__c = 1123;
    objCR.CR_Return_Date__c = System.today();
    objCR.Envoy__c = false;
    objCR.Subcase_number__c = objSubCase.Id;    
    insert objCR;
    
    //Invoca la clase tipo Schuduler
    ChangeRequestToReturn_cls ia=new ChangeRequestToReturn_cls();
    DateTime fechaActual= System.now().addMinutes(1);
    Integer minutos=fechaActual.minute();
    Integer hora=fechaActual.hour();
    Integer dia=fechaActual.day();
    integer mes=fechaActual.month();
    Integer anio=fechaActual.year();
    Integer segundo=fechaActual.second();
    //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
    String sch = segundo+' '+minutos+' '+hora+' '+dia+' '+mes+' ? '+anio;
    System.debug('\n\n###sch'+sch);
    Id tarea=System.schedule('ChangeRequestToReturn:'+System.now(), sch, ia);
    ia.execute(null);
    ia.EliminarSch();
    
    }
}