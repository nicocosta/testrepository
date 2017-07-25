/****************************************************************************************************
    General Information. 
    -------------------
    Developed by:   	Avanxo Colombia
    Author:             Giovanny Rey Cediel.
    Project:           	Novartis (CRM)
    Description:        Test class to EventClosedTask class.
    
    Information about version
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     25-03-2011  Giovanny Rey Cediel          Creation.
**************************************************************************************************/
@isTest
private class TestEventClosedTask {	    
    static testMethod void testOne() {
	  SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
	  User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
	  System.runAs ( userWhitAutorization ) {
		CreateObjects co = new CreateObjects();
		co.createObjects();		  
		    try{
		    	 EventClosedTask.flatTestOne=true;
		    	 EventClosedTask.flatTestTwo=false;
		    	 co.task.Description__c='TestDescription';
		    	 update co.task;
			}catch(Exception e){
		    	System.debug(' \n <MENSAJE'>+e.getMessage());
		    }
		} 		    
    }
    
     
    static testMethod void testTwo() {
		EventClosedTask ect = new EventClosedTask();
		ect.getIdProfileFromOwnerTask('123456');		
					    
    }
    
}