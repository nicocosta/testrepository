trigger MainEmail_tgr on Email_Address__c (after insert, after update, before insert, before update) {
    /**
     * Bulk
     */ 
    /*if (Trigger.isAfter && Trigger.isInsert) { // before-insert
        
        Set<Id> setAccountId = new Set<Id>();
        
        Map<Id, Id> mapAccountIdEmailId = new Map<Id, Id>();
        for (Email_Email_Address__c email : Trigger.new) {
            if (email.Main_email__c && email.Account__c != null) {
                setAccountId.add(email.Account__c);
                mapAccountIdEmailId.put(email.Account__c, email.Id); 
            }
        }
        
        Map<Id, Account> mapAccounts = new Map<Id, Account>([select Main_Email_Email_Address__c from Account where Id in :setAccountId]);
        Set<Id> setEmailIdForUpdate = new Set<Id>();
        for (Account acc : mapAccounts.values()) {
            Id emailId = mapAccountIdEmailId.get(acc.Id);
            Email_Email_Address__c email = Trigger.newMap.get(emailId);
            if (acc.Main_Email_Email_Address__c != null) {
            	setEmailIdForUpdate.add(acc.Main_Email_Email_Address__c);
            }
            acc.Main_Email_Email_Address__c = emailId;
        }
        
        Map<Id, Email_Email_Address__c> mapEmails = new Map<Id, Email_Email_Address__c>([select Main_email__c from Email_Email_Address__c where Id in :setEmailIdForUpdate]);
        for (Email_Email_Address__c email : mapEmails.values()) {
        	email.Main_email__c = false; 
        }
        
        update mapAccounts.values();
        
        update mapEmails.values();
        
        
    } else if (Trigger.isBefore && Trigger.isUpdate) { //before-update
        
        Map<Id, Id> mapAccountIdEmailId = new Map<Id, Id>();
        Set<Id> setAccountId1 = new Set<Id>();
        Set<Id> setAccountId2 = new Set<Id>();
        
        for (Email_Email_Address__c email : Trigger.new) {
            Email_Email_Address__c oldAddr = Trigger.oldMap.get(email.Id);
            /**
             * De No Primaria a primaria
             **/
           /* if (!oldAddr.Main_email__c && email.Main_email__c && email.Account__c != null) {
                mapAccountIdEmailId.put(email.Account__c, email.Id);
                setAccountId1.add(email.Account__c);
            }
            /**
             * De Primaria a no primaria.
             **/ 
           /* else if (oldAddr.Main_email__c && !email.Main_email__c) {
            	mapAccountIdEmailId.put(email.Account__c, email.Id);
                setAccountId2.add(email.Account__c);
            }
        }
        
        Map<Id, Account> mapAccounts = new Map<Id, Account>([select Main_Email_Email_Address__c from Account where Id in :setAccountId1]);
        Set<Id> setAddressIdForUpdate = new Set<Id>();
        for (Account acc : mapAccounts.values()) {
            Id emailId = mapAccountIdEmailId.get(acc.Id);
            Email_Email_Address__c email = Trigger.newMap.get(emailId);
            system.debug('ID.................................' + emailId + '.');
            if (acc.Main_Email_Email_Address__c != null 
                && Trigger.newMap.get(acc.Main_Email_Email_Address__c) == null) {
                setAddressIdForUpdate.add(acc.Main_Email_Email_Address__c);
            }
            acc.Main_Email_Email_Address__c = emailId;
        }
      
        Map<Id, Email_Email_Address__c> mapAddressForUpdate = new Map<Id, Email_Email_Address__c>([select Main_email__c from Email_Email_Address__c where Id in :setAddressIdForUpdate]);
        for (Email_Email_Address__c email : mapAddressForUpdate.values()) {
            email.Main_email__c = false;
        }
        
        update mapAccounts.values();
        
        update mapAddressForUpdate.values();
        
        mapAccounts = new Map<Id, Account>([select Main_Email_Email_Address__c from Account where Id in :setAccountId2]);  
        for (Account acc : mapAccounts.values()) {
        	Id emailId = mapAccountIdEmailId.get(acc.Id);
            Email_Email_Address__c email = Trigger.newMap.get(emailId);
            if (acc.Main_Email_Email_Address__c == email.Id) {
            	acc.Main_Email_Email_Address__c = null;
            }
        }
        
        update mapAccounts.values();
        
    }*/
    
       ////*--------- JPG 24-JUN-2011 
    ////Corrección
    
    
    //Masivo
    if(Trigger.new.size()>1){
	    if(Trigger.isInsert || Trigger.isUpdate){
		    if (Trigger.isBefore){
		    	
		    	
		    	
		    	//Traer Cuentas
		    	Set<Id> setAccountId = new Set<Id>();  
		    	for (Email_Address__c address : Trigger.new) {
		            if (address.Account__c != null) { 
		                    setAccountId.add(address.Account__c);
		            }
		        }
		      	
		      	Map<Id, Account> mapAccount = new Map<Id, Account>(
		      	[select Main_Email_Address__c
		      			from 
		      			Account where 
		      			Id in :setAccountId]);
		    	
		    	//Si cambiaron una dirección a no principal 
		    	for (Email_Address__c address : Trigger.new) {
		            Account a = mapAccount.get(address.Account__c);
		            if(a!=null){
			            if (address.id != null && address.Main_email__c==false) { 
			            	if(a.Main_Email_Address__c == address.id) a.Main_Email_Address__c=null; 
			            }
		            }
		        }
		        
		        //Si ya existe direccion principal, se deja como no principal.
		        for (Email_Address__c address: Trigger.new) {
		            if (address.Main_email__c) { 
						 Account a = mapAccount.get(address.Account__c);       
						 if(a.Main_Email_Address__c != address.id && a.Main_Email_Address__c!=null){
						 	 address.Main_email__c = false;
						 }else{
						 	 a.Main_Email_Address__c = address.id;
						 }
					}
		        }
		    }
		    	
		    if (Trigger.isAfter){
		    	//Traer las cuentas que se van a actualizar
		    	Set<Id> setAccountId = new Set<Id>();  
		    	for (Email_Address__c address : Trigger.new) {
		            if (address.Account__c != null) { 
		                    setAccountId.add(address.Account__c);
		            }
		        }
		        
		        Map<Id, Account> mapAccount = new Map<Id, Account>(
		      	[select Main_Email_Address__c
		      			from 
		      			Account where 
		      			Id in :setAccountId]);
		        
		        //En el before se aseguro que quede solo quede un mail principal
		        Set<Id> setAccountIdChange = new  Set<Id>(); 
		        for (Email_Address__c address : Trigger.new) {
		            if(address.Account__c != null){
			            Account a = mapAccount.get(address.Account__c);
			            if (address.Main_email__c) { 
							a.Main_Email_Address__c = address.id;
							setAccountIdChange.add(a.Id);
			            }
			            if (!address.Main_email__c) { 
							 if(a.Main_Email_Address__c == address.id){
							 	a.Main_Email_Address__c = null;
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
    }else{
    	//Individual
    	if (Trigger.isAfter){
    		Email_Address__c add = Trigger.new[0];
    		
    		if(add.Account__c!=null){
				Account acc = [select Main_Email_Address__c
      			from 
      			Account where 
      			Id =: add.Account__c ];
      			//Ahora es principal
      			if(add.Main_email__c){
      				if(acc.Main_Email_Address__c!= add.id){
      					if(acc.Main_Email_Address__c!=null){
      						Email_Address__c add2 = [SELECT Main_email__c FROM Email_Address__c WHERE id =:acc.Main_Email_Address__c];
      						add2.Main_email__c = false;
      						update add2;
      					}
      					acc.Main_Email_Address__c = add.id;
      					update acc;
      				}
      			}else{
      			//Ahora no es principal	
      				if(acc.Main_Email_Address__c== add.id ){
      					acc.Main_Email_Address__c = null;
      					update acc;
      				}
      			}
     		}
    	}
    }
    
  

}