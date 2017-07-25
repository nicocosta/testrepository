trigger TaskGroupInsert on Task (before insert, before update)
{
       if(trigger.new.size()==1)
       {
          /*  List<Group_Member__c> lstGm =[Select  User__c, Group__c, Group__r.Name    
                                                  From Group_Member__c Where Group__c=:Trigger.new[0].Groups_ID__c 
                                                                              and Group_Leader__c = true limit 1];
            if(lstGm.size()>0)
            {
                Trigger.new[0].OwnerId=lstGm[0].User__c;
            }*/
       }
       for(Task objTask: trigger.new)
       {
          objTask.DueDate__c= objTask.ActivityDate;
       }
}