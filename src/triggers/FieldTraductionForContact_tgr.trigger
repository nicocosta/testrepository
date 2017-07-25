trigger FieldTraductionForContact_tgr on Contact (before insert, before update) {
    translationMaps transMap = new translationMaps('Contact'); 
     
    for (Contact objcontact : Trigger.new) {
        
        //Salutation
        
        if (objcontact.Salutation != null) {
            
            String strTrad = transMap.getTranslation('Contact', 'Salutation',objcontact.Salutation);
            if (strTrad == null) {
                objcontact.Salutation.addError('Valor inválido');
            } else {
                objcontact.Salutation = strTrad;
            }
        }
        
        
        //Gender
        if (objcontact.Gender__c != null) {
            
            String strTrad = transMap.getTranslation('Contact', 'Gender__c',objcontact.Gender__c);
            if (strTrad == null) {
                objcontact.Gender__c.addError('Valor inválido');
            } else {
                objcontact.Gender__c= strTrad;
            }
        }
        
        
        //Occupation_Specialty__c
        
        if (objcontact.Occupation_Specialty__c != null) {
            
            String strTrad = transMap.getTranslation('Contact', 'Occupation_Specialty__c',objcontact.Occupation_Specialty__c);
            if (strTrad == null) {
                objcontact.Occupation_Specialty__c.addError('Valor inválido');
            } else {
                objcontact.Occupation_Specialty__c= strTrad;
            }
        }
        
        //Specialty__c
        
        if (objcontact.Specialty__c != null) {
            
            String strTrad = transMap.getTranslation('Contact', 'Specialty__c',objcontact.Specialty__c);
            if (strTrad == null) {
                objcontact.Specialty__c.addError('Valor inválido');
            } else {
                objcontact.Specialty__c= strTrad;
            }
        }
        
        
        
    }

 
}