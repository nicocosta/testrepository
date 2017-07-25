@isTest
private class DuplicateGroupMemberValidation_tst
{
	static testMethod void DuplicateGroupMemberValidationTest()
	{
		Group__c g = new Group__c();
		insert g;
		
		Group_Member__c gm1 = new Group_Member__c();
		gm1.User__c = UserInfo.getUserId();
		gm1.Group__c = g.Id;
		gm1.Active__c = true;
		try
		{
			insert gm1;
			System.assert( true );
		}
		catch( System.Exception e )
		{
			System.assert( false );
		}
		
		Group_Member__c gm2 = new Group_Member__c();
		gm2.User__c = UserInfo.getUserId();
		gm2.Group__c = g.Id;
		gm2.Active__c = true;
		try
		{
			insert gm2;
			System.assert( false );
		}
		catch( System.Exception e )
		{
			System.assert( true );
		}
	}
}