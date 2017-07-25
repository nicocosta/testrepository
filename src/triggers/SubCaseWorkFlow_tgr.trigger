/****************************************************************************************************
    General Information
    -------------------
    Developer:          Avanxo Colombia
    Autor:              Daniel Delgado (DFDC)
    Project:            Novartis Brazil
    Description:        Control of Flow Type functionality. Create tasks if it is related to some Stage
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     14-09-2010  Daniel Delgado (DFDC)       Trigger creation.
    1.1     27-10-2010  Daniel Delgado (DFDC)       Funcionalidad check SIR Seriousness.
    ****************************************************************************************************/
trigger SubCaseWorkFlow_tgr on Case (after insert) 
{
    if( Trigger.new.size() == 1 )
    {
        Case SubCase = Trigger.new[0];
        //This functionality only applies for SubCases
        if( [ Select Count() From RecordType where id = :SubCase.RecordTypeId and Name = 'Subcase' ] > 0 )
        {
            if( SubCase.Flow_Type__c != null && SubCase.Case_Type__c != null )
            {
                //Search for Flow Type's Stages without Predecessor
                List<Stage__c> lstStages = [    Select  Send_notification_email__c, Predecessor__c, Name, Maxim_Duration__c, 
                                                        Description__c, Assigned_to__c, Priority__c, Subject__c, Group__c, CadFor__c,
                                                        Depends_on_subcase_seriousness__c
                                                From    Stage__c
                                                Where   Predecessor__c = null and Flow_Type__c = :SubCase.Flow_Type__c ];
                System.debug( '+-+-+ lstStages: ' + lstStages );
                if( !lstStages.isEmpty() )
                {
                    Boolean findSIR = false;
                    Safety_Individual_Report__c sir = null;
                    /*for( Stage__c stg : lstStages )
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
                                    Where   Subcase_Number__c = :SubCase.Id 
                                    limit   1 ];
                        }
                        catch( System.exception e )
                        {
                            System.debug( '****** EXCEPTION. No se encontró SIR' );
                        }
                    }*/
                    
                    //Search for the Working Hours record.
                    BusinessHours bh;
                    try
                    {
                        bh = [ Select id From BusinessHours where name = 'Working Hours Flow Type' limit 1 ];
                    }
                    catch( System.exception e )
                    {
                        SubCase.addError( System.Label.Business_hours_not_found );
                    }
                    
                    //For each Stage found, we have to create his Task.
                    List<Task> lstTasks = new List<Task>();
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
                        task.CadFor__c = stage.CadFor__c;
                        task.WhatId = SubCase.Id;
                        task.StageId__c = stage.Id;
                        task.Subject = stage.Subject__c;
                        task.Status = 'Open';
                        task.Priority = stage.Priority__c;
                        task.IsReminderSet = false;
                        Integer intValue = Integer.valueOf( '' + stage.Maxim_Duration__c.intValue() );
                        DateTime dtInicial = System.now();
                        Datetime dt = BusinessHours.add( bh.id, dtInicial, intValue * 60 * 60 * 1000L);
                        Datetime dtGmt = BusinessHours.addGmt( bh.id, dtInicial, intValue * 60 * 60 * 1000L);
                        System.debug( '+-+-+ Business Hours Calculation: System.now: ' + System.now() + ' dt: ' + dt );
                        System.debug( '+-+-+ Business Hours Calculation: System.now: ' + System.now() + ' dtGmt: ' + dtGmt );
                        task.ActivityDate = dt.date();
                        System.debug( '+-+-+ task: ' + task );
                        lstTasks.add( task );
                    }
                    System.debug( '+-+-+ lstTasks: ' + lstTasks );
                    insert lstTasks;
                    List<Task> lstCloseTask = new List<Task>();
                    for( Integer i = 0; i < lstTasks.size(); i++ )
                    {
                        //MMilian 260511 - Ingresando ChageRequest - INICIO
                        Stage__c stageAux = [select Id, Change_Request__c from Stage__c where id = :lstTasks[i].StageId__c];
                        if (stageAux.Change_Request__c == TRUE) {
                            Change_Request__c cr = new Change_Request__c();
                            Case SubCaseAux = [select Id, Reimbursement_via__c from Case where Id = :SubCase.Id];
                            cr.Status__c = 'Open';
                            cr.Subcase_number__c = SubCaseAux.Id;
                            cr.Task_Id__c = lstTasks[i].Id;
                            if(SubCaseAux.Reimbursement_via__c != null)
                            {
                                if (SubCaseAux.Reimbursement_via__c.equalsIgnoreCase('Money') || SubCaseAux.Reimbursement_via__c.equalsIgnoreCase('Ressarcimento em dinheiro')) {
                                    cr.Visit_type__c = 'Withdrawal';
                                } else if (SubCaseAux.Reimbursement_via__c.equalsIgnoreCase('Product') || SubCaseAux.Reimbursement_via__c.equalsIgnoreCase('Troca do produto')) {
                                    cr.Visit_type__c = 'Exchange';
                                } else if (SubCaseAux.Reimbursement_via__c.equalsIgnoreCase('Delivery')  || SubCaseAux.Reimbursement_via__c.equalsIgnoreCase('Entrega')) {
                                    cr.Visit_type__c = 'Delivery';
                                }else if (SubCaseAux.Reimbursement_via__c.equalsIgnoreCase('N/A (Analysis only)') || SubCaseAux.Reimbursement_via__c.equalsIgnoreCase('Retirada da amostra do cliente')) {
                                    cr.Visit_type__c = 'Withdrawal';
                                }
                                insert cr;
                                InvokeChangeRequestWS.invokeChangeRequestWS(cr.Id);
                            }
                            else
                            {
                                SubCase.addError( System.Label.Subcase_with_no_reimbursement_via);
                            }
                        }
                        else
                        {
                            System.debug(':::: El Stage no es Change Request.');
                        }
                        //MMilian 260511 - Ingresando ChageRequest - FIN                    

                        if( lstTasks[i].CadFor__c )
                        {
                            lstTasks[i].Status = 'Closed';
                            lstCloseTask.add( lstTasks[i] );
                            lstTasks.remove( i );
                        }
                    }
                    System.debug( '+-+-+ lstTasks: ' + lstTasks );
                    System.debug( '+-+-+ lstCloseTask: ' + lstCloseTask );
                    if( !lstCloseTask.isEmpty() )
                    {
                        update lstCloseTask;
                    }
                    System.debug( '+-+-+ lstTasks: ' + lstTasks );
                    //Send Email notification
                    if( !lstTasks.isEmpty() )
                        FlowType_Tools_cls.SendEmailNotification( lstTasks );
                }
            }
        }
    }
}