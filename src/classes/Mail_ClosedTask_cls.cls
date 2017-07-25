/**                                                     
* ===================================================================================================================================
*  Desarrollado por:    Avanxo Colombia
*  @AUTHOR:             Juan Gabriel Duarte Pacheco
*  Fecha:               Mayo 23 de 2013
*  Decripción:          Clase que contiene la lógica del desencadenador Mail_ClosedTask_tgr
*  @version:            1.0
* ===================================================================================================================================
*       Version     Fecha                       Desarrollador                   Observaciones
*       1.0         Mayo 23 de 2013             JGDP                            Creación
*       2.0         Julio 31 de 2013            JGDP                            Modificación
**/

public class Mail_ClosedTask_cls {
	
	public String strFlowType {get; set;}
	public Map<String, Task> mapStageIdXOpenActivities {get; set;}
	public List<Stage__c> lstStage {get; set;}
	public String strCaseId {get; set;}
	public Boolean isAllowed {get; set;}
	public List<String> lstSubjects {get; set;}
	public Task objTaskActual {get; set;}
	public set<String> setEmailTemplateXStage {get; set;}	
	public Case objCase {get; set;}
	
	public Mail_ClosedTask_cls()
	{
	   //Se inicializan las variables globales
	   objCase = new Case();
	}
	
    /** Obtiene el Id del caso e inicia el proceso
    *  @param lstNewDat proveniente del trigger
    *  @param lstOldDat proveniente del trigger
    *  @return void
    **/
    public void executeLogic(List<Task> lstNewDat, List<Task> lstOldDat)
    {
        if( lstNewDat.size() == 1 )
        {   
            objTaskActual = lstNewDat[0];
            isAllowed = false;
            if(objTaskActual.isClosed && objTaskActual.WhatId != null)
            {
                strCaseId = objTaskActual.WhatId;
                startProcess();
                // Julio 31 de 2013. Si el subcaso está en estado abierto y el contacto es el mismo destinatario del correo
                if( objCase.Status.equals('Open') && (objTaskActual.WhoId == objCase.ContactId) )
	            {
	               updateCase();
	            }
            }
        }
    }    
    /** Se encarga de realizar las validaciones
    *  @param N/A    
    *  @return void
    **/
    public void startProcess()
    {
    	mapStageIdXOpenActivities = new Map<String, Task>();
    	lstStage = new List<Stage__c>();
    	lstSubjects = new List<String>();
    	setEmailTemplateXStage = new set<String>();
    	getFlowType();
    	fillMap();
    	getCustomSettings();
        
        if(strFlowType != null)
        {
            lstStage = [Select Id, Flow_Type__r.Id, Flow_Type__c, Close_task_when_user_sends_an_email__c From Stage__c where Flow_Type__r.Id =:strFlowType and Close_task_when_user_sends_an_email__c=true order by Name asc];
        }
        
        if(!mapStageIdXOpenActivities.IsEmpty() && !lstStage.IsEmpty())
        {
            updateActivities();
        }
    }
    
    /** Actualiza el Status de la tarea
    *  @param N/A
    *  @return void
    **/
    public void updateActivities()
    {
        for(Stage__c objStage: lstStage)
        {
            if(mapStageIdXOpenActivities.containsKey(objStage.Id))
            {
                Task objTask = mapStageIdXOpenActivities.get(objStage.Id);
                objTask.Status = 'Closed';
		        for(String objSubject:lstSubjects)
		        {
		        	System.debug('setEmailTemplateXStage-> '+setEmailTemplateXStage);
		            if(objTaskActual.Subject.contains(objSubject))
		            { 
		              String key = objTask.StageId__c+'-'+objSubject;
		              System.debug('key-> '+key);
		              if( setEmailTemplateXStage.contains(key) )
		              {
		                  isAllowed = true;
		              }
		            }
		        }
                
                if(isAllowed)
                {
                    Database.update(objTask, true);
                }
            }
        }
    }
    
    /** Actualiza el strFlowType con el Id del Caso
    *  @param N/A
    *  @return void
    **/
    public void getFlowType()
    {
        List<Case> lstCase = [Select Flow_Type__c, ContactId, Status, Subcase_Solution_Description_Email_Res__c From Case Where Id =:strCaseId];
        if(!lstCase.IsEmpty())
        {
            strFlowType = lstCase.get(0).Flow_Type__c;
            objCase = lstCase.get(0);
        }
    }
    
    /** Llena el mapa: mapStageIdXOpenActivities
    *  @param N/A
    *  @return void
    **/
    public void fillMap()
    {
        List<Task> lstTask = [Select WhatId, Status, StageId__c, IsClosed, Subject, Task_subject__c From Task Where WhatId=:strCaseId And IsClosed = false];
        for(Task objTask:lstTask)
        {
            mapStageIdXOpenActivities.put(objTask.StageId__c, objTask);
        }
    }
    
    /** Llena la lista: lstSubjects. Toma la configuración personalizada con los asuntos correspondientes de las plantillas de correo
    *  @param N/A
    *  @return void
    **/
    public void getCustomSettings()
    {
        List<ConfigurationEmailStage__c> lstCES = ConfigurationEmailStage__c.getall().values();
		Set<String> lstIdTemplate = new Set<String>();
		
		for(ConfigurationEmailStage__c objCES:lstCES)
		{
		  lstIdTemplate.add(objCES.EmailTemplateId__c);
		  setEmailTemplateXStage.add(objCES.StageId__c+'-'+objCES.EmailTemplateName__c);
		}
		
		List<EmailTemplate> lstET = [ SELECT Id, Name FROM EmailTemplate WHERE Id IN:lstIdTemplate ];
		for(EmailTemplate objET:lstET)
		{
		  lstSubjects.add(objET.Name);
		}
    }
    
    /** Julio 31 de 2013. Actualiza el campo de respuesta de correo en el objeto subcaso, con el contenido del correo.
    *  @param N/A
    *  @return void
    **/
    public void updateCase()
    {
        String strEmailResponse = '';
        if(objCase.Subcase_Solution_Description_Email_Res__c != null)
        {
            strEmailResponse=objCase.Subcase_Solution_Description_Email_Res__c;
        }
        String strDescription = + '\r\n' + 'Dia e hora: '+system.now().format('yyyy-MM-dd','America/Sao_Paulo')+' '+String.valueOf(system.now().time()).left(8) + '\r\n' + objTaskActual.Description;
        objCase.Subcase_Solution_Description_Email_Res__c = '\r\n' + strDescription+ '\r\n' +strEmailResponse + '\r\n';
        if(objCase.Subcase_Solution_Description_Email_Res__c != '')
        {
            Database.update(objCase, false);
        }
    }
}