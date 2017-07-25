/****************************************************************************************************
    General information. 
    -------------------
    Developed by:  		Avanxo Colombia
    Author:             Giovanny Rey Cediel.
    Project:           	Novartis (CRM)
    Descripción:        Test class to UpdateDataAccountFromSIR trigger.  
    
    Information about changes (Vertions)
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     31-03-2011  Giovanny Rey Cediel          Create.
****************************************************************************************************/
@isTest
private class TestUpdateDataAccountFromSIR {
	/***********************************************************************
		This method fire trigger, when is edti Safety_Individual_Report__c
	************************************************************************/
    static testMethod void testOne() {
		CreateObjects co = new CreateObjects();
		co.createObjects();
		
		Safety_Individual_Report__c  sir = new Safety_Individual_Report__c(id = co.safetyIndividualReport.id);
		sir.Patient_Name_Frozen__c='New';
		//sir.Patient_Last_Name_Frozen__c='New';		
		sir.Patient_Birthdate_Frozen__c=System.today();
		sir.Client_Name_Frozen__c='New';
		//sir.Client_Last_Name_Frozen__c='New';
		sir.Client_Profession_Frozen__c='New';
		update sir; 						 	     
    }
    
}