@IsTest
private class FieldTraductionForContact_tst {
	static testMethod void test_one()
	{
		Contact objContact =new Contact();
		objContact.FirstName='Homer P1';
		objContact.LastName='Simpson P1';
		objContact.Gender__c='Feminino123';
		objContact.Salutation='Sr123';
		objContact.Occupation_Specialty__c='Biólogo123';
		objContact.Specialty__c='Alergista123';
	
		try
		{
			insert objContact;
			//System.assert( false );
		}
		catch( System.exception e )
		{
			//System.assert( true );
		}
		
 	
		objContact.Gender__c='Feminino';
		objContact.Salutation='Sr';
		objContact.Occupation_Specialty__c='social worker';
		objContact.Specialty__c='Alergista';
		
		//insert objContact;
	}


}