trigger HistoryFAQTrg on FAQ__c (before update) 
{
    if(trigger.new.size()==1)
    {
        HistoryTrackObjects.historyInput input= new HistoryTrackObjects.historyInput();     
        input.idRegister=Trigger.old[0].Id;
        input.fieldName='Faq.Description';
        input.oldValue=Trigger.old[0].Description__c;
        input.newValue=Trigger.new[0].Description__c;
        input.modifyDateTime=DateTime.now();
        input.currentUser=Userinfo.getUserId();    
        HistoryTrackObjects hstFAQ= new HistoryTrackObjects();        
        if(Trigger.old[0].Description__c!=Trigger.new[0].Description__c)
        {
            hstFAQ.TrackHistoryFAQ(input); 
        }
        
    }
}