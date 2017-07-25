/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Pablo Gracia
	Project:			Novartis Brazil
	Description: 		AccountSearch_ctr's Test.
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		25-04-2011	Juan Pablo Gracia			Create class.
	****************************************************************************************************/
@isTest
private class AccountSearch_tst {
	static testmethod void generalTest(){
		PageReference pageRef = Page.AccountSearch;
		Test.setCurrentPageReference(pageRef);
		
		
		Test.startTest();
			
			AccountSearch_ctr myPageCon = new AccountSearch_ctr();
			myPageCon.newAccount();
			myPageCon.phone ='';
			myPageCon.name ='';
			myPageCon.search();
			myPageCon.name ='te';
			myPageCon.search();
			myPageCon.phone ='te';
			myPageCon.search();
			myPageCon.name ='test';
			myPageCon.phone ='te';
			myPageCon.search();
			myPageCon.name ='test';
			myPageCon.phone ='test';
			myPageCon.search();
			myPageCon.first();
			myPageCon.last();
			myPageCon.previous();
			myPageCon.next();
			myPageCon.cancel(); 
			myPageCon.getWrappers(); 
			myPageCon.newAccount();
			myPageCon.newAccountBusiness();
			Integer i = myPageCon.PageNumber; 
			Boolean a = myPageCon.HasPrevious; 
			Boolean b = myPageCon.HasNext; 
		Test.stopTest();
	}
	
	
	
}