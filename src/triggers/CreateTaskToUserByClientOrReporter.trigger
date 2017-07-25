trigger CreateTaskToUserByClientOrReporter on Account (after update) {
	/********************************************************************************
 		 La clase CreateTaskToUserByClientOrReporter define la lógica de este trigger 
   	*********************************************************************************/
	CreateTaskToUserByClientOrReporter cttu = new CreateTaskToUserByClientOrReporter();
	cttu.executeTrigger(Trigger.new, Trigger.old);
}