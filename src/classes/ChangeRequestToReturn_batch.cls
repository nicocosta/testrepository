global class ChangeRequestToReturn_batch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    public String strStatus {get; set;} 
    global String myQuery;
    public Boolean blnContinue {get; set;}
    
    global Database.QueryLocator start(Database.BatchableContext DB)
    {   
        strStatus = 'Closed';
        blnContinue = false;
        this.myQuery = 'Select Id,CR_Return_Date__c,CR_closing_date__c, CR_error_message__c, CR_number__c, Status__c' 
                                        +' from Change_Request__c ' 
                                        +' where Status__c= \''+strStatus+'\' And CR_number__c!= null And CR_Return_Date__c = null And Envoy__c = false limit 1';
      
        return Database.getQueryLocator(myQuery);   
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        System.debug('\n Entro al método ActualizarCR');
        if(!scope.isEmpty())
        {
            blnContinue = true;
            for( sObject sobj : scope )
            {
                Change_Request__c objChangeRequest = (Change_Request__c)sobj;
                //Verifica reintentos
                if(objChangeRequest != null)
                    sendWSRetries(String.valueOf(objChangeRequest.CR_number__c), objChangeRequest.Id);
                //Actualiza el objeto como procesado
                objChangeRequest.Envoy__c = true;
                update objChangeRequest;
                System.debug('Obj actualizado--> '+objChangeRequest.Id);
                    
            }
        }       
    }
            
    global void finish(Database.BatchableContext BC)
    {
        //Invoca la clase tipo Schuduler
        ChangeRequestToReturn_cls ia=new ChangeRequestToReturn_cls();        
        DateTime fechaActual= System.now().addMinutes(1);
        Integer minutos=fechaActual.minute();
        Integer hora=fechaActual.hour();
        Integer dia=fechaActual.day();
        integer mes=fechaActual.month();
        Integer anio=fechaActual.year();
        Integer segundo=fechaActual.second();
        
        String sch = segundo+' '+minutos+' '+hora+' '+dia+' '+mes+' ? '+anio;
        System.debug('\n\n###sch-> '+sch);
        System.debug('\n\n###blnContinue-> '+blnContinue); 
        
        if( blnContinue && !Test.isRunningTest() )
            Id tarea=System.schedule('ChangeRequestToReturn_cls:'+System.now(), sch, ia);
           
    }
    
    public void sendWSRetries(String CRnumber, String idCR)
    {   
        System.debug('\n Entra al método sendWSRetries desde el scheduler');
        String rta='';
        System.debug('\n CRnumber-> '+CRnumber);
        System.debug('\n idCR-> '+idCR);
        Long cont=0;
        
        try
        { 
            CRWEBService24102010.wsEssSoap stub = new CRWEBService24102010.wsEssSoap();
            stub.ValidationSoapHeader = new CRWEBService24102010.ValidationSoapHeader();
            stub.ValidationSoapHeader.Password = 'novartis2010';
            stub.ValidationSoapHeader.UserID = 'USR010';

            if (stub != null)
            {
                CRWEBService24102010.ArrayOfWsSolicitacaoMovim rstaWS= new CRWEBService24102010.ArrayOfWsSolicitacaoMovim();
                                
                List<CRWEBService24102010.wsSolicitacaoMovim> listRsta;
                if(Test.isRunningTest()){
                    listRsta= new List<CRWEBService24102010.wsSolicitacaoMovim>();                  
                    CRWEBService24102010.wsSolicitacaoMovim obj = new CRWEBService24102010.wsSolicitacaoMovim();
                    obj.Observacao='x';
                    obj.MovimData=System.now();
                    obj.MovinHora='y';
                    obj.Status = 'Test';
                    listRsta.add(obj);
                    
                }else{
                    listRsta= new List<CRWEBService24102010.wsSolicitacaoMovim>();
                    rstaWS= stub.ConsultarMovimentacaoSolicitacoes(Integer.Valueof(CRnumber));
                    System.debug('\n rstaWS--> '+rstaWS); 
                    listRsta=rstaWS.wsSolicitacaoMovim;                                      
                }
                System.debug('\n respuesta--> '+listRsta);
                System.debug('\n tamaño--> '+listRsta.size());                  
                if (listRsta != null || Test.isRunningTest())
                {   
                   
                    List<Change_Request_Retry__c> lstCRRDelete = new List<Change_Request_Retry__c>();
                    lstCRRDelete = [Select id, Change_Request__c from Change_Request_Retry__c where Change_Request__c=:idCR];
                    for (Change_Request_Retry__c recCRR : lstCRRDelete)
                        delete recCRR;
                    
                    list<Change_Request_Retry__c> listCRR = new list<Change_Request_Retry__c>();
                    Change_Request__c Crc = [Select CR_creation_date__c, CR_closing_date__c, CR_Return_Date__c, CR_Customer_Return_Date__c, Visit_type__c, CR_retries__c from Change_Request__c where id=:idCR];
                                        
                    //lista las respuestas del servicio
                    cont=listRsta.size();
                    for(integer i=0;i<listRsta.size();i++)
                    {
                        System.debug('listRsta[i].Observacao---> '+listRsta[i].Observacao.trim());
                        if (listRsta[i].Observacao.trim() == 'RETORNOCLIENTE')
                        {
                            Crc.CR_Return_Date__c = listRsta[i].MovimData.date()+1;
                            Crc.CR_closing_date__c= listRsta[i].MovimData.date()+1;
                            Crc.Status__c='Closed';                            
                            cont--;
                        }
                        else
                        {
                            if (listRsta[i].Status.trim() == 'ENCERRADO')
                            {
                                Crc.CR_Customer_Return_Date__c = listRsta[i].MovimData.date()+1;
                                if (Crc.Visit_type__c == 'Delivery')
                                {
                                    Crc.CR_closing_date__c= listRsta[i].MovimData.date()+1;
                                    Crc.Status__c='Closed';                                                                
                                }
                                cont--;
                            }
                            else
                            {   
                                 if (listRsta[i].Status.trim() == 'CANCELADO')
                                {
                                    Crc.CR_closing_date__c= listRsta[i].MovimData.date()+1;
                                    Crc.Status__c='Canceled';
                                    cont--;
                                }
                                else
                                {
                                    Change_Request_Retry__c objChange_Request_Retry=new Change_Request_Retry__c();
                                        
                                    objChange_Request_Retry.Observations__c=listRsta[i].Observacao.trim();
                                    objChange_Request_Retry.Handling_Hour__c=listRsta[i].MovinHora;
                                    objChange_Request_Retry.Handling_Date__c=listRsta[i].MovimData.date()+1;
                                    
                                    objChange_Request_Retry.Change_Request__c= idCR;
                                    objChange_Request_Retry.Change_Request_Number__c=listRsta[i].SolCod;
                                     
                                    listCRR.add(objChange_Request_Retry);
                                    }
                                
                            }
                        }
                    }
                    
                    insert listCRR;
                  
                    Crc.CR_retries__c=cont;
                    update Crc;
                    rta='Change Request Retries updated. Close the window.';
                    
                    System.debug('rta 1'+rta);
                }
                else
                {
                    Change_Request__c Crc = [Select CR_retries__c from Change_Request__c where id=:idCR];
                    Crc.CR_retries__c=0;
                    update Crc;
                    rta='No records. Close the window.';
                    
                    System.debug('rta 2'+rta);
                }
        
            }
            
        }
        catch( Exception e )
        {
            rta=e.getMessage();
            
            System.debug('rta 3'+rta);
        }
    }
 }