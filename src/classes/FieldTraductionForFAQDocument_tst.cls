public with sharing class FieldTraductionForFAQDocument_tst {
	static testMethod void test_one()
	{	
		FAQ__c objFAQ =new FAQ__c();
		objFAQ.key_words__c='Inactive';
		objFAQ.Status__c='Active';
			
		insert objFAQ;
		 
		FAQ_document__c objFAQ_Document =new FAQ_document__c();
		objFAQ_Document.FAQ__c=objFAQ.Id;
		objFAQ_Document.Address_Location__c='Cll 24 #12-01';
		objFAQ_Document.Status__c='Active123';
		
		try
		{
			insert objFAQ_Document;
			//System.assert( false );
		}
		catch( System.exception e )
		{
			//System.assert( true );
		}
		
		objFAQ_Document.Status__c='Active';
		
		//insert objFAQ_Document;
	}
}