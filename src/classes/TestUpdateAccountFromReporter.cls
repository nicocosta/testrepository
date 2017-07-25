/****************************************************************************************************
    General Information. 
    -------------------
    Developed by:   	Avanxo Colombia
    Author:             Giovanny Rey Cediel.
    Project:           	Novartis (CRM)
    Description:       	Test class to UpdateAccountFromReporter trigger.   
    
    Information about version
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     31-03-2011  Giovanny Rey Cediel          Creation.
****************************************************************************************************/
@isTest
private class TestUpdateAccountFromReporter {
	/***********************************************************************
		This method fire trigger, when is edit Reporter__c object
	************************************************************************/
    static testMethod void testOne() {		
		CreateObjects co = new CreateObjects();
		co.createObjects();
		Reporter__c reporter = new Reporter__c(id=co.reporter.id);
		reporter.Reporter_Name_Frozen__c='New';
		reporter.Reporter_related_name__c = co.account.Id;
		//reporter.Reporter_Last_Name_Frozen__c ='New';
		reporter.Reporter_Profession_Frozen__c= 'New';
		update reporter;
				 	     
    }
}