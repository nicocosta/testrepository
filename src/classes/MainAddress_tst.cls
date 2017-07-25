/**
 * @author Diego Satoba
 */
 @isTest
private class MainAddress_tst {
	
	public static testMethod void testOne() {
		Account account = MockObject.getNewDummyPersonAccount();
		insert account;
		
		Address__c address = MockObject.getNewDummyAddress();
		address.Account__c = account.Id;
		address.Is_Main_Address__c = true;
		insert address;
		
		Address__c address2 = MockObject.getNewDummyAddress();
		address2.Account__c = account.Id;
		address2.Is_Main_Address__c = true;
		insert address2;
		
		List<Address__c> lstAdd = new List<Address__c>(); 
		lstAdd.add(address);
		lstAdd.add(address2);
		update lstAdd;
		
		address = MockObject.getAddress(address.Id);
		System.assert(!address.Is_Main_Address__c);
		address.Is_Main_Address__c = true;
		update address;
		
		address = MockObject.getAddress(address.Id);
		address.Is_Main_Address__c = false;
		update address;
		
		lstAdd = new List<Address__c>(); 
		address.Is_Main_Address__c = true;
		lstAdd.add(address);
		address2.Is_Main_Address__c = false;
		lstAdd.add(address2);
		update lstAdd;
		
		lstAdd = new List<Address__c>(); 
		address.Is_Main_Address__c = false;
		lstAdd.add(address);
		address2.Is_Main_Address__c = false;
		lstAdd.add(address2);
		update lstAdd;
	}
	

	
}