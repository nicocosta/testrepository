/****************************************************************************************************
    General Information
    -------------------
    Developer:          Avanxo Colombia
    Autor:              Juan Pablo Gracia
    Project:            Novartis Brazil
    Description:        Validate whether the SIR can be edited.
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     08-03-2011  Juan Pablo Gracia           Create class.
    ****************************************************************************************************/
trigger ValidationSIREdition on Safety_Individual_Report__c (before insert, before update) {
    if (Userinfo.getProfileId() == '00eA0000000tn2OIAQ') return;
    
    if(Trigger.isInsert){
        ValidationSIREdition.executeInsert = true;
    }
    if(Trigger.isUpdate && !ValidationSIREdition.executeInsert){
        ValidationSIREdition vse = new ValidationSIREdition();
        Map<ID,String> validationMap = vse.validateEdition(Trigger.old, Userinfo.getProfileId());
        //for(Safety_Individual_Report__c c:Trigger.new){
        for(Integer i=0;i<Trigger.new.size();i++){
            String error = validationMap.get(Trigger.new[i].Id);
            if(error!=null){ 
                System.debug('*************' + error);
                Trigger.new[i].addError(error);
            }else{
                //JGDP. 29-08-2013. Cambio configuración personaliza para incluir más de un perfil
                List<FV_Profile_Config__c> vfpc = FV_Profile_Config__c.getall().values();
                set<String> lstIdProfiles = new set<String>();
                for( FV_Profile_Config__c objFV :vfpc )
                {
                  lstIdProfiles.add(objFV.IdProfile__c);
                }
                
                if( lstIdProfiles.contains(Userinfo.getProfileId()) ){
                    String newValue='';
                    if(Trigger.new[i].Second_level_description__c!=null)newValue=Trigger.new[i].Second_level_description__c.replace('\n','').replace('\r','');
                    String oldValue='';
                    if(Trigger.old[i].Second_level_description__c!=null)oldValue=Trigger.old[i].Second_level_description__c.replace('\n','').replace('\r','');
                    if(newValue!=null && !newValue.equalsIgnoreCase(oldValue)){
                        System.debug('****Error');
                        Trigger.new[i].Second_level_description__c.addError(Label.YouCantEditField);
                    }
                }
            
            }
        }
    }

}