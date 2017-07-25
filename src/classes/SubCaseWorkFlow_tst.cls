@isTest
private class SubCaseWorkFlow_tst 
{/*
	static testMethod void createSubCase() 
	{
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
		caseType = MockObject.getCaseType(caseType.id);
		
		RecordType rtCase    = MockObject.getRecordType('Case');
		RecordType rtSubcase = MockObject.getRecordType('Subcase');
		RecordType rTPersonAccount = MockObject.getRecordType('Person Account');
		
		List<RecordType> lstRecordType = [ Select Id, Name From RecordType Where Name = 'Case' or Name = 'Subcase' order by Name ];
		System.debug( '*-*----* lstRecordType: ' + lstRecordType );
		if( lstRecordType.size() == 2 )
		{
			
			
			Case caso = new Case();
			caso.Case_Type__c = caseType.Id;
			caso.Flow_Type__c = flowType.Id;
			caso.ContactId = contact.Id;
			caso.AccountId = account.Id;
			caso.Status = 'Open';
			caso.Origin = 'Email';
			caso.RecordTypeId = lstRecordType[0].Id;
			insert caso;
			
			//If a case record is created with recordtype "Case" no Taks has to be created.
			System.assertEquals( 0, [ Select Count() From Task Where WhatId = :caso.Id ] );
			
			Case_Type__c ct = new Case_Type__c();
			ct.Name = 'Case Type Test';
			ct.Subcase_type__c = 'Suggestion';
			ct.Subcase_subtype__c = 'Request User';
			ct.Script__c = 'Script Test';
			ct.Theme__c = 'Several references';
			ct.Scenario__c = 'Scenario Test';
			insert ct;
			
			Flow_Type__c ft = new Flow_Type__c();
			ft.Flow_Number__c = 'MI';
			insert ft;
			
			Stage__c stage1 = new Stage__c();
			stage1.Name = 'Test Stage 1';
			stage1.Flow_Type__c = ft.Id;
			stage1.Description__c = 'Test Description 1';
			stage1.Predecessor__c = null;
			stage1.Maxim_Duration__c = 3;
			stage1.Send_notification_email__c = false;
			stage1.Assigned_to__c = UserInfo.getUserId();
			stage1.Priority__c = 'Low';
			stage1.Subject__c = 'Test Subject 1';
			stage1.CadFor__c = true;
			insert stage1;
			
			Group__c grupo = new Group__c( Name = 'Test Group' );
			insert grupo;
			
			Group_Member__c gm = new Group_Member__c();
			gm.Group__c = grupo.Id;
			gm.User__c = UserInfo.getUserId();
			gm.Group_Leader__c = true;
			insert gm;
			Test.startTest();
			gm = new Group_Member__c();
			gm.Group__c = grupo.Id;
			gm.User__c = [ Select Id From User Where Id != :UserInfo.getUserId() and isActive = true limit 1 ].Id;
			gm.Group_Leader__c = false;
			insert gm;
			
			grupo.Active__c = true;
			//update grupo;
			
			
			
			Stage__c stage2 = new Stage__c();
			stage2.Name = 'Test Stage 2';
			stage2.Flow_Type__c = ft.Id;
			stage2.Description__c = 'Test Description 2';
			stage2.Predecessor__c = null;
			stage2.Maxim_Duration__c = 3;
			stage2.Send_notification_email__c = true;
			stage2.Group__c = grupo.Id;
			stage2.Priority__c = 'Low';
			stage2.Subject__c = 'Test Subject 2';
			insert stage2;
			
			
			
			Stage__c stage31 = new Stage__c();
			stage31.Name = 'Test Stage 31';
			stage31.Flow_Type__c = ft.Id;
			stage31.Description__c = 'Test Description 31';
			stage31.Predecessor__c = stage1.Id;
			stage31.Maxim_Duration__c = 3;
			stage31.Send_notification_email__c = false;
			stage31.Group__c = grupo.Id;
			stage31.Priority__c = 'Low';
			stage31.Subject__c = 'Test Subject 31';
			stage31.Depends_on_subcase_seriousness__c = true;
			insert stage31;
			
			Stage__c stage3 = new Stage__c();
			stage3.Name = 'Test Stage 3';
			stage3.Flow_Type__c = ft.Id;
			stage3.Description__c = 'Test Description 3';
			stage3.Predecessor__c = stage2.Id;
			stage3.Maxim_Duration__c = 3;
			stage3.Send_notification_email__c = false;
			stage3.Group__c = grupo.Id;
			stage3.Priority__c = 'Low';
			stage3.Subject__c = 'Test Subject 3';
			insert stage3;
			
			Stage__c stage4 = new Stage__c();
			stage4.Name = 'Test Stage 4';
			stage4.Flow_Type__c = ft.Id;
			stage4.Description__c = 'Test Description 4';
			stage4.Predecessor__c = stage3.Id;
			stage4.Maxim_Duration__c = 3;
			stage4.Send_notification_email__c = false;
			stage4.Assigned_to__c = UserInfo.getUserId();
			stage4.Priority__c = 'Low';
			stage4.Subject__c = 'Test Subject 4';
			insert stage4;
			
			Case subcase = new Case();
			subcase.ContactId = contact.Id;
			subcase.AccountId = Account.Id;
			subcase.Status = 'Open';
			subcase.Origin = 'Email';
			subcase.RecordTypeId = rtSubcase.Id;
			subcase.ParentId = caso.Id;
			subcase.Case_Type__c = ct.Id;
			subcase.Flow_Type__c = ft.Id;
			insert subcase;
			
			//Test.startTest();
			
			Safety_Individual_Report__c sir = new Safety_Individual_Report__c();
			sir.Receipt_date_of_report__c = date.newInstance(2009, 04, 01);
			sir.Second_level_description__c = 'descrinao'; 
			sir.Hospitalized__c = 'Não';
			sir.Reporter_allow_us_to_contact_physician__c = 'Yes';
			sir.Reporter_allow_us_to_share_the_data__c = 'Yes';	
			sir.Subcase_seriousness__c = 'serious';
			sir.Subcase_Number__c = subcase.Id;
			sir.PV_system_number_Sina__c = '1236';
			insert sir;
			
			
			
			//System.assertEquals( 2, [ Select Count() From Task Where WhatId = :subcase.Id ] );
			List<String> lstOldTask = new List<String>();
			Task TestTask = [ Select Id, Status From Task Where WhatId = :subcase.Id and Subject = 'Test Subject 1' limit 1 ];
			
			//lstOldTask.add( TestTask.Id );
			//TestTask.Status = 'Closed';
			//update TestTask;
			
			
			
			//Comprobar funcionalidad ed Cad_For
			System.assertEquals( true, [ Select isClosed From Task Where Id = :TestTask.Id ].isClosed );
			System.assertEquals( 2, [ Select Count() From Task Where WhatId = :subcase.Id and isClosed = false ] );
			
			TestTask = [ Select Id, Status From Task Where WhatId = :subcase.Id and Subject = 'Test Subject 31' limit 1 ];
			TestTask.Status = 'Closed';
			lstOldTask.add( TestTask.Id );
			FlowType_Tools_cls.setBlnEjecutarTriggerTaskWorkFlow_tgr( true );
			update TestTask;
			
			/*
			TestTask = [ Select Id, Status From Task Where WhatId = :subcase.Id and Subject = 'Test Subject 2' limit 1 ];
			TestTask.Status = 'Closed';
			lstOldTask.add( TestTask.Id );
			FlowType_Tools_cls.setBlnEjecutarTriggerTaskWorkFlow_tgr( true );
			update TestTask;
			
			System.assertEquals( true, [ Select isClosed From Task Where Id = :TestTask.Id ].isClosed );
			//System.debug( '??????? ' + [ Select isClosed, Description__c, WhatId, StageId__c, Subject, Status, Priority, IsReminderSet, ActivityDate From Task Where WhatId = :subcase.Id and isClosed = false] );
			//System.assertEquals( 1, [ Select Count() From Task Where WhatId = :subcase.Id and isClosed = false] );
			
			TestTask = [ Select Id, Status From Task Where WhatId = :subcase.Id and Subject = 'Test Subject 3' limit 1 ];
			TestTask.Status = 'Closed';
			lstOldTask.add( TestTask.Id );
			FlowType_Tools_cls.setBlnEjecutarTriggerTaskWorkFlow_tgr( true );
			update TestTask;
			
			System.assertEquals( true, [ Select isClosed From Task Where Id = :TestTask.Id ].isClosed );
			//System.assertEquals( 1, [ Select Count() From Task Where WhatId = :subcase.Id and isClosed = false ] );
			
			TestTask = [ Select Id, Status From Task Where WhatId = :subcase.Id and Subject = 'Test Subject 4' limit 1 ];
			TestTask.Status = 'Closed';
			lstOldTask.add( TestTask.Id );
			FlowType_Tools_cls.setBlnEjecutarTriggerTaskWorkFlow_tgr( true );
			update TestTask;
			
			System.assertEquals( true, [ Select isClosed From Task Where Id = :TestTask.Id ].isClosed );
			//System.assertEquals( 0, [ Select Count() From Task Where Status != 'Closed' and WhatId = :subcase.Id ] );
			///*
			
			Test.stopTest();
		}
		
		
	}
	
	static testMethod void createSubCase1() 
	{
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
		caseType = MockObject.getCaseType(caseType.id);
		
		RecordType rtCase    = MockObject.getRecordType('Case');
		RecordType rtSubcase = MockObject.getRecordType('Subcase');
		RecordType rTPersonAccount = MockObject.getRecordType('Person Account');
		
		List<RecordType> lstRecordType = [ Select Id, Name From RecordType Where Name = 'Case' or Name = 'Subcase' order by Name ];
		System.debug( '*-*----* lstRecordType: ' + lstRecordType );
		if( lstRecordType.size() == 2 )
		{
						
			Case caso = new Case();
			caso.AccountId = account.Id;
			caso.ContactId = contact.Id;
			caso.Flow_Type__c = flowType.Id; 
			caso.Status = 'Open';
			caso.Origin = 'Email';
			caso.RecordTypeId = rtCase.Id;
			insert caso;
			
			//If a case record is created with recordtype "Case" no Taks has to be created.
			System.assertEquals( 0, [ Select Count() From Task Where WhatId = :caso.Id ] );
			
			Case_Type__c ct = new Case_Type__c();
			ct.Name = 'Case Type Test';
			ct.Subcase_type__c = 'Suggestion';
			ct.Subcase_subtype__c = 'Request User';
			ct.Script__c = 'Script Test';
			ct.Theme__c = 'Several references';
			ct.Scenario__c = 'Scenario Test';
			insert ct;
			
			Flow_Type__c ft = new Flow_Type__c();
			ft.Flow_Number__c = 'MI';
			insert ft;
			
			Stage__c stage1 = new Stage__c();
			stage1.Name = 'Test Stage 1';
			stage1.Flow_Type__c = ft.Id;
			stage1.Description__c = 'Test Description 1';
			stage1.Predecessor__c = null;
			stage1.Maxim_Duration__c = 3;
			stage1.Send_notification_email__c = false;
			stage1.Assigned_to__c = UserInfo.getUserId();
			stage1.Priority__c = 'Low';
			stage1.Subject__c = 'Test Subject 1';
			insert stage1;
			
			Group__c grupo = new Group__c( Name = 'Test Group' );
			insert grupo;
			
			Group_Member__c gm = new Group_Member__c();
			gm.Group__c = grupo.Id;
			gm.User__c = UserInfo.getUserId();
			gm.Group_Leader__c = true;
			insert gm;
			
			gm = new Group_Member__c();
			gm.Group__c = grupo.Id;
			gm.User__c = [ Select Id From User Where Id != :UserInfo.getUserId() and isActive = true limit 1 ].Id;
			gm.Group_Leader__c = false;
			insert gm;
			
			grupo.Active__c = true;
			update grupo;
			
			Stage__c stage2 = new Stage__c();
			stage2.Name = 'Test Stage 2';
			stage2.Flow_Type__c = ft.Id;
			stage2.Description__c = 'Test Description 2';
			stage2.Predecessor__c = null;
			stage2.Maxim_Duration__c = 3;
			stage2.Send_notification_email__c = true;
			stage2.Group__c = grupo.Id;
			stage2.Priority__c = 'Low';
			stage2.Subject__c = 'Test Subject 2';
			stage2.CadFor__c = true;
			insert stage2;
			
			Stage__c stage3 = new Stage__c();
			stage3.Name = 'Test Stage 3';
			stage3.Flow_Type__c = ft.Id;
			stage3.Description__c = 'Test Description 3';
			stage3.Predecessor__c = stage2.Id;
			stage3.Maxim_Duration__c = 3;
			stage3.Send_notification_email__c = false;
			stage3.Group__c = grupo.Id;
			stage3.Priority__c = 'Low';
			stage3.Subject__c = 'Test Subject 3';
			insert stage3;
			
			Stage__c stage4 = new Stage__c();
			stage4.Name = 'Test Stage 4';
			stage4.Flow_Type__c = ft.Id;
			stage4.Description__c = 'Test Description 4';
			stage4.Predecessor__c = stage3.Id;
			stage4.Maxim_Duration__c = 3;
			stage4.Send_notification_email__c = false;
			stage4.Assigned_to__c = UserInfo.getUserId();
			stage4.Priority__c = 'Low';
			stage4.Subject__c = 'Test Subject 4';
			stage4.Depends_on_subcase_seriousness__c = true;
			insert stage4;
			
			Case subcase = new Case();
			subcase.Status = 'Open';
			subcase.Origin = 'Email';
			subcase.RecordTypeId = lstRecordType[1].Id;
			subcase.ParentId = caso.Id;
			subcase.Case_Type__c = ct.Id;
			subcase.Flow_Type__c = ft.Id;
			subcase.Receipt_date_of_report__c = System.today();
			insert subcase;
						
			Safety_Individual_Report__c sir = new Safety_Individual_Report__c();
			sir.Receipt_date_of_report__c = date.newInstance(2009, 04, 01);
			sir.Second_level_description__c = 'descrinao'; 
			sir.Hospitalized__c = 'Não';
			sir.Reporter_allow_us_to_contact_physician__c = 'Yes';
			sir.Reporter_allow_us_to_share_the_data__c = 'Yes';	
			sir.Subcase_seriousness__c = 'serious';
			sir.Subcase_Number__c = subcase.Id;
			sir.PV_system_number_Sina__c = '1236';
			insert sir;
			
			Test.startTest();
			
			List<String> lstOldTask = new List<String>();
			Task TestTask = [ Select Id, Status From Task Where WhatId = :subcase.Id and Subject = 'Test Subject 2' limit 1 ];
			
			//Comprobar funcionalidad ed Cad_For
			System.assertEquals( true, [ Select isClosed From Task Where Id = :TestTask.Id ].isClosed );
			//System.assertEquals( 2, [ Select Count() From Task Where WhatId = :subcase.Id and isClosed = false ] );
			
			TestTask = [ Select Id, Status From Task Where WhatId = :subcase.Id and Subject = 'Test Subject 1' limit 1 ];
			TestTask.Status = 'Closed';
			lstOldTask.add( TestTask.Id );
			FlowType_Tools_cls.setBlnEjecutarTriggerTaskWorkFlow_tgr( true );
			update TestTask;
			
			Test.stopTest();
		}
	}
	*/
	static testMethod void createSubCase2() 
	{
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
		caseType = MockObject.getCaseType(caseType.id);
		
		RecordType rtCase    = MockObject.getRecordType('Case');
		RecordType rtSubcase = MockObject.getRecordType('Subcase');
		RecordType rTPersonAccount = MockObject.getRecordType('Person Account');
		
		List<RecordType> lstRecordType = [ Select Id, Name From RecordType Where Name = 'Case' or Name = 'Subcase' order by Name ];
		System.debug( '*-*----* lstRecordType: ' + lstRecordType );
		
		if( lstRecordType.size() == 2 )
		{
			
			
			Case caso = new Case();
			caso.AccountId = account.Id;
			caso.ContactId = contact.Id;
			caso.Flow_Type__c = flowType.Id;
			caso.Case_Type__c = caseType.Id;
			caso.Status = 'Open';
			caso.Origin = 'Email';
			caso.RecordTypeId = lstRecordType[0].Id;
			insert caso;
			
			//If a case record is created with recordtype "Case" no Taks has to be created.
			//System.assertEquals( 0, [ Select Count() From Task Where WhatId = :caso.Id ] );
			
			
			
			Case_Type__c ct = new Case_Type__c();
			ct.Name = 'Case Type Test';
			ct.Subcase_type__c = 'Suggestion';
			ct.Subcase_subtype__c = 'Request User';
			ct.Script__c = 'Script Test';
			ct.Theme__c = 'Several references';
			ct.Scenario__c = 'Scenario Test';
			insert ct;
			
			Flow_Type__c ft = new Flow_Type__c();
			ft.Flow_Number__c = 'MI';
			insert ft;
			
			
			
						
			Stage__c stage1 = new Stage__c();
			stage1.Name = 'Test Stage 1';
			stage1.Flow_Type__c = ft.Id;
			stage1.Description__c = 'Test Description 1';
			stage1.Predecessor__c = null;
			stage1.Maxim_Duration__c = 3;
			stage1.Send_notification_email__c = false;
			stage1.Assigned_to__c = UserInfo.getUserId();
			stage1.Priority__c = 'Low';
			stage1.Subject__c = 'Test Subject 1';
			stage1.CadFor__c = true;
			insert stage1;
			
			Group__c grupo = new Group__c( Name = 'Test Group' );
			insert grupo;
			
			Group_Member__c gm = new Group_Member__c();
			gm.Group__c = grupo.Id;
			gm.User__c = UserInfo.getUserId();
			gm.Group_Leader__c = true;
			insert gm;
			
			gm = new Group_Member__c();
			gm.Group__c = grupo.Id;
			gm.User__c = [ Select Id From User Where Id != :UserInfo.getUserId() and isActive = true limit 1 ].Id;
			gm.Group_Leader__c = false;
			insert gm;
			
			
			
			grupo.Active__c = true;
			update grupo;
			
			Stage__c stage2 = new Stage__c();
			stage2.Name = 'Test Stage 2';
			stage2.Flow_Type__c = ft.Id;
			stage2.Description__c = 'Test Description 2';
			stage2.Predecessor__c = null;
			stage2.Maxim_Duration__c = 3;
			stage2.Send_notification_email__c = true;
			stage2.Group__c = grupo.Id;
			stage2.Priority__c = 'Low';
			stage2.Subject__c = 'Test Subject 2';
			insert stage2;
			
			
			
			Stage__c stage3 = new Stage__c();
			stage3.Name = 'Test Stage 3';
			stage3.Flow_Type__c = ft.Id;
			stage3.Description__c = 'Test Description 3';
			stage3.Predecessor__c = stage2.Id;
			stage3.Maxim_Duration__c = 3;
			stage3.Send_notification_email__c = false;
			stage3.Group__c = grupo.Id;
			stage3.Priority__c = 'Low';
			stage3.Subject__c = 'Test Subject 3';
			insert stage3;
			
			Stage__c stage4 = new Stage__c();
			stage4.Name = 'Test Stage 4';
			stage4.Flow_Type__c = ft.Id;
			stage4.Description__c = 'Test Description 4';
			stage4.Predecessor__c = stage3.Id;
			stage4.Maxim_Duration__c = 3;
			stage4.Send_notification_email__c = false;
			stage4.Assigned_to__c = UserInfo.getUserId();
			stage4.Priority__c = 'Low';
			stage4.Subject__c = 'Test Subject 4';
			stage4.Depends_on_subcase_seriousness__c = true;
			insert stage4;
			
				
			
			Case subcase = new Case();
			subcase.Status = 'Open';
			subcase.Origin = 'Email';
			subcase.RecordTypeId = lstRecordType[1].Id;
			subcase.ParentId = caso.Id;
			subcase.Case_Type__c = ct.Id;
			subcase.Flow_Type__c = ft.Id;
			subcase.Receipt_date_of_report__c = System.today();
			insert subcase;
			
			Test.startTest();
			
			Safety_Individual_Report__c sir = new Safety_Individual_Report__c();
			sir.Receipt_date_of_report__c = date.newInstance(2009, 04, 01);
			sir.Second_level_description__c = 'descrinao'; 
			sir.Hospitalized__c = 'Não';
			sir.Reporter_allow_us_to_contact_physician__c = 'Yes';
			sir.Reporter_allow_us_to_share_the_data__c = 'Yes';	
			sir.Subcase_seriousness__c = 'serious';
			sir.Subcase_Number__c = subcase.Id;
			sir.PV_system_number_Sina__c = '1236';
			insert sir;
			
						
			//System.assertEquals( 2, [ Select Count() From Task Where WhatId = :subcase.Id ] );
			List<String> lstOldTask = new List<String>();
			Task TestTask = [ Select Id, Status From Task Where WhatId = :subcase.Id and Subject = 'Test Subject 1' limit 1 ];
			/*lstOldTask.add( TestTask.Id );
			TestTask.Status = 'Closed';
			update TestTask;*/
			//Comprobar funcionalidad ed Cad_For
			//System.assertEquals( true, [ Select isClosed From Task Where Id = :TestTask.Id ].isClosed );
			//System.assertEquals( 2, [ Select Count() From Task Where WhatId = :subcase.Id and isClosed = false ] );
			
			TestTask = [ Select Id, Status From Task Where WhatId = :subcase.Id and Subject = 'Test Subject 2' limit 1 ];
			
			
			
			TestTask.Status = 'Canceled';
			TestTask.Justification__c = 'isTest';
			lstOldTask.add( TestTask.Id );
			FlowType_Tools_cls.setBlnEjecutarTriggerTaskWorkFlow_tgr( true );
			update TestTask;
			
			
			
			Test.stopTest();
		}
		
		
	}
}