/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Daniel Delgado (DFDC)
	Project:			Novartis Brazil
	Description: 		Validate if case can change status from 'Not attended' to 'Closed'
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		21-09-2010	Daniel Delgado (DFDC)		Create Trigger.
	****************************************************************************************************/
trigger CloseToNotAttendedCase on Case (before update) {
	if(trigger.new.size()==1){
		Case caseNew = trigger.new[0];
		Case caseOld = trigger.old[0];
		if(caseNew.Status == 'Not attended' && caseOld.Status == 'Closed'){
			Task tsk;
			try{
				tsk = [ Select Status From Task Where whatId = :caseNew.Id  Order By CreatedDate DESC limit 1];
			}catch(Exception e){
			}
			
			if( tsk!=null && tsk.Status != 'Unrealized' ){
				caseNew.addError(System.Label.ClosedCaseCantBeModified);	
		        return;
			}
			
			Map<String, Schema.SObjectField> M = Schema.SObjectType.Case.fields.getMap();
			for (String str : M.keyset()) {
		         if(caseNew.get(str) != caseOld.get(str) && str!='Status'){
		         	caseNew.addError(System.Label.CantChangeAnyFieldExceptStatus );	
		         	return;	
		         }
		    }
		}
	}

}