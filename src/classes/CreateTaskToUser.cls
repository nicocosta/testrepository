/****************************************************************************************************
    Information general 
    -------------------
    Developed by:   	Avanxo Colombia
    Author:             Giovanny Rey Cediel.
    Project:           	Novartis (CRM)
    Description:        Trigger is fired after editing an Account. If you change the name or
     					birthday or genre, it create a task for a user registered in a
     					"Custom Settings ".
    
    Information about  version changes.
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     17-03-2011  Giovanny Rey Cediel          Create.
    1.0 	15-06-2011 	Juan Pablo Gracia			 Assign to leader of custom group
****************************************************************************************************/
public with sharing class CreateTaskToUser {
	 public static boolean flatExe=false;

	/************************************************************************************
		Make trigger logic, if it change the name or birthday or genere, on
		Account, it create a task for a user registered in a "Custom Settings ".		
		@List<Account> listNewInMemmory
		@List<Account> listOldInDb
	************************************************************************************/
	public void executeTrigger(List<Account> listNewInMemmory, List<Account> listOldInDb){
        //verifica la bendera de ejecución        
        if(flatExe)return; 
        flatExe=true;
        try{
            //Activa bandera de ejecucion            
            if(!listNewInMemmory.IsEmpty()){ 
				System.debug('\nLISTA DE ACCOUNT NUEVA NO VACIA, TAMAÑO:'+listNewInMemmory);                   	
                System.debug('\nLISTA DE ACCOUNT ANTIGUA NO VACIA, TAMAÑO:'+listOldInDb);
                   	
                for(Account  acc  : listNewInMemmory){
                    try{
                    	String primerNombreNuevo;                    	
                    	String primerNombreAntiguo;
                    	String segundoNombreNuevo;                    	
                    	String segundoNombreAntiguo;
                    	Date birthdayNuevo;
                    	Date birthdayAntiguo;
                    	String genderNuevo;
                    	String genderAntiguo;                    	                                        	
                    	String msg='';
                    	//Controla enventualidades de campos nulos                    	                    	                    	                    	                    	
                    	try{primerNombreNuevo =acc.FirstName;if( primerNombreNuevo==null) throw new TriggerOperationException();} catch(TriggerOperationException e){primerNombreNuevo='';}
                    	try{primerNombreAntiguo = listOldInDb.get(0).FirstName;if( primerNombreAntiguo==null) throw new  TriggerOperationException();} catch(TriggerOperationException e){primerNombreAntiguo='';}                    	                    	                    	
                    	try{segundoNombreNuevo =acc.LastName;if(segundoNombreNuevo==null) throw new TriggerOperationException();} catch(TriggerOperationException e){segundoNombreNuevo='';}
                    	try{segundoNombreAntiguo = listOldInDb.get(0).LastName;if(segundoNombreAntiguo==null) throw new  TriggerOperationException();} catch(TriggerOperationException e){segundoNombreAntiguo='';}                    	                    	                    	
                    	try{birthdayNuevo = acc.PersonBirthdate;if(birthdayNuevo==null) throw new  TriggerOperationException();}catch(TriggerOperationException e){birthdayNuevo=System.today();}
                    	try{birthdayAntiguo = listOldInDb.get(0).PersonBirthdate;if(birthdayAntiguo==null) throw new  TriggerOperationException();}catch(TriggerOperationException e){birthdayAntiguo=System.today();}                    	
                    	System.debug('\nBIRTHDAY NEW:'+ birthdayNuevo+'  BIRTHDAY OLD:'+birthdayAntiguo);                    	
                    	try{genderNuevo = acc.Gender__pc; if(genderNuevo==null) throw new  TriggerOperationException();}catch(TriggerOperationException e){genderNuevo='';}
                    	try{genderAntiguo = listOldInDb.get(0).Gender__pc; if(genderAntiguo==null) throw new TriggerOperationException();}catch(TriggerOperationException e){genderAntiguo='';}                    		
                    	System.debug('\nGENDER NUEVO:'+ genderNuevo+' GENDER ANTIGUO:'+genderAntiguo);                    	
                    	
                    	if(!primerNombreNuevo.equalsIgnoreCase(primerNombreAntiguo)){
                    	 	msg += System.label.ChangeFieldLabel.replace('%f',Schema.sObjectType.Account.fields.FirstName.getLabel()).replace('%n',primerNombreNuevo).replace('%o',primerNombreAntiguo) + '\n';
                    	}
                    	if(!segundoNombreNuevo.equalsIgnoreCase(segundoNombreAntiguo)){
                    	 	msg += System.label.ChangeFieldLabel.replace('%f',Schema.sObjectType.Account.fields.LastName.getLabel()).replace('%n',segundoNombreNuevo).replace('%o',segundoNombreAntiguo) + '\n';
                    	}	
                    	if(birthdayNuevo!=birthdayAntiguo){
                    	 	msg += System.label.ChangeFieldLabel.replace('%f',Schema.sObjectType.Account.fields.PersonBirthdate.getLabel()).replace('%n',String.ValueOf(birthdayNuevo)).replace('%o',String.ValueOf(birthdayAntiguo)) + '\n';
                    	}
                    	if(!genderNuevo.equalsIgnoreCase(genderAntiguo)){
                    	 	msg += System.label.ChangeFieldLabel.replace('%f',Schema.sObjectType.Account.fields.Gender__pc.getLabel()).replace('%n',genderNuevo).replace('%o',genderAntiguo) + '\n';
                    	}
                    		                    	
                    	if(//Si se cambian los campos Nombre, FechaNacimento y Genero
                    		birthdayNuevo!=birthdayAntiguo ||
                    		!primerNombreNuevo.equalsIgnoreCase(primerNombreAntiguo) ||
                    		!segundoNombreNuevo.equalsIgnoreCase(segundoNombreAntiguo) ||
                    		!genderNuevo.equalsIgnoreCase(genderAntiguo)                    			                   		                    			
                    	){
                    		System.debug('\nSI SE CAMBIARON LOS CAMPOS NOMBRE, FECHA_NACIMIENTO, GENERO');                    		
                    		//Si la cuenta esta asociada a un SIR (Safety_Individual_Report__c) como paciente
                    		if(listOldInDb==null ||listOldInDb.size()==0){
                    			System.debug('\nLISTA ANTIGUA NULA O VACIA');
                    		}else if(this.isAccountPatientSIR_giv(listOldInDb.get(0).id)){
								System.debug('\n LA CUENTA ESTA ASOCIADA A UN SIR COMO PACIENTE');
								//Obtiene Configuración personalizada para el perfíl
								FV_Setup__c fvSetup = FV_Setup__c.getInstance(Userinfo.getProfileId());
								//Anotar las traducciones 
								//String idUser = fvSetup.idUserToAssignedTaskFromUpdatePatient__c;	
								String idUser = getMemberLeader(fvSetup.IdGroupToAssignedTaskFromUpdateAccount__c);							
								//valida si el perfil tiene asignado usuario para asignar tarea					
								if(idUser!=null){
									System.debug('\n EL PERFIL TIENE ASOSCIADO USUARIO EN EL CUSTOM SETTINGS');
									//Si hay idUserToAssignedTaskFromUpdatePatient se crea una tarea
									Task tarea = new Task();
									tarea.OwnerId=idUser;
									tarea.WhatId=acc.id;
									tarea.ActivityDate = System.Today().addDays(1);
									tarea.Description = msg;
									//Usar label 
									tarea.Subject=System.label.ChangeDataPatientOrReporter;
									insert tarea;
									System.debug('\nSE CREÓ TAREA CON EXITO');						
								}else{
									System.debug('\n EL PERFIL NO TIENE ASOSCIADO USUARIO EN EL CUSTOM SETTINGS');
								}																								                     		
                    		}                    		
                    	}else{
                    		System.debug('\nNO SE CAMBIARON LOS CAMPOS NOMBRE, FECHA_NACIMIENTO, GENERO');
                    	}
                    }catch(Exception e){
            			acc.addError(System.label.CreateTaskToUserTriggerError+e.getMessage());
 	    		   	}
        
            	}  		
			}else{
				System.debug('\nLISTA DE ACCOUNT NUEVA VACIA');
			}			
		}catch(Exception e){
			System.debug('\n\nERROR TRIGGER:'+e.getMessage());    	    	
    	}
	}
	
	/*******************************************************************************
		Determines whether the account is associated with a Safety_Individual_Report__c
		as a patient.		
	*****************************************************************************/
	public boolean isAccountPatientSIR_giv(String idAccount){
		Integer  cant = [
		Select Count() 
		From Safety_Individual_Report__c 
		Where Patient_Name__c = :idAccount];
	 	if(cant>0){
	 		return true;
	 	}else{
	 		return false;
	 	}
	}
	
	
	/*
	* Get a group's member leader
	* @param groupId Group Id
	* @return id's member leader
	* @autor JPG 15-06-2011
	*/
	public Id getMemberLeader(String groupId){
		List<Group_Member__c> gmlst= [Select g.User__c
										From Group_Member__c g 
										where  g.Group__c =: groupId
										and g.Group_Leader__c = true LIMIT 1];
		if(gmlst.size()>0){
			return gmlst[0].User__c;
		}								
		return null;								 
	} 
	

	/******************************************************************
		Operación exception by trigger.
	*****************************************************************/
	public class TriggerOperationException extends Exception{}
}