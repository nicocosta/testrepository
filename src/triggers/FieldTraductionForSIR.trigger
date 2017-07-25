trigger FieldTraductionForSIR on Safety_Individual_Report__c (before insert, before update) {
    translationMaps transMap = new translationMaps('SIR'); 
    
        for (Safety_Individual_Report__c sir : Trigger.new) {
        if (sir.Hospitalized__c != null) {
            String strTrad = transMap.getTranslation('SIR','Hospitalized__c', sir.Hospitalized__c);
            if (strTrad == null) {
                //sir.Hospitalized__c.addError('Valor inválido');
            } else {
                sir.Hospitalized__c = strTrad;
            }
        } 
        if (sir.Reporter_allow_us_to_contact_physician__c != null) {
            String strTrad = transMap.getTranslation('SIR','Reporter_allow_us_to_contact_physician__c', sir.Reporter_allow_us_to_contact_physician__c);
            if (strTrad == null) {
                //sir.Reporter_allow_us_to_contact_physician__c.addError('Valor inválido');
            } else {
                sir.Reporter_allow_us_to_contact_physician__c = strTrad;
            }
        }
        if (sir.Reporter_allow_us_to_share_the_data__c != null) {
            String strTrad = transMap.getTranslation('SIR','Reporter_allow_us_to_share_the_data__c', sir.Reporter_allow_us_to_share_the_data__c);
            if (strTrad == null) {
                //sir.Reporter_allow_us_to_share_the_data__c.addError('Valor inválido');
            } else {
                sir.Reporter_allow_us_to_share_the_data__c = strTrad;
            }
        }
        if (sir.Subcase_seriousness__c != null) {
            String strTrad = transMap.getTranslation('SIR','Subcase_seriousness__c', sir.Subcase_seriousness__c);
            if (strTrad == null) {
                //sir.Subcase_seriousness__c.addError('Valor inválido');
            } else {
                sir.Subcase_seriousness__c = strTrad;
            }
        }
        
    }
}