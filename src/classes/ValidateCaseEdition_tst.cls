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
private class ValidateCaseEdition_tst 
{
    static testmethod void generalTest(){
      SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
      User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
      CreateTestObjects co;
      System.runAs ( userWhitAutorization ) {
        co = new CreateTestObjects();
        co.createObjects(); 
        
        ValidateCaseEdition.executeInsert = false;
        ValidationSIREdition.executeInsert = false;
        Test.startTest();
        //Tratar de actualizar casos cerrados 
        try{
            co.caseClose.Description = 'test1';
            update co.caseClose;
            System.assert(false);
        }catch(Exception e){
        }
        
        //Tratar de actualizar caso abierto
        //donde Case_Type__c.EditInfoDisable__c es falso.
        co.caseOpen.Description = 'test';
        update co.caseOpen; 
        
        //Tratar de actualizar caso abierto
        //donde Case_Type__c.EditInfoDisable__c es true.
        //La tarea esta asignada al mismo usuario
        co.caseType.EditInfoDisable__c = true; 
        update co.caseType; 
        
        co.caseOpen.Description = 'test1';
        update co.caseOpen;
        
        Test.stopTest();
        
      }
      
     }
    
    static testmethod void generalTest2(){
      SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
      User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
      CreateTestObjects co;
      System.runAs ( userWhitAutorization ) {
        
        co = new CreateTestObjects();
        co.createTask = false;
        co.createObjects(); 
        
        ValidateCaseEdition.executeInsert = false;
        ValidationSIREdition.executeInsert = false;
        Test.startTest();
        
                
        //Tratar de actualizar caso abierto
        //donde Case_Type__c.EditInfoDisable__c es true.
        //El caso no tiene tareas asignadas
        co.caseType.EditInfoDisable__c = true; 
        update co.caseType; 
        
        try{
            co.caseOpen.Description = 'test';
            update co.caseOpen;
            System.assert(false);
        }catch(Exception e){
        }
        
        
     }
     
     //Crear una tarea asiganada a otro usuario.
      co.createTask(co.caseOpen.Id, co.stage.Id,co.taskOpenStatus);
      
      //No permite actualizar ya que la tarea esta asignada a otro perfil de usuario.
      System.runAs ( userWhitAutorization ) {
          try{
            co.caseOpen.Description = 'test2';
            update co.caseOpen;
            System.assert(false);
          }catch(Exception e){
          }
      }
      Test.stopTest();
  }
  
  
  static testmethod void generalTest3(){
      SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
      User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
      System.runAs ( userWhitAutorization ) {
        
        CreateTestObjects co = new CreateTestObjects();
        co.createTask = false;
        co.createObjects(); 
        
        ValidateCaseEdition.executeInsert = false;
        ValidationSIREdition.executeInsert = false;
        Test.startTest();
        
        CreateTestObjects co2 = new CreateTestObjects();
        co2.createObjects(); 
        
        //Tratar de actualizar caso abierto
        //donde Case_Type__c.EditInfoDisable__c es true.
        //El caso no tiene tareas asignadas
        co.caseType.EditInfoDisable__c = true; 
        update co.caseType; 
        
        ValidateCaseEdition.executeInsert = false;
        
        //Masivo Falla
        List<Case> lstCase = new List<Case>();
        co.caseOpen.Description = 'test';
        co2.caseOpen.Description = 'test';
        lstCase.add(co.caseOpen);//No permite actualizar ya Case_Type__c.EditInfoDisable__c es true y no tiene tareas asignadas
        lstCase.add(co2.caseOpen);//Si permite actualizar 
        lstCase.add(co.caseOpen);
        try{
            update lstCase;
            System.assert(false);
        }catch(Exception e){
            System.debug('---->*' + e.getMessage());
        }
        
        Test.stopTest();
     }
     
     ValidateCaseEdition v = new ValidateCaseEdition();  
     v.validateEdition(null,null);
  }
  
  
  static testmethod void generalTest4(){
      SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
      User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
      System.runAs ( userWhitAutorization ) {
        
        CreateTestObjects co = new CreateTestObjects();
        co.createObjects(); 
        
        ValidateCaseEdition.executeInsert = false;
        ValidationSIREdition.executeInsert = false;
        Test.startTest();
        case otherCaseOpen = co.createCase(co.caseType, co.account, co.flowType, co.contact, co.caseOpenStage);
        insert otherCaseOpen;      
         
        //Masivo Correcto
        List<Case> lstCase = new List<Case>();
        co.caseOpen.Description = 'test';
        otherCaseOpen.Description = 'test';
        lstCase.add(co.caseOpen);//Si permite actualizar
        lstCase.add(otherCaseOpen);//Si permite actualizar 
            
        try{
            update lstCase;         
        }catch(Exception e){
            System.debug('---->*' + e.getMessage());
        }
        
        Test.stopTest();
     }
  }
  
  static testmethod void generalTest5(){
      SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
      User userWhitAutorization = [ select Id,ProfileId from User where  IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
      System.runAs ( userWhitAutorization ) {
        CreateTestObjects co = new CreateTestObjects();
        co.createObjects(); 
        
        ValidateCaseEdition.executeInsert = false;
        ValidationSIREdition.executeInsert = false;
        Test.startTest();
        
        co.caseOpen.Subcase_Description__c = 'test1';
        try{
            update co.caseOpen;         
        }catch(Exception e){
            System.debug('---->*' + e.getMessage());
        }
        
        Test.stopTest();
        
      }
      
    }
    
}