@isTest
private class testCase00343199 {

    static testMethod void myUnitTest() 
    {
        testCase00343199__c conf= testCase00343199__c.getinstance('conf1');
        
        System.debug('Case00343199: DebugLine9: '+ conf);
        
        Safety_Individual_Report__c objSIR= new Safety_Individual_Report__c(Id=conf.SIRId__c,PV_system_number_Sina__c='Abc123');
        User objUser= [Select Id from User where Id=:conf.UserId__c limit 1];
        System.runAs(objUser)
        {
            try
            {
                update objSIR;
            }
            catch(System.Exception e)
            {
                System.debug('myUnitTest.Case00343199: DebugLine18: '+ e.GetMessage());
                
                System.debug('myUnitTest.Case00343199: DebugLine19: '+ objSIR);
                
                System.debug('myUnitTest.Case00343199: DebugLine20: '+ conf);
            }
        }
    }
    static testMethod void myUnitTest1() 
    {
        testCase00343199__c conf= testCase00343199__c.getinstance('conf1');
        
        System.debug('Case00343199: DebugLine9: '+ conf);
        
        Safety_Individual_Report__c objSIR= [Select Id, PV_system_number_Sina__c from Safety_Individual_Report__c where Id=:conf.SIRId__c limit 1];
        
        objSIR.PV_system_number_Sina__c='Abc123';
        User objUser= [Select Id from User where Id=:conf.UserId__c limit 1];
        System.runAs(objUser)
        {
            try
            {
                update objSIR;
            }
            catch(System.Exception e)
            {
                System.debug('myUnitTest1.Case00343199: DebugLine18: '+ e.GetMessage());
                
                System.debug('myUnitTest1Case00343199: DebugLine19: '+ objSIR);
                
                System.debug('myUnitTest1.Case00343199: DebugLine20: '+ conf);
            }
        }
    }
}