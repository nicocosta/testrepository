@isTest
private class FieldTraductionForMedicineInUse_tst {
	
	static testMethod void test_one()
	{
		Account account = MockObject.getNewDummyPersonAccount();
		insert account;
		account = MockObject.getAccount(account.id);
		
		Account patient = MockObject.getNewDummyPersonAccount();
		patient.Type__c = 'Patient/Product user';
		insert patient;
		patient = MockObject.getAccount(patient.id);
		
		Contact contact = MockObject.getNewDummyContact();
		insert contact;
		contact = MockObject.getContact(contact.Id);
		
		Flow_Type__c flowType = MockObject.getNewDummyFlowType();
		insert flowType;
		flowType = MockObject.getFlowType(flowType.id);
		
		Case_Type__c caseType = MockObject.getNewDummyCaseType();		
		insert caseType;
		
		RecordType rtCase = MockObject.getRecordType('Case');
		RecordType rtSubcase = MockObject.getRecordType('Subcase');
		
		Product2 product = new Product2();
		product.Name = 'product name';
		product.SAP_code__c = 123;
		product.Bar_Code__c = 321;
		product.Family = 'SNC';
		product.Subgroup__c = 'Other';
		
		insert product;
		
		Case caso =new Case();
		caso.RecordTypeId = rtCase.Id;
		caso.AccountId = account.Id;
		caso.ContactId = contact.Id;
		caso.Flow_Type__c = flowType.Id;
		caso.Case_Type__c = caseType.Id;
		caso.Origin='Phone';
		caso.Status='Open';
		caso.Non_attendance_reason__c='Invoice not received';
		caso.Manufacture_Date_Month__c='january';
		caso.Expire_Date_Month__c='april';
		caso.Reimbursement_via__c='Product';
		caso.Complaint_Response__c='Fitting';
		caso.Technical_Request_Type__c='others';
		caso.Technical_Request_subtype__c='Dependence';

		insert caso; 
		
		Case subcase = new Case (
			ContactId = contact.Id,
			Flow_Type__c = flowType.Id,
			RecordTypeId = rtSubcase.Id,
			Case_Type__c = caseType.Id,
			RecordType = rtSubcase,
			ParentId = caso.Id,
			Status = 'Open',
			AccountId = account.Id,
			Number_of_complained_packages__c = 2,
			Patient_Name__c = patient.Id,
			Request_Numbers__c = 3,
			//Product__c = product.Id,
			Copy_data_from_client__c = false,
			Reimbursement_via__c = 'Dinheiro',
			Bank_Name__c = 'World Bank',
			Agency_Number__c = '00',
			Bank_Account_number__c = '0000000001',
			Bank_Account_Name__c = 'Bank Account Name Test',
			Person_identification_number_CPF__c = '0',
			Phone__c = '3492384',
			Address__c = 'akdsjja',
			Receipt_date_of_report__c = System.today()
		);
		
		insert subcase;

		Safety_Individual_Report__c sir = new Safety_Individual_Report__c();
		sir.Receipt_date_of_report__c = date.newInstance(2009, 04, 01); 
		sir.Second_level_description__c = 'descrinao'; 
		sir.Hospitalized__c = 'Não';
		sir.Reporter_allow_us_to_contact_physician__c = 'Yes';
		sir.Reporter_allow_us_to_share_the_data__c = 'Yes';	
		sir.Subcase_seriousness__c = 'serious';
		sir.Subcase_Number__c = subcase.Id;
		
		insert sir; 
		
		Medicines_in_use__c objMedicines =new Medicines_in_use__c();
		objMedicines.Indication__c='topical';
		objMedicines.Administration_route__c='Ignorado132';
		objMedicines.Ongoing__c='Não informado123';
		objMedicines.Suspect_Products__c='Yes132';
		objMedicines.Novartis_Product_Name__c = product.Id;
		objMedicines.Safety_Individual_Report__c = sir.Id;

		try
		{
			insert objMedicines;
			//System.assert( false );
		}
		catch( System.exception e )
		{
			//System.assert( true );
		}
		
		
		objMedicines.Administration_route__c='Ignorado';
		objMedicines.Ongoing__c='Não informado';
		objMedicines.Suspect_Products__c='Yes';
		
		//insert objMedicines;
		//update objMedicines;
	}
}