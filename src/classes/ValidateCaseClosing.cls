/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Pablo Gracia
	Project:			Novartis Brazil
	Description: 		Validate whether the case can be closed.
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		10-03-2011	Juan Pablo Gracia			Create class.
	1.1		07-07-2011	Juan Pablo Gracia			Verify if case have subcase open.
	1.2		16-11-2011	Juan Pablo Gracia			Validate whether the case can change status.
	****************************************************************************************************/

public class ValidateCaseClosing {
	
	/*This method validate whether the cases can be closed.
	*@param lstCase List of cases to validate
	*@return Map<ID,String> Where id is a case's id and string is a error message,
	*if message is null, case can be closed.
	*/
	public Map<ID,String> validateClose(List<Case> lstCase){
		Map<ID,String> resp = new Map<ID,String>();
		List<Id> lstCasesIdsClosed = new List<Id>();  
		List<Case> lstCasesClosesForValidation = new List<Case>();
		Map<Id, Case_Type__c> mapCaseType = new  Map<Id, Case_Type__c>();
		
		//Seleccion los casos que se van a cerrar
		for(Case c:lstCase){
			//JPG 16-11-2011 Ahora se validan los status diferentes a abierto.
			if(c.Status != 'Open' ){
				lstCasesIdsClosed.add(c.Id);
			}
			resp.put(c.Id, null);
		}
		
		
		
		//Tomo los ids de los casos que tienen tipo de caso que valida las tareas abiertas
		List<Case> lstCaseTypes = getCaseForValidationClosing(lstCasesIdsClosed);
		lstCasesIdsClosed.clear();
		for(Case c:lstCaseTypes){
			if(c.Case_Type__r.Validate_closing_with_open_tasks__c){
				lstCasesIdsClosed.add(c.Id);
			}
			//Si tiene subcasos abiertos agrego el error
			for(Case sc:c.Cases){
				if(!sc.IsClosed){
					resp.put(c.Id,Label.CaseCanCloseHaveSubCaseOpen);
				}
			}
		}
		
		
		
		//Obtengo las tareas abiertas para dichos casos
		List<Task> tasks = getTasksOpensByCasesIDs(lstCasesIdsClosed); 
		
		//Verifico si un caso tiene tareas abiertas
		lstCasesIdsClosed.sort();
		Integer i=0;
		Boolean allow;
		for(ID idCase:lstCasesIdsClosed ){
			allow = true;
			while(i<tasks.size() && idCase==tasks[i].WhatId){
				allow = false;
				i++;
			}
			if(!allow){
				resp.put(idCase,Label.CaseCanCloseHaveOpenTask);
			}
		} 
		return resp;
	}
	
	/*Get tasks due a set of case's ids. 
	@param setIDs set of case types ids
	@return list of case types
	*/
	public List<Task> getTasksOpensByCasesIDs(List<ID> lstCaseIDs){
	 return [Select Id, t.Owner.Profile.Id, t.WhatId  
	 		 From Task t 
	 		 Where t.WhatId IN :lstCaseIDs
	 		 AND isClosed = false 
	 		 ORDER BY t.WhatId];  
	}
	
	/*Get List of Cases which must be validate due a set of ids
	@param lstIDs case ids
	@return list of cases 
	*/
	public List<Case> getCaseForValidationClosing(List<ID> lstIDs){
		return [SELECT c.id,  c.Case_Type__r.Validate_closing_with_open_tasks__c, (Select IsClosed From Cases )	
				FROM Case c
				WHERE c.id IN :lstIDs]; 
	}

}