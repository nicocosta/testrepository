/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Daniel Delgado (DFDC)
	Project:			Novartis Brazil
	Description: 		General methods to be used by all Flow Types classes, triggers, etc. 
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		14-09-2010	Daniel Delgado (DFDC)		Create class.
	****************************************************************************************************/
public class FlowType_Tools_cls
{
	public static Boolean blnEjecutarTriggerTaskWorkFlow_tgr = true;
	public static Boolean blnEjecutarTriggerTraductionTask_tgr = true;
	
	public static Boolean getBlnEjecutarTriggerTaskWorkFlow_tgr()
	{
		return blnEjecutarTriggerTaskWorkFlow_tgr;
	}
	
	public static void setBlnEjecutarTriggerTaskWorkFlow_tgr( Boolean newBoolean )
	{
		blnEjecutarTriggerTaskWorkFlow_tgr = newBoolean;
	}
	
	public static Boolean getBlnEjecutarTriggerTraductionTask_tgr()
	{
		return blnEjecutarTriggerTraductionTask_tgr;
	}
	
	public static void setBlnEjecutarTriggerTraductionTask_tgr( Boolean newBoolean )
	{
		blnEjecutarTriggerTraductionTask_tgr = newBoolean;
	}
	
	/**
	*	This methods send email notifications to all users assigned to the Tasks created by 
	*	Flow Type functionality. If the Stage's especification referes to Groups, then all
	*	Group Members will be notified too.
	*	@param	lstTask	|	Task's list created
	*	@return void
	*	@authors: DFDC
	*/
	public static void SendEmailNotification( List<Task> lstTask )
	{
		Set<String> setStageId = new Set<String>();
		Map<String, FTS__c> mapFTS = FTS__c.getAll();
		Map<String, List<String>> mapLstStageByUserId = new Map<String, List<String>>();
		Map<String, List<String>> mapLstStageByGroupId = new Map<String, List<String>>();
		Map<String, List<User>> mapLstUsersByStage = new Map<String, List<User>>();
		
		//List of all Stages id related to each Task
		for( Task t : lstTask )
		{
			setStageId.add( t.StageId__c );
		}
		
		//Search for all Stages that required Email Notification.
		for( Stage__c stage : [	Select	Id, Group__c, Assigned_to__c
								From	Stage__c
								Where	id IN :setStageId and Send_notification_email__c = true and ( Group__c <> null
										or Assigned_to__c <> null ) ] )
		{
			//List of Stages By Group Id
			if( stage.Group__c != null )
			{
				if( mapLstStageByGroupId.containsKey( stage.Group__c ) )
					mapLstStageByGroupId.get( stage.Group__c ).add( stage.Id );
				else
					mapLstStageByGroupId.put( stage.Group__c, new List<String> { stage.Id } );
			}
			//List of Stages By Users Id
			else
			{
				if( mapLstStageByUserId.containsKey( stage.Assigned_to__c ) )
					mapLstStageByUserId.get( stage.Assigned_to__c ).add( stage.Id );
				else
					mapLstStageByUserId.put( stage.Assigned_to__c, new List<String> { stage.Id } );
			}
		}

		System.debug( '*-*-*-* lstTask: ' + lstTask );
		System.debug( '*-*-*-* setStageId: ' + setStageId );
		System.debug( '*-*-*-* mapLstStageByGroupId: ' + mapLstStageByGroupId );
		System.debug( '*-*-*-* mapLstStageByUserId: ' + mapLstStageByUserId );
		
		//Search for all Users related to each Group.
		for( Group_Member__c gm : [ Select User__c, Group__c From Group_Member__c Where Group__c IN :mapLstStageByGroupId.keySet() ] )
		{
			if( !mapLstStageByUserId.containsKey( gm.User__c ) )
				mapLstStageByUserId.put( gm.User__c, new List<String>() );
			
			mapLstStageByUserId.get( gm.User__c ).addAll( mapLstStageByGroupId.get( gm.Group__c ) );
		}
		
		System.debug( '*-*-*-* mapLstStageByUserId: ' + mapLstStageByUserId );
		
		//Search for User information.
		for( User usr : [ Select Id, Name, Email From User Where id IN :mapLstStageByUserId.keySet() and Email != null ] )
		{
			for( String strStage : mapLstStageByUserId.get( usr.Id ) )
			{
				if( mapLstUsersByStage.containsKey( strStage ) )
					mapLstUsersByStage.get( strStage ).add( usr );
				else
					mapLstUsersByStage.put( strStage, new List<User> { usr } );
			}
		}
		
		System.debug( '*-*-*-* mapLstUsersByStage: ' + mapLstUsersByStage );
		
		//Create and send emails to each user.
		for( Task t : lstTask )
		{
			if( mapLstUsersByStage.containsKey( t.StageId__c ) )
			{
				for( User usr : mapLstUsersByStage.get( t.StageId__c ) )
				{
					try
					{
						Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
						String[] toAddresses = new String[] { usr.Email };
						mail.setToAddresses( toAddresses );
						mail.setSubject( System.Label.New_Task + ': ' + t.Subject );
						String strEnter = '<br></br>';
						String strBody = '<strong>' + usr.Name + '</strong>, ' + System.Label.New_Task_Notification_Header + ':';
						strBody += strEnter + strEnter;
						strBody += System.Label.Subject + ': ' + t.Subject + strEnter;
						Datetime dt = Datetime.newInstance( t.ActivityDate.year(), t.ActivityDate.month(), t.ActivityDate.day() );
						strBody += System.Label.Due_Date + ': ' + dt.format( 'yyyy-MM-dd' ) + strEnter;
						strBody += System.Label.Priority + ': ' + t.Priority + strEnter;
						strBody += System.Label.Comments + ': ' + t.Description__c + strEnter + strEnter;
						strBody += System.Label.For_more_details + ':' + strEnter + strEnter;
						if( mapFTS.containsKey( 'SFDC Address' ) )
						{
							String strURL = '' + mapFTS.get( 'SFDC Address' ).value__c + t.Id;
							strBody += '<a href="' + strURL + '" target="_blank">' + strURL + '</a>';
						}
						mail.setHtmlBody( strBody );
						Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
					}
					catch( System.exception e )
					{}
				}
			}
		}
	}
}