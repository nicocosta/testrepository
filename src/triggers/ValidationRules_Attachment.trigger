/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Daniel Delgado (DFDC)
	Project:			Novartis Brazil
	Description: 		Validation Rules for Attachment. None user can delete Attachments. 
						For inserts and updates:
							* If the related case is closed only FV profiles can create and edit.
							* If the related case is open, the system will find all open tasks created
							  by task flow and related to the case. Then will check for the Validate
							  Comments functionallity in the Stage
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		09-03-2011	Daniel Delgado (DFDC)		Trigger creation.
	****************************************************************************************************/
trigger ValidationRules_Attachment on Attachment (after insert, after update, before delete)
{
	if( Trigger.isDelete )
	{
		for( Attachment cc : Trigger.old )
		{
			String strId = cc.ParentId;
			if( strId.startsWith( '500' ) || strId.startsWith( 'a0a' ) )
				cc.addError( System.label.Cannot_Delete_record );
		}
	}
	else if( Trigger.isInsert || Trigger.isUpdate )
	{
		Map<String, List<Attachment>> lstAttachmentsByCaseId = new Map<String, List<Attachment>>();
		Map<String, List<Attachment>> lstAttachmentsByStageId = new Map<String, List<Attachment>>();
		Set<String> setAttachmentIdOk = new Set<String>();
		Set<String> setAttachmentIdAddError = new Set<String>();
		String fvProfileId = FV_Setup__c.getInstance().FV_Profile_Id__c;
		fvProfileId = fvProfileId.subString( 0, 15 );
		String strProfileName = [ Select Name From Profile Where Id = :Userinfo.getProfileId() ].Name;
		
		System.debug( 'Id Perfil FV: ' + fvProfileId );
		System.debug( 'Nombre Perfil del Usuario: ' + strProfileName );
		System.debug( 'Map inicial: ' + Trigger.newMap );
		
		for( Attachment cc : Trigger.new )
		{
			String strId = cc.ParentId;
			if( strId.startsWith( '500' ) )
			{
				List<Attachment> lstTemp = new List<Attachment>{ cc };
				if( lstAttachmentsByCaseId.containsKey( cc.ParentId ) )
					lstTemp.addAll( lstAttachmentsByCaseId.get( cc.ParentId ) );
				lstAttachmentsByCaseId.put( cc.ParentId, lstTemp );
			}
		}
		
		System.debug( 'lstAttachmentsByCaseId: ' + lstAttachmentsByCaseId );
		
		for( Case c : [ Select isClosed, Id From Case Where Id IN :lstAttachmentsByCaseId.keySet() ] )
		{
			if( c.isClosed && Userinfo.getProfileId().substring( 0, 15 ) == fvProfileId )
				lstAttachmentsByCaseId.remove( c.Id );
			else if( c.isClosed && Userinfo.getProfileId().substring( 0, 15 ) != fvProfileId )
			{
				for( Attachment cc : lstAttachmentsByCaseId.get( c.Id ) )
					cc.addError( System.label.Cannot_Edit_Record_Closed_Case );
				lstAttachmentsByCaseId.remove( c.Id );
			}
		}
		
		System.debug( 'lstAttachmentsByCaseId: ' + lstAttachmentsByCaseId );
		
		for( Task t : [	Select	StageId__c, WhatId
						From	Task
						Where	WhatId IN :lstAttachmentsByCaseId.keySet() 
								and IsClosed = false
								and StageId__c <> null ] )
		{
			List<Attachment> lstTemp = lstAttachmentsByCaseId.get( t.WhatId );
			if( lstAttachmentsByStageId.containsKey( t.StageId__c ) )
				lstTemp.addAll( lstAttachmentsByStageId.get( t.StageId__c ) );
			lstAttachmentsByStageId.put( t.StageId__c, lstTemp );
		}
		
		System.debug( 'lstAttachmentsByStageId: ' + lstAttachmentsByStageId );
		
		for( Stage__c stg : [	Select	Id, Validate_Comments__c, Users_profiles__c
								From	Stage__c
								Where	Id IN :lstAttachmentsByStageId.keySet() ] )
		{
			System.debug( 'stg.Validate_Comments__c: ' + stg.Validate_Comments__c );
			if( stg.Validate_Comments__c )
			{
				Set<String> setProfileNames = new Set<String>();
				
				System.debug('******stg:' + stg);
				System.debug('******stg.Users_profiles__c:' + stg.Users_profiles__c);
				
				List<String> lstProfilesTemp = stg.Users_profiles__c.split( ';' );
				setProfileNames.addAll( lstProfilesTemp );
				System.debug( 'setProfileNames: ' + setProfileNames );
				System.debug( 'strProfileName: ' + strProfileName );
				System.debug( 'setProfileNames.contains( strProfileName ): ' + setProfileNames.contains( strProfileName ) );
				if( !setProfileNames.contains( strProfileName ) )
				{
					for( Attachment cc : lstAttachmentsByStageId.get( stg.Id ) )
					{
						if( !setAttachmentIdOk.contains( cc.Id ) )
							setAttachmentIdAddError.add( cc.Id );
					}
				}
				else
				{
					for( Attachment cc : lstAttachmentsByStageId.get( stg.Id ) )
					{
						if( setAttachmentIdAddError.contains( cc.Id ) )
							setAttachmentIdAddError.remove( cc.Id );
						setAttachmentIdOk.add( cc.Id );
					}
				}
			}
			else
			{
				for( Attachment cc : lstAttachmentsByStageId.get( stg.Id ) )
				{
					if( !setAttachmentIdAddError.contains( cc.Id ) )
						setAttachmentIdAddError.remove( cc.Id );
					setAttachmentIdOk.add( cc.Id );
				}
			}
		}
		
		for( String strKey : setAttachmentIdAddError )
		{
			Attachment cc = Trigger.newMap.get( strKey );
			cc.addError( System.label.Cannot_Create_Edit_Record );
		}
	}
}