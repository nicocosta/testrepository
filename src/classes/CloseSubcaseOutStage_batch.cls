/**                                                     
* ===================================================================================================================================
*  Desarrollado por:    Avanxo Colombia
*  @AUTHOR:             Juan Gabriel Duarte Pacheco
*  Fecha:               Mayo 23 de 2013
*  Decripción:          Clase que actualiza los subcasos abiertos a cerrados dado que el FlowType no tiene Stages
*  @version:            1.0
* ===================================================================================================================================
*       Version     Fecha                       Desarrollador                   Observaciones
*       1.0         Mayo 23 de 2013             JGDP                            Creación
**/

global class CloseSubcaseOutStage_batch implements Database.Batchable<SObject>,Database.AllowsCallouts,Database.Stateful{
    public String myQuery;
    
    global CloseSubcaseOutStage_batch()
    {
        myQuery = 'Select Id, Status From Case Where RecordType.Name = \'Subcase\' and Status= \'Open\' and Flow_Type__r.Stage_Number__c=0 ';
        
       if(Test.isRunningTest()) 
       {
           myQuery+=' limit 10';
       }
    }
    
    global Database.QueryLocator start(Database.BatchableContext DB) 
    {
        return Database.getQueryLocator(myQuery);
    }
    
    global void execute(Database.BatchableContext DB, List<sObject> scope)
    {
        for( sObject sobj : scope )
        {
            Case objCase = (Case)sobj;
            objCase.Status = 'Closed';
        }
        
        if(!scope.IsEmpty())
        {
            Database.update(scope, false);
        }
    }
    
    global void finish(Database.BatchableContext DB)
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> listEmails= new List<String>();
        List<ListaCorreosBatch__c> lstEmail = ListaCorreosBatch__c.getall().values();
        Config_EmailTemplate__c confET= Config_EmailTemplate__c.getInstance('CloseSubcaseOutStage');

        for(ListaCorreosBatch__c objemail:lstEmail)
        {
            listEmails.add(objemail.Name);
        }

        mail.setToAddresses(listEmails);        
        mail.setTemplateId(confET.TemplateId__c);
        mail.setTargetObjectId(UserInfo.getUserId());
        mail.setSaveAsActivity(false);

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
}