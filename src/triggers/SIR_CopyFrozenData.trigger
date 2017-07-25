trigger SIR_CopyFrozenData on Safety_Individual_Report__c (before insert, before update)
{
    if (Userinfo.getProfileId() == '00eA0000000tn2OIAQ') return;
  
    Map<String, Account> mapAccountById;
    List<String> lstAccountsToSearch = new List<String>();
    for( Integer i = 0; i < Trigger.new.size(); i++ )
    {
        if( Trigger.new[i].Client_Name__c != null && ( 
            Trigger.isInsert || ( Trigger.isUpdate && Trigger.old[i].Client_Name__c != Trigger.new[i].Client_Name__c ) ) )
            lstAccountsToSearch.add( Trigger.new[i].Client_Name__c );
        if( Trigger.new[i].Patient_Name__c != null && ( 
            Trigger.isInsert || ( Trigger.isUpdate && Trigger.old[i].Patient_Name__c != Trigger.new[i].Patient_Name__c ) ) )
            lstAccountsToSearch.add( Trigger.new[i].Patient_Name__c );
    }
    
    mapAccountById = new Map<String,Account>( [ Select  Id, Name, PersonBirthdate, Gender__pc, Occupation_Specialty__pc
                                                From    Account
                                                Where   Id IN :lstAccountsToSearch ] );
    
    for( Integer i = 0; i < Trigger.new.size(); i++ )
    {
        Account acc;
        if( Trigger.new[i].Client_Name__c != null && ( 
            Trigger.isInsert || ( Trigger.isUpdate && Trigger.old[i].Client_Name__c != Trigger.new[i].Client_Name__c ) ) )
        {
            acc = mapAccountById.get( Trigger.new[i].Client_Name__c );
            Trigger.new[i].Client_Name_Frozen__c = acc.Name;
            Trigger.new[i].Client_Profession_Frozen__c = acc.Occupation_Specialty__pc;
        }
        if( Trigger.new[i].Patient_Name__c != null && ( 
            Trigger.isInsert || ( Trigger.isUpdate && Trigger.old[i].Patient_Name__c != Trigger.new[i].Patient_Name__c ) ) )
        {
            acc = mapAccountById.get( Trigger.new[i].Patient_Name__c );
            Trigger.new[i].Patient_Name_Frozen__c = acc.Name;
            Trigger.new[i].Patient_Birthdate_Frozen__c = acc.PersonBirthdate;
            Trigger.new[i].Patient_Gender_Frozen__c = acc.Gender__pc;
        }
    }
}