@IsTest
private class FieldTraductionForFAQ_tst {
	static testMethod void test_one()
	{	
		 
		FAQ__c objFAQ =new FAQ__c();
		objFAQ.key_words__c='Inactive123';
		objFAQ.Status__c='Active123';
				
		try
		{
			insert objFAQ;
			//System.assert( false );
		}
		catch( System.exception e )
		{
			//System.assert( true );
		}
		
		objFAQ.key_words__c='Inactive';
		objFAQ.Status__c='Active';
		
		//insert objFAQ;		
	}
}