trigger Changerequest_tgr on Change_Request__c (before update) {
    
    if(trigger.new.size()>1)
    {
        List<String> lstCR=new List<String>();
        System.debug('Entro Mayor 1');
        for(Change_Request__c updCR:trigger.new)
        {
            System.debug('updCR-> '+updCR);
            if(updCR.Status__c=='Closed' && updCR.Task_Id__c!=null)
            {
                System.debug('updCR.Task_Id__c-> '+updCR.Task_Id__c);
                lstCR.add(updCR.Task_Id__c);
            }
        }   
        
        List<Task> ltsk=[Select Status from Task where id in:lstCR  limit 9999];
        System.debug('Mayor a 0?');
        if(ltsk.size()>0)
        {
            System.debug('SI Mayor a 0');
            for(Task tsk:ltsk)
            {
                System.debug('tsk-> '+tsk);
                tsk.Status='Closed';
            }
            System.debug('ltsk-> '+ltsk);
            update ltsk;
        }
    }
    else
    {
        System.debug('Entro al else');
        for(Change_Request__c updCR:trigger.new)
        {
            System.debug('updCR-> '+updCR);
            if(updCR.Status__c=='Closed' && updCR.Task_Id__c!=null)
            {
                List<Task> lstTask=[Select Status from Task where id=:updCR.Task_Id__c limit 1 ALL ROWS];
                if( !lstTask.IsEmpty() && lstTask.get(0).Status != 'Closed' )
                {
                    lstTask.get(0).Status ='Closed';
                    System.debug('lstTask-> '+lstTask);
                    update lstTask;
                }
            }
        }
    }
    

}