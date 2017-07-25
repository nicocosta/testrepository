/****************************************************************************************************
    Information general 
    -------------------
    Developed by:        Avanxo Colombia
    Author:              Juan Gabriel Duarte Pacheco
    Project:             Novartis (CRM)
    Description:         Check fields in the stage when closed task
    
    Information about  version changes.
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     08-Jul-2013  Juan Gabriel Duarte P.          Create.
****************************************************************************************************/

public class ValidateCloseTask_cls {
	
	public Boolean blnValidateSampleAnalysisIncluded {get; set;}
	public Boolean blnValidateSIR_Opened {get; set;}
	public Boolean blnValidateDocumentationAnalysisIncluded {get; set;}
	public Case objCase {get; set;}
	public Boolean has_a_SIR {get; set;}
	
	public ValidateCloseTask_cls()
	{
		//Booleans correspondientes al stage
		blnValidateSampleAnalysisIncluded = false;
		blnValidateSIR_Opened = false;
		blnValidateDocumentationAnalysisIncluded = false;
		
		objCase = new Case();
		has_a_SIR = false;
	}
		
	public void executeLogic(List<Task> lstNewDat, List<Task> lstOldDat)
	{
		if(lstNewDat!=null)
        {
            if(lstNewDat.size() == 1)
            {   
                Task objTask = lstNewDat[0];
                if( objTask.StageId__c != null && objTask.Status.equals('Closed') )
                {
                	getRequiredFields( objTask.StageId__c );
                	System.debug('blnValidateSampleAnalysisIncluded-> '+blnValidateSampleAnalysisIncluded);
                	System.debug('blnValidateSIR_Opened-> '+blnValidateSIR_Opened);
                	getObjCase( objTask.WhatId );
                	System.debug('objCase-> '+objCase);
                }
                //Si en el stage esta activo dicho campo, la información Analysis Data Sample en el subcaso de estar diligenciada.
                if( blnValidateSampleAnalysisIncluded && objCase.Complaint_investigation_results_sample__c == null && objCase.Complaint_response_sample__c == null && objCase.QC_number_Technical_Claim_Number_sample__c == null)
                {
                	objTask.addError(System.label.ValidateCloseTask_AnalysisDataSample);
                }        
                //Si en el stage esta activo dicho campo, debe tener asociado un SIR.
                if( blnValidateSIR_Opened && !has_a_SIR)
                {
                	objTask.addError(System.label.ValidateCloseTask_ValidateSIROpened);
                }
                //Si en el stage esta activo dicho campo, la información Analysis Data en el subcaso de estar diligenciada.
                if( blnValidateDocumentationAnalysisIncluded && objCase.QC_number_Technical_Claim_Number__c == null && objCase.Complaint_investigation_results__c == null && objCase.Complaint_Response__c == null)
                {
                    objTask.addError(System.label.ValidateCloseTask_AnalysisData);
                }
            }
        }
	}
	
	/** Identifica los campos que se deben validar según esten activos en el Stage. 
	*@param idStage
	*@return Void
	**/ 
	public void getRequiredFields(String idStage)
	{
		List<Stage__c> lstStage = [SELECT Id, Validate_Sample_Analysis_Included__c, 
		                                  Validate_SIR_Opened__c, 
		                                  Validate_Documentation_Analysis_Included__c 
                                    FROM Stage__c Where Id =:idStage];
        if(!lstStage.isEmpty())
        {
            blnValidateSampleAnalysisIncluded = lstStage.get(0).Validate_Sample_Analysis_Included__c;
            blnValidateSIR_Opened = lstStage.get(0).Validate_SIR_Opened__c;
            blnValidateDocumentationAnalysisIncluded = lstStage.get(0).Validate_Documentation_Analysis_Included__c;
        }     
	}
	
	/** Obtiene la información del objeto Case.
	*@param 
	*@return Void
	**/ 
	public void getObjCase(String idCase)
	{
		List<Case> lstCase = [SELECT Id, Complaint_investigation_results_sample__c,Complaint_response_sample__c,QC_number_Technical_Claim_Number_sample__c, //Analysis Data Sample
		                          QC_number_Technical_Claim_Number__c,Complaint_investigation_results__c,Complaint_Response__c, // Analysis Data
		                          (Select Id From Safety_Individual_Reports__r) //SIR's
	                          FROM Case Where Id =:idCase];
		if(!lstCase.isEmpty())
		{	
			if(lstCase.get(0).Safety_Individual_Reports__r.size()>0)
			{
				has_a_SIR = true;
			}
			objCase = lstCase.get(0);
		}
	}	
}