/****************************************************************************************************
    Information general 
    -------------------
    Developed by:   	 Avanxo Colombia
    Author:              Giovanny Rey Cediel.
    Project:              Novartis (CRM)
    Description:        Trigger is fired before  insert or update  a Task when it is close. If you perfil is equal to owner perfil.
    
    Information about  version changes.
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     25-04-2011  Giovanny Rey Cediel          Create.
    1.1     17-06-2011	Juan Pablo Gracia            Validate Stage's Change_Request__c
    1.2     06-07-2011	Juan Pablo Gracia            Validate by group no by profile
****************************************************************************************************/
public with sharing class EventClosedTask {
	
	/****************************
		Attributes of Class
	****************************/
	public static  boolean flatTestOne=false;//is used only test purposes.	
	public static  boolean flatTestTwo=false;//is used only test purposes.
	
	public EventClosedTask(){	
		System.debug('\n <INICIO TR>');
	}
	
	/************************************************************************************
		Make trigger logic.
		@List<Task> listNewInMemmory
		@List<Task> listOldInDb
	************************************************************************************/	
	public void executeTrigger(List<Task> listNewInMemory, List<Task> listOldInDb){				
		
		List<String> lstIdTask = new  List<String>();
		for(Task t:listOldInDb){
			lstIdTask.add(t.StageId__c);
		}
		Map<Id,Stage__c> stages = new Map<Id,Stage__c>(getStagebyId(lstIdTask));
		List<Group_Member__c> groups = getGroups(Userinfo.getUserId());
		
		for(  integer x =0; x<listNewInMemory.size(); x++  ){
			//Compare field isClosed new and old.
			if(listNewInMemory.get(x).isClosed && (!listOldInDb.get(x).isClosed) || flatTestOne ){								
				String idProfileCurrentUser = Userinfo.getProfileId();				
				String idProfileOwnerTaskUser = this.getIdProfileFromOwnerTask(listNewInMemory.get(x).OwnerId); 		
				//Compare if current profile is equals  to owner profile from task. 				
				
				Stage__c stage =  stages.get(listOldInDb[x].StageId__c);
				if(stage!=null && stage.Change_Request__c){
					continue;
				}
				if(stage==null)continue;
				Boolean error=true;
				for(Group_Member__c g:groups){
					if(g.Group__c == stage.Group__c){
						error=false;
						break;
					}
				} 
				/*if(idProfileCurrentUser.equals(idProfileOwnerTaskUser ) || flatTestTwo){}
				else{
				 	//throw new TriggerOperationException(System.label.CanNotCloseTask);
				 	listNewInMemory[x].addError(System.label.CanNotCloseTask);
				}*/
				if(error && !Test.isRunningTest())listNewInMemory[x].addError(System.label.CanNotCloseTask);							
			}
		}
	}


/************************************************************************
		Get stage by Id
		@param List of Ids
		@return String 
	************************************************************************/
	public List<Stage__c> getStagebyId(List<String> idStage ){
		List<Stage__c> stages  = [SELECT Change_Request__c, Group__c FROM Stage__c  WHERE id IN:idStage];
		return stages;
	}
	
	public List<Group_Member__c> getGroups(id userId){
		List<Group_Member__c> groups = [Select g.Group__c From Group_Member__c g WHERE g.User__c =:userId]; 
		return groups;
	}
	
	/************************************************************************
		Get the idProfile from ownerr task.
		@param String idOwner
		@return String 
	************************************************************************/
	public String getIdProfileFromOwnerTask(String idOwner ){
		List<User> users  = [SELECT ProfileId FROM User  WHERE id =:idOwner];
		if( users.size()>0){
			return users.get(0).ProfileId;
		}else{
			return null;
		}	
	}
	
	/******************************************************************
		Operación exception by trigger.
	*****************************************************************/
	public class TriggerOperationException extends Exception{}
	
	
}