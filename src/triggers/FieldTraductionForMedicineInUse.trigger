trigger FieldTraductionForMedicineInUse on Medicines_in_use__c (before insert, before update) {
    translationMaps transMap = new translationMaps('medicinesinuse');
    
    for (Medicines_in_use__c Medicines : Trigger.new) {
        if (Medicines.Suspect_Products__c != null) {
            String strTrad = transMap.getTranslation('medicinesinuse','Suspect_Products__c', Medicines.Suspect_Products__c);
            if (strTrad == null) {
                //Medicines.Suspect_Products__c.addError('Valor inválido');
            } else {
                Medicines.Suspect_Products__c = strTrad;
            }
        }
        if (Medicines.Administration_route__c != null) {
            String strTrad = transMap.getTranslation('medicinesinuse','Administration_route__c', Medicines.Administration_route__c);
            if (strTrad == null) {
                //Medicines.Administration_route__c.addError('Valor inválido');
            } else {
                Medicines.Administration_route__c = strTrad;
            }
        }
        if (Medicines.Ongoing__c != null) {
            String strTrad = transMap.getTranslation('medicinesinuse','Ongoing__c', Medicines.Ongoing__c);
            if (strTrad == null) {
                //Medicines.Ongoing__c.addError('Valor inválido');
            } else {
                Medicines.Ongoing__c = strTrad;
            }
        }
    }
}