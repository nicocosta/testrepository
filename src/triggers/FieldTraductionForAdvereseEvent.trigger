trigger FieldTraductionForAdvereseEvent on Adverse_Event__c (before insert, before update) {
    translationMaps transMap = new translationMaps('AdverseEvent');
    
    for (Adverse_Event__c Adverse : Trigger.new) {
        if (Adverse.Event_Seriousness__c != null) {
            String strTrad = transMap.getTranslation('AdverseEvent','Event_Seriousness__c', Adverse.Event_Seriousness__c);
            if (strTrad == null) {
                Adverse.Event_Seriousness__c.addError('Valor inválido');
            } else {
                Adverse.Event_Seriousness__c = strTrad;
            }
        }
    }
    
}