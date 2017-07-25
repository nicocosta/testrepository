trigger FieldTraductionForAcount_tgr on Account (before insert, before update) {
    translationMaps transMap = new translationMaps('Account'); 
     
    for (Account objAccount : Trigger.new) {
        
        //Type__c 
        
        if (objAccount.Type__c != null) {
            
            String strTrad = transMap.getTranslation('Account', 'Type__c',objAccount.Type__c);
            
            if (strTrad == null) {
                objAccount.Type__c.addError('Valor inválido');
            } else {
                objAccount.Type__c  = strTrad;
            }
        }
        
        
        //Status__c
        //System.debug('ENTRO Status__c = '+ objAccount.Status__c);
        
        if (objAccount.Status__c != null) {
            
            
            String strTrad = transMap.getTranslation('Account', 'Status__c',objAccount.Status__c);
        //System.debug('SALIO Status__c = '+ strTrad);
            if (strTrad == null) {
                objAccount.Status__c.addError('Valor inválido');
            } else {
                objAccount.Status__c = strTrad;
            }
        }
        
        //Do_you_want_Novartis_contact_you__c
        
        if (objAccount.Do_you_want_Novartis_contact_you__c != null) {
            
            String strTrad = transMap.getTranslation('Account', 'Do_you_want_Novartis_contact_you__c',objAccount.Do_you_want_Novartis_contact_you__c);
            
            if (strTrad == null) {
                objAccount.Do_you_want_Novartis_contact_you__c.addError('Valor inválido');
            } else {
                objAccount.Do_you_want_Novartis_contact_you__c = strTrad;
            }
        }
         
                
         
    }
}