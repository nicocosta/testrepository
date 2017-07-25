/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Pablo Gracia
	Project:			Novartis Brazil
	Description: 		Logic of Assign Task Trigger
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		22-11-2011	Juan Pablo Gracia			Create class.
	****************************************************************************************************/
public class AssignTask {
	public void AssignTask(List<Task> lstNewTask, List<Task> lstOldTask){
		List<String> lstGroups = new List<String>();
		List<Task> lstTaskUpdate = new List<Task>();
		integer i=0;
		for(Task tsk:lstNewTask){
			if(tsk.Group_Id__c!=null){
				if(lstOldTask!=null && lstOldTask.size()>0){
					if(lstOldTask[i].Group_Id__c != tsk.Group_Id__c){
						lstGroups.add(tsk.Group_Id__c);
						lstTaskUpdate.add(tsk);
					}
				}else{
					lstGroups.add(tsk.Group_Id__c);	
					lstTaskUpdate.add(tsk);
				}
			}
			i++;
		}
		Map<Id,Group__c> groupMap = new Map<Id,Group__c>([Select g.Name, 
																(Select User__r.Id From Group_Members__r WHERE Group_Leader__c=true LIMIT 1) 
														  From Group__c g 
														  Where id =:lstGroups]);
		for(Task tsk:lstTaskUpdate){
			if(tsk.Group_Id__c!=null){
				Group__c groupObj = groupMap.get(tsk.Group_Id__c);
				if(groupObj!=null && groupObj.Group_Members__r.size()>0){
					tsk.OwnerId = groupObj.Group_Members__r[0].User__r.Id;
				}
				if(groupObj!=null){
					tsk.Group_Name__c = groupObj.Name;
				}
			}
		}
	}
}