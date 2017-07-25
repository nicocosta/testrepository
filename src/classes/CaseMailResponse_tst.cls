/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Pablo Gracia
	Project:			Novartis Brazil
	Description: 		Test CaseMailResponse_ctr
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		18-11-2011	Juan Pablo Gracia			Create class.
	****************************************************************************************************/

@isTest
private class CaseMailResponse_tst {

    static testMethod void myUnitTest() {
       Case_Mail_Response__c cmr = new Case_Mail_Response__c(); 
       cmr.Message__c = 'Test';	
       ApexPages.StandardController sc = new ApexPages.standardController(cmr);
       CaseMailResponse_ctr cmr_ctr = new CaseMailResponse_ctr(sc);
       cmr_ctr.URLAnalist();
       cmr_ctr.quit();
       CaseMailResponse_ctr.deleteDoc(cmr_ctr.docId);
    }
}