/****************************************************************************************************
    Information general 
    -------------------
    Developed by:        Avanxo Colombia
    Author:              Juan Gabriel Duarte Pacheco
    Project:             Novartis (CRM)
    Description:         Trigger is fired before update a Task. Validates that user can modify the task.
    
    Information about  version changes.
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     30-08-2012  Juan Gabriel Duarte P.          Create.
****************************************************************************************************/

public class ValidateUpdateTask {
    
    public void executeLogic(List<Task> lstNewDat, List<Task> lstOldDat)
    {
        if(lstNewDat!=null)
        {
            if(lstNewDat.size() == 1)
            {   
                Task objTask = lstNewDat[0];                
                //Si la tarea tiene asociado un grupo, solo los usuario miembros del grupo pueden modificarla. También se valida que no tenga asociado un CHR activo    
                if( objTask.Group_Id__c != null && objTask.StageId__c != null )
                {
                    if( !isAMemberOf(objTask.Group_Id__c) && !haveCHR(objTask.StageId__c) )
                        objTask.addError(System.label.ValidateModifyTaskForGroup);
                    else
                        return;
                }
                else if(objTask.Group_Id__c != null)
                {
                	 if( !isAMemberOf(objTask.Group_Id__c) )
                        objTask.addError(System.label.ValidateModifyTaskForGroup);
                }
                else//De los contrario, solo el usuario propietario (Assigned To) puede hacerlo.
                {
                    if( objTask.OwnerId != Userinfo.getUserId() )
                        objTask.addError(System.label.ValidateModifyTask);
                    else
                        return; 
                }               
            }            
        }
    }
    
    //Método encargado de validar que el usuario que intenta modificar la tarea pertenezca al grupo asociado a la tarea.
    public Boolean isAMemberOf(String idGroup)
    {
        Boolean blnIsMember = false;
        List<Group_Member__c> lstGM = [SELECT Id FROM Group_Member__c WHERE Group__c =:idGroup and User__c =:Userinfo.getUserId() ];
        if(!lstGM.isEmpty())
            blnIsMember = true;
        return blnIsMember; 
    }
    
    //Validar que no tenga CHR
    public Boolean haveCHR(String idStage)
    {
        Boolean blnCHR = false;       
        List<Stage__c> lstStage = [SELECT Change_Request__c FROM Stage__c Where Id =:idStage];
        if(!lstStage.isEmpty())
        {
            if(lstStage.get(0).Change_Request__c == true) blnCHR = true;
        }                         
        return blnCHR;
    }
}