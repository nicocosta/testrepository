@isTest
private class SirUpdateTaskCheck_tst 
{

    static testMethod void myUnitTest() 
    {
    	RecordType rtPersonAccount = MockObject.getRecordType('Person Account');
        
        Account account = MockObject.getNewDummyPersonAccount();
        insert account;
        account = MockObject.getAccount(account.id);
        
        // Account creation (patient)
        
        Account patient = MockObject.getNewAccount(new Map<String, Object>{'LastName' => 'Bart Simpson', 'RecordTypeId' => rTPersonAccount.Id, 'Type__c' => 'Patient/Product user' });
        insert patient;
        patient = MockObject.getAccount(patient.id);
        
        Contact contact = MockObject.getNewDummyContact();
        insert contact;
        contact = MockObject.getContact(contact.Id);
        
        Flow_Type__c flowType = MockObject.getNewDummyFlowType();
        insert flowType;
        flowType = MockObject.getFlowType(flowType.id);
        
        Case_Type__c caseType = MockObject.getNewDummyCaseType();       
        insert caseType;
        
        RecordType rtCase = MockObject.getRecordType('Case');
        RecordType rtSubcase = MockObject.getRecordType('Subcase');
        
        // Product creation
        
        Product2 product = MockObject.getNewProduct(new Map<String, Object>{'Bar_Code__c' => 0, 
            'SAP_code__c' => 123456, 'Subgroup__c' => 'GALVUS', 'Family' => 'METABOLISMO', 'Name' => 'GALVUS 50MG 7CE'});       
        insert product;
        product = MockObject.getProduct(product.id);
        
        Case caso = new Case();
        caso.AccountId = account.Id;
        caso.ContactId = contact.Id;
        caso.Flow_Type__c = flowType.Id;
        caso.Case_Type__c = caseType.Id;
        caso.RecordTypeId = rtCase.Id;
        
        insert caso;
        
        Test.startTest();
        
        flowType = MockObject.getFlowType(flowType.id);
            Case subcase = new Case (
            ContactId = contact.Id,
            Flow_Type__c = flowType.Id,
            RecordTypeId = rtSubcase.Id,
            Case_Type__c = caseType.Id,
            RecordType = rtSubcase,
            ParentId = caso.Id,
            Status = 'Open',
            AccountId = account.Id,
            Number_of_complained_packages__c = 2,
            Patient_Name__c = patient.Id,
            Request_Numbers__c = 3,
            Product__c = product.Id,
            Copy_data_from_client__c = false,
            Reimbursement_via__c = 'Dinheiro',
            Bank_Name__c = 'World Bank',
            Agency_Number__c = '00',
            Bank_Account_number__c = '0000000001',
            Bank_Account_Name__c = 'Bank Account Name Test',
            Person_identification_number_CPF__c = '0',
            Phone__c = '3492384',
            Address__c = 'akdsjja',
            Receipt_date_of_report__c = System.today()
        );
        
        insert subcase;
        
        Safety_Individual_Report__c Acc = new Safety_Individual_Report__c();
        Acc.Subcase_Number__c=subcase.Id;
        Acc.Receipt_date_of_report__c=Date.today();
        Acc.Subcase_seriousness__c = 'serious';
        Acc.PV_system_number_Sina__c = '123';
        insert Acc;
        
        //Stage Creation
        Stage__c stg = new Stage__c();
        stg.Not_Edit_SIR__c = true;
        stg.Assigned_to__c = UserInfo.getUserId();
        stg.Maxim_Duration__c = 123;
        stg.Flow_Type__c = flowType.Id;
        insert stg;
        
        //Task Creation
        Task tt= new Task();
        tt.Subject='processar relato no SINA e fechar tarefa';
        tt.WhatId=Acc.Subcase_Number__c;
        //tt.Status='Opened';
        tt.Status='Closed';
        tt.StageId__c = stg.Id;
        tt.OwnerId = UserInfo.getUserId();
        insert tt;
        //tt.Status='Closed';
        //update tt;
        
        
        /*Adverse_Event__c aa = new Adverse_Event__c();
        aa.PV_number_SINA__c=Acc.Id;
        aa.Start__c='sss';
        aa.Evolution__c='ssss';
        insert aa;*/
        
        Medicines_in_use__c mm= new Medicines_in_use__c();
        mm.Safety_Individual_Report__c=Acc.Id;
        mm.Novartis_Product_Name__c=product.id;
        mm.Indication__c='dfdsf';
        mm.Posology__c='sdfds';
        insert mm;
        SirUpdateTaskCheck_cls ss = new SirUpdateTaskCheck_cls();
        
         
        
        ss.SirUpdateTaskCheck(Acc);
        
        //ss.AdverseEventUpdate(aa);
        
        //ss.MedicineInUseUpdate(mm);
        
        //JPG 08/07/2011
        
        Reporter__c r = new Reporter__c();
        
         //ss.ReporterUpdateTaskCheck(r);
         
         Test.stopTest();
    }
    
    static testMethod void myUnitTest1() 
    {
    	RecordType rtPersonAccount = MockObject.getRecordType('Person Account');
        
        Account account = MockObject.getNewDummyPersonAccount();
        insert account;
        account = MockObject.getAccount(account.id);
        
        // Account creation (patient)
        
        Account patient = MockObject.getNewAccount(new Map<String, Object>{'LastName' => 'Bart Simpson', 'RecordTypeId' => rTPersonAccount.Id, 'Type__c' => 'Patient/Product user' });
        insert patient;
        patient = MockObject.getAccount(patient.id);
        
        Contact contact = MockObject.getNewDummyContact();
        insert contact;
        contact = MockObject.getContact(contact.Id);
        
        Flow_Type__c flowType = MockObject.getNewDummyFlowType();
        insert flowType;
        flowType = MockObject.getFlowType(flowType.id);
        
        Case_Type__c caseType = MockObject.getNewDummyCaseType();       
        insert caseType;
        
        RecordType rtCase = MockObject.getRecordType('Case');
        RecordType rtSubcase = MockObject.getRecordType('Subcase');
        
        // Product creation
        
        Product2 product = MockObject.getNewProduct(new Map<String, Object>{'Bar_Code__c' => 0, 
            'SAP_code__c' => 123456, 'Subgroup__c' => 'GALVUS', 'Family' => 'METABOLISMO', 'Name' => 'GALVUS 50MG 7CE'});       
        insert product;
        product = MockObject.getProduct(product.id);
        
        Case caso = new Case();
        caso.AccountId = account.Id;
        caso.ContactId = contact.Id;
        caso.Flow_Type__c = flowType.Id;
        caso.Case_Type__c = caseType.Id;
        caso.RecordTypeId = rtCase.Id;
        
        insert caso;
        
        
        flowType = MockObject.getFlowType(flowType.id);
            Case subcase = new Case (
            ContactId = contact.Id,
            Flow_Type__c = flowType.Id,
            RecordTypeId = rtSubcase.Id,
            Case_Type__c = caseType.Id,
            RecordType = rtSubcase,
            ParentId = caso.Id,
            Status = 'Open',
            AccountId = account.Id,
            Number_of_complained_packages__c = 2,
            Patient_Name__c = patient.Id,
            Request_Numbers__c = 3,
            Product__c = product.Id,
            Copy_data_from_client__c = false,
            Reimbursement_via__c = 'Dinheiro',
            Bank_Name__c = 'World Bank',
            Agency_Number__c = '00',
            Bank_Account_number__c = '0000000001',
            Bank_Account_Name__c = 'Bank Account Name Test',
            Person_identification_number_CPF__c = '0',
            Phone__c = '3492384',
            Address__c = 'akdsjja',
            Receipt_date_of_report__c = System.today()
        );
        
        insert subcase;
        
        Test.startTest();
        
    	Safety_Individual_Report__c Acc = new Safety_Individual_Report__c();
        Acc.Subcase_Number__c=subcase.Id;
        Acc.Receipt_date_of_report__c=Date.today();
        insert Acc;
        
        Adverse_Event__c aa = new Adverse_Event__c();
        aa.Start__c='sss';
        aa.Evolution__c='ssss';
        aa.PV_number_SINA__c=Acc.Id;
        insert aa;
        update aa;
        
         Medicines_in_use__c mm= new Medicines_in_use__c();
        mm.Safety_Individual_Report__c=Acc.Id;
        mm.Novartis_Product_Name__c=product.id;
        mm.Indication__c='dfdsf';
        mm.Posology__c='sdfds';
        insert mm;
        
        update mm;
        
        Test.stopTest();
    	
    }
}