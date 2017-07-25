@isTest
private class MedicinesInUseAsignAccount_Tgr_tst {
/*
    static testMethod void MedicinesInUse() {
        Account Patient=new Account();
        patient.RecordTypeId='012T00000000SpPIAU';
        //patient.fCPF__c=510564891;
        //patient.FirstName='Test paciente';
        patient.LastName='testPaciente';
        patient.fName__c='Test Paciente';
        //patient.Person_identification_number_CPF__pc=510564891;
        patient.Type__c='Patient/Product user';
        database.insert(patient);
        Account client=new Account();
        client.RecordTypeId='012T00000000SpPIAU';
        //client.fCPF__c=510564892;
        //client.FirstName='Test paciente2';
        client.LastName='testPaciente2';
        client.fName__c='Test Paciente2';
       // client.Person_identification_number_CPF__pc=510564892;
        client.Type__c='Patient/Product user';
        database.insert(client);
        Account Professional=new Account();
        Professional.RecordTypeId='012T00000000SpPIAU';
        //Professional.fCPF__c=510564893;
        //Professional.FirstName='Test profesional3';
        Professional.LastName='testProfesional3';
        Professional.fName__c='Test Profesional3';
        //Professional.Person_identification_number_CPF__pc=510564893;
        Professional.Type__c='Health care professional';
        database.insert(Professional);
        Case theCase=new Case();
        theCase.RecordTypeId='012T00000000SnOIAU';
        database.insert(theCase);
        Case theSubcase=new Case();
        theSubcase.RecordTypeId='012T00000000SnTIAU';
        theSubcase.AccountId=client.id;
        thesubcase.ParentId=thecase.id;
        theSubcase.Patient_Name__c=Patient.Id;
        theSubcase.Case_Type__c='a0GT0000001xXj1MAE';
        database.insert(theSubcase);
        Safety_Individual_Report__c sir=new Safety_Individual_Report__c();
        sir.Subcase_Number__c=theSubcase.id;
        sir.Responsible_physician_name__c=Professional.id;
        sir.Receipt_date_of_report__c=system.today();
        database.insert(sir);
        Adverse_Event__c adverseEvent=new Adverse_Event__c();
        adverseEvent.PV_number_SINA__c=sir.id;
        adverseEvent.Start__c='12';
        adverseEvent.Evolution__c='12';
        database.insert(adverseEvent);
        Product2 product=new Product2();
        product.Name='product test';
        product.SAP_code__c=12;
        product.Bar_Code__c=12;
        database.insert(product);
        Medicines_in_use__c medicinesInUse=new Medicines_in_use__c();
        medicinesInUse.Adverse_Event__c=adverseEvent.id;
        medicinesInUse.Novartis_Product_Name__c=product.id;
        medicinesInUse.Posology__c='12';
        medicinesInUse.Indication__c='2';
        medicinesInUse.Start_Date__c='12-05-2010';
        database.insert(medicinesInUse);
        
    }*/
}