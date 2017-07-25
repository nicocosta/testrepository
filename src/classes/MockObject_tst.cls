/**
 * @author Diego Satoba
 */
@isTest
private class MockObject_tst {

    static testMethod void myUnitTest() {
    	RecordType rtPersonAccount = MockObject.getRecordType('Person Account');
    	RecordType rtBusinessCustomer = MockObject.getRecordType('Business Customer');
    	RecordType rtCase = MockObject.getRecordType('Case');
    	RecordType rtSubcase = MockObject.getRecordType('Subcase');
    	    	
    	Account account = MockObject.getNewAccount(new Map<String, Object>{'RecordTypeId' => rtPersonAccount.Id, 'LastName' => 'Homer J. Simpsons'});
    	insert account;
        MockObject.getAccount(account.Id);
        
        Contact contact = MockObject.getNewContact(new Map<String, Object>{'LastName' => 'Homero Simpson'});
        MockObject.getNewDummyContact();
        insert contact;
        MockObject.getContact(contact.Id);
        
        Address__c address = MockObject.getNewAddress(new Map<String, Object>{'Type__c' => 'Residencial', 'Address_Name__c' => 'R JOAQUIM MURTINHO, 4136', 'District__c' => 'VILA BOSSI', 'City__c' => 'LOUVEIRA', 'State__c' => 'SP', 'Status__c' => 'ativo', 'Is_Main_Address__c' => true, 'Account__c' => account.Id, 'Post_code_number__c' => '00000001'});
        insert address;
        Address__c address2 = MockObject.getNewAddress(new Map<String, Object>{'Account__c' => account.Id, 'Is_Main_Address__c' => false});
        MockObject.getNewDummyAddress();        
        MockObject.getAddress(address.Id);
        
        Phone__c phone = MockObject.getNewPhone(new Map<String, Object>{'Account__c' => account.Id, 'Local_Code__c' => 11, 'Phone_Number__c' => '2222222'});
        insert phone;
        MockObject.getPhone(phone.Id);
        
        Product2 product = MockObject.getNewProduct(new Map<String, Object>{'Bar_Code__c' => 0, 'SAP_code__c' => 123456, 'Subgroup__c' => 'GALVUS', 'Family' => 'METABOLISMO', 'Name' => 'GALVUS 50MG 7CE'});
        MockObject.getNewProduct(new Map<String, Object>{'Bar_Code__c' => 0, 'SAP_code__c' => 123456, 'Subgroup__c' => 'GALVUS', 'Family' => 'METABOLISMO', 'Name' => 'GALVUS 50MG 7CE', 'IsActive' => false});
		insert product;
		MockObject.getProduct(product.Id);
		
		Case_Type__c caseType = MockObject.getNewCaseType(new Map<String, Object>{'Name' => 'Case Type Test','Script__c' => 'Script Test','Theme__c' => 'Confirmação lote/val/fab/dcb/cód barras/ip'});
		Case_Type__c caseType2 = MockObject.getNewCaseType(new Map<String, Object>{'Name' => 'Case Type Test','Script__c' => 'Script Test','Theme__c' => 'Confirmação lote/val/fab/dcb/cód barras/ip', 'Is_active__c' => true});
		MockObject.getNewDummyCaseType();
		insert caseType;		
		MockObject.getCaseType(caseType.id);
		
		Email_Address__c email = MockObject.getNewEmailAddress(new Map<String, Object>{'email_Address__c' => 'homero.simpson@mail.com', 'Account__c' => account.Id});	
		Email_Address__c email2 = MockObject.getNewEmailAddress(new Map<String, Object>{'email_Address__c' => 'homero.simpson@mail.com', 'Account__c' => account.Id, 'Main_email__c' => false});
		MockObject.getNewDummyEmailAddress();
		insert email;
		MockObject.getEmailAddress(email.Id);
		
		Account person = MockObject.getNewDummyPersonAccount();
		Account business = MockObject.getNewDummyBusinessAccount();
		
    }
}