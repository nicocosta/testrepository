/**
 * @author Diego Satoba
 * El usuario seleccionará cual de los tres telefonos principales es registrado,
 * si la cuenta tiene asignado otro telefono en este, entonces será reemplazado
 * y desmarcado como principal.
 
 ambios (Versiones)
    -------------------------------------
    No. Fecha Autor Descripción
    ------  ----------   -------------------------- -----------
    1.0     11-02-2014   Nestor Diazgranados        Adding Phone3 when adding a "is not main" Phone Object.
 
 */
trigger MainPhone_tgr on Phone__c (after insert, after update, before insert, before update, after delete) {
   /**
     * Bulk
     */
     
  /*  if (Trigger.isAfter && Trigger.isInsert) {
        
        Set<Id> setAccountId = new Set<Id>();
        Map<Id, Account> mapAccount = new Map<Id, Account>();

        Map<Id, Set<Phone__c>> mapAccountIdPhoneSet = new Map<Id, Set<Phone__c>>();     
        
        for (Phone__c phone : Trigger.new) {
            // System.debug('PHONE.MAIN_PHONE__C:'+phone.Main_Phone__c+'.');
            if (phone.Main_Phone__c != null && !phone.Main_Phone__c.equalsIgnoreCase('Is not main')) { // Si telefono es principal     
                if (phone.Account__c != null) { // Si telefono no es null
                    setAccountId.add(phone.Account__c);
                    Set<Phone__c> setPh = mapAccountIdPhoneSet.get(phone.Account__c);
                    if (setPh == null) mapAccountIdPhoneSet.put(phone.Account__c, setPh = new Set<Phone__c>());
                    setPh.add(phone);
                }
            }

        }
        
        // System.debug('Accounts: ' + mapAccountIdPhoneSet.size() + '.');
        
        // Recupera las cuentas a partir de los ids.
        mapAccount = new Map<Id, Account>([select Phone_1__c, Phone_2__c, Phone_3__c from Account where Id in :setAccountId]);
        
        Set<Id> setPhoneIdToUpdate = new Set<Id>();     
        
        // Por cada cuenta
        for (Id accountId : mapAccountIdPhoneSet.keySet()) {
            Account account = mapAccount.get(accountId);
            if (account != null) {
                // System.debug('account:'+account.Id);
                Set<Phone__c> setPh = mapAccountIdPhoneSet.get(accountId);
                if (setPh != null) {
                    for (Phone__c phone : setPh) {
                        // System.debug('--->Phone'+phone.Id);
                        if (phone.Main_Phone__c.equalsIgnoreCase('Phone 1')) {
                            // System.debug('------>phone 1');
                            if (account.Phone_1__c != null) {
                                setPhoneIdToUpdate.add(account.Phone_1__c);
                            }
                            account.Phone_1__c = phone.Id;                      
                        } else if (phone.Main_Phone__c.equalsIgnoreCase('Phone 2')) {
                            // System.debug('------>phone 2');
                            if (account.Phone_2__c != null) {
                                setPhoneIdToUpdate.add(account.Phone_2__c);
                            }
                            account.Phone_2__c = phone.Id;                          
                        } else if (phone.Main_Phone__c.equalsIgnoreCase('Phone 3')){
                            // System.debug('------>phone 3');
                            if (account.Phone_3__c != null) {
                                setPhoneIdToUpdate.add(account.Phone_3__c);
                            }
                            account.Phone_3__c = phone.Id;
                        }
                    }
                }
            }
        }
        Map<Id, Phone__c> mapAddressToUpdate = new Map<Id, Phone__c>([select Main_Phone__c from Phone__c where Id in :setPhoneIdToUpdate]);
        
        List<Phone__c> lstPhonesToUpdate = new List<Phone__c>();        
        for (Phone__c phone : mapAddressToUpdate.values()) {
            phone.Main_Phone__c = 'Is not main';
                if (Trigger.newMap.get(phone.Id) == null) {
                lstPhonesToUpdate.add(phone);
            }
        }
        
        update mapAccount.values();
        
        update lstPhonesToUpdate;
        
    } else if (Trigger.isBefore && Trigger.isUpdate) { //before-update
        
        Set<Id> setUncheckPhoneId = new Set<Id>();
        Set<Id> setCheckPhoneId = new Set<Id>();
        
        Set<Id> setAccountId1 = new Set<Id>();
        Set<Id> setAccountId2 = new Set<Id>();
        Map<Id, Id> mapAccountIdPhoneId = new Map<Id,Id>();
        
        
        
        for (Phone__c phone : Trigger.new) {
            Phone__c oldPhone = Trigger.oldMap.get(phone.Id);
            if (oldPhone != null) {
                /**
                 * Este Phone p pasa de no ser principal a principal ó cambia de 
                 *   ser principal a ser otro principal,
                 *   se debe buscar la cuenta c a la cual está asociado este Phone
                 *   para obtener, si lo hay, el Phone q que deja de ser principal
                 *   a causa que este Phone p se vuelve principal para poner q como
                 *   no principal. 
                 */
                 /*
                if (oldPhone.Main_Phone__c != null && !oldPhone.Main_Phone__c.equalsIgnoreCase(phone.Main_Phone__c) &&
                    (phone.Main_Phone__c.equalsIgnoreCase('Phone 1') ||                 
                     phone.Main_Phone__c.equalsIgnoreCase('Phone 2') ||
                     phone.Main_Phone__c.equalsIgnoreCase('Phone 3'))) {
                    if (phone.Account__c != null) {
                        setAccountId1.add(phone.Account__c);
                        mapAccountIdPhoneId.put(phone.Account__c, phone.Id);                        
                    }
                }
                /**
                 * Este Phone pasa de ser principal a no principal.  
                 */
                 /*
                else if ((oldPhone.Main_Phone__c != null && oldPhone.Main_Phone__c.equalsIgnoreCase('Phone 1') ||                 
                     (oldPhone.Main_Phone__c != null && oldPhone.Main_Phone__c.equalsIgnoreCase('Phone 2')) ||
                     (oldPhone.Main_Phone__c != null && oldPhone.Main_Phone__c.equalsIgnoreCase('Phone 3'))) && 
                     (oldPhone.Main_Phone__c != null && phone.Main_Phone__c.equalsIgnoreCase('Is not main'))) {
                    if (phone.Account__c != null) {
                        setAccountId2.add(phone.Account__c);
                        mapAccountIdPhoneId.put(phone.Account__c, phone.Id);
                    }
                }
            }
        }
        
        // System.debug('setAccountId1 size:' + setAccountId1.size());
        
        Map<Id, Account> mapAccount1 = new Map<Id, Account>([select Phone_1__c, Phone_2__c, Phone_3__c from Account where Id in :setAccountId1]);
        Set<Id> setPhoneIdToUpdate = new Set<Id>();
        for (Account acc : mapAccount1.values()) {
            Phone__c phone = Trigger.newMap.get(mapAccountIdPhoneId.get(acc.Id));
            Phone__c oldPhone = Trigger.oldMap.get(phone.Id);
            Id phoneId = null;
            if (phone.Main_Phone__c.equalsIgnoreCase('Phone 1')) {
                phoneId = acc.Phone_1__c;
                acc.Phone_1__c = phone.Id;
                if (oldPhone.Main_Phone__c.equalsIgnoreCase('Phone 2')) {
                    acc.Phone_2__c = null;
                } else if (oldPhone.Main_Phone__c.equalsIgnoreCase('Phone 3')){
                    acc.Phone_3__c = null;
                }
            } else if (phone.Main_Phone__c.equalsIgnoreCase('Phone 2')) {
                phoneId = acc.Phone_2__c;
                acc.Phone_2__c = phone.Id;
                if (oldPhone.Main_Phone__c.equalsIgnoreCase('Phone 1')) {
                    acc.Phone_1__c = null;
                } else if (oldPhone.Main_Phone__c.equalsIgnoreCase('Phone 3')){
                    acc.Phone_3__c = null;
                }
            } else if (phone.Main_Phone__c.equalsIgnoreCase('Phone 3')) {
                phoneId = acc.Phone_3__c;
                acc.Phone_3__c = phone.Id;
                if (oldPhone.Main_Phone__c.equalsIgnoreCase('Phone 1')) {
                    acc.Phone_1__c = null;
                } else if (oldPhone.Main_Phone__c.equalsIgnoreCase('Phone 2')){
                    acc.Phone_2__c = null;
                }
            }
            if (phoneId != null) {
            	if (Trigger.newMap.get(phoneId) == null) 
            		setPhoneIdToUpdate.add(phoneId);
            }
        }
        
        Map<Id, Phone__c> mapPhoneToUpdate = new Map<Id, Phone__c>([select Main_Phone__c from Phone__c where Id in :setPhoneIdToUpdate]);
        for (Phone__c phone : mapPhoneToUpdate.values()) {
            phone.Main_Phone__c = 'Is not main';
        }
        
        // Actualizando las cuentas
        update mapAccount1.values();        
        
        // Actualizando los Phones
        update mapPhoneToUpdate.values();
        
        // Segunda Parte del Trigger
        
        Map<Id, Account> mapAccount2 = new Map<Id, Account>([select Phone_1__c, Phone_2__c, Phone_3__c from Account where Id in :setAccountId2]);
        List<Account> lstAccountForUpdate = new List<Account>();
        for (Account acc : mapAccount2.values()) {
            Phone__c phone = Trigger.newMap.get(mapAccountIdPhoneId.get(acc.Id));
            Phone__c oldPhone = Trigger.oldMap.get(phone.Id);
                
            if (oldPhone.Main_Phone__c.equalsIgnoreCase('Phone 1') && acc.Phone_1__c != null && acc.Phone_1__c == phone.Id) {
                acc.Phone_1__c = null;
                lstAccountForUpdate.add(acc);
            } else if (oldPhone.Main_Phone__c.equalsIgnoreCase('Phone 2') && acc.Phone_2__c != null && acc.Phone_2__c == phone.Id) {
                acc.Phone_2__c = null;
                lstAccountForUpdate.add(acc);
            } else if (oldPhone.Main_Phone__c.equalsIgnoreCase('Phone 3') && acc.Phone_3__c != null && acc.Phone_3__c == phone.Id) {
                acc.Phone_3__c = null;
                lstAccountForUpdate.add(acc);
            }
        }
        
        // Actualizando las cuentas
        update lstAccountForUpdate;
    }
    
    */
    ////*--------- JPG 24-JUN-2011 
    ////Corrección
    
    //Actualizar estado
     if (Trigger.isBefore){
     	List<String> lstLocalCode = new List<String>();
     	for(Phone__c p:Trigger.new ){
     		System.debug('>>>phone:' + p);
			if(p.Local_Code__c !=null && p.State__c==null)	lstLocalCode.add(String.valueOf(p.Local_Code__c.intValue()));
		}
		if(lstLocalCode.size()>0){
	     	List<PhoneLocalCode__c> lpc = [Select p.Name,p.State__c
							   From PhoneLocalCode__c p 
							   Where p.Name IN: lstLocalCode ]; 
			System.debug('>>>lpc:' + lpc);	
			System.debug('>>>lstLocalCode:' + lstLocalCode);			   
			Map<String,String> mappc = new Map<String,String>();
			for(PhoneLocalCode__c p:lpc ){
				mappc.put(p.Name,p.State__c);
			}
			for(Phone__c p:Trigger.new  ){
				if(p.Local_Code__c !=null && p.State__c==null){
					p.State__c = mappc.get(String.valueOf(p.Local_Code__c.intValue()));
				}
			}
		}
     }
    
    
    //Individual
    if(Trigger.new != null && Trigger.new.size()==1){
    	if (Trigger.isAfter){
    		Phone__c phone = Trigger.new[0];
    		if(phone.Account__c!=null){
				Account acc = [select Phone_1__c, 
	      			Phone_2__c, 
	      			Phone_3__c,
	      			Phone_1__r.Main_Phone__c, 
	      			Phone_2__r.Main_Phone__c, 
	      			Phone_3__r.Main_Phone__c,
	      			State_Phone_1__c,
	      			State_Phone_2__c,
	      			State_Phone_3__c  
      			from 
      			Account where 
      			Id =: phone.Account__c ];
      			//Ahora es principal 1
      			if(phone.Main_Phone__c!=null && phone.Main_Phone__c.equalsIgnoreCase('Phone 1')){
      				if(acc.Phone_1__c!= phone.id){
      					if(acc.Phone_1__c!=null){
      						Phone__c phone2 = [SELECT Main_Phone__c FROM Phone__c WHERE id =:acc.Phone_1__c];
      						phone2.Main_Phone__c = 'Is not main';
      						update phone2;
      					}
      					if(acc.Phone_2__c==phone.id){
      						acc.State_Phone_2__c = null;
      						acc.Phone_2__c = null;
      					}
      					if(acc.Phone_3__c==phone.id){
      						acc.State_Phone_3__c = null;
      						acc.Phone_3__c = null;
      					}
      				}
      					acc.State_Phone_1__c = phone.State__c;
      					acc.Phone_1__c = phone.id;
      					update acc;
      			//Ahora es principal 2	
      			}else if(phone.Main_Phone__c!=null && phone.Main_Phone__c.equalsIgnoreCase('Phone 2')){	
      				System.debug('>>>Asignar Phone 2');
      				if(acc.Phone_2__c!= phone.id){
      					if(acc.Phone_2__c!=null){
      						Phone__c phone2 = [SELECT Main_Phone__c FROM Phone__c WHERE id =:acc.Phone_2__c];
      						phone2.Main_Phone__c = 'Is not main';
      						update phone2;
      						System.debug('>>>Phone 2 anterior ya no es principal');
      					}
      					if(acc.Phone_1__c==phone.id){
      						acc.State_Phone_1__c = null;
      						acc.Phone_1__c = null;
      						System.debug('>>>Cambia Phone 1 ahora Phone 2');
      					}
      					if(acc.Phone_3__c==phone.id){
      						acc.State_Phone_3__c = null;
      						acc.Phone_3__c = null;
      					}
      				}	
      					acc.State_Phone_2__c = phone.State__c;
      					acc.Phone_2__c = phone.id;
      					update acc;
      			//Ahora no es principal		
      			}else{
      				if(acc.Phone_2__c== phone.id ){
      					acc.State_Phone_2__c = null;
      					acc.Phone_2__c = null;
      					update acc;
      				}
      				if(acc.Phone_1__c== phone.id ){
      					acc.State_Phone_1__c = null;
      					acc.Phone_1__c = null;
      					update acc;
      				}
      				//-- 1. v(1.0) When is not a main phone will be saved as Phone3
      				acc.Phone_3__c=phone.id;
      				acc.State_Phone_3__c = phone.State__c;
      				update acc;
      			}
     		}
    	}
    }else{
    
	    //Masivo
	    if(Trigger.isInsert || Trigger.isUpdate){
		    if (Trigger.isBefore){
		    	
		    	
		    	
		    	//Traer Cuentas
		    	Set<Id> setAccountId = new Set<Id>();  
		    	for (Phone__c phone : Trigger.new) {
		            if (phone.Account__c != null) { 
		                    setAccountId.add(phone.Account__c);
		            }
		        }
		      	
		      	Map<Id, Account> mapAccount = new Map<Id, Account>(
		      	[select Phone_1__c, 
		      			Phone_2__c, 
		      			Phone_3__c,
		      			Phone_1__r.Main_Phone__c, 
		      			Phone_2__r.Main_Phone__c, 
		      			Phone_3__r.Main_Phone__c 
		      			from 
		      			Account where 
		      			Id in :setAccountId]);
		    	
		    	//Si cambiaron un telefono como no principal o cambio de primario a secundario marcarlo
		    	for (Phone__c phone : Trigger.new) {
		            Account a = mapAccount.get(phone.Account__c);
		            if(a!=null){
			            if (phone.id != null && (phone.Main_Phone__c==null || phone.Main_Phone__c.equalsIgnoreCase('Is not main'))) { 
			            	if(a.Phone_1__c == phone.id) a.Phone_1__c=null; 
			                if(a.Phone_2__c == phone.id) a.Phone_2__c=null;
			                if(a.Phone_3__c == phone.id) a.Phone_3__c=null; 
			            }
			            if (phone.Main_Phone__c!=null && phone.Main_Phone__c.equalsIgnoreCase('Phone 1')) {
			            	if(a.Phone_2__c == phone.id) a.Phone_2__c=null;
			                if(a.Phone_3__c == phone.id) a.Phone_3__c=null; 
			            }
			            if (phone.Main_Phone__c!=null && phone.Main_Phone__c.equalsIgnoreCase('Phone 2')) {
			            	if(a.Phone_1__c == phone.id)a.Phone_1__c = null;
							if(a.Phone_3__c == phone.id) a.Phone_3__c=null; 
			            }
		            }
		        }
		        
		        //Si ya existe telefono principal, se deja como no principal.
		        for (Phone__c phone : Trigger.new) {
		            if (phone.Main_Phone__c!=null && phone.Main_Phone__c.equalsIgnoreCase('Phone 1')) { 
						 Account a = mapAccount.get(phone.Account__c);       
						 if(a.Phone_1__c != phone.id && a.Phone_1__c!=null){
						 	 phone.Main_Phone__c = 'Is not main';
						 }else{
						 	a.Phone_1__c = phone.id;
						 }
					}
		            if (phone.Main_Phone__c!=null && phone.Main_Phone__c.equalsIgnoreCase('Phone 2')) { 
						 Account a = mapAccount.get(phone.Account__c);       
						 if(a.Phone_2__c != phone.id && a.Phone_2__c!=null ){
						 	 phone.Main_Phone__c = 'Is not main';
						 }else{
						 	a.Phone_2__c = phone.id;
						 }
		            }
		            if (phone.Main_Phone__c!=null && phone.Main_Phone__c.equalsIgnoreCase('Is not main')) { 
						 Account a = mapAccount.get(phone.Account__c);       
						 a.Phone_3__c = phone.id;
		            }
		        }
		        
		    }
		    	
		    if (Trigger.isAfter){
		    	//Traer las cuentas que se van a actualizar
		    	Set<Id> setAccountId = new Set<Id>(); 
		    	for (Phone__c phone : Trigger.new) {
		            if (phone.Account__c != null) { 
		                    setAccountId.add(phone.Account__c);
		            }
		        }
		        
		        Map<Id, Account> mapAccount = new Map<Id, Account>(
		      	[select Phone_1__c, 
		      			Phone_2__c, 
		      			Phone_3__c,
		      			Phone_1__r.Main_Phone__c, 
		      			Phone_2__r.Main_Phone__c, 
		      			Phone_3__r.Main_Phone__c,
		      			State_Phone_1__c,
		      			State_Phone_2__c,
		      			State_Phone_3__c 
		      			from 
		      			Account where 
		      			Id in :setAccountId]);
		        
		        //En el before se aseguro que quede solo quede un Phone 1 y Phone 2
		        Set<Id> setAccountIdChange = new  Set<Id>(); 
		        for (Phone__c phone : Trigger.new) {
		            if(phone.Account__c != null){
			            Account a = mapAccount.get(phone.Account__c);
			            if (phone.Main_Phone__c!=null && phone.Main_Phone__c.equalsIgnoreCase('Phone 1')) { 
							a.Phone_1__c = phone.id;
							a.State_Phone_1__c = phone.State__c;
							setAccountIdChange.add(a.Id);
							if(a.Phone_2__c == phone.id){
							 	a.Phone_2__c = null;
							 	a.State_Phone_2__c = null;
							}
			            }
			            if (phone.Main_Phone__c!=null && phone.Main_Phone__c.equalsIgnoreCase('Phone 2')) { 
							 a.Phone_2__c = phone.id;
							 a.State_Phone_2__c = phone.State__c;
							 setAccountIdChange.add(a.Id);
							 if(a.Phone_1__c == phone.id){
							 	a.Phone_1__c = null;
							 	a.State_Phone_1__c = null;
							 }
			            }
			            if (phone.Main_Phone__c==null || phone.Main_Phone__c.equalsIgnoreCase('Is not main')) { 
			            	 a.Phone_3__c = phone.id;
							 a.State_Phone_3__c = phone.State__c;
							 if(a.Phone_1__c == phone.id){
							 	a.Phone_1__c = null;
							 	a.State_Phone_1__c = null;
							 }
							 if(a.Phone_2__c == phone.id){
							 	a.Phone_2__c = null;
							 	a.State_Phone_2__c = null;
							 }
							 setAccountIdChange.add(a.Id);
			            }
		            }
		        }
		        
		        List<Account> lstAccount = new  List<Account>();
		        for(Id i:setAccountIdChange){
		        	lstAccount.add(mapAccount.get(i));
		        }
		        update lstAccount;
		        
		    }
	    }
	    
    }
	 
    //Borrar el estado de las cuentas.
    if(Trigger.isDelete){
    	
    	//Traer cuentas;
    	Set<Id> setAccountId = new Set<Id>(); 
    	for (Phone__c phone : Trigger.old) {
            if (phone.Account__c != null) { 
                    setAccountId.add(phone.Account__c);
            }
        }
	        
        Map<Id, Account> mapAccount = new Map<Id, Account>(
      	[select Phone_1__c, 
      			Phone_2__c, 
      			Phone_3__c,
      			Phone_1__r.Main_Phone__c, 
      			Phone_2__r.Main_Phone__c, 
      			Phone_3__r.Main_Phone__c,
      			State_Phone_1__c,
      			State_Phone_2__c,
      			State_Phone_3__c 
      			from 
      			Account where 
      			Id in :setAccountId]);
      	
      	Set<Id> setAccountIdChange = new  Set<Id>(); 
	        for (Phone__c phone : Trigger.old) {
	            if(phone.Account__c != null){
		            Account a = mapAccount.get(phone.Account__c);
		            if (phone.Main_Phone__c!=null && phone.Main_Phone__c.equalsIgnoreCase('Phone 1')) { 
						 if(a.Phone_1__c != phone.id){
						 	a.State_Phone_1__c = null;
						 	setAccountIdChange.add(a.Id);
						 }
		            }
		            if (phone.Main_Phone__c!=null && phone.Main_Phone__c.equalsIgnoreCase('Phone 2')) { 
						 if(a.Phone_2__c != phone.id){
						 	a.State_Phone_2__c = null;
						 	setAccountIdChange.add(a.Id);
						 }
		            }
		            //-- 2. v(1.0) When erasing a 'Is not main' phone will be treated as the other 2 above here.
		             if (phone.Main_Phone__c!=null && phone.Main_Phone__c.equalsIgnoreCase('Is not main')) { 
						 if(a.Phone_3__c != phone.id){
						 	a.State_Phone_3__c = null;
						 	setAccountIdChange.add(a.Id);
						 }
		            }
		        }
	        }
	        
	        List<Account> lstAccount = new  List<Account>();
	        for(Id i:setAccountIdChange){
	        	lstAccount.add(mapAccount.get(i));
	        }
	        update lstAccount;		
      			
    }

    
}