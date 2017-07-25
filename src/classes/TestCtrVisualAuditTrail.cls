/****************************************************************************************************
    General Information 
    -------------------
    Developed by:   	Avanxo Colombia
    Author:             Giovanny Rey Cediel.
    Projecto:           Novartis (CRM)
    Description:        Test class from CtrVisualAuditTrail controller.
    
    Information about (Versions)
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     30-03-2011  Giovanny Rey Cediel          Create.
****************************************************************************************************/
@isTest
private class TestCtrVisualAuditTrail {

    static testMethod void myUnitTest() {
    	
    	SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
        
        User usr = [Select Id From User Where profileid =:conf.PvProfileId__c  and isactive=true limit 1];
        system.runAs(usr){        			
			    	
			CreateObjects co = new CreateObjects();
	    	co.createObjects();    			
			System.Pagereference pr = Apexpages.currentPage();
			pr.getParameters().put('id',co.safetyIndividualReport.id);
						
			Test.startTest();			
			//update data on Safety_Individual_Report__c			
			Safety_Individual_Report__c sir = new Safety_Individual_Report__c(id = co.safetyIndividualReport.id);
			sir.Cause__c ='New Cause';
			sir.Duration__c='30';
			update sir;																				
			//update data on Reporter__c			
			Reporter__c reporter = new Reporter__c(id = co.reporter.id);
			reporter.Reporter_Name_Frozen__c = 'ReporterFirtsNameFrozen';
			reporter.Reporter_related_name__c = co.account.Id;
			update reporter;
			//update data on Medicines_in_use__c							
			Medicines_in_use__c med = new Medicines_in_use__c (id =co.medicinesInUse.id);
			med.Indication__c='commentToTest';
			update med;
			//updata data on Adverse_Event__c
			Adverse_Event__c adv = new Adverse_Event__c(id = co.adverseEvent.id);
			adv.Evolution__c='NewValueToTest';			 
			update adv;						
			CtrVisualAuditTrail.testFlat=true;
			CtrVisualAuditTrail.testFlatTwo=true;
			CtrVisualAuditTrail ctr = new CtrVisualAuditTrail();				
			List<CtrVisualAuditTrail.Values> values = ctr.listValues;
			Test.stopTest();	
	               
        }
    	
    	
   }
}