/****************************************************************************************************
    General Information
    -------------------
    Developer:          Avanxo Colombia
    Autor:              Juan Pablo Gracia
    Project:            Novartis Brazil
    Description:        Validate whether the cases can be edited.
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     07-03-2011  Juan Pablo Gracia           Create trigger.
    ****************************************************************************************************/
trigger ValidateCaseEdition on Case (before insert, before update) 
{
    if(Trigger.isInsert){
        ValidateCaseEdition.executeInsert = true;
    }
    if(Trigger.isUpdate && !ValidateCaseEdition.executeInsert && !ValidationSIREdition.executeInsert){
        ValidateCaseEdition vce = new ValidateCaseEdition();
        list<Case> cases = vce.validateCasesChanges(Trigger.new, Trigger.old);
        Map<ID,String> validationMap = vce.validateEdition(cases, Userinfo.getProfileId());
        //for(Case c:Trigger.new){
        
        List<Id> lstCaseIds= new List<Id>();
        
        for(Case objCase: Trigger.old)
        {
            lstCaseIds.add(objCase.Id);
        }
        Map<String,Case> mapCases= new Map<String,Case>();
        
        for(Case objCase:[Select Id, Subcase_Description__c from Case where Id in : lstCaseIds])
        {
            mapCases.put(objCase.Id, objCase);
        }
        
        for(integer i =0; i< Trigger.new.size(); i++ )
        {
            System.Debug('DebugLine 26: ValidateCaseEditionTrigger: caseNew.Subcase_Description__c: '+Trigger.new[0].Subcase_Description__c+', caseOld.Subcase_Description__c: '+Trigger.old[0].Subcase_Description__c);
                            
            String error = validationMap.get(Trigger.new.get(i).Id);
            if(error!=null)
            {
                if (
                    (Trigger.new[0].get('QC_number_Technical_Claim_Number__c') == Trigger.old[0].get('QC_number_Technical_Claim_Number__c')) &&
                    (Trigger.new[0].get('QC_number_Technical_Claim_Number_sample__c') == Trigger.old[0].get('QC_number_Technical_Claim_Number_sample__c')) &&
                    (Trigger.new[0].get('Complaint_investigation_results__c') == Trigger.old[0].get('Complaint_investigation_results__c')) &&
                    (Trigger.new[0].get('Complaint_investigation_results_sample__c') == Trigger.old[0].get('Complaint_investigation_results_sample__c')) &&
                    (Trigger.new[0].get('Complaint_Response__c') == Trigger.old[0].get('Complaint_Response__c')) &&
                    (Trigger.new[0].get('Complaint_response_sample__c') == Trigger.old[0].get('Complaint_response_sample__c')) &&
                    (Trigger.new[0].get('Person_identification_number_CPF__c') == Trigger.old[0].get('Person_identification_number_CPF__c')) &&
                    (Trigger.new[0].get('Phone__c') == Trigger.old[0].get('Phone__c')) &&
                    (Trigger.new[0].get('Price__c') == Trigger.old[0].get('Price__c')) &&
                    (Trigger.new[0].get('Address__c') == Trigger.old[0].get('Address__c')) &&
                    (Trigger.new[0].get('Agency_number__c') == Trigger.old[0].get('Agency_number__c')) &&
                    (Trigger.new[0].get('Bank_Name__c') == Trigger.old[0].get('Bank_Name__c')) &&
                    (Trigger.new[0].get('Bank_Account_Name__c') == Trigger.old[0].get('Bank_Account_Name__c')) &&
                    (Trigger.new[0].get('Bank_Account_number__c') == Trigger.old[0].get('Bank_Account_number__c')) 
                   )
                {   
                    Trigger.new.get(i).addError(error);
                }
            }
            else
            {
                //Si el perfil es o "PV" o "SIC 2nd level"
                //JGDP. 29-08-2013. Cambio configuración personaliza para incluir más de un perfil
                List<FV_Profile_Config__c> vfpc = FV_Profile_Config__c.getall().values();
                set<String> lstIdProfiles = new set<String>();
                for( FV_Profile_Config__c objFV :vfpc )
                {
                  lstIdProfiles.add(objFV.IdProfile__c);
                }
                
                List<TDS_Profile_Config__c> configTDS = TDS_Profile_Config__c.getall().values();
                set<String> lstIdTDS = new set<String>();
                for( TDS_Profile_Config__c objConfig :configTDS )
                {
                  lstIdTDS.add(objConfig.IdProfile__c);
                }
        
                id fvProfileIdTwo = FV_Setup__c.getInstance().Id_2nd_Level__c;
                id fvProfileIdOnco = FV_Setup__c.getInstance().SICOncology__c;
                id fvProfileIdSICVacinas = FV_Setup__c.getInstance().SICVacinas__c;                
                System.Debug('DebugLine 35: ValidateCaseEditionTrigger: caseNew.Subcase_Description__c: '+Trigger.new[0].Subcase_Description__c+', caseOld.Subcase_Description__c: '+Trigger.old[0].Subcase_Description__c);
                
                if( lstIdProfiles.contains(Userinfo.getProfileId()) || fvProfileIdTwo==Userinfo.getProfileId() || fvProfileIdOnco==Userinfo.getProfileId() || fvProfileIdSICVacinas==Userinfo.getProfileId() || lstIdTDS.contains(Userinfo.getProfileId()) )
                {                                       //Si se edito el campo Subcase description lanzar error
                    if (mapCases.containsKey(Trigger.new.get(i).Id) && vce.isEditSubcaseDescriptionFieled(Trigger.new.get(i),mapCases.get(Trigger.new.get(i).Id))&&Trigger.new.get(i).Case_Type__c==System.Label.Farmacovigilancia)
                    {
                        System.Debug('DebugLine 59: ValidateCaseEditionTrigger: mapCases.get(Trigger.new.get(i).Id)): '+mapCases.get(Trigger.new.get(i).Id));
                        
                        Trigger.new.get(i).Subcase_Description__c.addError(System.label.YouCantEditField);//Label
                    }
                                        
                }
                
            }
            
        }
        
    }
}