trigger AdverseEvent_tgr on Adverse_Event__c (before update, before insert) 
{
    if(Trigger.new.size()==1)
    {
        SirUpdateTaskCheck_cls uptSubcase = new SirUpdateTaskCheck_cls();
        
        uptSubcase.AdverseEventUpdate(Trigger.new[0]);
        
    }
    
}