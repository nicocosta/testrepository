trigger DuplicateGroupMemberValidation on Group_Member__c (before insert, before update)
{
	if( Trigger.isInsert )
	{
		if( [ Select Count() From Group_Member__c Where Group__c = :Trigger.new[0].Group__c and User__c = :Trigger.new[0].User__c ] != 0 )
			Trigger.new[0].addError( 'The user is already associated with this group.' );
		else
		{
			if( ![ Select isActive From User Where id = :Trigger.new[0].User__c ].isActive )
				Trigger.new[0].addError( 'The user has to be active to add it as a Group Member.' );
		}
	}
	else
	{
		if( [ Select Count() From Group_Member__c Where id != :Trigger.new[0].Id and  Group__c = :Trigger.new[0].Group__c and User__c = :Trigger.new[0].User__c ] != 0 )
			Trigger.new[0].addError( 'The user is already associated with this group.' );
		else
		{
			System.debug( '-*-*-*-* Trigger.new[0].Active__c: ' + Trigger.new[0].Active__c );
			if( ![ Select isActive From User Where id = :Trigger.new[0].User__c ].isActive && Trigger.new[0].Active__c )
				Trigger.new[0].addError( 'The user has to be active to add it as a Group Member.' );
		}
	}
}