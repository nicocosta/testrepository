@isTest

private class SIRAsignAccount_tgr_tst {

    static testMethod void SIRAsignAccount() {
    	Account account = MockObject.getNewDummyPersonAccount();
		insert account;
		account = MockObject.getAccount(account.id);
		
		Contact contact = MockObject.getNewDummyContact();
		insert contact;
		contact = MockObject.getContact(contact.Id);
		
		Flow_Type__c flowType = MockObject.getNewDummyFlowType();
		insert flowType;
		flowType = MockObject.getFlowType(flowType.id);
    	
    	Map<String,String> mapRecordTypeIdByName = new Map<String,String>();
    	for( RecordType rt : [ Select Id, Name From RecordType ] )
    		mapRecordTypeIdByName.put( rt.Name.toLowerCase(), rt.Id );
        Account Patient=new Account();
        patient.RecordTypeId = mapRecordTypeIdByName.get( 'Person Account'.toLowerCase() );//'012T00000000SpPIAU';
        //patient.fCPF__c=510564891;
        //patient.FirstName='Test paciente';
        patient.LastName='testPaciente';
        patient.fName__c='Test Paciente';
        //patient.Person_identification_number_CPF__pc=510564891;
        patient.Type__c='Patient/Product user';
        database.insert(patient);
        Account client=new Account();
        client.RecordTypeId = mapRecordTypeIdByName.get( 'Person Account'.toLowerCase() );//'012T00000000SpPIAU';
        //client.fCPF__c=510564892;
        //client.FirstName='Test paciente2';
        client.LastName='testPaciente2';
        client.fName__c='Test Paciente2';
        //client.Person_identification_number_CPF__pc=510564892;
        client.Type__c='Patient/Product user';
        database.insert(client);
        Account Professional=new Account();
        Professional.RecordTypeId = mapRecordTypeIdByName.get( 'Person Account'.toLowerCase() );//'012T00000000SpPIAU';
        //Professional.fCPF__c=510564893;
        //Professional.FirstName='Test profesional3';
        Professional.LastName='testProfesional3';
        Professional.fName__c='Test Profesional3';
        //Professional.Person_identification_number_CPF__pc=510564893;
        Professional.professional_identification_document__pc = '123456789';
        Professional.Type__c='Health care professional';
        database.insert(Professional);
        Case theCase=new Case();
        theCase.AccountId = account.Id;
        theCase.ContactId = contact.Id;
        theCase.Flow_Type__c = flowType.Id;
        theCase.RecordTypeId = mapRecordTypeIdByName.get('Case'.toLowerCase() );//'012T00000000SnOIAU';
        database.insert(theCase);
        
        Case_Type__c ct = new Case_Type__c();
		ct.Name = 'Case Type Test';
		ct.Subcase_type__c = 'Suggestion';
		ct.Subcase_subtype__c = 'Request User';
		ct.Script__c = 'Script Test';
		ct.Theme__c = 'Several references';
		ct.Scenario__c = 'Scenario Test';
		insert ct;
        
        Case theSubcase=new Case();
        theSubcase.RecordTypeId = mapRecordTypeIdByName.get( 'Subcase'.toLowerCase() );//'012T00000000SnTIAU';
        theSubcase.AccountId=client.id;
        thesubcase.ParentId=thecase.id;
        theSubcase.Patient_Name__c=Patient.Id;
        theSubcase.Flow_Type__c = flowType.Id;
        theSubcase.Case_Type__c = ct.Id;//'a0GT0000001xXj1MAE';
        theSubcase.Receipt_date_of_report__c = System.today();
        database.insert(theSubcase);
        Safety_Individual_Report__c sir=new Safety_Individual_Report__c();
        sir.Subcase_Number__c=theSubcase.id;
        sir.Responsible_physician_name__c=Professional.id;
        sir.Receipt_date_of_report__c=system.today();
        database.insert(sir);
                
    }
}