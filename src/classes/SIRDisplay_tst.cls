/****************************************************************************************************
    General Information
    -------------------
    Developer:          Avanxo Colombia
    Autor:              Juan Pablo Gracia
    Project:            Novartis Brazil
    Description:        SIRDisplay_ctr's Test.
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     07-04-2011  Juan Pablo Gracia           Create class.
    ****************************************************************************************************/
@isTest
private class SIRDisplay_tst {
    
    static testmethod void generalTest(){
        PageReference pageRef = Page.SIRDisplay;
        Test.setCurrentPageReference(pageRef);
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
        
        ApexPages.StandardController sc = new ApexPages.standardController(co.safetyIndividualReport);
        
        SIRDisplay_ctr myPageCon = new SIRDisplay_ctr(sc);
        myPageCon.myEdit();
        
        myPageCon.getCase(cc.Id);
        
        myPageCon.deleteId = a.Id;
        myPageCon.deleteNotesAndAttachment();
        
        myPageCon.deleteId = ac.Id;
        myPageCon.deleteNotesAndAttachment();
                
        test.stopTest();
    }
    
}