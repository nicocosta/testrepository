/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Pablo Gracia
	Project:			Novartis Brazil
	Description: 		CreateTestObjects's Test.
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		04-03-2011	Juan Pablo Gracia			Create class.
	****************************************************************************************************/
@isTest
private class CreateTestObjects_tst {
	static testmethod void generalTest(){
	  SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
	  User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
	  System.runAs ( userWhitAutorization ) {
	    CreateTestObjects co = new CreateTestObjects();
	    co.createObjects();
	  }
	}
}