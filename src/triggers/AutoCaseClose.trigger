/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Daniel Delgado (DFDC)
	Project:			Novartis Brazil
	Description: 		Trigger for close Case when a SubCase is closed and no other SubCase related to the 
						parent Case remains open.
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		21-09-2010	Daniel Delgado (DFDC)		Create Trigger.
	****************************************************************************************************/
trigger AutoCaseClose on Case (after update)
{ 
	
	if( Trigger.new.size() == 1 )
	{
		Case SubCase = Trigger.new[0];
		//This functionality only applies for SubCases that are closed
		if( [ Select Count() From RecordType where id = :SubCase.RecordTypeId and Name = 'Subcase' ] == 1 && SubCase.IsClosed )
		{
			//This functionality applies only when the SubCase is recently closed
			if( SubCase.IsClosed != Trigger.old[0].IsClosed )
			{
				//The parent case must be closed only if it hasn't others SubCases open
				if( [	Select	Count()
						From	Case
						where	RecordTypeId = :SubCase.RecordTypeId and ParentId = :SubCase.ParentId and IsClosed = false ] == 0  )
				{
					Case ParentCase = new Case( Id = SubCase.ParentId );
					ParentCase.Status = 'Closed';
					Database.update(ParentCase, false);
				}
			}
		}
	}
}