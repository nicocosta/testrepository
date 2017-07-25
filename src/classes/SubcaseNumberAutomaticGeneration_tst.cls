@isTest
private class SubcaseNumberAutomaticGeneration_tst {
	 /*
	static testMethod void URL_Analist_Test()
	{
		ApexPages.Standardcontroller stc;
		
		Case caso, subcaso;
		SubCaseCreator_ctr controller;
		Case_Type__c ct;
		Flow_Type__c ft;
		Case_Type_x_Flow_Type__c ctxft;
		
		List<RecordType> lstRecordType = [ Select Id, Name From RecordType Where Name = 'Case' or Name = 'Subcase' order by Name ];
		String strBuffer = '';
		for (RecordType r : lstRecordType) {
			strBuffer += '(' + r.Name + ':' + r.Id + '), ';
		}
		System.debug('RecordTypes:' + strBuffer);
		RecordType recordTypeCase = lstRecordType.get(0), recordTypeSubcase = lstRecordType.get(1);
		
		
		
		ct = new Case_Type__c();
		ct.Name               = 'Case Type Test';
		ct.Subcase_type__c    = 'SubCase Type Test';
		ct.Subcase_subtype__c = 'SubCase SubType Test';
		ct.Script__c          = 'Script Test';
		ct.Theme__c           = 'Theme Test';
		ct.Scenario__c        = 'Scenario Test';
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
		caso.Case_Type__c = ct.Id;
		caso.RecordTypeId = recordTypeCase.Id;
		caso.RecordType = lstRecordType.get( 0 );
		insert caso;
		
		
		
		
		PageReference paginaPrueba = Page.SubCaseCreator;
		paginaPrueba.getParameters().put('id', caso.Id );
		test.setCurrentPage(paginaPrueba);
		
		stc = new ApexPages.Standardcontroller( caso );
		controller = new SubCaseCreator_ctr( stc );
		controller.URL_Analist();
		
		subcaso = new Case();
		subcaso.Case_Type__c = ct.Id;
		subcaso.RecordTypeId = lstRecordType.get( 1 ).Id;
		subcaso.RecordType = lstRecordType.get( 1 );
		subcaso.ParentId = caso.Id;
		insert subcaso;
		
		paginaPrueba = Page.SubCaseCreator;
		paginaPrueba.getParameters().put('id', subcaso.Id );
		test.setCurrentPage(paginaPrueba);
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		List<SelectOption> lstTest = controller.lstFlows;
		controller.URL_Analist();
		
		paginaPrueba = Page.SubCaseCreator;
		paginaPrueba.getParameters().put('RecordType', lstRecordType.get( 1 ).Id );
		test.setCurrentPage(paginaPrueba);
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.URL_Analist();
		
		paginaPrueba = Page.SubCaseCreator;
		paginaPrueba.getParameters().put('RecordType', lstRecordType.get( 0 ).Id );
		test.setCurrentPage(paginaPrueba);
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.URL_Analist();
		
		paginaPrueba = Page.SubCaseCreator;
		paginaPrueba.getParameters().put('RecordType', 'Exception Id' );
		test.setCurrentPage(paginaPrueba);
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.URL_Analist();
	}
	
	static testMethod void updateCaseTypeInfo_Test()
	{
		ApexPages.Standardcontroller stc;
		Case caso, subcaso;
		SubCaseCreator_ctr controller;
		Case_Type__c ct;
		Flow_Type__c ft;
		Case_Type_x_Flow_Type__c ctxft;
		List<RecordType> lstRecordType = [ Select Id, Name From RecordType Where Name = 'Case' or Name = 'Subcase' order by Name ];
		
		ct = new Case_Type__c();
		ct.Name = 'Case Type Test';
		ct.Subcase_type__c = 'SubCase Type Test';
		ct.Subcase_subtype__c = 'SubCase SubType Test';
		ct.Script__c = 'Script Test';
		ct.Theme__c = 'Theme Test';
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
		caso.Case_Type__c = ct.Id;
		caso.RecordTypeId = lstRecordType.get( 0 ).Id;
		caso.RecordType = lstRecordType.get( 0 );
		insert caso;
		
		subcaso = new Case();
		subcaso.Case_Type__c = ct.Id;
		subcaso.RecordTypeId = lstRecordType.get( 1 ).Id;
		subcaso.RecordType = lstRecordType.get( 1 );
		subcaso.ParentId = caso.Id;
		insert subcaso;
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.updateCaseTypeInfo();
		
		subcaso = new Case();
		subcaso.Case_Type__c = null;
		subcaso.RecordTypeId = lstRecordType.get( 1 ).Id;
		subcaso.RecordType = lstRecordType.get( 1 );
		subcaso.ParentId = caso.Id;
		insert subcaso;
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.updateCaseTypeInfo();
	}
	
	static testMethod void save_Test()
	{
		ApexPages.Standardcontroller stc;
		Case caso, subcaso;
		SubCaseCreator_ctr controller;
		Case_Type__c ct;
		Flow_Type__c ft;
		Case_Type_x_Flow_Type__c ctxft;
		List<RecordType> lstRecordType = [ Select Id, Name From RecordType Where Name = 'Case' or Name = 'Subcase' order by Name ];
		
		ct = new Case_Type__c();
		ct.Name = 'Case Type Test';
		ct.Subcase_type__c = 'SubCase Type Test';
		ct.Subcase_subtype__c = 'SubCase SubType Test';
		ct.Script__c = 'Script Test';
		ct.Theme__c = 'Theme Test';
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
		caso.Case_Type__c = ct.Id;
		caso.RecordTypeId = lstRecordType.get( 0 ).Id;
		caso.RecordType = lstRecordType.get( 0 );
		insert caso;
		
		subcaso = new Case();
		subcaso.Case_Type__c = ct.Id;
		subcaso.RecordTypeId = lstRecordType.get( 1 ).Id;
		subcaso.RecordType = lstRecordType.get( 1 );
		subcaso.ParentId = caso.Id;
		insert subcaso;
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.updateCaseTypeInfo();
		
		subcaso = new Case();
		subcaso.Case_Type__c = null;
		subcaso.RecordTypeId = lstRecordType.get( 1 ).Id;
		subcaso.RecordType = lstRecordType.get( 1 );
		subcaso.ParentId = caso.Id;
		//insert subcaso;
		
		stc = new ApexPages.Standardcontroller( subcaso );
		controller = new SubCaseCreator_ctr( stc );
		controller.save();
	}
	
	static testMethod void addMsg_test()
	{
		Case subcaso = new Case();
		ApexPages.Standardcontroller stc = new ApexPages.Standardcontroller( subcaso );
		SubCaseCreator_ctr controller = new SubCaseCreator_ctr( stc );
		controller.addMsg( 'Info', '', '' );
		controller.addMsg( 'Confirm', '', '' );
		controller.addMsg( 'Warning', '', '' );
		controller.addMsg( 'Error', '', '' );
		controller.addMsg( 'Fatal', '', '' );
	}
	*/
}