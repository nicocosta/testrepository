/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Pablo Gracia
	Project:			Novartis Brazil
	Description: 		AssignTask's Test.
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		28-11-2011	Juan Pablo Gracia			Create class.
	****************************************************************************************************/
@isTest
private class AssignTask_tst {
	static testmethod void generalTest(){
		
		Group__c grouptst = new Group__c();
		grouptst.Name = 'test';
		insert grouptst;
		
		Group_Member__c groupMemberTst = new Group_Member__c();
		groupMemberTst.User__c = UserInfo.getUserId();
		groupMemberTst.Group__c = grouptst.id;
		groupMemberTst.Group_Leader__c = true;
		insert groupMemberTst;
		Test.startTest();
		Task task = new Task();
		task.Group_Id__c = grouptst.Id;
		insert task;
		
		grouptst = new Group__c();
		grouptst.Name = 'test';
		insert grouptst;
		
		groupMemberTst = new Group_Member__c();
		groupMemberTst.User__c = UserInfo.getUserId();
		groupMemberTst.Group__c = grouptst.id;
		groupMemberTst.Group_Leader__c = true;
		insert groupMemberTst;
		Test.stopTest();
		task.Group_Id__c = grouptst.Id;
		update task;
	}
}