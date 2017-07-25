/****************************************************************************************************
    Information general 
    -------------------
    Developed by:        Avanxo Colombia
    Author:              Juan Gabriel Duarte Pacheco
    Project:             Novartis (CRM)
    Description:         Test's ValidateUpdateTask
    
    Information about  version changes.
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     30-08-2012  Juan Gabriel Duarte P.          Create.
****************************************************************************************************/
@isTest
private class ValidateUpdateTask_tst {

    static testMethod void myUnitTest() {
        
      Task objTask = new Task();
      objTask.Subject = 'test subject';
      objTask.Description__c = 'test description';
      insert objTask;
      update objTask;
       
    }
    
    static testMethod void myUnitTestGroup() {
        
      Group__c objGroup = new Group__c();        
      objGroup.Name = 'Group Name Test ';
      insert objGroup;
    
      Group_Member__c objGroupMember = new Group_Member__c();        
      objGroupMember.Group__c = objGroup.Id;
      objGroupMember.User__c  = UserInfo.getUserId();
      insert objGroupMember;
      
      Task objTask = new Task();
      objTask.Subject = 'test subject';
      objTask.Description__c = 'test description';
      objTask.Group_Id__c = objGroup.Id;
      insert objTask;
      update objTask;
      
      ValidateUpdateTask validate = new ValidateUpdateTask ();
      validate.isAMemberOf(objGroup.Id);
      
      Flow_Type__c objFT = new Flow_Type__c();
      objFT.Flow_Number__c='29';
      objFT.Description__c='RT/FV - PESSOA JURÍDICA (recebida pela FV)';
      insert objFT;
      
      Stage__c objStage = new Stage__c();
      objStage.Description__c = '4-Processar relato no SINA e fechar tarefa';
      objStage.Maxim_Duration__c = 120;
      objStage.Name = '14';
      objStage.Subject__c = '4-Processar relato no SINA e fechar tarefa';
      objStage.Group__c = objGroup.Id;
      objStage.Flow_Type__c = objFT.Id;
      insert objStage;
      
      validate.haveCHR(objStage.id); 
    }
}