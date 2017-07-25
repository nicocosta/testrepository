trigger SirUpdateTaskCheck_tgr on Safety_Individual_Report__c (before update,before insert)
{
    if (Userinfo.getProfileId() == '00eA0000000tn2OIAQ') return;
  
    if(Trigger.new.size()==1)
    {
        SirUpdateTaskCheck_cls updtSir= new SirUpdateTaskCheck_cls();
        
        updtSir.SirUpdateTaskCheck(Trigger.New[0]);
    }
}