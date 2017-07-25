public class UpdateBussinesAcountType_cls {
	
    public void executeLogic(List<Account> lstNewDat, List<Account> lstOldDat)
    {
        if(lstNewDat!=null)
        {
            if( lstNewDat.size() == 1 )
            {   
                Account objAccount = lstNewDat[0];                
                if(objAccount.Bussines_Type__c != null && RecordTypesId__c.getInstance('BusinessCustomer').RecordTypeId__c == String.valueOf(objAccount.RecordTypeId).substring(0,15))
                {
                    objAccount.Type__c = objAccount.Bussines_Type__c;                    
                }
            }
        }
    }   
}