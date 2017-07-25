trigger FieldTraductionForFAQ on FAQ__c (before insert, before update) {
    translationMaps transMap = new translationMaps('FAQ');
    
    for (FAQ__c faq : Trigger.new) {
        if (faq.Status__c != null) {
            String strTrad = transMap.getTranslation('FAQ','Status__c', faq.Status__c);
            if (strTrad == null) {
                faq.Status__c.addError('Valor inválido');
            } else {
                faq.Status__c = strTrad;
            }
        }
    }
}