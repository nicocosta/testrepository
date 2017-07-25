/**
 * @author Diego Satoba
 */
public with sharing class MainEmail_tst {
	
	public static testMethod void testOne() {
		Account account = MockObject.getNewDummyPersonAccount();
		insert account;
		
		Email_Address__c email = MockObject.getNewDummyEmailAddress();
		email.Account__c = account.Id;
		email.Main_email__c = true;
		insert email;
		
		Email_Address__c email2 = MockObject.getNewDummyEmailAddress();
		email2.Account__c = account.Id;
		email2.Main_email__c = true;
		insert email2;
		
		
		List<Email_Address__c> lstEmails = new List<Email_Address__c>();
		lstEmails.add(email);
		lstEmails.add(email2);  
		update lstEmails;
		
		email = MockObject.getEmailAddress(email.Id);
		System.assert(!email.Main_email__c);
		email.Main_email__c = true;
		update email;
		
		email = MockObject.getEmailAddress(email.Id);
		email.Main_email__c = false;
		update email;
		
		
		lstEmails = new List<Email_Address__c>();
		email.Main_email__c = false;
		lstEmails.add(email);
		email2.Main_email__c = true;
		lstEmails.add(email2);  
		update lstEmails;
		
		lstEmails = new List<Email_Address__c>();
		email.Main_email__c = false;
		lstEmails.add(email);
		email2.Main_email__c = false;
		lstEmails.add(email2);  
		update lstEmails;
		
	}

}