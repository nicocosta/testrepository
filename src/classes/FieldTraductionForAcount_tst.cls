@isTest
private class FieldTraductionForAcount_tst {

	static testMethod void test_one()
	{
		Account objAcount = new Account();
		objAcount.Name='William';
		objAcount.Status__c='Ativo123';
		objAcount.Do_you_want_Novartis_contact_you__c='Sim123';
		objAcount.Type__c ='outros123';
		  
		try
		{
			insert objAcount;
			//System.assert( false );
		}
		catch( System.exception e )
		{
			//System.assert( true );
		}

		objAcount.Status__c='Active';
		objAcount.Do_you_want_Novartis_contact_you__c='Yes';
		objAcount.Type__c ='Caregiver';
		
		//insert objAcount;
	}
}