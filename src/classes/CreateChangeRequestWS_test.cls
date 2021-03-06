@isTest(SeeAllData=true)
private class CreateChangeRequestWS_test {

     static testMethod void myUnitTest() {
        RecordType rtCase    = MockObject.getRecordType('Case');
        RecordType rtSubcase = MockObject.getRecordType('Subcase');
        RecordType rTPersonAccount = MockObject.getRecordType('Person Account');
        
        Contact contact = MockObject.getNewDummyContact();
        insert contact;
        contact = MockObject.getContact(contact.Id);
        
        Flow_Type__c flowType1 = MockObject.getNewDummyFlowType();
        insert flowType1;
        flowType1 = MockObject.getFlowType(flowType1.id);
        
        // Account creation     
        
        Account account = MockObject.getNewAccount(new Map<String, Object>{'LastName' => 'Homer J Simpson', 'RecordTypeId' => rTPersonAccount.Id });
        insert account;
        account = MockObject.getAccount(account.id);
        
        // Creating Address
        Address__c address = MockObject.getNewDummyAddress();
        address.Account__c = account.Id;
        insert address;
        address = MockObject.getAddress(address.id);
        
        // Phone
        Phone__c phone = MockObject.getNewPhone(new Map<String, Object>{'Account__c' => account.Id, 'Exten__c' => 3070,
            'Local_Code__c' => 61, 'Phone_Number__c' => '32033204', 'Status__c' => 'ativo', 'Type__c' => 'bina', 'Main_Phone__c' => 'Telefone 1'});         
        insert phone;
        phone = MockObject.getPhone(phone.id);
        
        // Account creation (patient)
        
        Account patient = MockObject.getNewAccount(new Map<String, Object>{'LastName' => 'Bart Simpson', 'RecordTypeId' => rTPersonAccount.Id });       
        insert patient;
        patient = MockObject.getAccount(patient.id);
        
        // Product creation
        
        Product2 product = MockObject.getNewProduct(new Map<String, Object>{'Bar_Code__c' => 0, 
            'SAP_code__c' => 123456, 'Subgroup__c' => 'GALVUS', 'Family' => 'METABOLISMO', 'Name' => 'GALVUS 50MG 7CE'});       
        insert product;
        product = MockObject.getProduct(product.id);
        
        // Case creation                
        
        Case_Type__c caseType = MockObject.getNewDummyCaseType();       
        insert caseType;
        
        caseType = MockObject.getCaseType(caseType.id);
        
        System.debug(':::: After insert Case Type:...');
        System.debug(':::: Case Type[Theme:' + caseType.Theme__c + ']');
        
        
        
        Case myCase = new Case(
            AccountId = account.Id,
            Flow_Type__c = flowType1.Id,
            ContactId = contact.Id,
            Case_Type__c = caseType.Id,
            RecordTypeId = rtCase.Id,
            RecordType = rtCase,
            Status = 'Open',
            Person_identification_number_CPF__c = '0'
        );
        
        
        insert myCase;
        myCase = [select Case_Type__c, RecordType.Id, Status from Case where Id = :myCase.Id];
        
        Test.startTest();
        
        System.debug(':::: After insert Case:...');
        System.debug(':::: Case [RecordTypeId:' + myCase.RecordType.Id + ',' +
            'Status:' + myCase.Status + ']');
        
        Case subcase = new Case (
            ContactId = contact.Id,
            Flow_Type__c = flowType1.Id,
            RecordTypeId = rtSubcase.Id,
            Case_Type__c = caseType.Id,
            RecordType = rtSubcase,
            ParentId = myCase.Id,
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
        
        subcase = [select RecordTypeId, Case_Type__c, ParentId, Status, AccountId, Number_of_complained_packages__c, Patient_Name__c, Request_Numbers__c, Reimbursement_via__c from Case where Id = :subcase.Id];
        
        System.debug(':::: After insert Subcase:...');
        System.debug(':::: Subcase [RecordTypeId:' + subcase.RecordTypeId + ',' +
            'Status:' + myCase.Status + ',Reimbursement_via__c:' + subcase.Reimbursement_via__c + ']');     
        
        // Stage creation 
        Flow_Type__c objFltype= new Flow_Type__c();
        objFltype.Description__c='PRUEBA';
        insert objFltype;
        Flow_Type__c flowType = new List<Flow_Type__c>([select Name from Flow_Type__c where Description__c = 'PRUEBA'])[0];     
        
        Stage__c stage = new Stage__c(
            Change_Request__c = true,
            Description__c = 'Test Stage Description...',
            Assigned_to__c = UserInfo.getUserId(),
            Maxim_Duration__c = 1.0,
            Flow_Type__c = flowType.Id
        );
        
        insert stage;
        
        // Task creation
        
        Task task = new Task(
            StageId__c = stage.Id,
            WhatId = subcase.Id,
            Subject = 'Test Task 1'
        );
                
        insert task;
        task = [select StageId__c, WhatId, Subject from Task where Id = :task.Id];
        
        Change_Request__c objCR = new Change_Request__c();
        objCR.Task_Id__c = task.Id;
        objCR.CR_number__c = 54654;
        objCR.Subcase_number__c = subcase.Id;	
        objCR.Visit_type__c = 'Exchange';
        objCR.Status__c='Open';
        insert objCR;
        
        Change_Request__c cr = [select Id from Change_Request__c where Task_Id__c = :task.Id];
        
        task.Status = 'Closed';
        update task;
        
        cr.Status__c = 'Closed';
        update cr;
        
        
        Task task2 = new Task(
            StageId__c = stage.Id,
            WhatId = subcase.Id,
            Subject = 'Test Task 2'
        );
                
        insert task2;
        task2 = [select StageId__c, WhatId, Subject from Task where Id = :task2.Id];
        
        task2.Status = 'Closed';
        update task2;
        
        Change_Request__c objCR2 = new Change_Request__c();
        objCR2.Task_Id__c = task2.Id;
        objCR2.CR_number__c = 54655;
        objCR2.Subcase_number__c = subcase.Id;	
        objCR2.Visit_type__c = 'Exchange';
        objCR2.Status__c='Open';
        insert objCR2;
        
        Change_Request__c cr2 = [select Id from Change_Request__c where Task_Id__c = :task2.Id];
        
        cr2.Status__c = 'Closed';
        update cr2;
                
        System.debug(':::: Update ChangeRequest');
        List<Change_Request__c> lstCRs = new List<Change_Request__c>();
        lstCRs.add(cr);
        lstCRs.add(cr2);
        
        update lstCRs;
        
        Task task3 = new Task(
            StageId__c = stage.Id,
            WhatId = subcase.Id,
            Subject = 'Test Task 2'
        );
                
        insert task3;
        task3 = [select StageId__c, WhatId, Subject from Task where Id = :task2.Id];
        
        Change_Request__c objCR3 = new Change_Request__c();
        objCR3.Task_Id__c = task.Id;
        objCR3.CR_number__c = 54656;
        objCR3.Subcase_number__c = subcase.Id;	
        objCR3.Visit_type__c = 'Exchange';
        objCR3.Status__c='Open';
        insert objCR3;
        
        Change_Request__c cr3 = [select Id from Change_Request__c where Task_Id__c = :task3.Id];

        task3.Status = 'Closed';
        update task3;
        
        cr3.Status__c = 'Closed';       
        
        update cr3;
        /*
        System.debug(':::: Update ChangeRequest');
        cr.Status__c = 'Closed';
        update cr;
        */
        
        Test.stopTest();
        
       // CreateChangeRequestWS_ctr.sendWS(cr.Id);
        //CreateChangeRequestWS_ctr.sendWScheduler(cr.Id);
        CreateChangeRequestWS_ctr ctr = new CreateChangeRequestWS_ctr();
        ctr.idCR = cr.Id;
        System.debug(':::: cr.Id:'+cr.Id);
        System.debug(':::: ctr.idCR:'+ctr.idCR);
        ctr.sendWSPage();
        ctr.sendWSRetries();
        
        
    }
    static testMethod void myUnitTest1() {
        RecordType rtCase    = MockObject.getRecordType('Case');
        RecordType rtSubcase = MockObject.getRecordType('Subcase');
        RecordType rTPersonAccount = MockObject.getRecordType('Person Account');
        
        Contact contact = MockObject.getNewDummyContact();
        insert contact;
        contact = MockObject.getContact(contact.Id);
        
        Flow_Type__c flowType1 = MockObject.getNewDummyFlowType();
        insert flowType1;
        flowType1 = MockObject.getFlowType(flowType1.id);
        
        // Account creation     
        
        Account account = MockObject.getNewAccount(new Map<String, Object>{'LastName' => 'Homer J Simpson', 'RecordTypeId' => rTPersonAccount.Id });
        insert account;
        account = MockObject.getAccount(account.id);
        
        // Creating Address
        Address__c address = MockObject.getNewDummyAddress();
        address.Account__c = account.Id;
        insert address;
        address = MockObject.getAddress(address.id);
        
        // Phone
        Phone__c phone = MockObject.getNewPhone(new Map<String, Object>{'Account__c' => account.Id, 'Exten__c' => 3070,
            'Local_Code__c' => 61, 'Phone_Number__c' => '32033204', 'Status__c' => 'ativo', 'Type__c' => 'bina', 'Main_Phone__c' => 'Telefone 1'});         
        insert phone;
        phone = MockObject.getPhone(phone.id);
        
        // Account creation (patient)
        
        Account patient = MockObject.getNewAccount(new Map<String, Object>{'LastName' => 'Bart Simpson', 'RecordTypeId' => rTPersonAccount.Id });       
        insert patient;
        patient = MockObject.getAccount(patient.id);
        
        // Product creation
        
        Product2 product = MockObject.getNewProduct(new Map<String, Object>{'Bar_Code__c' => 0, 
            'SAP_code__c' => 123456, 'Subgroup__c' => 'GALVUS', 'Family' => 'METABOLISMO', 'Name' => 'GALVUS 50MG 7CE'});       
        insert product;
        product = MockObject.getProduct(product.id);
        
        // Case creation                
        
        Case_Type__c caseType = MockObject.getNewDummyCaseType();       
        insert caseType;
        
        caseType = MockObject.getCaseType(caseType.id);
        
        System.debug(':::: After insert Case Type:...');
        System.debug(':::: Case Type[Theme:' + caseType.Theme__c + ']');
        
        
        
        Case myCase = new Case(
            AccountId = account.Id,
            Flow_Type__c = flowType1.Id,
            ContactId = contact.Id,
            Case_Type__c = caseType.Id,
            RecordTypeId = rtCase.Id,
            RecordType = rtCase,
            Status = 'Open',
            Person_identification_number_CPF__c = '0'
        );
        
        
        insert myCase;
        myCase = [select Case_Type__c, RecordType.Id, Status from Case where Id = :myCase.Id];
        
        Test.startTest();
        
        System.debug(':::: After insert Case:...');
        System.debug(':::: Case [RecordTypeId:' + myCase.RecordType.Id + ',' +
            'Status:' + myCase.Status + ']');
        
        Case subcase = new Case (
            ContactId = contact.Id,
            Flow_Type__c = flowType1.Id,
            RecordTypeId = rtSubcase.Id,
            Case_Type__c = caseType.Id,
            RecordType = rtSubcase,
            ParentId = myCase.Id,
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
        
        subcase = [select RecordTypeId, Case_Type__c, ParentId, Status, AccountId, Number_of_complained_packages__c, Patient_Name__c, Request_Numbers__c, Reimbursement_via__c from Case where Id = :subcase.Id];
        
        System.debug(':::: After insert Subcase:...');
        System.debug(':::: Subcase [RecordTypeId:' + subcase.RecordTypeId + ',' +
            'Status:' + myCase.Status + ',Reimbursement_via__c:' + subcase.Reimbursement_via__c + ']');     
        
        // Stage creation 
        Flow_Type__c objFltype= new Flow_Type__c();
        objFltype.Description__c='PRUEBA';
        insert objFltype;
        Flow_Type__c flowType = new List<Flow_Type__c>([select Name from Flow_Type__c where Description__c = 'PRUEBA'])[0];     
        
        Stage__c stage = new Stage__c(
            Change_Request__c = true,
            Description__c = 'Test Stage Description...',
            Assigned_to__c = UserInfo.getUserId(),
            Maxim_Duration__c = 1.0,
            Flow_Type__c = flowType.Id
        );
        
        insert stage;
        
        // Task creation
        
        Task task = new Task(
            StageId__c = stage.Id,
            WhatId = subcase.Id,
            Subject = 'Test Task 1'
        );
                
        insert task;
        
        task = [select StageId__c, WhatId, Subject from Task where Id = :task.Id];
        Change_Request__c objCR = new Change_Request__c();
        objCR.Task_Id__c = task.Id;
        objCR.CR_number__c = 54654;
        objCR.Subcase_number__c = subcase.Id;	
        objCR.Visit_type__c = 'Exchange';
        objCR.Status__c='Open';
        insert objCR;
        
        Change_Request__c cr = [select Id from Change_Request__c where Task_Id__c = :task.Id];
        
        task.Status = 'Closed';
        update task;
        
        cr.Status__c = 'Closed';
        update cr;
        
        
        Task task2 = new Task(
            StageId__c = stage.Id,
            WhatId = subcase.Id,
            Subject = 'Test Task 2'
        );
                
        insert task2;
        task2 = [select StageId__c, WhatId, Subject from Task where Id = :task2.Id];
        
        task2.Status = 'Closed';
        update task2;
        
        Change_Request__c objCR2 = new Change_Request__c();
        objCR2.Task_Id__c = task2.Id;
        objCR2.CR_number__c = 54655;
        objCR2.Subcase_number__c = subcase.Id;	
        objCR2.Visit_type__c = 'Exchange';
        objCR2.Status__c='Open';
        insert objCR2;
        
        Change_Request__c cr2 = [select Id from Change_Request__c where Task_Id__c = :task2.Id];
        
        cr2.Status__c = 'Closed';
        update cr2;
                
        System.debug(':::: Update ChangeRequest');
        List<Change_Request__c> lstCRs = new List<Change_Request__c>();
        lstCRs.add(cr);
        lstCRs.add(cr2);
        
        update lstCRs;
        
        Task task3 = new Task(
            StageId__c = stage.Id,
            WhatId = subcase.Id,
            Subject = 'Test Task 2'
        );
                
        insert task3;
        task3 = [select StageId__c, WhatId, Subject from Task where Id = :task2.Id];
        
        Change_Request__c objCR3 = new Change_Request__c();
        objCR3.Task_Id__c = task.Id;
        objCR3.CR_number__c = 54656;
        objCR3.Subcase_number__c = subcase.Id;	
        objCR3.Visit_type__c = 'Exchange';
        objCR3.Status__c='Open';
        insert objCR3;
        
        Change_Request__c cr3 = [select Id from Change_Request__c where Task_Id__c = :task3.Id];

        task3.Status = 'Closed';
        update task3;
        
        cr3.Status__c = 'Closed';       
        
        update cr3;
        /*
        System.debug(':::: Update ChangeRequest');
        cr.Status__c = 'Closed';
        update cr;
        */
        
        
        try
        {
            CreateChangeRequestWS_ctr.sendWS(cr.Id);
        }
        catch(System.Exception e){}
        
        //CreateChangeRequestWS_ctr.sendWScheduler(cr.Id);
        Test.stopTest();
        CreateChangeRequestWS_ctr ctr = new CreateChangeRequestWS_ctr();
        ctr.setMsg01(0, 'test');
        ctr.setMsg01(1, 'test');
        ctr.setMsg01(2, 'test');
        
        ctr.setMsg02(0, 'test');
        ctr.setMsg02(1, 'test');
        ctr.setMsg02(2, 'test');

        ctr.setMsg03(0, 'test');
        ctr.setMsg03(1, 'test');
        ctr.setMsg03(2, 'test');
        
        ctr.setMsg04(0, 'test');
        ctr.setMsg04(1, 'test');
        ctr.setMsg04(2, 'test');
                
        ctr.setMsg05(0, 'test');
        ctr.setMsg05(1, 'test');
        ctr.setMsg05(2, 'test');

        ctr.setMsg06(0, 'test');
        ctr.setMsg06(1, 'test');
        ctr.setMsg06(2, 'test');
        
        ctr.setMsg07(0, 'test');
        ctr.setMsg07(1, 'test');
        ctr.setMsg07(2, 'test');
                
        ctr.idCR = cr.Id;
        System.debug(':::: cr.Id:'+cr.Id);
        System.debug(':::: ctr.idCR:'+ctr.idCR);
        
        System.Pagereference pr = Apexpages.currentPage();
        pr.getParameters().put('CRnumber', String.valueOf(objCR3.CR_number__c));
        pr.getParameters().put('idCR', objCR3.Id);
        
        ctr.sendWSPage();
        ctr.sendWSRetries();
        
        
    }
}