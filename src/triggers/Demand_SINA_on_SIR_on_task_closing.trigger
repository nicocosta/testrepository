/****************************************************************************************************
    General Information
    -------------------
    Developer:          Avanxo Colombia
    Autor:              Juan Pablo Gracia
    Project:            Novartis Brazil
    Description:        Validate SINA number to the associated SIR must be assigned before closing the Task
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     06-04-2010  Juan Pablo Gracia       Trigger creation.
    ****************************************************************************************************/
trigger Demand_SINA_on_SIR_on_task_closing on Task (after update) {
    if( Trigger.new.size() == 1 )
    {
        Task t = Trigger.new[0];
        
        if(t.isClosed && !Test.isRunningTest()){
            List<Stage__c> stglst = [Select Not_Edit_SIR__c From Stage__c Where id=:t.StageId__c];
            if(stglst.size() > 0 && stglst[0].Not_Edit_SIR__c){
                
                List<Case> subcaselst = [select SIR_missing_SINA__c from Case where Id = :t.WhatId];
                if(subcaselst.size() > 0 && subcaselst[0].SIR_missing_SINA__c>0){
                    t.addError(System.Label.ClosingTaskNeedSINANumber);
                    return;
                }
            }
        }
        
    }
}