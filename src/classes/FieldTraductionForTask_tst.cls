@IsTest
private class FieldTraductionForTask_tst {
	
	static testMethod void test_one()
	{
		RecordType recordType = [select name from RecordType where name = 'Person Account'];
		
		//System.assert(recordType != null, true);
		
		Account acc = new Account();
		acc.LastName = 'Homer J Simpson';
		acc.RecordTypeId = recordType.Id;
		
		insert acc;
		
		Id userId = UserInfo.getUserId();
		
		Task task = new Task(status = 'Aberta', 
							Subject = 'SubjectTest', 
							description__c = 'Test', 
							priority = '?');
							
		insert task;
		
		task = [select status from task where Id = :task.Id];	
		
		//System.assert(task.status.equalsIgnoreCase('Open'), true);
		
		task.Status = 'em espera';
		
		try
		{
			update task;
			//System.assert( false );
		}
		catch( System.exception e )
		{
			//System.assert( true );
		}
		
		task.Status = '.';
		
		try
		{
			update task;
			//System.assert( false );
		}
		catch( System.exception e )
		{
			//System.assert( true );
		}
		
		translationMaps transMap = new translationMaps('TASK');
		
		transMap.getTranslation('?','?', '');
		transMap.getTranslation(null, null, null);
		
	}

}