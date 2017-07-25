/**
 * @author Diego Satoba
 * @see 
 * Si la cuenta tiene asignada previamente otra direccion marcada como primaria
 * y otro registro direccion asociado a la misma cuenta esta marcado como primario
 * tambien. Entonces el sistema reemplazara la direccion primaria a esta (cuenta)
 * y desmarcara el registro como primario.
 */
trigger MainAddress_tgr on Address__c (after insert, after update, before insert, before update) {
    /**
     * Bulk
     */ 
    /*if (Trigger.isAfter && Trigger.isInsert) { // before-insert
        
        Set<Id> setAccountId = new Set<Id>();
        
        Map<Id, Id> mapAccountIdAddressId = new Map<Id, Id>();
        for (Address__c addr : Trigger.new) {
        	System.debug('Address:' + addr + '.');
            if (addr.Is_Main_Address__c && addr.Account__c != null) {
                setAccountId.add(addr.Account__c);
                mapAccountIdAddressId.put(addr.Account__c, addr.Id); 
            }
        }
        
        Map<Id, Account> mapAccounts = new Map<Id, Account>([select Main_Address__c from Account where Id in :setAccountId]);
        Set<Id> setAddressIdForUpdate = new Set<Id>();
        for (Account acc : mapAccounts.values()) {
            Id addressId = mapAccountIdAddressId.get(acc.Id);
            Address__c addr = Trigger.newMap.get(addressId);
            if (acc.Main_Address__c != null) {
            	setAddressIdForUpdate.add(acc.Main_Address__c);
            }
            acc.Main_Address__c = addressId;
        }
        
        Map<Id, Address__c> mapAddress = new Map<Id, Address__c>([select Is_Main_Address__c from Address__c where Id in :setAddressIdForUpdate]);
        for (Address__c addr : mapAddress.values()) {
        	addr.Is_Main_Address__c = false;
        }
        
        System.debug('Account size: ' + mapAccounts.values()+'.');
        update mapAccounts.values();
        
        update mapAddress.values();
        
    } else if (Trigger.isBefore && Trigger.isUpdate) { //before-update
        
        Map<Id, Id> mapAccountIdAddressId = new Map<Id, Id>();
        Set<Id> setAccountId1 = new Set<Id>();
        Set<Id> setAccountId2 = new Set<Id>();
        
        for (Address__c addr : Trigger.new) {
            Address__c oldAddr = Trigger.oldMap.get(addr.Id);
            /**
             * De No Primaria a primaria
             **/
           /* if (!oldAddr.Is_Main_Address__c && addr.Is_Main_Address__c && addr.Account__c != null) {
                mapAccountIdAddressId.put(addr.Account__c, addr.Id);
                setAccountId1.add(addr.Account__c);
            }*/
            /**
             * De Primaria a no primaria.
             **/ 
           /* else if (oldAddr.Is_Main_Address__c && !addr.Is_Main_Address__c) {
            	mapAccountIdAddressId.put(addr.Account__c, addr.Id);
                setAccountId2.add(addr.Account__c);
            }
        }*/
        
     /*   Map<Id, Account> mapAccounts = new Map<Id, Account>([select Main_Address__c from Account where Id in :setAccountId1]);
        Set<Id> setAddressIdForUpdate = new Set<Id>();
        for (Account acc : mapAccounts.values()) {
            Id addrId = mapAccountIdAddressId.get(acc.Id);
            Address__c addr = Trigger.newMap.get(addrId);
            if (acc.Main_Address__c != null && Trigger.newMap.get(acc.Main_Address__c) == null) {
                setAddressIdForUpdate.add(acc.Main_Address__c);
            }
            acc.Main_Address__c = addrId;
        }
        
        Map<Id, Address__c> mapAddressForUpdate = new Map<Id, Address__c>([select Is_Main_Address__c from Address__c where Id in :setAddressIdForUpdate]);
        for (Address__c addr : mapAddressForUpdate.values()) {
            addr.Is_Main_Address__c = false;
        }
        
        update mapAccounts.values();
        
        update mapAddressForUpdate.values();
        
        mapAccounts = new Map<Id, Account>([select Main_Address__c from Account where Id in :setAccountId2]);
        
        for (Account acc : mapAccounts.values()) {
        	Id addrId = mapAccountIdAddressId.get(acc.Id);
            Address__c addr = Trigger.newMap.get(addrId);
            if (acc.Main_Address__c == addr.Id) {
            	acc.Main_Address__c = null;
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
		    	for (Address__c address : Trigger.new) {
		            if (address.Account__c != null) { 
		                    setAccountId.add(address.Account__c);
		            }
		        }
		      	
		      	Map<Id, Account> mapAccount = new Map<Id, Account>(
		      	[select Main_Address__c
		      			from 
		      			Account where 
		      			Id in :setAccountId]);
		    	
		    	//Si cambiaron una dirección a no principal 
		    	for (Address__c address : Trigger.new) {
		            Account a = mapAccount.get(address.Account__c);
		            if(a!=null){
			            if (address.id != null && address.Is_Main_Address__c==false) { 
			            	if(a.Main_Address__c == address.id) a.Main_Address__c=null; 
			            }
		            }
		        }
		        
		        //Si ya existe direccion principal, se deja como no principal.
		        for (Address__c address: Trigger.new) {
		            if (address.Is_Main_Address__c) { 
						 Account a = mapAccount.get(address.Account__c);       
						 if(a.Main_Address__c != address.id && a.Main_Address__c!=null){
						 	 address.Is_Main_Address__c = false;
						 }else{
						 	 a.Main_Address__c = address.id;
						 }
					}
		        }
		    }
		    	
		    if (Trigger.isAfter){
		    	//Traer las cuentas que se van a actualizar
		    	Set<Id> setAccountId = new Set<Id>();  
		    	for (Address__c address : Trigger.new) {
		            if (address.Account__c != null) { 
		                    setAccountId.add(address.Account__c);
		            }
		        }
		        
		        Map<Id, Account> mapAccount = new Map<Id, Account>(
		      	[select Main_Address__c
		      			from 
		      			Account where 
		      			Id in :setAccountId]);
		        
		        //En el before se aseguro que quede solo quede una dirección principal
		        Set<Id> setAccountIdChange = new  Set<Id>(); 
		        for (Address__c address : Trigger.new) {
		            if(address.Account__c != null){
			            Account a = mapAccount.get(address.Account__c);
			            if (address.Is_Main_Address__c) { 
							a.Main_Address__c = address.id;
							setAccountIdChange.add(a.Id);
			            }
			            if (!address.Is_Main_Address__c) { 
							 if(a.Main_Address__c == address.id){
							 	a.Main_Address__c = null;
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
    	if (Trigger.isAfter){
    		Address__c add = Trigger.new[0];
    		
    		if(add.Account__c!=null){
				Account acc = [select Main_Address__c
      			from 
      			Account where 
      			Id =: add.Account__c ];
      			if(add.Is_Main_Address__c){
      				if(acc.Main_Address__c!= add.id){
      					if(acc.Main_Address__c!=null){
      						Address__c add2 = [SELECT Is_Main_Address__c FROM Address__c WHERE id =:acc.Main_Address__c];
      						add2.Is_Main_Address__c = false;
      						update add2;
      					}
      					acc.Main_Address__c = add.id;
      					update acc;
      				}
      			}else{
      				if(acc.Main_Address__c== add.id ){
      					acc.Main_Address__c = null;
      					update acc;
      				}
      			}
     		}
    	}
    }

}