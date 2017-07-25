@isTest
private class FieldTraductionForAdess_tst {

    static testMethod void test_one()
	{
		RecordType rt = [ Select id From RecordType Where Name = 'Person Account' ];
		
		Account acc = new Account();
		acc.RecordTypeId = rt.Id;
		acc.Do_you_want_Novartis_contact_you__c = 'Not';
		acc.Gender__pc = 'Male';
		//acc.FirstName = 'Prueba';
		acc.LastName = 'Test';
		
		insert acc;
		
		Address__c objAddress =new Address__c();
		objAddress.Status__c='AtivDDFo';
		objAddress.Type__c='ComerciaDDFl';
		objAddress.Account__c = acc.Id;
		
		try
		{
			insert objAddress;
			//System.assert( false );
		}
		catch( System.exception e )
		{
			//System.assert( true );
		}
		
		objAddress.Status__c='Ativo';
		objAddress.Type__c='Comercial';
		
		System.debug('DATOS Antes = '+ objAddress.Status__c);
		System.debug('DATOS Antes = '+ objAddress.Type__c);
		
		//insert objAddress;  

		//objAddress = [select Status__c,Type__c from Address__c where Id =: objAddress.Id];	
		 
		System.debug('DATOS despues = '+ objAddress.Status__c);
		System.debug('DATOS despues = '+ objAddress.Type__c);
		  
		  
	}
    
}