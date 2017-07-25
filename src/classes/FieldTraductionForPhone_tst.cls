@isTest
private class FieldTraductionForPhone_tst {

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
		
		Phone__c objPhone =new Phone__c();
		
		objPhone.Status__c = 'Ativo654';
		objPhone.Type__c = 'Celular456';
		objPhone.Main_Phone__c = 'Telefone 146654';
		objPhone.Account__c = acc.Id;
		objPhone.Local_Code__c = 0;
		objPhone.Phone_Number__c = '0.0';
		
		try
		{
			insert objPhone;
			//system.assert( false );
		}
		catch( System.exception e )
		{
			//system.assert( true );
		}
		
		objPhone.Status__c = 'Ativo';
		objPhone.Type__c = 'Celular';
		objPhone.Main_Phone__c = 'Telefone 1';
		
		//insert objPhone;
	}
}