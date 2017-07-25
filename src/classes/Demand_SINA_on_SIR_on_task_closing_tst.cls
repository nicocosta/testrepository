/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Pablo Gracia
	Project:			Novartis Brazil
	Description: 		trigger Demand_SINA_on_SIR_on_task_closing's Test.
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		10-03-2011	Juan Pablo Gracia			Create class.
	****************************************************************************************************/
@isTest
private class Demand_SINA_on_SIR_on_task_closing_tst {
	
	static testmethod void generalTest(){
	  SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
	  User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
	  System.runAs ( userWhitAutorization ) {
	    CreateTestObjects co = new CreateTestObjects();
	    co.createObjects();
	    Test.startTest();
	    //Actualización correcta
	    Task task = co.createTask(co.subCase.Id, co.stage.Id, co.taskOpenStatus);
	    task.status = co.taskCloseStatus;
	    try{
	    	update task;
	    	
	    }catch(Exception e){
	    }
	    Test.stopTest();
	  }
	}
}