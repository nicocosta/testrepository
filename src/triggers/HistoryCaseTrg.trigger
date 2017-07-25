trigger HistoryCaseTrg on Case (before update) 
{
    if(trigger.new.size()==1)
    {
        HistoryTrackClass_cls trackHistory= new HistoryTrackClass_cls();
        
        trackHistory.HistoryCaseTrg(Trigger.old[0], Trigger.new[0]);
    }
}