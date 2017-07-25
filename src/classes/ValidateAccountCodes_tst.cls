/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Pablo Gracia
	Project:			Novartis Brazil
	Description: 		ValidateAccountCodes's Test.
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		12-05-2011	Juan Pablo Gracia			Create class.
	****************************************************************************************************/

@isTest
private class ValidateAccountCodes_tst {

	static testmethod void generalTest(){
	  SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
	  User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
	  System.runAs ( userWhitAutorization ) {
	    CreateTestObjects co = new CreateTestObjects();
	    co.createObjects();
	    test.startTest();
	    //Actualización correcta
	    co.account.Person_identification_number_CPF__pc = '1234567890';
	    co.account.AccountNumber = '1234567890';
	    try{
	    	update co.account;
	    	System.assert(false);
	    }catch(Exception e){
	    }
	    test.stopTest();
	  }
	}

}