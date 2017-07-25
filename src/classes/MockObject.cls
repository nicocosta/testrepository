/**
 * @author Diego Satoba
 */

public class MockObject {
	
	/**
	 * Account
	 */
	
	public static Account getAccount(Id id) {
		Account account = [
			Select
				a.AccountNumber, a.AnnualRevenue, a.Area_company__pc, a.BillingCity,
				a.BillingCountry, a.BillingPostalCode, a.BillingState, a.BillingStreet, 
				a.CreatedById, a.CreatedDate, a.Description, a.Do_you_want_Novartis_contact_you__c, 
				a.F_City_Adress__c, a.F_State_Address__c, a.Fax, a.fCPF__c, a.fGender__c,
				a.FirstName, a.fMain_address__c, a.fMain_e_mail__c, a.fMain_phone__c, 
				a.fName__c, a.fOcupation__c, a.Gender__pc, a.Id, a.Industry, a.IsDeleted, 
				a.IsPersonAccount, a.LastActivityDate, a.LastModifiedById, a.LastModifiedDate, 
				a.LastName, a.Main_Address__c, a.Main_Contact__c, a.Main_email_address__c, 
				a.Main_Phone_2__c, a.Main_Phone_3__c, a.MasterRecordId, a.Migration_Id__c, 
				a.Migration_Id__pc, a.Name, a.NumberOfEmployees, a.Occupation_Specialty__pc, 
				a.OwnerId, a.ParentId, a.Person_identification_number_CPF__pc, 
				a.PersonAssistantName, a.PersonAssistantPhone, a.PersonBirthdate, 
				a.PersonContactId, a.PersonDepartment, a.PersonEmail, a.PersonHomePhone,
				a.PersonLastCURequestDate, a.PersonLastCUUpdateDate, a.PersonLeadSource, 
				a.PersonMailingCity, a.PersonMailingCountry, a.PersonMailingPostalCode, 
				a.PersonMailingState, a.PersonMailingStreet, a.PersonMobilePhone, 
				a.PersonOtherCity, a.PersonOtherCountry, a.PersonOtherPhone, 
				a.PersonOtherPostalCode, a.PersonOtherState, a.PersonOtherStreet, 
				a.PersonTitle, a.Phone, a.Phone_1__c, a.Phone_2__c, a.Phone_3__c, 
				a.Positiont_responsability__pc, a.professional_identification_document__pc, 
				a.Provider_Code__pc, a.RecordTypeId, a.Salutation, a.ShippingCity, 
				a.ShippingCountry, a.ShippingPostalCode, a.ShippingState, a.ShippingStreet, 
				a.Specialty__pc, a.Status__c, a.SystemModstamp, a.Type, a.Type__c, 
				a.VMS_safety_code_number__pc, a.Website from Account a where Id = :id
		];
		return account;
	}
	
	public static Account getNewAccount(Map<String, Object> mapValues) {		
		Account account = new Account(
			LastName     = (String) mapValues.get('LastName'),
			RecordTypeId = (Id) mapValues.get('RecordTypeId'),
			Type__c      = (String) mapValues.get('Type__c') 
		);
		return account;
	}
	
	public static Account getNewDummyPersonAccount() {		
		Account account = new Account(
			LastName     = 'Homer J. Simpson',
			RecordTypeId = MockObject.getRecordType('Person Account').Id,
			Status__c       = 'ativo'			
		);
		return account;
	}
	
	public static Account getNewDummyBusinessAccount() {
		Account account = new Account(
			RecordTypeId = MockObject.getRecordType('Business Customer').Id
		);
		return Account;
	}
	
	/**
	 * Address
	 */
	
	public static Address__c getAddress(Id id) {
		Address__c address = [
			select
				Account__c, Address_Name__c, City__c, Complement__c, CreatedById,
				CreatedDate, District__c, Id, Is_Main_Address__c, IsDeleted, 
				LastActivityDate, LastModifiedById, LastModifiedDate, Migration_Id__c,
				Name, Number__c, Post_Code__c, Post_code_number__c, State__c, Status__c,
				SystemModstamp, Type__c
			from Address__c
			where Id = :id
		];
		return address;
	}
	
	public static Address__c getNewAddress(Map<String, Object> mapValues) {
		Address__c address = new Address__c (
			Type__c            = (String) mapValues.get('Type__c'),
			Address_Name__c    = (String) mapValues.get('Address_Name__c'),
			District__c        = (String) mapValues.get('District__c'),
			City__c            = (String) mapValues.get('City__c'),
			State__c           = (String) mapValues.get('State__c'),
			Status__c          = (String) mapValues.get('Status__c'),
			Post_code_number__c = (String) mapValues.get('Post_code_number__c'),
			Is_Main_Address__c = mapValues.get('Is_Main_Address__c') == null ? false : (Boolean) mapValues.get('Is_Main_Address__c'),
			Account__c         = (Id) mapValues.get('Account__c')
		);
		return address;
	}
	
	public static Address__c getNewDummyAddress() {
		Address__c address = MockObject.getNewAddress(new Map<String, Object>{
			'Account__c ' => account.Id, 'Address_Name__c' => 'R JOAQUIM MURTINHO, 4136',
			'City__c' => 'CAMPO GRANDE', 'State__c' => 'MS', 'Status__c' => 'ativo',
			'Type__c' => 'comercial', 'Is_Main_Address__c' => false, 'Post_code_number__c' => '00000001',
			'District__c' => 'District test'
		});
		return address;
	}	
	
	/**
	 * Phone
	 */
	
	public static Phone__c getNewPhone(Map<String, Object> mapValues) {
		Phone__c phone = new Phone__c (
			Account__c      = (Id) mapValues.get('Account__c'),
			Exten__c        = (Double) mapValues.get('Exten__c'),
			Local_Code__c   = (Integer) mapValues.get('Local_Code__c'),
			Phone_Number__c = (String) mapValues.get('Phone_Number__c'),
			Status__c       = (String) mapValues.get('Status__c'),
			Type__c         = (String) mapValues.get('Type__c'), 
			Main_Phone__c   = (String) mapValues.get('Main_Phone__c') 
		);
		return phone;
	}
	
	public static Phone__c getPhone(Id id) {
		Phone__c phone = [
			select 
				Account__c, CreatedById, CreatedDate, Exten__c, Id, IsDeleted, 
				LastActivityDate, LastModifiedById, LastModifiedDate, Local_Code__c, 
				Main_Phone__c, Migration_Id__c, Name, Phone_Number__c, Status__c, 
				SystemModstamp, Type__c, whole_phone__c 
			from Phone__c p 
			where Id = :id
		];
		return phone;
	}
	
	/**
	 * Product
	 */
	public static Product2 getProduct(Id id) {
		Product2 product = [
			select 
				Bar_Code__c, CreatedById, CreatedDate, Description, Family, 
				Id, IsActive, IsDeleted, LastModifiedById, LastModifiedDate, 
				Migration_Id__c, Name, Price__c, ProductCode, Related_pathology__c, 
				SAP_code__c, Subgroup__c, SystemModstamp
			from Product2 p
			where Id = :id
		];
		return product;
	}
	
	public static Product2 getNewProduct(Map<String, Object> mapValues) {
		Product2 product = new Product2 (
			Bar_Code__c      = (Double) mapValues.get('Bar_Code__c'),
			Description      = (String) mapValues.get('Description'),
			Family           = (String) mapValues.get('Family'),
			IsActive         = mapValues.get('IsActive') == null ? false : (Boolean) mapValues.get('IsActive'),
			Migration_Id__c  = (String) mapValues.get('Migration_Id__c'),
			Name             = (String) mapValues.get('Name'),
			Price__c         = (Double) mapValues.get('Price__c'),
			ProductCode      = (String) mapValues.get('ProductCode'),
			Related_pathology__c = (String) mapValues.get('Related_pathology__c'),
			SAP_code__c      = (Double) mapValues.get('SAP_code__c'),
			Subgroup__c      = (String) mapValues.get('Subgroup__c') 
		);
		return product;
	}
	
	/**
	 * RecordType
	 */
	
	public static RecordType getRecordType(String name) {
		RecordType recordType = [select name from RecordType where name = :name];
		return recordType;
	}
	
	/**
	 * Case Type
	 */	
	public static Case_Type__c getCaseType(Id id) {
		Case_Type__c caseType = [
			select 
				CreatedById, CreatedDate, Id, Is_active__c, IsDeleted, LastActivityDate, 
				LastModifiedById, LastModifiedDate, Migration_Id__c, Name, Scenario__c, 
				Script__c, Subcase_subtype__c, Subcase_type__c, SystemModstamp, Theme__c 
			from Case_Type__c
			where Id = :id
		];
		return caseType;
	}
	
	public static Case_Type__c getNewDummyCaseType() {
		Case_Type__c caseType = getNewCaseType(new Map<String, Object>{
			'Name' => 'Case Type Test',
			'Script__c' => 'Script Test',
			'Theme__c' => 'Confirmação lote/val/fab/dcb/cód barras/ip'
		});
		return caseType;
	}
	
	
	public static Case_Type__c getNewCaseType(Map<String, Object> mapValues) {
		Case_Type__c caseType = new Case_Type__c (
			Is_active__c = mapValues.get('Is_active__c') == null ? false : (Boolean) mapValues.get('Is_active__c'),
			Migration_Id__c = (String) mapValues.get('Migration_Id__c'),
			Name = (String) mapValues.get('Name'),
			Scenario__c = (String) mapValues.get('Scenario__c'),
			Script__c = (String) mapValues.get('Script__c'), 
			Subcase_subtype__c = (String) mapValues.get('Subcase_subtype__c'), 
			Subcase_type__c = (String) mapValues.get('Subcase_type__c'),  
			Theme__c =  (String) mapValues.get('Theme__c')
		);
		return caseType;
	}
	
	/**
	 * Email Address
	 */	
	public static Email_Address__c getEmailAddress(Id id) {
		Email_Address__c email = [
			select 
				Account__c, CreatedById, CreatedDate, email_Address__c, Id, IsDeleted,
				LastActivityDate, LastModifiedById, LastModifiedDate, Main_email__c, 
				Migration_Id__c, Name, SystemModstamp 
			from Email_Address__c
			where Id = :id
		];
		return email;
	}
	
	public static Email_Address__c getNewDummyEmailAddress() {
		Email_Address__c email = getNewEmailAddress(new Map<String, Object>{ 
			'email_Address__c' => 'homero.simpson@mail.com', 
			'Main_email__c' => false
		});
		return email;
	}
	
	
	public static Email_Address__c getNewEmailAddress(Map<String, Object> mapValues) {		
		Email_Address__c email = new Email_Address__c (
			Account__c       = (Id) mapValues.get('Account__c'),
			email_Address__c = (String) mapValues.get('email_Address__c'),
			Main_email__c    = mapValues.get('Main_email__c') == null ? false : (Boolean) mapValues.get('Main_email__c') 
		);
		return email;
	}
	
	/**
	 * Change Request	 
	 */
	public static Change_Request__c getChangeRequest(Id id) {
		Change_Request__c cr = [
			select 
				CR_closing_date__c, CR_creation_date__c, CR_error_message__c, 
				CR_number__c, CreatedById, CreatedDate, Id, IsDeleted, 
				LastActivityDate, LastModifiedById, LastModifiedDate, Name, 
				Status__c, Subcase_number__c, SystemModstamp, Task_Id__c, 
				Visit_type__c 
			from Change_Request__c
			where Id = :id
		];
		return cr;
	}
	
	public static Contact getContact(Id id) {
		Contact contact = [
			Select 
				AccountId, Area_company__c, AssistantName, 
				AssistantPhone, Birthdate, CreatedById, CreatedDate, 
				Department, Description, Email, Fax, FirstName, Gender__c, 
				HomePhone, Id, IsDeleted, IsPersonAccount, LastActivityDate, 
				LastCURequestDate, LastCUUpdateDate, LastModifiedById, 
				LastModifiedDate, LastName, LeadSource, MailingCity, 
				MailingCountry, MailingPostalCode, MailingState, MailingStreet, 
				MasterRecordId, Migration_Id__c, MobilePhone, Name, 
				Occupation_Specialty__c, OtherCity, OtherCountry, OtherPhone, 
				OtherPostalCode, OtherState, OtherStreet, OwnerId, 
				Person_identification_number_CPF__c, Phone, 
				Positiont_responsability__c, professional_identification_document__c, 
				Provider_Code__c, ReportsToId, 
				Salutation, Specialty__c, SystemModstamp, Title, 
				VMS_safety_code_number__c 
			from Contact c
			where Id = :id
		];
		return contact;
	}
	
	
	public static Contact getNewContact(Map<String, Object> mapValues) {		
		Contact contact = new Contact(
		/*
			Acting_site__c, 
			Area_company__c, 
			AssistantName, 
			AssistantPhone, 
			Birthdate, 
			Cargo__c, 
			CreatedById, 
			CreatedDate,
			Department,
			Description, 
			Email, 
			Fax, 
			FirstName, 
			Gender__c,
			HomePhone, 
			Id, 
			IsDeleted, 
			IsPersonAccount, 
			LastActivityDate,
			LastCURequestDate, 
			LastCUUpdateDate, 
			LastModifiedById, 
			LastModifiedDate,
			*/ 
			LastName = (String) mapValues.get('LastName')
			/*
			LeadSource, 
			MailingCity, 
			MailingCountry, 
			MailingPostalCode, 
			MailingState, 
			MailingStreet, 
			MasterRecordId, 
			Migration_Id__c, 
			MobilePhone, 
			Name,
			Occupation_Specialty__c, 
			OtherCity, 
			OtherCountry, 
			OtherPhone, 
			OtherPostalCode, 
			OtherState, 
			OtherStreet, 
			OwnerId,
			Person_identification_number_CPF__c, 
			Phone,
			Positiont_responsability__c, 
			professional_identification_document__c,
			Provider_Code__c, 
			RecordTypeId, 
			ReportsToId, 
			Responsabilities__c,
			Salutation, 
			Specialty__c, 
			Status__c, 
			SystemModstamp, 
			Title, 
			VMS_safety_code_number__c
			*/  
		);
		return contact;
	}
	
	public static Contact getNewDummyContact() {		
		Contact contact = getNewContact(new Map<String, Object>{ 
			'LastName' => 'Marge Simpson'
		});
		return contact;
	}
	
	public static Flow_Type__c getFlowType(Id id) {
		Flow_Type__c flow = [
			Select 
				CreatedById, CreatedDate, Description__c, Flow_Number__c, Id,
				IsDeleted, LastActivityDate, LastModifiedById, LastModifiedDate, 
				Migration_Id__c, Name, OwnerId, SystemModstamp 
			from Flow_Type__c
			where Id = :id
		];
		return flow;
	}
	
	public static Flow_Type__c getNewDummyFlowType() {
		Flow_Type__c flow = getNewFlowType(new Map<String, Object>{'Description__c' => 'Test Description', 'Flow_Number__c' => '1234567890'});
		return flow;
	}
	
	public static Flow_Type__c getNewFlowType(Map<String, Object> mapValues) {
		Flow_Type__c flow = new Flow_Type__c(
			Description__c = (String) mapValues.get('Description__c'), 
			Flow_Number__c = (String) mapValues.get('Flow_Number__c'),
			Migration_Id__c = (String) mapValues.get('Migration_Id__c')
		);
		return flow;
	}
}