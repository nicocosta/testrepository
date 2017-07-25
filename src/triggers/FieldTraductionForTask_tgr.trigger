trigger FieldTraductionForTask_tgr on Task (before insert, before update) {
    
    translationMaps transMap = new translationMaps('TASK'); 
    
    for ( Task t : Trigger.new ) {
        if ( t.Status != null ) {
            System.debug( 'MIGRATIONID: ' + t.Migration_Id__c );
            String strTrad = transMap.getTranslation('TASK','STATUS', t.Status);
            System.debug( 'strTrad: ' + strTrad );
            if (strTrad == null) {
                //t.Status.addError('Valor inválido');
            } else {
                t.Status = strTrad;
            }
        }
    }
}