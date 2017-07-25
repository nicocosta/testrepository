/****************************************************************************************************
    General information. 
    -------------------
    Developed by:  		Avanxo Colombia
    Author:             Giovanny Rey Cediel.
    Project:           	Novartis (CRM)
    Descripción:        Core from trigger CreateTaskTooUserByClientOrReporter. If change the name or 
    					birthday or genere in account, is it create task to user registerd in "Custom Settings" 
    
    Information about changes (Vertions)
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     17-03-2011  Giovanny Rey Cediel          Create.
    1.0 	15-06-2011 	Juan Pablo Gracia			 Assign to leader of custom group
****************************************************************************************************/
public with sharing class CreateTaskToUserByClientOrReporter {
	
	public static boolean flatExe=false;
	
	/************************************************************************************
		Make the logical from trigger. If change the name or profession or g
		Realiza lógica del trigger.Si se cambia el nombre o profesión de un Account, se crea 
		una tarea para un usuario registrado en un "Custom Settings".
		@List<Account> listNewInMemmory
		List<Account> listOldInDb
	************************************************************************************/
	public void executeTrigger(List<Account> listNewInMemmory, List<Account> listOldInDb){
		//Si la bandera de ejecución esta en true returna;   
        if(flatExe)return;
        flatExe=true;
        String msg='';
                
        try{
            if(!listNewInMemmory.IsEmpty()){ 
            	System.debug('\nLISTA DE ACCOUNT NUEVA NO VACIA, TAMAÑO:'+listNewInMemmory.size());                   	
                System.debug('\nLISTA DE ACCOUNT ANTIGUA NO VACIA, TAMAÑO:'+listOldInDb.size());
                for(Account  acc  : listNewInMemmory){
                    try{
						String primerNombreNuevo;                    	
                    	String primerNombreAntiguo;
                    	String segundoNombreNuevo;                    	
                    	String segundoNombreAntiguo;                    	
                    	String profesionNueva;
                    	String profesionAntigua;
                    	// Control de campos null	                    	
						try{primerNombreNuevo =acc.FirstName;if( primerNombreNuevo==null) throw new TriggerOperationException();} catch(TriggerOperationException e){primerNombreNuevo='';}
                    	try{primerNombreAntiguo = listOldInDb.get(0).FirstName;if( primerNombreAntiguo==null) throw new  TriggerOperationException();} catch(TriggerOperationException e){primerNombreAntiguo='';}                    	                    	                    	
                    	try{segundoNombreNuevo =acc.LastName;if(segundoNombreNuevo==null) throw new TriggerOperationException();} catch(TriggerOperationException e){segundoNombreNuevo='';}
                    	try{segundoNombreAntiguo = listOldInDb.get(0).LastName;if(segundoNombreAntiguo==null) throw new  TriggerOperationException();} catch(TriggerOperationException e){segundoNombreAntiguo='';}                    	                    	                    	
                    	try{profesionNueva = acc.Occupation_Specialty__pc;if(profesionNueva==null) throw new  TriggerOperationException();}catch(TriggerOperationException e){profesionNueva='';}
                    	try{profesionAntigua = listOldInDb.get(0).Occupation_Specialty__pc;if(profesionAntigua==null) throw new  TriggerOperationException();}catch(TriggerOperationException e){profesionAntigua='';}                    	
                    	System.debug('\n --->Account NUEVO:'+ acc +'  \n-->Account ANTIGUO:'+ listOldInDb.get(0));  
                    	System.debug('\n PROFESION NUEVA:'+profesionNueva+'  PROFESION ANTIGUA:'+profesionAntigua);  
                    	System.debug('\n PRIMER NOMBRE NUEVO:'+primerNombreNuevo+'  PRIMER NOMBRE ANTIGUO:'+primerNombreAntiguo);  
                    	System.debug('\n SEGUNDO NOMBRE NUEVO:'+segundoNombreNuevo+'  SEGUNDO NOMBRE ANTIGUO:'+segundoNombreAntiguo);                    	
                    	
                    	if(!primerNombreNuevo.equalsIgnoreCase(primerNombreAntiguo)){
                    	 	msg += System.label.ChangeFieldLabel.replace('%f',Schema.sObjectType.Account.fields.FirstName.getLabel()).replace('%n',primerNombreNuevo).replace('%o',primerNombreAntiguo) + '\n';
                    	}
                    	if(!segundoNombreNuevo.equalsIgnoreCase(segundoNombreAntiguo)){
                    	 	msg += System.label.ChangeFieldLabel.replace('%f',Schema.sObjectType.Account.fields.LastName.getLabel()).replace('%n',segundoNombreNuevo).replace('%o',segundoNombreAntiguo) + '\n';
                    	}	
                    	if(!profesionNueva.equalsIgnoreCase(profesionAntigua)){
                    	 	msg += System.label.ChangeFieldLabel.replace('%f',Schema.sObjectType.Account.fields.Occupation_Specialty__pc.getLabel()).replace('%n',profesionNueva).replace('%o',profesionAntigua) + '\n';
                    	}
                    	                    	
                    	if(//Si se cambian los campos First y Last Name, FechaNacimento y Genero
                    		!primerNombreNuevo.equalsIgnoreCase(primerNombreAntiguo) ||
                    		!segundoNombreNuevo.equalsIgnoreCase(segundoNombreAntiguo) ||
                    		!profesionNueva.equalsIgnoreCase(profesionAntigua)                    			                   		                    			
                    	){
                    		System.debug('\nSI SE CAMBIARON LOS CAMPOS NOMBRE, FECHA_NACIMIENTO, GENERO');                    		
                    		//Verifica que la lista no sea nula                    		                 		
                    		if(listOldInDb==null || listOldInDb.size()==0){
                    			System.debug('\nLISTA ANTIGUA NULA O VACIA');
                    		}
                    		//Si la cuenta esta asociada a un SIR (Safety_Individual_Report__c) como reporter.   
                    		else if(isAccountReporterSIR_giv(listOldInDb.get(0).id)){
								//Obtiene Configuración personalizada para el perfíl
								FV_Setup__c fvSetup = FV_Setup__c.getInstance(Userinfo.getProfileId());
								//String idUser = fvSetup.idUserToAssignedTaskFromUpdatePatient__c;								
								String idUser = getMemberLeader(fvSetup.IdGroupToAssignedTaskFromUpdateAccount__c);							
								//valida si el perfil tiene asignado usuario para asignar tarea					
								if(idUser!=null){
									System.debug('\n EL PERFIL TIENE ASOSCIADO USUARIO EN EL CUSTOM SETTINGS');
									//se asigna una tarea
									Task tarea = new Task();
									tarea.OwnerId=idUser;
									tarea.WhatId=acc.id;
									tarea.Subject=System.label.ChangeDataPatientOrReporter;
									tarea.ActivityDate = System.Today().addDays(1);
									tarea.Description = msg;
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
		Determina si el account esta asociado a un Safety_Individual_Report__c
		como Reporter.
		@String idAccount
	*****************************************************************************/
	public boolean isAccountReporterSIR_giv(String idAccount){
		Integer cant = [
		Select COUNT() 
		From Reporter__c Where Reporter_related_name__c = :idAccount];
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
										where  g.Group__c  =: groupId
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