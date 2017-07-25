/****************************************************************************************************
    General Information
    -------------------
    Developer:          Avanxo Colombia
    Autor:              Daniel Delgado (DFDC)
    Project:            Novartis Brazil
    Description:        Control of Flow Type functionality. Create new Tasks each time a previous Task is closed.
                        If the closed task is related to a Stage and this Stage is predecesor of another Stage,
                        the new Task is created. If the related Stage is not a predecesor, then the trigger verify
                        if the Case related has to closed.
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     14-09-2010  Daniel Delgado (DFDC)       Trigger creation.
    1.1     27-10-2010  Daniel Delgado (DFDC)       Funcionalidad check SIR Seriousness.
    1.2     02-12-2011  Juan Pablo Gracia           Behavior if the task changes the state unrealized
    ****************************************************************************************************/
trigger TaskWorkFlow_tgr on Task (after update, before update, after insert)
{
    private  Task tcompare; 
    
    if( Trigger.isUpdate )
    {
        if( Trigger.isBefore )
        {
            for( Integer i = 0; i < Trigger.new.size(); i++ )
            {
                DateTime dtDateNow= DateTime.Now();
                //dtDateNow=dtDateNow.addHours(-2);
                if(Trigger.new[i].Description != Trigger.old[i].Description && Trigger.old[i].Description!=null)
                {
                    Trigger.new[i].Comment_History__c=GetDataComent(Trigger.new[i].Comment_History__c,Trigger.old[i].Description);
                    
                }
                
                if(Trigger.new[i].Comments_2__c != Trigger.old[i].Comments_2__c && Trigger.old[i].Comments_2__c!=null)
                {
                    Trigger.new[i].Comment_2_History__c=GetDataComent(Trigger.new[i].Comment_2_History__c,Trigger.old[i].Comments_2__c);
                }
                
                if(Trigger.new[i].Comments_3__c != Trigger.old[i].Comments_3__c && Trigger.old[i].Comments_3__c!=null)
                {
                    Trigger.new[i].Comment_3_History__c=GetDataComent(Trigger.new[i].Comment_3_History__c,Trigger.old[i].Comments_3__c);
                }
                                
                if( Trigger.new[i].Status != Trigger.old[i].Status )
                {
                    String str = Trigger.new[i].Status_history__c;
                    if( str == null )
                        str = '';
                    else if( str != '' )
                        str += '\n';
                        
                    
                    
                    str += Trigger.new[i].Status + ' - ' + dtDateNow.format('yyyy-MM-dd HH:mm:ss','America/Sao_Paulo') + ' - ' + UserInfo.getUserName();
                    Trigger.new[i].Status_history__c = str;
                }
                if(Trigger.new[i].Status=='Closed')
                {
                    Trigger.new[i].Closing_date__c=Date.today();
                }
            }
        }
        else
        {
            if( Trigger.new.size() == 1 )
            {
                String strStageId = '', strCaseId = '', strTaskId = '';
                Task t = Trigger.new[0];
                tcompare=t;
                System.debug( '+-+-+ Validaciones: t.Id ' + t.Id + ' t.Status ' + t.Status + ' t.isClosed ' + t.isClosed + ' Trigger.Old[0].isClosed ' + Trigger.Old[0].isClosed + ' t.StageId__c ' + t.StageId__c + ' t.WhatId ' + t.WhatId );
                if( FlowType_Tools_cls.getBlnEjecutarTriggerTaskWorkFlow_tgr() && t.isClosed != Trigger.Old[0].isClosed && t.isClosed && (t.Status == 'Closed' || t.Status == 'Unrealized') && t.StageId__c != null && t.StageId__c != '' && t.WhatId != null )
                {
                    strStageId = t.StageId__c;
                    strCaseId = t.WhatId;
                    strTaskId = t.Id;
                    FlowType_Tools_cls.setBlnEjecutarTriggerTaskWorkFlow_tgr( false );
                    
                    //Search Stages where Predecessor__c field is the same Stage related to the closed Task.
                    List<Stage__c> lstStages = [    Select  Send_notification_email__c, Predecessor__c, Name, Maxim_Duration__c, 
                                                            Description__c, Assigned_to__c, Priority__c, Subject__c, Group__c, CadFor__c,
                                                            Depends_on_subcase_seriousness__c
                                                    From    Stage__c
                                                    Where   Predecessor__c = :strStageId ];
                    System.debug( '+-+-+ lstStages: ' + lstStages );
                    if( !lstStages.isEmpty() )
                    {
                        Boolean findSIR = false;
                        Safety_Individual_Report__c sir = null;
                        for( Stage__c stg : lstStages )
                        {
                            if( stg.Depends_on_subcase_seriousness__c )
                            {
                                findSIR = true;
                                break;
                            }
                        }
                        
                        if( findSIR )
                        {
                            try
                            {
                                sir = [ Select  Receipt_date_of_report__c, Maxim_Duration_hours__c 
                                        From    Safety_Individual_Report__c 
                                        Where   Subcase_Number__c = :t.WhatId 
                                        limit   1 ];
                            }
                            catch( System.exception e )
                            {
                                System.debug( '****** EXCEPTION. No se encontró SIR' );
                            }
                        }
                        
                        //Search for the Working Hours record.
                        BusinessHours bh;
                        try
                        {
                            bh = [ Select id From BusinessHours where name = 'Working Hours Flow Type' limit 1 ];
                        }
                        catch( System.exception e )
                        {
                            t.addError( System.Label.Business_hours_not_found );
                        }
                        
                        //For each Stage found, we have to create his Task.
                        List<Task> lstTask = new List<Task>();
                        List<String> lstGroups = new List<String>();
                        Map<String, Group_Member__c> mapLeadersByGroup = new Map<String, Group_Member__c>();
                        for( Stage__c stage : lstStages )
                        {
                            if( stage.Assigned_to__c == null && stage.Group__c != null )
                                lstGroups.add( stage.Group__c );
                        }
                        
                        for( Group_Member__c gm : [ Select  User__c, Group__c, Group__r.Name    From Group_Member__c Where Group__c IN :lstGroups and Group_Leader__c = true ] )
                        {
                            mapLeadersByGroup.put( gm.Group__c, gm );
                        }
                        System.debug( '*-*-*-* mapLeadersByGroup: ' + mapLeadersByGroup );
                        
                        for( Stage__c stage : lstStages )
                        {
                            Task task = new Task();
                            if( stage.Assigned_to__c != null )
                                task.OwnerId = stage.Assigned_to__c;
                            else if( stage.Group__c != null && mapLeadersByGroup.containsKey( stage.Group__c ) )
                            {
                                Group_Member__c gmTemp = mapLeadersByGroup.get( stage.Group__c );
                                task.OwnerId = gmTemp.User__c;
                                task.Group_Name__c = gmTemp.Group__r.Name;
                                task.Group_Id__c = gmTemp.Group__c;
                            }
                            else
                            {
                                System.debug( '*-*-*-*- Group Leader not found or User not assigend to Stage. stage.Assigned_to__c: ' + stage.Assigned_to__c + ' -- stage.Group__c: ' + stage.Group__c );
                                continue;
                            }
                            task.Description__c = stage.Description__c;
                            task.WhatId = strCaseId;
                            task.StageId__c = stage.Id;
                            task.Subject = stage.Subject__c;
                            task.Status = 'Open';
                            task.Priority = stage.Priority__c;
                            task.IsReminderSet = false;
                            task.CadFor__c = stage.CadFor__c;
                            Integer intValue = Integer.valueOf( '' + stage.Maxim_Duration__c.intValue() );
                            
                            DateTime dtInicial;
                            //if the closing date of the task is less than today it consider this date.,
                            if(tcompare.ActivityDate < System.today()){
                                dtInicial = tcompare.ActivityDate;
                            }
                            //if the closing date of the task is greater than or equal to today it consider now                             
                            else{ 
                                dtInicial = System.now();                           
                            }
                                                        
                            Datetime dt;
                            //Datetime dtGmt;
                            System.debug( 'SI DEPENDE DE SERIEDAD DEL CASO');
                            if( stage.Depends_on_subcase_seriousness__c && sir != null )
                            {
                                dtInicial = Datetime.newInstance( sir.Receipt_date_of_report__c, dtInicial.time() );
                                System.debug( 'sir.Maxim_Duration_hours__c: ' + sir.Maxim_Duration_hours__c );
                                System.debug( 'TIEMPO INICIAL' + dtInicial);
                                try
                                {
                                    intValue = Integer.valueOf( '' + sir.Maxim_Duration_hours__c.intValue() );
                                }
                                catch( System.exception e )
                                { 
                                    intValue = 120; 
                                }//Si por alguna razon no hay valor en este campo se asumirá la fecha máxima. JFR Nov. 18 de 2010
                                Datetime dtTemp = System.now();
                                
                                if( sir.Receipt_date_of_report__c != null )
                                    dtTemp = sir.Receipt_date_of_report__c;
                                System.debug( 'FECHA TEMPORAL 1 --> ' + dtTemp);
                                dt = dtTemp.addHours( intValue + 3 );
                                System.debug( 'FECHA TEMPORAL 2 --> ' + dt);
                            }
                            
                            else
                            {
                                dt = BusinessHours.add( bh.id, dtInicial, intValue * 60 * 60 * 1000L);
                                //dtGmt = BusinessHours.addGmt( bh.id, dtInicial, intValue * 60 * 60 * 1000L);
                            }
                            System.debug( '+-+-+ Hours Calculation: System.now: ' + System.now() + ' dt: ' + dt );
                            //System.debug( '+-+-+ Hours Calculation: System.now: ' + System.now() + ' dtGmt: ' + dtGmt );
                            task.ActivityDate = dt.date();
                            System.debug( '+-+-+ task: ' + task );
                            lstTask.add( task );
                        }
                        System.debug( '+-+-+ lstTask: ' + lstTask );
                        insert lstTask;
                        List<Task> lstCloseTask = new List<Task>();
                        for( Integer i = 0; i < lstTask.size(); i++ )
                        {
                            if( lstTask[i].CadFor__c )
                            {
                                lstTask[i].Status = 'Closed';
                                lstCloseTask.add( lstTask[i] );
                                lstTask.remove( i );
                            }
                        }
                        System.debug( '+-+-+ lstTask: ' + lstTask );
                        System.debug( '+-+-+ lstCloseTask: ' + lstCloseTask );
                        if( !lstCloseTask.isEmpty() )
                        {
                            update lstCloseTask;
                            FlowType_Tools_cls.setBlnEjecutarTriggerTaskWorkFlow_tgr( true );
                        }
                        System.debug( '+-+-+ lstTask: ' + lstTask );
                        //Send Email notification
                        if( !lstTask.isEmpty() )
                        {
                            FlowType_Tools_cls.SendEmailNotification( lstTask );
                        }
                    }
                    else
                    {
                        Stage__c st = [ Select Id, Flow_Type__c From Stage__c Where id = :strStageId ];
                        List<String> lstStagesId = new List<String>();
                        for( Stage__c s : [ Select Id From Stage__c Where Flow_Type__c = :st.Flow_Type__c ] )
                        {
                            lstStagesId.add( s.Id );
                        } 
                        
                        
                        //If no other Task related to those Stages and SubCase still open, then the SubCase is closed.
                        if( [ Select Count() From Task Where Id != :strTaskId and WhatId = :strCaseId and StageId__c IN :lstStagesId and isClosed = false ] == 0 )
                        {
                            Case subCase = [ Select Status From Case Where id = :strCaseId limit 1 ];

                            if( [ Select Count() From Task Where WhatId = :strCaseId and Status = 'Unrealized'] != [ Select Count() From Task Where WhatId = :strCaseId ] )
                            {
                                try
                                {
                                    subCase.status = 'Closed';
                                    update subCase;
                                }
                                catch( System.exception e )
                                {
                                    t.addError( System.label.Update_SubCase_Error + '\n ' + e.getMessage() );
                                }
                            }
                            else
                            {
                                try
                                {
                                    subCase.status = 'Canceled';
                                    update subCase;
                                }
                                catch( System.exception e )
                                {
                                    t.addError( System.label.Update_SubCase_Error + '\n ' + e.getMessage() );
                                }
                            }
                            
                        }
                    }
                }
                else if( t.isClosed != Trigger.Old[0].isClosed && t.isClosed && t.Status != 'Closed' && t.StageId__c != null && t.StageId__c != '' )
                {
                    strStageId = t.StageId__c;
                    strCaseId = t.WhatId;
                    strTaskId = t.Id;
                    Stage__c st = [ Select Id, Flow_Type__c From Stage__c Where id = :strStageId ];
                    List<String> lstStagesId = new List<String>();
                    for( Stage__c s : [ Select Id From Stage__c Where Flow_Type__c = :st.Flow_Type__c ] )
                    {
                        lstStagesId.add( s.Id );
                    }
                    
                    
                    //If no other Task related to those Stages and SubCase still open, then the SubCase is closed.
                    if( [ Select Count() From Task Where Id != :strTaskId and WhatId = :strCaseId and StageId__c IN :lstStagesId and isClosed = false ] == 0 )
                    {
                        try
                        {
                            Case subCase = [ Select Status, Non_attendance_reason__c From Case Where id = :strCaseId limit 1 ];
                            if( t.Non_attendance_reason__c != null )
                                subCase.Non_attendance_reason__c = t.Non_attendance_reason__c;
                            ///JPG 02/12/2011
                            if(t.Status == 'Canceled')subCase.status = 'Canceled';
                            if(t.Status == 'Unrealized')subCase.status = 'Closed';
                            ///---------------
                            update subCase;
                        }
                        catch( System.exception e )
                        {
                            t.addError( System.label.Update_SubCase_Error );
                        }
                    }
                }
            }
        }
    }
    else if( Trigger.isInsert )
    {
        // CadFor__c functionality.
        Set<String> lstCasesId = new Set<String>();
        for( Task t : Trigger.new )
        {
            if( t.CadFor__c != null && t.CadFor__c )
                lstCasesId.add( t.WhatId );
        }
        
        List<Case> lstCases = new List<Case>();
        for( Case c : [ Select CadFor__c From Case Where Id IN :lstCasesId ] )
        {
            c.CadFor__c = true;
            lstCases.add( c );
        }
        
        update lstCases;
    }
    public String GetDataComent(String hstComent, String oldComent)
    {
        DateTime dtDateNow= DateTime.Now();
        //dtDateNow=dtDateNow.addHours(-2);
        String EndComent=' - '+dtDateNow.format('yyyy-MM-dd HH:mm:ss','America/Sao_Paulo')+' - '+UserInfo.getUserName();
        
        if(hstComent==null)
        {
            hstComent=oldComent+EndComent;
        }
        else
        {
            hstComent+='\n'+oldComent+EndComent;
        }
        if(hstComent.length()>255)
        {
            hstComent=hstComent.subString(0,254);
        }
        return hstComent;
    }
}