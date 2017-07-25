/****************************************************************************************************
    General Information
    -------------------
    Developer:          Avanxo Colombia
    Autor:              Juan Pablo Gracia
    Project:            Novartis Brazil
    Description:        ValidationRules_CaseComment's Test.
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     08-04-2011  Juan Pablo Gracia           Create class.
    ****************************************************************************************************/
@isTest
private class ValidationRules_CaseComment_tst {

    static testmethod void generalTest(){
      SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
      User userWhitAutorization = [ select Id,ProfileId from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
      CaseComment c;
      System.runAs ( userWhitAutorization ) {
        CreateTestObjects co = new CreateTestObjects();
        co.createObjects();
        
        Test.startTest();
        
        //Caso Abierto
        List<CaseComment> lstc = new List<CaseComment>(); 
        c =  new CaseComment();
        c.ParentId = co.caseOpen.Id;
        lstc.add(c);
        
        c =  new CaseComment();
        c.ParentId = co.caseOpen.Id;
        lstc.add(c);
        
        //Masivo
        insert lstc;
        
        //No lo puede eliminar por que es de un caso.   
        try{
            delete c;
            System.assert(false);
        }catch (Exception e){
        }
        
         //Caso cerrado
        c =  new CaseComment();
        c.ParentId = co.caseClose.Id;
        insert c;
            
      }
      
       //No se puede actualizar con otro perfil
      try{
        update c;
        System.assert(false);
      }catch(Exception e){
      }
    
       Test.stopTest();
    }
    
    static testmethod void generalTest2(){
      SubcaseTgrTaskSetUp__c conf= SubcaseTgrTaskSetUp__c.getInstance();
      User userWhitAutorization = [ select Id,ProfileId, Profile.Name from User where IsActive = true AND ProfileId = :conf.PvProfileId__c LIMIT 1];
      CaseComment c;
      System.runAs ( userWhitAutorization ) {
        CreateTestObjects co = new CreateTestObjects();
        co.createObjects();
        
        Test.startTest();
        
        //No se puede editar dado que se validan los comentarios
        co.stage.Validate_Comments__c = true;
        co.stage.Users_profiles__c = 'test';
        update co.stage;
        
        //Crear otra tarea
        co.createTask(co.caseOpen.Id, co.stage.Id,co.taskOpenStatus);
        
        c =  new CaseComment();
        c.ParentId = co.caseOpen.Id;
        try{
            insert c;
            System.assert(true);
        }catch(Exception e){
        }
        
         //Se puede editar dado que se validan con el perfil correcto
        co.stage.Validate_Comments__c = true;
        co.stage.Users_profiles__c = userWhitAutorization.Profile.Name;
        update co.stage;
        try{
       insert c;
       
        }catch(Exception e){
        }
    
      }
      
       Test.stopTest();
      
    }
}