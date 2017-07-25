trigger InactiveGroupMemberCheck on User (after update)
{
    Map<String, User> mapUsersById = new Map<String, User>();
    List<Group_Member__c> lstGroupMembers = new List<Group_Member__c>();
    
    for( Integer i = 0; i < Trigger.new.size(); i++ )
    {
        if( Trigger.new[i].IsActive != Trigger.old[i].IsActive )
            mapUsersById.put( Trigger.new[i].Id, Trigger.new[i] );
    }
    
    for( Group_Member__c gm : [ Select Group_Leader__c, Active__c, User__c From Group_Member__c Where User__c IN :mapUsersById.keySet() ] )
    {
        if( gm.Group_Leader__c && !mapUsersById.get( gm.User__c ).IsActive )
            mapUsersById.get( gm.User__c ).addError( 'This user is a Group Leader and cannot be inactive.' );
        else
        {
            gm.Active__c = mapUsersById.get( gm.User__c ).IsActive;
            lstGroupMembers.add( gm );
        }
    }
    
    update lstGroupMembers;
}