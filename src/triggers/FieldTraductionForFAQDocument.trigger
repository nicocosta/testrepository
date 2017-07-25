trigger FieldTraductionForFAQDocument on FAQ_document__c (before insert, before update) {
    translationMaps transMap = new translationMaps('FAQ_X_Document');
    
    for (FAQ_document__c faqD : Trigger.new) {
        if (faqD.Status__c != null) {
            String strTrad = transMap.getTranslation('FAQ_X_Document','Status__c', faqD.Status__c);
            if (strTrad == null) {
                faqD.Status__c.addError('Valor inválido');
            } else {
                faqD.Status__c = strTrad;
            }
        }
    }
}