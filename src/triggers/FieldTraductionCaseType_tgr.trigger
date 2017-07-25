trigger FieldTraductionCaseType_tgr on Case_Type__c (before insert, before update) {
    translationMaps transMap = new translationMaps('CaseType'); 
     
    for (Case_Type__c objCase_Type : Trigger.new) {
         
        //Subcase_type__c 
        
        if (objCase_Type.Subcase_type__c != null) {
            
            String strTrad = transMap.getTranslation('CaseType', 'Subcase_type__c',objCase_Type.Subcase_type__c);
            if (strTrad == null) {
                objCase_Type.Subcase_type__c.addError('Valor inválido');
            } else {
                objCase_Type.Subcase_type__c  = strTrad;
            }
        }
        
        
        //Theme__c 
        
        if (objCase_Type.Theme__c != null) {
            
            String strTrad = transMap.getTranslation('CaseType', 'Theme__c',objCase_Type.Theme__c);
            if (strTrad == null) {
                objCase_Type.Theme__c.addError('Valor inválido');
            } else {
                objCase_Type.Theme__c  = strTrad;
            }
        }
        
        //Subcase_subtype__c 
        
        if (objCase_Type.Subcase_subtype__c != null) {
            
            String strTrad = transMap.getTranslation('CaseType', 'Subcase_subtype__c',objCase_Type.Subcase_subtype__c);
            if (strTrad == null) {
                objCase_Type.Subcase_subtype__c.addError('Valor inválido');
            } else {
                objCase_Type.Subcase_subtype__c  = strTrad;
            }
        }
        
    }

}