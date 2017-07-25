trigger MedicineInUse_tgr on Medicines_in_use__c (before update,before insert) 
{
    if(Trigger.new.size()==1)
    {
        SirUpdateTaskCheck_cls uptSubcase = new SirUpdateTaskCheck_cls();
        
        uptSubcase.MedicineInUseUpdate(Trigger.new[0]);
        
    }
}