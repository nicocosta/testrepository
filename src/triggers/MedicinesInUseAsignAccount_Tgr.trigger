/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Mario Chaves (MCH)
	Project:			Novartis Brazil
	Description: 		Asign Account from Adverse_Event__c on Medicines_in_use field. 
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		24-09-2010	Mario Chaves (MCH)		Create Trigger.
	****************************************************************************************************/

trigger MedicinesInUseAsignAccount_Tgr on Medicines_in_use__c (before insert) {

	Map<String,List<Medicines_in_use__c>> mapLstMedicinesByCase = new Map<String,List<Medicines_in_use__c>>();
	for( Medicines_in_use__c newMedicinesInUse : Trigger.new )
	{
		if( mapLstMedicinesByCase.containsKey( newMedicinesInUse.Safety_Individual_Report__c ) )
			mapLstMedicinesByCase.get( newMedicinesInUse.Safety_Individual_Report__c ).add( newMedicinesInUse );
		else
			mapLstMedicinesByCase.put( newMedicinesInUse.Safety_Individual_Report__c, new List<Medicines_in_use__c> { newMedicinesInUse } );
	}
	
	for( Safety_Individual_Report__c sir : [ Select Client_Name__c, Patient_Name__c From Safety_Individual_Report__c Where id IN :mapLstMedicinesByCase.keySet() ] )
	{
		if( mapLstMedicinesByCase.containsKey( sir.Id ) )
		{
			for( Medicines_in_use__c newMedicinesInUse : mapLstMedicinesByCase.get( sir.Id ) )
			{
				newMedicinesInUse.Client_Name__c = sir.Client_Name__c;
				newMedicinesInUse.Patient_Name__c = sir.Patient_Name__c;
			}
		}
	}
	/*
	for(Medicines_in_use__c newMedicinesInUse:trigger.new)
	{
		Adverse_Event__c AdverseEvent=[select patient_name__C, Client_Name__c from Adverse_Event__C where id=:newMedicinesInUse.Adverse_Event__c ];
		if(AdverseEvent!=null)
		{
			newMedicinesInUse.Client_Name__c=AdverseEvent.Client_Name__C;
			newMedicinesInUse.Patient_Name__c=AdverseEvent.patient_name__C;
		}
	}*/
}