public class SubcaseTask_cls 
{
    public SubcaseTask_cls()
    {
        
    } 
    public void CheckTask(Case objCase)
    {
        SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
        
        List<Task> lst=[Select Id,Group_Id__c from Task where Status='Open' and Group_Id__c=:conf.GroupId__c and WhatId=:objCase.Id limit 1];
        System.debug('Grupo-->' + conf.GroupId__c);
        System.debug('Caso-->' + objCase.Id);
        System.debug('ProfileID-->' + UserInfo.getProfileId());
        
        if(lst.size()>0)
        {
            if(UserInfo.getProfileId()!=conf.PvProfileId__c && UserInfo.getProfileId()!=conf.TdSAnalystProfileId__c && UserInfo.getProfileId()!=conf.VacinasProfileId__c && UserInfo.getProfileId()!=conf.SecondLevelProfileId__c)
            {
                 //objCase.addError(Label.SubcaseTask_cls_Error);
            }
        }
    }
}