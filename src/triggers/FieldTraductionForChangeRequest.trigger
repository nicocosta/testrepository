trigger FieldTraductionForChangeRequest on Change_Request__c (before insert, before update) {
    translationMaps transMap = new translationMaps('ChangeRequest');
    
    for (Change_Request__c change : Trigger.new) {
        if (change.Visit_type__c != null) {
            String strTrad = transMap.getTranslation('ChangeRequest','Visit_type__c', change.Visit_type__c);
            if (strTrad == null) {
                change.Visit_type__c.addError('Valor inválido');
            } else {
                change.Visit_type__c = strTrad;
            }
        }
        if (change.Status__c != null) {
            String strTrad = transMap.getTranslation('ChangeRequest','Status__c', change.Status__c);
            if (strTrad == null) {
                change.Status__c.addError('Valor inválido');
            } else {
                change.Status__c = strTrad;
            }
        }
    }
    
}