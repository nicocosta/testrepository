trigger Reporter_CopyFrozenData on Reporter__c (before insert, before update)
{
	Map<String, Account> mapAccountById;
	List<String> lstAccountsToSearch = new List<String>();
	for( Integer i = 0; i < Trigger.new.size(); i++ )
	{
		if( Trigger.new[i].Reporter_related_name__c != null )
		{
			if( Trigger.isInsert || ( Trigger.isUpdate && Trigger.old[i].Reporter_related_name__c != Trigger.new[i].Reporter_related_name__c ) )
				lstAccountsToSearch.add( Trigger.new[i].Reporter_related_name__c );
		}
	}
	
	mapAccountById = new Map<String,Account>( [ Select	Id, Name, Occupation_Specialty__pc
												From	Account
												Where	Id IN :lstAccountsToSearch ] );
	
	for( Integer i = 0; i < Trigger.new.size(); i++ )
	{
		Account acc;
		if( Trigger.new[i].Reporter_related_name__c != null && ( 
			Trigger.isInsert || ( Trigger.isUpdate && Trigger.old[i].Reporter_related_name__c != Trigger.new[i].Reporter_related_name__c ) ) )
		{
			acc = mapAccountById.get( Trigger.new[i].Reporter_related_name__c );
			Trigger.new[i].Reporter_Name_Frozen__c = acc.Name;
			Trigger.new[i].Reporter_Profession_Frozen__c = acc.Occupation_Specialty__pc;
		}
	}
}