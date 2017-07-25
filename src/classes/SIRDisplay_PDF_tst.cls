/****************************************************************************************************
    General Information 
    -------------------
    Developed by:       Avanxo Colombia
    Author:             
    Projecto:           Novartis (CRM)
    Description:        Test class from SIRDisplay_PDF_ctr controller.
    
    Information about (Versions)
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     19/09/2013  Juan Sebastián Cardona       Create.
****************************************************************************************************/
@isTest
private class SIRDisplay_PDF_tst {
       
    static testmethod void generalTest(){
        PageReference pageRef = Page.SIRDisplay_PDF;
        Test.setCurrentPageReference(pageRef);
        SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
        User userWhitAutorization = [ select Id,ProfileId from User where IsActive =: true AND ProfileId =:conf.PvProfileId__c limit 1];
        CreateObjects co_tst;  
        System.runAs ( userWhitAutorization ) {
            co_tst = new CreateObjects();
            co_tst.createObjects();             
             
            test.startTest();
            
            //Create Note
            Note n = new Note();
            n.ParentId = co_tst.safetyIndividualReport.Id;
            n.Title =  'Test';
            insert n;
            
            Attachment a = new Attachment();
            a.ParentId= co_tst.safetyIndividualReport.Id;
            a.Name = 'Test';
            a.Body = Blob.valueOf('Test');
            insert a;
            
            Attachment ac = new Attachment();
            ac.ParentId= co_tst.subCase.Id;
            ac.Name = 'Test';
            ac.Body = Blob.valueOf('Test');
            insert ac;
            
            CaseComment cc = new CaseComment();
            cc.ParentId = co_tst.subCase.Id;
            cc.CommentBody = 'test';
            insert cc;
            
            Safety_Individual_Report__c sir = new Safety_Individual_Report__c(id = co_tst.safetyIndividualReport.id);
            sir.Cause__c ='New Cause';
            sir.Duration__c='30';
            update sir;     
                                                                                    
            //update data on Reporter__c            
            Reporter__c reportertst = new Reporter__c(id = co_tst.reporter.id);
            reportertst.Reporter_Name_Frozen__c = 'ReporterFirtsNameFrozen';
            reportertst.Reporter_related_name__c = co_tst.account.Id;
            update reportertst;
            
            //update data on Medicines_in_use__c                            
            Medicines_in_use__c med = new Medicines_in_use__c (id =co_tst.medicinesInUse.id);
            med.Indication__c='commentToTest';
            update med;
            
            //updata data on Adverse_Event__c
            Adverse_Event__c adv = new Adverse_Event__c(id = co_tst.adverseEvent.id);
            adv.Evolution__c='NewValueToTest';           
            update adv;
                     
            ApexPages.StandardController sc = new ApexPages.standardController(co_tst.safetyIndividualReport);
            
            SIRDisplay_PDF_ctr myPageCon = new SIRDisplay_PDF_ctr(sc);
            
            myPageCon.getCase(cc.Id);        
            myPageCon.deleteId = a.Id;  
            myPageCon.deleteId = ac.Id;
    
            SIRDisplay_PDF_ctr.testFlat=true;
            SIRDisplay_PDF_ctr.testFlatTwo=true;        
            List<SIRDisplay_PDF_ctr.Values> values = myPageCon.listValues;       
                    
            test.stopTest();
        
        }             

    }   

}