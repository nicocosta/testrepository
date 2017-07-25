@isTest
private class MainPhone_tst {
	
	static testMethod void test_one()
	{
		String IS_NOT_MAIN = 'Is not main';
		
		String PHONE_1 = 'Phone 1';
		String PHONE_2 = 'Phone 2';
		String PHONE_3 = 'Phone 3';
		
		String COMERCIAL   = 'Comercial'; 
		String RESIDENTIAL = 'Residential';
		String MOBILE      = 'Mobile';
		String BINA	       = 'Bina';
		
		
		RecordType recordType = [select name from RecordType where name = 'Person Account'];
		
		System.assert(recordType != null, true);
		
		Account acc = new Account();
		acc.LastName = 'Homer J Simpson';
		acc.RecordTypeId = recordType.Id;
		
		insert acc;
		
		System.debug('ACCOUNT ID:' + acc.Id);
		
		Phone__c phone1 = new Phone__c(Main_Phone__c = IS_NOT_MAIN,
		                               Local_Code__c = 11,
		                               Type__c = COMERCIAL,
		                               Phone_Number__c = '5532-0001',
		                               Status__c = 'Active',
		                               Account__c = acc.Id);
		
		
		Phone__c phone2 = new Phone__c(Main_Phone__c = PHONE_1, 
		                               Local_Code__c = 11,
		                               Type__c = RESIDENTIAL,
		                               Phone_Number__c = '5532-0002',
		                               Status__c = 'Active',
		                               Account__c = acc.Id);
		                               
		Phone__c phone3 = new Phone__c(Main_Phone__c = PHONE_2, 
		                               Local_Code__c = 11,
		                               Type__c = COMERCIAL,
		                               Phone_Number__c = '5532-0003',
		                               Status__c = 'Active',
		                               Account__c = acc.Id);
		
		Phone__c phone4 = new Phone__c(Main_Phone__c = PHONE_3, 
		                               Local_Code__c = 11,
		                               Type__c = RESIDENTIAL,
		                               Phone_Number__c = '5532-0004',
		                               Status__c = 'Active',
		                               Account__c = acc.Id);
		
		Phone__c phone5 = new Phone__c(Main_Phone__c = IS_NOT_MAIN, 
		                               Local_Code__c = 11,
		                               Type__c = COMERCIAL,
		                               Phone_Number__c = '5532-0005',
		                               Status__c = 'Active',
		                               Account__c = acc.Id);
		/**
		 * Inserciones
		 **/                               
		// Inserta Phone no principal
		insert phone1;
		
		// Inserta Phone principal 1
		insert phone2;
		// Recupera La Cuenta
		acc = [select Phone_1__c, Phone_2__c, Phone_3__c, LastName from Account where LastName = 'Homer J Simpson'];		
		// 
		System.assert(acc.Phone_1__c == phone2.Id, true);
		
		// Inserta Phone principal 2
		insert phone3;
		//
		acc = [select Phone_1__c, Phone_2__c, Phone_3__c, LastName from Account where LastName = 'Homer J Simpson'];
		//
		System.assert(acc.Phone_2__c == phone3.Id, true);
		
		// Inserta Phone principal 3
		//insert phone4;
		//
		//acc = [select Phone_1__c, Phone_2__c, Phone_3__c, LastName from Account where LastName = 'Homer J Simpson'];
		//
		//System.assert(acc.Phone_3__c == phone4.Id, true);
		
		/**
		 * Actualización
		 */
		// De principal a no principal
		phone2.Main_Phone__c = 'Is not main';
		update phone2;
		acc = [select Phone_1__c, Phone_2__c, Phone_3__c, LastName from Account where LastName = 'Homer J Simpson'];
		System.assert(acc.Phone_1__c == null, true);
		
		// De no principal a principal
		phone2.Main_Phone__c = 'Phone 2';
		update phone2;
		acc = [select Phone_1__c, Phone_2__c, Phone_3__c, LastName from Account where LastName = 'Homer J Simpson'];
		//System.assert(acc.Phone_2__c == phone2.Id, true);
		
		//phone3 = [select Main_Phone__c, Local_Code__c, Type__c, Phone_Number__c, Status__c, Account__c from Phone__c where Id = :phone3.Id];
		//System.assert(phone3.Main_Phone__c.equalsIgnoreCase('Is not main'));
		
		// De principal a principal
		phone2.Main_Phone__c = 'Phone 3';
		update phone2;
		acc = [select Phone_1__c, Phone_2__c, Phone_3__c, LastName from Account where LastName = 'Homer J Simpson'];
		//System.assert(acc.Phone_3__c == phone2.Id, true);
		//System.assert(acc.Phone_2__c == null, true);
		//phone4 = [select Main_Phone__c, Local_Code__c, Type__c, Phone_Number__c, Status__c, Account__c from Phone__c where Id = :phone4.Id];
		//System.assert(phone4.Main_Phone__c.equalsIgnoreCase('Is not main'));
		
		/**
		 *
		 **/
		phone5.Main_Phone__c = PHONE_3;
		insert phone5;
		acc = [select Phone_1__c, Phone_2__c, Phone_3__c, LastName from Account where LastName = 'Homer J Simpson'];
		phone2 = [select Main_Phone__c, Local_Code__c, Type__c, Phone_Number__c, Status__c, Account__c from Phone__c where Id = :phone2.Id];
		
		//System.assert(acc.Phone_3__c == phone5.Id, true);
		//System.assert(phone2.Main_Phone__c.equalsIgnoreCase('Is not main'), true);
		
		phone1.Main_Phone__c = PHONE_1;
		phone2.Main_Phone__c = PHONE_2;
		
		List<Phone__c> lstPhone = new List<Phone__c>();
		lstPhone.add(phone1);
		lstPhone.add(phone2);
		
		update lstPhone;
		
		
		
		acc = [select Phone_1__c, Phone_2__c, Phone_3__c, LastName from Account where LastName = 'Homer J Simpson'];
		System.assert(acc.Phone_1__c == phone1.Id, true);
		//System.assert(acc.Phone_2__c == phone2.Id, true);
		
		phone1.Main_Phone__c = PHONE_2;
		phone2.Main_Phone__c = PHONE_1;
		
		lstPhone = new List<Phone__c>();
		lstPhone.add(phone1);
		lstPhone.add(phone2);
		
		update lstPhone;
		
		lstPhone = new List<Phone__c>();
		phone1.Main_Phone__c = null;
		lstPhone.add(phone1);
		phone2.Main_Phone__c = null;
		lstPhone.add(phone2);
		
		update lstPhone;
		
		
		
		
		phone5.Main_Phone__c = PHONE_1;
		update phone5;
		
		phone1.Main_Phone__c = IS_NOT_MAIN;
		update phone1;
		
		phone5.Main_Phone__c = PHONE_1;
		update phone5;
		
		Phone__c phone6 = new Phone__c(Main_Phone__c = PHONE_1, 
		                               Local_Code__c = 11,
		                               Type__c = COMERCIAL,
		                               Phone_Number__c = '5532-0006',
		                               Status__c = 'Active',
		                               Account__c = acc.Id);
		
		Phone__c phone7 = new Phone__c(Main_Phone__c = PHONE_2, 
		                               Local_Code__c = 11,
		                               Type__c = RESIDENTIAL,
		                               Phone_Number__c = '5532-0007',
		                               Status__c = 'Active',
		                               Account__c = acc.Id);
		insert phone6;
		insert phone7;
		
		phone7.Main_Phone__c = PHONE_2;
		
		update phone7;
		
		
		
		//phone4.Main_Phone__c = IS_NOT_MAIN;
		//update phone4;
		
		lstPhone = new List<Phone__c>();
		lstPhone.add(phone1);
		lstPhone.add(phone2);
		lstPhone.add(phone3);
		//lstPhone.add(phone4);
		lstPhone.add(phone5);
		lstPhone.add(phone6);
		lstPhone.add(phone7);
		delete lstPhone; 
	}

}