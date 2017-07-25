@isTest 
private class SubCaseCreator_tst
{
	static testMethod void URL_Analist_Test()
	{
		RecordType rtCases = MockObject.getRecordType('Case');
		RecordType rtSubcases = MockObject.getRecordType('Subcase');
    	
    	Account account = MockObject.getNewDummyPersonAccount();
		insert account;
		account = MockObject.getAccount(account.id);
		
		Contact contact = MockObject.getNewDummyContact();
		insert contact;
		contact = MockObject.getContact(contact.Id);
		
		Flow_Type__c flowType = MockObject.getNewDummyFlowType();
		insert flowType;
		flowType = MockObject.getFlowType(flowType.id);
    	
    	Case_Type__c caseType = MockObject.getNewDummyCaseType();
    	insert caseType;    	
    	caseType = MockObject.getCaseType(caseType.Id);
    				
		ApexPages.Standardcontroller stc;
		Case caso;
		Case subcaso;
		SubCaseCreator_ctr controller;
		Case_Type__c ct;
		Flow_Type__c ft;
		Case_Type_x_Flow_Type__c ctxft;
		List<RecordType> lstRecordType = [ Select Id, Name From RecordType Where Name = 'Case' or Name = 'Subcase' order by Name ];
		
		ct = new Case_Type__c();
		ct.Name = 'Case Type Test';
		ct.Subcase_type__c = 'Suggestion';
		ct.Subcase_subtype__c = 'Request User';
		ct.Script__c = 'Script Test';
		ct.Theme__c = 'Several references';
		ct.Scenario__c = 'Scenario Test';
		insert ct;
		
		ft = new Flow_Type__c();
		ft.Description__c = 'Description Test';
		ft.Flow_Number__c = 'Num Test';
		insert ft;
		
		ctxft = new Case_Type_x_Flow_Type__c();
		ctxft.Case_Type__c = ct.Id;
		ctxft.Flow_Type__c = ft.Id;
		insert ctxft;
		
		caso = new Case();
		caso.Flow_Type__c = flowType.Id;		
		caso.AccountId = account.Id;
		caso.ContactId = contact.Id;
		caso.Case_Type__c = ct.Id;
		caso.RecordTypeId = lstRecordType.get( 0 ).Id;
		caso.RecordType = lstRecordType.get( 0 );
		insert caso;
		
		PageReference paginaPrueba = Page.SubCaseCreator;
		paginaPrueba.getParameters().put('id', caso.Id );
		test.setCurrentPage(paginaPrueba);
		
		stc = new ApexPages.Standardcontroller( caso );
		controller = new SubCaseCreator_ctr( stc );
		controller.URL_Analist();
		
		subcaso = new Case();		
		subcaso.AccountId = account.Id;
		subcaso.ContactId = contact.Id;
		subcaso.Case_Type__c = ct.Id;
		subcaso.RecordTypeId = lstRecordType.get( 1 ).Id;
		subcaso.RecordType = lstRecordType.get( 1 );
		subcaso.ParentId = caso.Id;
		subcaso.Flow_Type__c = ft.Id;
		subcaso.Receipt_date_of_report__c = System.today();
		insert subcaso;
		
		paginaPrueba = Page.SubCaseCreator;
		paginaPrueba.getParameters().put('id', subcaso.Id );
		test.setCurrentPage(paginaPrueba);
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		List<SelectOption> lstTest = controller.lstFlows;
		controller.URL_Analist();
		
		paginaPrueba = Page.SubCaseCreator;
		paginaPrueba.getParameters().put('NewSC', '1' );
		test.setCurrentPage(paginaPrueba);
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.URL_Analist();
		
		paginaPrueba = Page.SubCaseCreator;
		paginaPrueba.getParameters().put('NewSC', '2' );
		test.setCurrentPage(paginaPrueba);
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.URL_Analist();
		
		paginaPrueba = Page.SubCaseCreator;
		paginaPrueba.getParameters().put('id', subcaso.Id );
		paginaPrueba.getParameters().put('RecordType', lstRecordType.get( 1 ).Id );
		test.setCurrentPage(paginaPrueba);
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.URL_Analist();
		
		paginaPrueba = Page.SubCaseCreator;
		paginaPrueba.getParameters().put('id', subcaso.Id );
		paginaPrueba.getParameters().put('RecordType', lstRecordType.get( 0 ).Id );
		test.setCurrentPage(paginaPrueba);
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.URL_Analist();
		
		paginaPrueba = Page.SubCaseCreator;
		paginaPrueba.getParameters().put('id', subcaso.Id );
		paginaPrueba.getParameters().put('RecordType', 'Exception Id' );
		test.setCurrentPage(paginaPrueba);
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.URL_Analist();
		
		
		paginaPrueba = Page.SubCaseCreator;
		paginaPrueba.getParameters().put('clone', '1' );
		test.setCurrentPage(paginaPrueba);
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.URL_Analist();
		controller.updatePage();
		try
		{
			controller.btnSave();
		}
		catch( System.exception e )
		{
			
		}
	}
	
	static testMethod void updateCaseTypeInfo_Test()
	{
		RecordType rtCases = MockObject.getRecordType('Case');
		RecordType rtSubcases = MockObject.getRecordType('Subcase');
		system.debug('@@-rtCases'+rtCases);
		system.debug('@@-rtSubcases'+rtSubcases);
    	
    	Account account = MockObject.getNewDummyPersonAccount();
		insert account;
		account = MockObject.getAccount(account.id);
		
		Contact contact = MockObject.getNewDummyContact();
		insert contact;
		contact = MockObject.getContact(contact.Id);
		
		Flow_Type__c flowType = MockObject.getNewDummyFlowType();
		insert flowType;
		flowType = MockObject.getFlowType(flowType.id);
    	
    	Case_Type__c caseType = MockObject.getNewDummyCaseType();
    	insert caseType;    	
    	caseType = MockObject.getCaseType(caseType.Id);
		
		ApexPages.Standardcontroller stc;
		Case caso, subcaso;
		SubCaseCreator_ctr controller;
		Case_Type__c ct;
		Flow_Type__c ft;
		Case_Type_x_Flow_Type__c ctxft;
		List<RecordType> lstRecordType = [ Select Id, Name From RecordType Where Name = 'Case' or Name = 'Subcase' order by Name ];
		
		ct = new Case_Type__c();
		ct.Name = 'Case Type Test';
		ct.Subcase_type__c = 'Suggestion';
		ct.Subcase_subtype__c = 'Request User';
		ct.Script__c = 'Script Test';
		ct.Theme__c = 'Several references';
		ct.Scenario__c = 'Scenario Test';
		insert ct;
		
		ft = new Flow_Type__c();
		ft.Description__c = 'Description Test';
		ft.Flow_Number__c = 'Num Test';
		insert ft;
		
		ctxft = new Case_Type_x_Flow_Type__c();
		ctxft.Case_Type__c = ct.Id;
		ctxft.Flow_Type__c = ft.Id;
		insert ctxft;
		
		caso = new Case();
		caso.Flow_Type__c = flowType.Id;		
		caso.AccountId = account.Id;
		caso.ContactId = contact.Id;
		caso.Case_Type__c = ct.Id;
		caso.RecordTypeId = lstRecordType.get( 0 ).Id;
		caso.RecordType = lstRecordType.get( 0 );
		insert caso;
		
		subcaso = new Case();
		subcaso.Flow_Type__c = flowType.Id;		
		subcaso.AccountId = account.Id;
		subcaso.ContactId = contact.Id;
		subcaso.Case_Type__c = ct.Id;
		subcaso.RecordTypeId = lstRecordType.get( 1 ).Id;
		subcaso.RecordType = lstRecordType.get( 1 );
		subcaso.ParentId = caso.Id;
		subcaso.Receipt_date_of_report__c = System.today();
		insert subcaso;
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.createSirRecord( subcaso );
		controller.updateCaseTypeInfo();
		controller.saveRelatedSubcase(subcaso);
		controller.agregarSubcasoRelacionado();		
		controller.reordenar();
		
		
		/*
		Dada la regla de validaci�n de que un subcaso debe tener un case type asociado, no se puede generar la prueba del
		case type nulo para que genere exscepcion la b�squeda.
		subcaso = new Case();
		subcaso.Case_Type__c = null;
		subcaso.RecordTypeId = lstRecordType.get( 1 ).Id;
		subcaso.RecordType = lstRecordType.get( 1 );
		subcaso.ParentId = caso.Id;
		insert subcaso;
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.updateCaseTypeInfo();*/
	}
	
	static testMethod void save_Test()
	{
		RecordType rtCases = MockObject.getRecordType('Case');
		RecordType rtSubcases = MockObject.getRecordType('Subcase');
    	
    	Account account = MockObject.getNewDummyPersonAccount();
		insert account;
		account = MockObject.getAccount(account.id);
		
		Contact contact = MockObject.getNewDummyContact();
		insert contact;
		contact = MockObject.getContact(contact.Id);
		
		Flow_Type__c flowType = MockObject.getNewDummyFlowType();
		insert flowType;
		flowType = MockObject.getFlowType(flowType.id);
    	
    	Case_Type__c caseType = MockObject.getNewDummyCaseType();
    	insert caseType;    	
    	caseType = MockObject.getCaseType(caseType.Id);
		
		ApexPages.Standardcontroller stc;
		Case caso, subcaso;
		SubCaseCreator_ctr controller;
		Case_Type__c ct;
		Flow_Type__c ft;
		Case_Type_x_Flow_Type__c ctxft;
		List<RecordType> lstRecordType = [ Select Id, Name From RecordType Where Name = 'Case' or Name = 'Subcase' order by Name ];
		
		ct = new Case_Type__c();
		ct.Name = 'Case Type Test';
		ct.Subcase_type__c = 'Suggestion';
		ct.Subcase_subtype__c = 'Request User';
		ct.Script__c = 'Script Test';
		ct.Theme__c = 'Several references';
		ct.Scenario__c = 'Scenario Test';
		insert ct;
		
		ft = new Flow_Type__c();
		ft.Description__c = 'Description Test';
		ft.Flow_Number__c = 'Num Test';
		insert ft;
		
		ctxft = new Case_Type_x_Flow_Type__c();
		ctxft.Case_Type__c = ct.Id;
		ctxft.Flow_Type__c = ft.Id;
		insert ctxft;
		
		caso = new Case();
		caso.Flow_Type__c = flowType.Id;		
		caso.AccountId = account.Id;
		caso.ContactId = contact.Id;
		caso.Case_Type__c = ct.Id;
		caso.RecordTypeId = lstRecordType.get( 0 ).Id;
		caso.RecordType = lstRecordType.get( 0 );
		insert caso;
		
		subcaso = new Case();
		subcaso.Flow_Type__c = flowType.Id;		
		subcaso.AccountId = account.Id;
		subcaso.ContactId = contact.Id;
		subcaso.Case_Type__c = ct.Id;
		subcaso.RecordTypeId = lstRecordType.get( 1 ).Id;
		subcaso.RecordType = lstRecordType.get( 1 );
		subcaso.ParentId = caso.Id;
		subcaso.Receipt_date_of_report__c = System.today();
		insert subcaso;
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.updateCaseTypeInfo();
		
		subcaso = new Case();
		subcaso.Flow_Type__c = flowType.Id;		
		subcaso.AccountId = account.Id;
		subcaso.ContactId = contact.Id;
		subcaso.Case_Type__c = null;
		subcaso.RecordTypeId = lstRecordType.get( 1 ).Id;
		subcaso.RecordType = lstRecordType.get( 1 );
		subcaso.ParentId = caso.Id;
		//insert subcaso;
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.btnSave();
	}
	
	static testMethod void save_Test2()
	{
		RecordType rtCases = MockObject.getRecordType('Case');
		RecordType rtSubcases = MockObject.getRecordType('Subcase');
    	
    	Account account = MockObject.getNewDummyPersonAccount();
		insert account;
		account = MockObject.getAccount(account.id);
		
		Contact contact = MockObject.getNewDummyContact();
		insert contact;
		contact = MockObject.getContact(contact.Id);
		
		Flow_Type__c flowType = MockObject.getNewDummyFlowType();
		insert flowType;
		flowType = MockObject.getFlowType(flowType.id);
    	
    	Case_Type__c caseType = MockObject.getNewDummyCaseType();
    	insert caseType;    	
    	caseType = MockObject.getCaseType(caseType.Id);
		
		ApexPages.Standardcontroller stc;
		Case caso, subcaso;
		SubCaseCreator_ctr controller;
		Case_Type__c ct;
		Flow_Type__c ft;
		Case_Type_x_Flow_Type__c ctxft;
		List<RecordType> lstRecordType = [ Select Id, Name From RecordType Where Name = 'Case' or Name = 'Subcase' order by Name ];
		
		ct = new Case_Type__c();
		ct.Name = 'Case Type Test';
		ct.Subcase_type__c = 'Suggestion';
		ct.Subcase_subtype__c = 'Request User';
		ct.Script__c = 'Script Test';
		ct.Theme__c = 'Several references';
		ct.Scenario__c = 'Scenario Test';
		insert ct;
		
		ft = new Flow_Type__c();
		ft.Description__c = 'Description Test';
		ft.Flow_Number__c = 'Num Test';
		insert ft;
		
		ctxft = new Case_Type_x_Flow_Type__c();
		ctxft.Case_Type__c = ct.Id;
		ctxft.Flow_Type__c = ft.Id;
		insert ctxft;
		
		caso = new Case();
		caso.Flow_Type__c = flowType.Id;		
		caso.AccountId = account.Id;
		caso.ContactId = contact.Id;
		caso.Case_Type__c = ct.Id;
		caso.RecordTypeId = lstRecordType.get( 0 ).Id;
		caso.RecordType = lstRecordType.get( 0 );
		insert caso;
		
		subcaso = new Case();
		subcaso.Flow_Type__c = flowType.Id;		
		subcaso.AccountId = account.Id;
		subcaso.ContactId = contact.Id;
		subcaso.Case_Type__c = ct.Id;
		subcaso.RecordTypeId = lstRecordType.get( 1 ).Id;
		subcaso.RecordType = lstRecordType.get( 1 );
		subcaso.ParentId = caso.Id;
		subcaso.Receipt_date_of_report__c = System.today();
		insert subcaso;
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.updateCaseTypeInfo();
		
		subcaso = new Case();
		subcaso.Flow_Type__c = flowType.Id;		
		subcaso.AccountId = account.Id;
		subcaso.ContactId = contact.Id;
		subcaso.Case_Type__c = null;
		subcaso.RecordTypeId = lstRecordType.get( 1 ).Id;
		subcaso.RecordType = lstRecordType.get( 1 );
		subcaso.ParentId = caso.Id;
		//insert subcaso;
		
		System.Pagereference pr = Apexpages.currentPage();
	    pr.getParameters().put('NewSC','1');
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.btnSave();
	}
	
	static testMethod void addMsg_test()
	{
		RecordType rtCases = MockObject.getRecordType('Case');
		RecordType rtSubcases = MockObject.getRecordType('Subcase');
    	
    	Account account = MockObject.getNewDummyPersonAccount();
		insert account;
		account = MockObject.getAccount(account.id);
		
		Contact contact = MockObject.getNewDummyContact();
		insert contact;
		contact = MockObject.getContact(contact.Id);
		
		Flow_Type__c flowType = MockObject.getNewDummyFlowType();
		insert flowType;
		flowType = MockObject.getFlowType(flowType.id);
    	
    	Case_Type__c caseType = MockObject.getNewDummyCaseType();
    	insert caseType;    	
    	caseType = MockObject.getCaseType(caseType.Id);
    	
		Case subcaso = new Case();
		ApexPages.Standardcontroller stc = new ApexPages.Standardcontroller( subcaso );
		SubCaseCreator_ctr controller = new SubCaseCreator_ctr( stc );
		controller.addMsg( 'Info', '', '' );
		controller.addMsg( 'Confirm', '', '' );
		controller.addMsg( 'Warning', '', '' );
		controller.addMsg( 'Error', '', '' );
		controller.addMsg( 'Fatal', '', '' );
		controller.updatePage();
		controller.removerSubcasoRelacionado();
	}
	
	static testMethod void showTest()
	{
		RecordType rtCases = MockObject.getRecordType('Case');
		RecordType rtSubcases = MockObject.getRecordType('Subcase');
    	
    	Account account = MockObject.getNewDummyPersonAccount();
		insert account;
		account = MockObject.getAccount(account.id);
		
		Contact contact = MockObject.getNewDummyContact();
		insert contact;
		contact = MockObject.getContact(contact.Id);
		
		Flow_Type__c flowType = MockObject.getNewDummyFlowType();
		insert flowType;
		flowType = MockObject.getFlowType(flowType.id);
    	
    	Case_Type__c caseType = MockObject.getNewDummyCaseType();
    	insert caseType;    	
    	caseType = MockObject.getCaseType(caseType.Id);
    	
		ApexPages.Standardcontroller stc;
		Case caso, subcaso;
		SubCaseCreator_ctr controller;
		Case_Type__c ct;
		Flow_Type__c ft;
		Case_Type_x_Flow_Type__c ctxft;
		List<RecordType> lstRecordType = [ Select Id, Name From RecordType Where Name = 'Case' or Name = 'Subcase' order by Name ];
		
		ct = new Case_Type__c();
		ct.Name = 'Case Type Test';
		ct.Subcase_type__c = 'Suggestion';
		ct.Subcase_subtype__c = 'Request User';
		ct.Script__c = 'Script Test';
		ct.Theme__c = 'Several references';
		ct.Scenario__c = 'Scenario Test';
		insert ct;
		
		ft = new Flow_Type__c();
		ft.Description__c = 'Description Test';
		ft.Flow_Number__c = 'Num Test';
		insert ft;
		
		ctxft = new Case_Type_x_Flow_Type__c();
		ctxft.Case_Type__c = ct.Id;
		ctxft.Flow_Type__c = ft.Id;
		insert ctxft;
		
		caso = new Case();
		caso.Flow_Type__c = flowType.Id;		
		caso.AccountId = account.Id;
		caso.ContactId = contact.Id;
		caso.Case_Type__c = ct.Id;
		caso.RecordTypeId = lstRecordType.get( 0 ).Id;
		caso.RecordType = lstRecordType.get( 0 );
		insert caso;
		
		subcaso = new Case();
		subcaso.Flow_Type__c = flowType.Id;		
		subcaso.AccountId = account.Id;
		subcaso.ContactId = contact.Id;
		subcaso.Case_Type__c = ct.Id;
		subcaso.RecordTypeId = lstRecordType.get( 1 ).Id;
		subcaso.RecordType = lstRecordType.get( 1 );
		subcaso.ParentId = caso.Id;
		subcaso.Receipt_date_of_report__c = System.today();
		insert subcaso;
		
		PageReference paginaPrueba = Page.SubCaseCreator;
		paginaPrueba.getParameters().put('id', subcaso.Id );
		test.setCurrentPage(paginaPrueba);
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.URL_Analist();
		
		Boolean blnTest = controller.showComplaint;
		blnTest = controller.showReimbursment;
		blnTest = controller.showPatient;
		blnTest = controller.showRequest;
		
		ct.Subcase_type__c = 'Complaint';
		ct.Subcase_subtype__c = 'Technical Complaint';
		
		update ct;
		
		subcaso.Reimbursement_via__c = 'Money';
		subcaso.Copy_data_from_client__c = false;
		subcaso.Agency_number__c = '11';
		subcaso.Bank_Account_Name__c = 'My Bank';
		subcaso.Bank_Name__c = 'My Other Bank';
		subcaso.Bank_Account_number__c = '128567';
		subcaso.Address__c = 'My DIr';
		subcaso.Phone__c = '123654789';
		update subcaso;
		
		paginaPrueba = Page.SubCaseCreator;
		paginaPrueba.getParameters().put('id', subcaso.Id );
		test.setCurrentPage(paginaPrueba);
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.URL_Analist();
		
		blnTest = controller.showComplaint;
		blnTest = controller.showReimbursment;
		
		ct.Subcase_type__c = 'reclama��o';
		ct.Subcase_subtype__c = 'reclama��o t�cnica';
		
		update ct;
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.URL_Analist();
		
		blnTest = controller.showComplaint;
		
		ct.Subcase_type__c = 'Request';
		ct.Subcase_subtype__c = 'Request Technical';
		
		update ct;
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.URL_Analist();
		
		blnTest = controller.showRequest;
		
		ct.Subcase_type__c = 'solicita��o';
		ct.Subcase_subtype__c = 'reclama��o t�cnica';
		
		update ct;
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.URL_Analist();
		
		blnTest = controller.showRequest;
		
		ct.Theme__c = 'Pharmacovigilance';
		ct.Subcase_subtype__c = 'Safety Report';
		
		update ct;
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.URL_Analist();
		
		blnTest = controller.showPatient;
		
		ct.Theme__c = 'with reports of pharmacovigilance';
		ct.Subcase_subtype__c = 'Technical Complaint';
		
		update ct;
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.URL_Analist();
		
		blnTest = controller.showPatient;
	}
	
	static testMethod void searchFAQProduct(){
		RecordType rtCases = MockObject.getRecordType('Case');
		RecordType rtSubcases = MockObject.getRecordType('Subcase');
    	
    	Account account = MockObject.getNewDummyPersonAccount();
		insert account;
		account = MockObject.getAccount(account.id);
		
		Contact contact = MockObject.getNewDummyContact();
		insert contact;
		contact = MockObject.getContact(contact.Id);
		
		Flow_Type__c flowType = MockObject.getNewDummyFlowType();
		insert flowType;
		flowType = MockObject.getFlowType(flowType.id);
    	
    	Case_Type__c caseType = MockObject.getNewDummyCaseType();
    	insert caseType;    	
    	caseType = MockObject.getCaseType(caseType.Id);
    	
		ApexPages.Standardcontroller stc;
		Case caso, subcaso;
		SubCaseCreator_ctr controller;
		Case_Type__c ct;
		Flow_Type__c ft;
		Case_Type_x_Flow_Type__c ctxft;
		List<RecordType> lstRecordType = [ Select Id, Name From RecordType Where Name = 'Case' or Name = 'Subcase' order by Name ];
		
		ct = new Case_Type__c();
		ct.Name = 'Case Type Test';
		ct.Subcase_type__c = 'Suggestion';
		ct.Subcase_subtype__c = 'Request User';
		ct.Script__c = 'Script Test';
		ct.Theme__c = 'Several references';
		ct.Scenario__c = 'Scenario Test';
		insert ct;
		
		ft = new Flow_Type__c();
		ft.Description__c = 'Description Test';
		ft.Flow_Number__c = 'Num Test';
		ft.Reimbursement_via__c='Product';
		insert ft;
		
		ctxft = new Case_Type_x_Flow_Type__c();
		ctxft.Case_Type__c = ct.Id;
		ctxft.Flow_Type__c = ft.Id;
		insert ctxft;
		
		caso = new Case();
		caso.Flow_Type__c = flowType.Id;		
		caso.AccountId = account.Id;
		caso.ContactId = contact.Id;
		caso.Case_Type__c = ct.Id;
		caso.RecordTypeId = lstRecordType.get( 0 ).Id;
		caso.RecordType = lstRecordType.get( 0 );
		insert caso;
		
		subcaso = new Case();
		subcaso.Flow_Type__c = flowType.Id;		
		subcaso.AccountId = account.Id;
		subcaso.ContactId = contact.Id;
		subcaso.Case_Type__c = ct.Id;
		subcaso.RecordTypeId = lstRecordType.get( 1 ).Id;
		subcaso.RecordType = lstRecordType.get( 1 );
		subcaso.ParentId = caso.Id;
		subcaso.Receipt_date_of_report__c = System.today();
		insert subcaso;
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		
		Test.startTest();
		controller.searchFAQProduct();
		controller.isCreate=true;
		controller.strFlowTypeName=ft.Id;
		controller.SubCase=subcaso;
		controller.autoAsignReimbursement();
		Test.stopTest();
	}
		
}