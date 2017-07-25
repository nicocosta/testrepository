trigger FieldTraductionForAdress_tgr on Address__c (before insert, before update) {
   
   translationMaps transMap = new translationMaps('Address');
    //clsTrans transMap=new clsTrans();
        
        
    for (Address__c objAddress : Trigger.new) {
        
        //Status__c 
           System.debug('ENTRO Status__c = '+ objAddress.Status__c);        
        
        if (objAddress.Status__c != null) {
            String strTrad = transMap.getTranslation('Address', 'Status__c',objAddress.Status__c);
            System.debug('SALIO Status__c = '+ strTrad);
            if (strTrad == null) {
                objAddress.Status__c.addError('Valor inválido');
            } else {
                objAddress.Status__c  = strTrad;
            }
        }
        
        
        
         
        //Type__c 
        if (objAddress.Type__c != null) {
            System.debug('ENTRO  Type__c= '+ objAddress.Type__c);       
            String strTrad = transMap.getTranslation('Address', 'Type__c',objAddress.Type__c);
            System.debug('SALIO Type__c = '+ strTrad);
            
            if (strTrad == null) {
                objAddress.Type__c.addError('Valor inválido');
            } else {
                objAddress.Type__c  = strTrad;
            }
        }
    
    }
    
}