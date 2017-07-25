trigger FieldTraductionForPhone_tgr on Phone__c (before insert, before update) {
 translationMaps transMap = new translationMaps('Phone'); 
     
    for (Phone__c objAddress : Trigger.new) {
         
        //Status__c 
        
        if (objAddress.Status__c != null) {
            
            String strTrad = transMap.getTranslation('Phone', 'Status__c',objAddress.Status__c);
            if (strTrad == null) {
                objAddress.Status__c.addError('Valor inválido');
            } else {
                objAddress.Status__c  = strTrad;
            }
        }
        
        //Type__c 
        if (objAddress.Type__c != null) {
            
            String strTrad = transMap.getTranslation('Phone', 'Type__c',objAddress.Type__c);
            if (strTrad == null) {
                objAddress.Type__c.addError('Valor inválido');
            } else {
                objAddress.Type__c  = strTrad;
            }
        }
      
 
        //Main_Phone__c 
        if (objAddress.Main_Phone__c != null) {
            
            String strTrad = transMap.getTranslation('Phone', 'Main_Phone__c',objAddress.Main_Phone__c);
            if (strTrad == null) {
                objAddress.Main_Phone__c.addError('Valor inválido');
            } else {
                objAddress.Main_Phone__c  = strTrad;
            }
        }
 
 
    }
 
}