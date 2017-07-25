/****************************************************************************************************
    General Information
    -------------------
    Developer:          Avanxo Colombia
    Autor:              Juan Pablo Gracia
    Project:            Novartis Brazil
    Description:        ValidateCaseEdition's Test.
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     04-03-2011  Juan Pablo Gracia           Create class.
    ****************************************************************************************************/


@isTest
private class ValidationSIREdition_tst 
{
    static testmethod void generalTest(){
      SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
      User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
      System.runAs ( userWhitAutorization ) {
        CreateTestObjects co = new CreateTestObjects();
        co.createObjects();
        ValidationSIREdition.executeInsert = false;
        test.startTest();
        //Actualización correcta
        co.safetyIndividualReport.Cause__c = 'test';
        update co.safetyIndividualReport;
        test.stopTest();
      }
    }
    
    static testmethod void generalTest2(){
      SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
      User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
      System.runAs ( userWhitAutorization ) {
        CreateTestObjects co = new CreateTestObjects();
        co.createObjects();
        ValidationSIREdition.executeInsert = false;
        
        test.startTest();
        
        co.caseType.EditInfoDisable__c = true; 
        update co.caseType; 
        
        //Validar la función llamada por el trigger con valores nulos. 
        ValidationSIREdition vsir = new ValidationSIREdition();
        vsir.validateEdition(null,null);
       
        
        //Se genera una tarea por triggers para el sub caso
        //le cambio el stage para que no cuente
        ValidateCaseEdition vc = new ValidateCaseEdition();
       List<Task> tasks = vc.getTasksByIDsForValidateCaseEdition(new List<Id>{co.subCase.Id} );
        tasks[0].StageId__c = null;
        update tasks[0]; 
        
        //Actualización falla
        try{
            update co.safetyIndividualReport;
            System.assert(false);
        }catch(Exception e){
        }
        
        test.stopTest();
      }
    }
    
    
    static testmethod void generalTest3(){
      SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
      User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
      System.runAs ( userWhitAutorization ) {
        CreateTestObjects co = new CreateTestObjects();
        co.createObjects();
        ValidationSIREdition.executeInsert = false;
        test.startTest();
        //No se puede relizar la actualización de este campo para este profile
        co.safetyIndividualReport.Second_level_description__c = 'test';
        //Actualización falla
        try{
            update co.safetyIndividualReport;
            System.assert(false);
        }catch(Exception e){
        }
        test.stopTest();
      }
    }
}