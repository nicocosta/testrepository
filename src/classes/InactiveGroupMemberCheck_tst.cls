@isTest
private class InactiveGroupMemberCheck_tst
{
	static testMethod void inactiveTest()
	{
		User usr1 = [ Select IsActive From User Where id != :UserInfo.getUserId() and isActive = true limit 1 ];
		User usr2 = [ Select Id From User Where id != :UserInfo.getUserId() and id != : usr1.Id and isActive = true limit 1];
		User usr3 = [ Select Id From User Where id != :UserInfo.getUserId() and id != : usr1.Id and id != :usr2.Id and isActive = true limit 1];
		
		List<Group_Member__c> lstMiembrosGrupos = new List<Group_Member__c>();
		Set<String> setGrupos = new Set<String>();
		List<Group__c> lstGrupos = new List<Group__c>();
		for( Group_Member__c gm : [ Select Id, Group__c From Group_Member__c Where User__c = :usr1.Id or User__c = :usr3.Id ] )
		{
			lstMiembrosGrupos.add( gm );
			setGrupos.add( gm.Group__c );
		}
		
		for( Group__c g : [ Select Active__c, Id From Group__c Where id IN :setGrupos ] )
		{
			g.Active__c = false;
			lstGrupos.add( g );
		}
		
		update lstGrupos;
		delete lstMiembrosGrupos;
		
		System.debug( '*/*/*/*/*/*/ Acá empieza la prueba' );
		System.Test.startTest();
		Group__c g = new Group__c();
		insert g;
		
		Group_Member__c gm = new Group_Member__c();
		gm.Group_Leader__c = false;
		gm.Active__c = true;
		gm.Group__c = g.Id;
		gm.User__c = usr1.Id;
		insert gm;
		
		System.assertEquals( true, [ Select Active__c From Group_Member__c Where id = :gm.Id].Active__c );
		
		System.runAs( usr2 )
		{
			usr1.IsActive = false;
			update usr1;
			
			System.assertEquals( false, [ Select Active__c From Group_Member__c Where id = :gm.Id].Active__c );
			
			try
			{
				gm.Group_Leader__c = true;
				update gm;
				System.assert( false );
			}
			catch( System.exception e )
			{
				System.assert( true );
			}
			
			usr1.IsActive = true;
			update usr1;
			
			gm.Group_Leader__c = true;
			update gm;
			
			try
			{
				usr1.IsActive = false;
				update usr1;
				System.assert( false );
			}
			catch( System.exception e )
			{
				System.assert( true );
			}
			
			usr3.IsActive = false;
			update usr3;
			
			Group_Member__c gm1 = new Group_Member__c();
			gm1.Group_Leader__c = false;
			gm1.Active__c = true;
			gm1.Group__c = g.Id;
			gm1.User__c = usr3.Id;
			try
			{
				insert gm1;
				System.assert( false );
			}
			catch( System.exception e )
			{
				System.assert( true );
			}
			
			usr3.IsActive = true;
			update usr3;
			insert gm1;
			
			try
			{
				gm.User__c = usr3.Id;
				update gm;
				System.assert( false );
			}
			catch( System.exception e )
			{
				System.assert( true );
			}
			
			gm1 = new Group_Member__c();
			gm1.Group_Leader__c = false;
			gm1.Active__c = true;
			gm1.Group__c = g.Id;
			gm1.User__c = usr3.Id;
			try
			{
				insert gm1;
				System.assert( false );
			}
			catch( System.exception e )
			{
				System.assert( true );
			}
		}
		System.Test.stopTest();
	}
}