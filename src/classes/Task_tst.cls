/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Pablo Gracia
	Project:			Novartis Brazil
	Description: 		Test's task_ctr.
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		21-11-2011	Juan Pablo Gracia			Create class.
	****************************************************************************************************/
@isTest(seeAllData=true)
private class Task_tst {

    static testMethod void myUnitTest() {
        Task task = new Task();
        task.Subject = 'test subject';
        task.Description__c = 'test description';
        task.Status = 'Canceled';
        task.Justification__c = 'test justification';
		ApexPages.StandardController sc = new ApexPages.standardController(task);
		Task_ctr taskctr = new Task_ctr(sc);
		taskctr.btnSave();
	}
	
	 static testMethod void myUnitTest2() {
        Task task = new Task();
        task.Subject = 'test subject';
        task.Description__c = 'test description';
        task.Status = 'Canceled';
        task.Justification__c = 'test justification';
        insert task;
		ApexPages.StandardController sc = new ApexPages.standardController(task);
		Task_ctr taskctr = new Task_ctr(sc);
		taskctr.btnSave();
	}
	
	
}