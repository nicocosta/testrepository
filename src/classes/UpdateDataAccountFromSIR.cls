/****************************************************************************************************
    General Information. 
    -------------------
    Developed by:   	Avanxo Colombia
    Author:             Giovanny Rey Cediel.
    Project:           	Novartis (CRM)
    Description:        When you change the Safety Individual Report information (whether patients or clients) to do 
    					an update to the corresponding field in the Account object.
    
    Information about version
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     17-03-2011  Giovanny Rey Cediel          Creation.
****************************************************************************************************/
public with sharing class UpdateDataAccountFromSIR {

	public void executeTrigger(List<Safety_Individual_Report__c> listNewInMemmory, List<Safety_Individual_Report__c> listOldInDb){
		try{
			//Activa banderas de ejecucion para trigger que establecen tareas por cambios en Account
			CreateTaskToUser.flatExe=true;
			CreateTaskToUserByClientOrReporter.flatExe=true;
			Integer x=0;
			for(Safety_Individual_Report__c sirNew : listNewInMemmory){
				try {
					//Si el SIR es paciente o cliente 
					if(this.isClientSIR_giv(sirNew,listOldInDb.get(0))){
						System.debug('\nEL SIR ES CLIENTE');
						//Se actualiza el nombre y profesión del cliente
						//this.updateClientNameAndProfessionFromAccount(sirNew.id,sirNew.Client_Name_Frozen__c, sirNew.Client_Last_Name_Frozen__c, sirNew.Client_Profession_Frozen__c);
						this.updateClientNameAndProfessionFromAccount(sirNew.Client_Name__c,sirNew.Client_Name_Frozen__c, null, sirNew.Client_Profession_Frozen__c,listOldInDb.get(x)); 			 				
					}
					if(this.isPatientSIR_giv(sirNew,listOldInDb.get(0))){
						System.debug('\nEL SIR ES PACIENTE');
						//Se actualiza el nombre del paciente, fecha de cumpleaños y genero
						//this.updatePatientNameBirthdateAndGenderFromAccount(sirNew.id, sirNew.Patient_Name_Frozen__c, sirNew.Patient_Last_Name_Frozen__c, sirNew.Patient_Birthdate_Frozen__c,sirNew.Patient_Gender_Frozen__c); 
						this.updatePatientNameBirthdateAndGenderFromAccount(sirNew.Patient_Name__c, sirNew.Patient_Name_Frozen__c, null, sirNew.Patient_Birthdate_Frozen__c,sirNew.Patient_Gender_Frozen__c, listOldInDb.get(x) ); 
					}			
												
				}catch(Exception e){
					sirNew.addError(System.label.UpdateAccountTriggerError+e.getMessage());	
				}
				x++;
			}						
		}finally{
			//Desactiva banderas de ejecución de los trigger.
			//CreateTaskToUser.flatExe=false;
			//CreateTaskToUserByClientOrReporter.flatExe=false;		
		}
	
	}
	
	/*******************************************************************************
		Determines whether account is related with Safety_Individual_Report__c
		like a patient.
		@Safety_Individual_Report__c sirNew
		@Safety_Individual_Report__c sirOld
		@return  boolean
	*****************************************************************************/
	public boolean isPatientSIR_giv(Safety_Individual_Report__c sirNew,Safety_Individual_Report__c sirOld){						
		if(sirNew.Patient_Name__c !=null && sirNew.Patient_Name__c==sirOld.Patient_Name__c ){ 
			return true;
		}else{
			return false;
		}					
	}
	
	/*******************************************************************************
		Determines whether the account is related with Safety_Individual_Report__c
		like client.
		@String Safety_Individual_Report__c sirNew
		@String Safety_Individual_Report__c sirOld
		@return boolean
	*****************************************************************************/
	public boolean isClientSIR_giv(Safety_Individual_Report__c sirNew, Safety_Individual_Report__c sirOld ){
		if(sirNew.Client_Name__c !=null && sirNew.Client_Name__c==sirOld.Client_Name__c ){ 
			return true;
		}else{
			return false;
		}	
	}	
	
	/**********************************************************************************
		Update fields clientNameFrozen and clientProfessionFrozen from Account object
		@String idSir 
		@String clientNameFrozen
		@String clientProfessionFrozen  
	**********************************************************************************/
	public void updateClientNameAndProfessionFromAccount(String idAcc, String clientNameFrozen, String clientLastNameFrozen, String clientProfessionFrozen,Safety_Individual_Report__c sirOld){	 	
	 	System.debug('\n<INICIO ACTUALIZACION CUENTA ID>:'+idAcc);
	 	Boolean actualizar=false;
	 	Account acc  = new Account(id=idAcc);
		if( clientNameFrozen != sirOld.Client_Name_Frozen__c){
			acc.LastName = clientNameFrozen;//Revisar si se debe cambiar a los demas campos (First y Last Name)
			actualizar=true;
		}
		//acc.LastName= clientLastNameFrozen;
		if( clientProfessionFrozen != sirOld.Client_Profession_Frozen__c ){
			acc.Occupation_Specialty__pc = clientProfessionFrozen;
			actualizar=true;
		}
		if(actualizar)update acc;
		System.debug('\n<CUENTA ACTUALIZADA>:'+acc);
	}

	/**********************************************************************************
		Update fileds PatientNameFrozen, PatientBirtdateFrozen y PatientGenderFrozen 
		del objeto Account asociado a un objeto SIR como paciente
		@String patientNameFrozen 
		@String patientBirthdateFrozen
		@String patientGenderFrozen
	**********************************************************************************/
	public void updatePatientNameBirthdateAndGenderFromAccount(String idAcc, String patientNameFrozen,String patientLastNameFrozen, Date patientBirthdateFrozen, String patientGenderFrozen, Safety_Individual_Report__c sirOld ){	 	
	 	System.debug('\n<INICIO ACTUALIZACION CUENTA ID>:'+idAcc);
	 	Boolean actualizar=false;
	 	Account acc  = new Account(id=idAcc);
	 	if( patientNameFrozen != sirOld.Patient_Name_Frozen__c ){
	 		acc.LastName = patientNameFrozen;
	 		actualizar=true;
	 	}
		//acc.LastName = patientLastNameFrozen;
		if( patientBirthdateFrozen != sirOld.Patient_Birthdate_Frozen__c ){
			acc.PersonBirthdate = patientBirthdateFrozen;
			actualizar=true;
		}
		if( patientGenderFrozen != sirOld.Patient_Gender_Frozen__c ){
			acc.Gender__pc = patientGenderFrozen;
			actualizar=true;
		}
	 	if(actualizar)update acc;
	 	System.debug('\n<CUENTA ACTUALIZADA>:'+acc);
	 		 		 						
	}

}