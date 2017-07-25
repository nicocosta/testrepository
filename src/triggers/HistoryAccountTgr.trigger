trigger HistoryAccountTgr on Account (before update) 
{
    if(trigger.new.size()==1)
    {
    	
    	HistoryTrackObjects.historyInput input= new HistoryTrackObjects.historyInput();     
        input.idRegister=Trigger.old[0].Id;
        input.fieldName='Account.Type';
        input.oldValue=Trigger.old[0].Type;
        input.newValue=Trigger.new[0].Type;
        input.modifyDateTime=DateTime.now();
        input.currentUser=Userinfo.getUserId();
        HistoryTrackObjects hstAccount= new HistoryTrackObjects();
        if(Trigger.old[0].Type!=Trigger.new[0].Type)
        {
            hstAccount.TrackHistoryAccount(input); 
        }
        
    }
}