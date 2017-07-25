trigger TaskChangeRequestCreation_tgr on Task (after insert) {

    if (Trigger.isAfter && Trigger.isInsert) {
        
        System.debug('::::TaskChangeRequestCreation INICIO');
        System.debug('::::Trigger.new.size():'+Trigger.new.size()+'.');
        if (Trigger.new.size() > 0) {
            Task task = Trigger.new[0];
            if (task.StageId__c != null) {
                System.debug('::::Task(id:'+task.Id+',stageId:'+task.StageId__c+')');
                Stage__c stage = [select Id, Change_Request__c from Stage__c where id = :task.StageId__c];
                if (stage.Change_Request__c) {
                    if (task.WhatId != null) {
                        Change_Request__c cr = new Change_Request__c();
                        Case subcase = [select Id, Reimbursement_via__c from Case where Id = :task.WhatId];

                        //cr.CreatedDate = Date.today();
                        cr.Status__c = 'Open';
                        cr.Subcase_number__c = subcase.Id;
                        cr.Task_Id__c = task.Id;
                        if(subcase.Reimbursement_via__c!=null)
                        {
                            if (subcase.Reimbursement_via__c.equalsIgnoreCase('Money')) {
                                cr.Visit_type__c = 'Withdrawal';
                            } else if (subcase.Reimbursement_via__c.equalsIgnoreCase('Product')) {
                                cr.Visit_type__c = 'Exchange';
                            } else if (subcase.Reimbursement_via__c.equalsIgnoreCase('Delivery')) {
                                cr.Visit_type__c = 'Delivery';
                            }
                            insert cr;
                            InvokeChangeRequestWS.invokeChangeRequestWS(cr.Id);

                        }
                        else
                        {
                            
                            Trigger.new[0].addError(Label.Subcase_with_no_reimbursement_via);
                        }
                        

                        
                    } else {
                        System.debug(':::: WhatId de task es null.');
                    }
                    
                } else {
                    System.debug(':::: El Stage no es Change Request.');
                }
                
            } else {
                System.debug('::::Task('+task.Id+',stageId:null)');
            }
        }
        
        /**
        System.debug('::::TaskChangeRequestCreation BEGIN');
        Map<Id, Task> mapTask = new Map<Id, Task>();
        List<Id> lstStageId = new List<Id>();
        for (Task task : Trigger.new) {
            mapTask.put(task.Id, task);
            if (task.StageId__c != null) {
                Id id = ''+task.StageId__c;
                lstStageId.add(id);
            }
        }
        Map<Id, Stage__c> mapTaskIdEvent = new Map<Id, Stage__c>();
        Map<Id, Stage__c> mapStage = new Map<Id, Stage__c>([select Id from Stage__c where Id in : lstStageId]);
        
        for (Id stageId : mapStage.keySet()) {
            Stage__c stage = mapStage.get(stageId);
            if (stage.Change_Request__c) {
                Task task = mapTask.get(stageId);
            }
        }
        */
        System.debug('::::TaskChangeRequestCreation FIN');
    }
}