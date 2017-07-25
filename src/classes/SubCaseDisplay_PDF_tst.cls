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
@isTest
private class SubCaseDisplay_PDF_tst {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        PageReference pageRef = Page.SubCaseDisplay_PDF;
        Test.setCurrentPageReference(pageRef);
        
        SubCaseDisplayPDF_ctr myPageCon;
        
        SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
        User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
        CreateTestObjects co;
        System.runAs ( userWhitAutorization ) {
            co = new CreateTestObjects();
            co.createObjects();
        }     
          
        test.startTest();
        
        //Create Note
        Note n = new Note();
        n.ParentId = co.safetyIndividualReport.Id;
        n.Title =  'Test';
        insert n;
        
        Attachment a = new Attachment();
        a.ParentId= co.safetyIndividualReport.Id;
        a.Name = 'Test';
        a.Body = Blob.valueOf('Test');
        insert a;
        
        Attachment ac = new Attachment();
        ac.ParentId= co.subCase.Id;
        ac.Name = 'Test';
        ac.Body = Blob.valueOf('Test');
        insert ac;
        
        CaseComment cc = new CaseComment();
        cc.ParentId = co.subCase.Id;
        cc.CommentBody = 'test';
        //insert cc;

        FAQ__c Faq = new FAQ__c();
        Faq.Name='Test';
        Faq.Description__c='sdfsd11a';
        insert Faq;
        
        FAQ_x_Case__c fc = new FAQ_x_Case__c();
        fc.FAQ__c = Faq.Id;        
        fc.Subcase_Number__c = co.subCase.Id;
        insert fc;
        
        Change_Request__c objCR = new Change_Request__c();
        objCR.Task_Id__c = co.task.Id;
        objCR.CR_number__c = 54654;
        objCR.Subcase_number__c = co.subCase.Id;    
        objCR.Visit_type__c = 'Exchange';
        objCR.Status__c='Open';
        insert objCR;
        
        //Task Creation
        Task task= new Task();
        task.Subject='processar relato no SINA e fechar tarefa';
        task.Status='Closed';
        task.WhatId = co.subCase.Id;
        task.OwnerId = UserInfo.getUserId();
        insert task;        
        
        co.subCase.Complaint_Response__c = 'Inconclusive';
        co.subCase.Description = 'test comment';
        co.subCase.Case_Subcase_Number__c = '9999999999999';
        update co.subCase;            
              
        ApexPages.StandardController sc = new ApexPages.standardController(co.subCase);
        
        myPageCon = new SubCaseDisplayPDF_ctr(sc);                     
        myPageCon.getCase(co.subCase.Id);           
        List<SubCaseDisplayPDF_ctr.SomeObjectHistory> listHistory = myPageCon.getSomeObjectHistory(co.subCase.Id);
        
        if( listHistory!=null && !listHistory.isEmpty() )
            listHistory[0].getActionFormat();         
                            
        test.stopTest();
                
    }
}