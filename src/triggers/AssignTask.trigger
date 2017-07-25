/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Pablo Gracia
	Project:			Novartis Brazil
	Description: 		Assign Task to Group member lider.
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		22-11-2011	Juan Pablo Gracia			Create class.
	****************************************************************************************************/
trigger AssignTask on Task (before insert, before update) {
	AssignTask at = new AssignTask();
	at.AssignTask(Trigger.new,Trigger.old);
}