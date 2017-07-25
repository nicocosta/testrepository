trigger SubcaseTask on Case (before update,before insert) 
{
    if(Trigger.new.size()==1)
    {
        SubcaseTask_cls uptSubcase = new SubcaseTask_cls();
        
        if (Trigger.isUpdate && (RecordTypesId__c.getInstance('Subcase').RecordTypeId__c == Trigger.new[0].RecordTypeId))
        {
            if (
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
                uptSubcase.CheckTask(Trigger.new[0]);
            }
        }
        else
           uptSubcase.CheckTask(Trigger.new[0]);
        
        SirUpdateTaskCheck_cls checkCase= new SirUpdateTaskCheck_cls();
        SubcaseTgrTaskSetUp__c conf = SubcaseTgrTaskSetUp__c.getInstance();
        
        if(Trigger.isUpdate&&RecordTypesId__c.getInstance('Subcase').RecordTypeId__c==Trigger.new[0].RecordTypeId)
        {
            //JPG 04-04-2011
            //Solo se valida si se cambia en campos diferentes a Status
            Map<String, Schema.SObjectField> M = Schema.SObjectType.Case.fields.getMap();
            for (String str : M.keyset()) {
                if(Trigger.new[0].get(str) != Trigger.old[0].get(str) && str!='Status')
                {
                    if (UserInfo.getProfileId() != conf.TdSAnalystProfileId__c )
                    {
                        if 
                        (
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
                            checkCase.CaseUpdateTaskCheck(Trigger.new[0]);
                        }
                    }
                    return;
                }
            }
            //Antes:
            //checkCase.CaseUpdateTaskCheck(Trigger.new[0]);
        }
    }
    
}