/****************************************************************************************************
    Genral Information 
    -------------------
    Developed by:   	Avanxo Colombia
    Author:             Giovanny Rey Cediel.
    Projecto:           Novartis (CRM)
    Description:        When it is change the account information (patients or clients) in the SIR object,
						it should make an update to the corresponding field in the object account.    
    Information about (Versions)
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     17-03-2011  Giovanny Rey Cediel          Create.
****************************************************************************************************/
public with sharing class UpdateAccountFromReporter {
	//Cuando se modifican el nombre o profesión de una cuenta en el objeto Reporter, 
	//se debe hacer un update al campo correspondiente en el objeto cuenta.
	
	
	
	public void executeTrigger(List<Reporter__c> listNewInMemmory, List<Reporter__c> listOldInDb){						
		//***
		try{
			//Activa banderas de ejecucion para trigger que establecen tareas por cambios en Account
			CreateTaskToUser.flatExe=true;
			CreateTaskToUserByClientOrReporter.flatExe=true;
			Integer x=0;
			for(Reporter__c rep : listNewInMemmory){
				try{
					String nombreNuevo = rep.Reporter_Name_Frozen__c; 
					//String segundoNombreNuevo = rep.Reporter_Last_Name_Frozen__c;
					String nombreAntiguo =listOldInDb.get(x).Reporter_Name_Frozen__c;
					//String segundoNombreAntiguo=listOldInDb.get(0).Reporter_Last_Name_Frozen__c;
					String profesionNueva =  rep.Reporter_Profession_Frozen__c;
					String profesionAntigua = listOldInDb.get(x).Reporter_Profession_Frozen__c;
					 
					//control de null pointer exception
					if(nombreNuevo==null){nombreNuevo=''; }
					//if(segundoNombreNuevo==null){segundoNombreNuevo=''; }
					if(nombreAntiguo==null){nombreAntiguo=''; }
					//if(segundoNombreAntiguo==null){segundoNombreAntiguo=''; }
					if(profesionNueva==null){profesionNueva=''; }
					if(profesionAntigua==null){profesionAntigua='';}							
					//Si hay cambio en los campos nombre o profesión
					if( nombreNuevo != nombreAntiguo || profesionNueva != profesionAntigua){					
						//actualiza los campos del objeto account con los campos del objeto reporter 
						//this.updateClientNameAndProfessionFromAccount(rep.Reporter_related_name__c, nombreNuevo,segundoNombreNuevo, profesionNueva);
						this.updateClientNameAndProfessionFromAccount(rep.Reporter_related_name__c, nombreNuevo,null, profesionNueva,listOldInDb.get(x));																	 					
					
					}else{
						System.debug('\nLOS CAMPOS Reporter_Name_Frozen y Reporter_Profession_Frozen  NO han sido cambiados.');	
					}												
				}catch(Exception e){
					rep.addError(System.label.UpdateAccountTriggerError+e.getMessage());	
				}
				x++;		
			}
					
		}finally{
			//Desactiva banderas de ejecución de los trigger.
			//CreateTaskToUser.flatExe=false;
			//CreateTaskToUserByClientOrReporter.flatExe=false;					
		}
	
	}
			
	/****************************************************************************************************************
		Update fields reporterNameFrozen, reporterLastNameFrozen and reporterProfessionFrozen from Account object
		@String idSir 
		@String reporterNameFrozen
		@String reporterProfessionFrozen  
	****************************************************************************************************************/
	public void updateClientNameAndProfessionFromAccount(String reporterRelatedName, String reporterNameFrozen,String reporterLastNameFrozen, String reporterProfessionFrozen, Reporter__c repOld){	 		 		 	
	 	Account acc  = new Account(id=reporterRelatedName);
	 	System.debug('INIT UPDATE:'+acc);
		//acc.FirstName = reporterNameFrozen;		
		if( reporterNameFrozen != repOld.Reporter_Name_Frozen__c)
			acc.LastName=reporterNameFrozen;
		if( reporterProfessionFrozen != repOld.Reporter_Profession_Frozen__c)			
			acc.Occupation_Specialty__pc = reporterProfessionFrozen;
		update acc;
		System.debug('END UPDATE:'+acc);
	}		
}