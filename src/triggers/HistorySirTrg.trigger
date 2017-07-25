trigger HistorySirTrg on Safety_Individual_Report__c (before update) 
{
    if(trigger.new.size()==1)
    {
        HistoryTrackObjects.historyInput input= new HistoryTrackObjects.historyInput();     
        input.idRegister=Trigger.old[0].Id;
        input.fieldName='SIR.Cause';
        input.oldValue=Trigger.old[0].Cause__c;
        input.newValue=Trigger.new[0].Cause__c;
        input.modifyDateTime=DateTime.now();
        input.currentUser=Userinfo.getUserId(); 
        
        HistoryTrackObjects hstSir= new HistoryTrackObjects();        
                
        if(Trigger.old[0].Cause__c!=Trigger.new[0].Cause__c)
        {
            hstSir.TrackHistorySIR(input);
        }
        
        input.fieldName='SIR.PV description';
        input.oldValue=Trigger.old[0].PV_description__c;
        input.newValue=Trigger.new[0].PV_description__c;
        
        if(Trigger.old[0].PV_description__c!=Trigger.new[0].PV_description__c)
        {
            hstSir.TrackHistorySIR(input);
        }
        
        input.fieldName='SIR.Second level description c';
        input.oldValue=Trigger.old[0].Second_level_description__c;
        input.newValue=Trigger.new[0].Second_level_description__c;
        
        
        if(Trigger.old[0].Second_level_description__c!=Trigger.new[0].Second_level_description__c)
        {
            hstSir.TrackHistorySIR(input);
        }
        
        input.fieldName='SIR.Measures taken';
        input.oldValue=Trigger.old[0].Measures_taken__c;
        input.newValue=Trigger.new[0].Measures_taken__c;
        
        
        if(Trigger.old[0].Measures_taken__c!=Trigger.new[0].Measures_taken__c)
        {
            hstSir.TrackHistorySIR(input);
        }
        
        input.fieldName='SIR.Related medical history';
        input.oldValue=Trigger.old[0].Related_medical_history__c;
        input.newValue=Trigger.new[0].Related_medical_history__c;
        
        
        if(Trigger.old[0].Related_medical_history__c!=Trigger.new[0].Related_medical_history__c)
        {
            hstSir.TrackHistorySIR(input);
        }
        
    }
}