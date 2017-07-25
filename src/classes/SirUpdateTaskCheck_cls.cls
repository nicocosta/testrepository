public class SirUpdateTaskCheck_cls 
{
	public SirUpdateTaskCheck_cls()
	{
		
	}
	
	public void SirUpdateTaskCheck( Safety_Individual_Report__c objSir )
	{
		List<String> lstStageId = new List<String>();
		String strTaksName = '';
		Map<String, Task> mapTasksByStage = new Map<String,Task>();
		
		for( Task t : [	Select	Id, Group_Id__c, Description, Subject, StageId__c
						from	Task
						where	WhatId = :objSir.Subcase_Number__c 
								and Status = 'Closed'
								and StageId__c <> null 
								and StageId__c <> '' ] )
		{
			mapTasksByStage.put( t.StageId__c, t );
		}
				
		for( Stage__c stg : [ Select Id From Stage__c Where Id IN :mapTasksByStage.keySet() and Not_Edit_SIR__c = true ] )
			strTaksName += strTaksName == '' ? mapTasksByStage.get( stg.Id ).Subject : ' -- ' + mapTasksByStage.get( stg.Id ).Subject;
		
		if( strTaksName != '' )
		 	objSir.addError(Label.SirUpdateTaskCheck_cls_Error + strTaksName + Label.SirUpdateTaskCheck2_cls_Error );
			
	}
	
	public void AdverseEventUpdate( Adverse_Event__c objAvE )
	{
		String strTaksName = '';
		
		Map<String, Task> mapTasksByStage = new Map<String,Task>();
		
        List<Safety_Individual_Report__c> lstSIR = [	Select	Id, Subcase_Number__c
					From	Safety_Individual_Report__c
					Where	Id = :objAvE.PV_number_SINA__c
							and Subcase_Number__c <> null limit 1];
		if(lstSIR.size()>0)
		{	
			for( Task t : [	Select	Id, Group_Id__c, Description, Subject, StageId__c
							From	Task 
							Where	WhatId = :lstSIR[0].Subcase_Number__c
									and Status = 'Closed' 
									and StageId__c <> null 
									and StageId__c <> '' ] )
			{
				mapTasksByStage.put( t.StageId__c, t );
			}
		}
			
		for( Stage__c stg : [ Select Id From Stage__c Where Id IN :mapTasksByStage.keySet() and Not_Edit_SIR__c = true ] )
			strTaksName += strTaksName == '' ? mapTasksByStage.get( stg.Id ).Subject : ' -- ' + mapTasksByStage.get( stg.Id ).Subject;
		
		if( strTaksName != '' )
			objAvE.addError( Label.AdverseEventUpdateTaskCheck + strTaksName + Label.AdverseEventUpdateTaskCheck2_cls_Error );
	}
	
	public void MedicineInUseUpdate( Medicines_in_use__c objMedicine )
	{
		String strTaksName = '';
		Map<String, Task> mapTasksByStage = new Map<String,Task>();
		List<Safety_Individual_Report__c> lstSIR = [	Select	Id, Subcase_Number__c
					From	Safety_Individual_Report__c
					Where	Id = :objMedicine.Safety_Individual_Report__c limit 1];
					
        if(lstSIR.size()>0)
        {
			for( Task t : [	Select	Id, Group_Id__c, Description, Subject, StageId__c
							from	Task 
							where	WhatId = :lstSIR[0].Subcase_Number__c
									and Status = 'Closed' 
									and StageId__c <> null 
									and StageId__c <> '' ] )
			{
				mapTasksByStage.put( t.StageId__c, t );
			}
        }
	
		for( Stage__c stg : [ Select Id From Stage__c Where Id IN :mapTasksByStage.keySet() and Not_Edit_SIR__c = true ] )
			strTaksName += strTaksName == '' ? mapTasksByStage.get( stg.Id ).Subject : ' -- ' + mapTasksByStage.get( stg.Id ).Subject;
		
		if( strTaksName != '' )
			objMedicine.addError( Label.MedicineInUseCheck_cls_Error + strTaksName + Label.MedicineInUseCheck2_cls_Error );

	}
	public void CaseUpdateTaskCheck(Case objCase)
	{
		String strTaksName = '';
        Map<String, Task> mapTasksByStage = new Map<String,Task>();
        
        for( Task t : [ Select  Id, Group_Id__c, Description, Subject, StageId__c
                        from    Task 
                        where   WhatId = :objCase.Id
                                and Status = 'Closed' 
                                and StageId__c <> null 
                                and StageId__c <> '' ] )
        {
            mapTasksByStage.put( t.StageId__c, t );
        }
         
        for( Stage__c stg : [ Select Id From Stage__c Where Id IN :mapTasksByStage.keySet() and Not_Edit_SIR__c = true ] )
            strTaksName += strTaksName == '' ? mapTasksByStage.get( stg.Id ).Subject : ' -- ' + mapTasksByStage.get( stg.Id ).Subject;
        
        //JGDP. 28-08-2013. Cambio configuración personaliza para incluir más de un perfil
       	List<TDS_Profile_Config__c> config = TDS_Profile_Config__c.getall().values();
       	set<String> lstIdProfiles = new set<String>();
       	for( TDS_Profile_Config__c objConfig :config )
       	{
       	  lstIdProfiles.add(objConfig.IdProfile__c);
       	}
        if( strTaksName != '' && !lstIdProfiles.contains(Userinfo.getProfileId()) )
            objCase.addError( Label.SubCaseUpdateTaskCheck + strTaksName + Label.MedicineInUseCheck2_cls_Error );

	}
	public void ReporterUpdateTaskCheck(Reporter__c objReporter)
	{
		String strTaksName = '';
        Map<String, Task> mapTasksByStage = new Map<String,Task>();
        List<Safety_Individual_Report__c> lstSIR = [    Select  Id, Subcase_Number__c
                    From    Safety_Individual_Report__c
                    Where   Id = :objReporter.Safety_Individual_Report__c limit 1];
                    
        if(lstSIR.size()>0)
        {
            for( Task t : [ Select  Id, Group_Id__c, Description, Subject, StageId__c
                            from    Task 
                            where   WhatId = :lstSIR[0].Subcase_Number__c
                                    and Status = 'Closed' 
                                    and StageId__c <> null 
                                    and StageId__c <> '' ] )
            {
                mapTasksByStage.put( t.StageId__c, t );
            }
        }
    
        for( Stage__c stg : [ Select Id From Stage__c Where Id IN :mapTasksByStage.keySet() and Not_Edit_SIR__c = true ] )
            strTaksName += strTaksName == '' ? mapTasksByStage.get( stg.Id ).Subject : ' -- ' + mapTasksByStage.get( stg.Id ).Subject;
        
        if( strTaksName != '' )
            objReporter.addError(Label.ReporterUpdateTaskCheck + strTaksName + Label.MedicineInUseCheck2_cls_Error );
	}
}