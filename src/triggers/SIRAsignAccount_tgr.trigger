/****************************************************************************************************
    General Information
    -------------------
    Developer:          Avanxo Colombia
    Autor:              Mario Chaves (MCH)
    Project:            Novartis Brazil
    Description:        Asign Account from subcases on SIR field. 
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     24-09-2010  Mario Chaves (MCH)      Create Trigger.
    1.1     15-06-2011  Juan Pablo Gracia       Modify by frozen fields
    ****************************************************************************************************/


trigger SIRAsignAccount_tgr on Safety_Individual_Report__c (before insert) {
    if (Userinfo.getProfileId() == '00eA0000000tn2OIAQ') return;
    
    Set<Id> setCasesId = new Set<Id>();
    
    for (Safety_Individual_Report__c sir : Trigger.new) {
        if (sir.Subcase_Number__c != null)
            setCasesId.add(sir.Subcase_Number__c);
    }
    
    Map<Id, Case> mapCases = new Map<Id, Case>([select patient_name__c, patient_name__r.LastName, patient_name__r.Gender__pc,patient_name__r.PersonBirthdate , AccountId, Account.LastName,Account.Occupation_Specialty__pc from case where id in :setCasesId]);
    

    
    for (Safety_Individual_Report__c sir: Trigger.new) {
        Case case0 = mapCases.get(sir.Subcase_Number__c);
        if (case0 != null) {
            sir.Client_Name__c = case0.AccountId;
            sir.Patient_Name__c = case0.patient_name__C;
            
            ///JPG  15-06-2011
            sir.Client_Name_Frozen__c = case0.Account.LastName;
            sir.Client_Profession_Frozen__c = case0.Account.Occupation_Specialty__pc;
            sir.Patient_Name_Frozen__c = case0.patient_name__r.LastName;
            sir.Patient_Birthdate_Frozen__c = case0.patient_name__r.PersonBirthdate;
            sir.Patient_Gender_Frozen__c = case0.patient_name__r.Gender__pc;
            System.debug('******case0.patient_name__C:' + case0.patient_name__c);
        }
    }
    System.debug( 'TST:: Trigger.new[0] = ' + Trigger.new[0] );
    /*

    for(Safety_Individual_Report__c newSIR:trigger.new)
    {
        Case theSubCase=[select patient_name__C, AccountId from case where id=:newSIR.Subcase_Number__c ];
        
        if(theSubCase!=null)
        {
            newSIR.Client_Name__c=theSubcase.AccountId;
            newSIR.Patient_Name__c=theSubCase.patient_name__C;
        }
    } */

}