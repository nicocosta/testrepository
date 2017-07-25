@isTest(SeeAllData=false)
private class FAQ_Review_date_email_test 
{ 
    static testMethod void myUnitTest() 
    {   
       List<FAQ__c> FAQList=[ select Id, Name,Addressee__c, Description__c, FAQ_Type__c, key_words__c, Number_nPCC__c, Responsible_Area__c, Review_date__c,Reviewer_Approver__c,Review_Schedule__c,Status__c,Summary__c from FAQ__c where Status__c='Active'];        
	   system.debug('xxx'+FAQList.size());
       if(FAQList.size()> 0 && FAQList != null )
       		{             
                Test.startTest();
                FAQ_Review_date_email BatchTest = new FAQ_Review_date_email();
                ID batchprocessid = Database.executeBatch(BatchTest);
                Test.stopTest();
            }
        }                

}