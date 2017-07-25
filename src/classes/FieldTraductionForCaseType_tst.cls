public class FieldTraductionForCaseType_tst {
    static testMethod void test_one()
	{
		
		 
		Case_Type__c objCase_Type =new Case_Type__c();
		objCase_Type.Subcase_type__c='Eulogy123';
		objCase_Type.Theme__c='Victorious123';
		objCase_Type.Subcase_subtype__c='commercial123';
		
		try
		{
			insert objCase_Type;
			//System.assert( false );
		}
		catch( System.exception e )
		{
			//System.assert( true );
		}
		
		objCase_Type.Subcase_type__c='Eulogy';
		objCase_Type.Theme__c='Victorious';
		objCase_Type.Subcase_subtype__c='Request User';
		
		//insert objCase_Type;
	}

}