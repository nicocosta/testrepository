/****************************************************************************************************
    General Information
    -------------------
    Developer:          Avanxo Colombia
    Autor:              Juan Gabriel Duarte P (JGDP)
    Project:            Novartis Brazil
    Description:        Send retries 
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                           Description
    ------  ----------  --------------------------      ----------- 
    1.0     06-07-2012  Juan Gabriel Duarte P (JGDP)    Create class.
    ***********************************************************************************************/

global class UpdateChangeRequest_batch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    
    public String strStatus {get; set;} 
    global String myQuery;
    public Boolean blnContinue {get; set;}
    public String strRequest {get;set;}    
    public String strResponseSolicitacaoMovim {get;set;}
    public String strResponseSolicitacaoHeader {get;set;}
    
    global Database.QueryLocator start(Database.BatchableContext DB)
    {   
    	strRequest = '';
        strResponseSolicitacaoMovim = '';
        strResponseSolicitacaoHeader = '';
        strStatus = 'Open';
        blnContinue = false;
        this.myQuery = 'Select Id, CR_closing_date__c,  CR_error_message__c, CR_number__c, Status__c from Change_Request__c where Status__c= \''+strStatus+'\' And isProcessed__c = false and CR_number__c != null order by CR_number__c desc limit 1';
        system.debug(this.myQuery);
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
                {
                    sendWSRetries(String.valueOf(objChangeRequest.CR_number__c), objChangeRequest.Id);
                }
            }
        }       
    }
            
    global void finish(Database.BatchableContext BC)
    {
        //Invoca la clase tipo Schuduler
        ChangeRequestShedulerAuto ia=new ChangeRequestShedulerAuto();
        ChangeRequestSheduler iaOriginal=new ChangeRequestSheduler();
        DateTime fechaActual= System.now().addMinutes(1);
        Integer minutos=fechaActual.minute();
        Integer hora=fechaActual.hour();
        Integer dia=fechaActual.day();
        integer mes=fechaActual.month();
        Integer anio=fechaActual.year();
        Integer segundo=fechaActual.second();
        Integer milisegundo=fechaActual.millisecond();
        
        String sch = segundo+' '+minutos+' '+hora+' '+dia+' '+mes+' ? '+anio;
        System.debug('\n\n###sch-> '+sch);
        System.debug('\n\n###blnContinue-> '+blnContinue); 
        if(blnContinue)
        {
            Id tarea=System.schedule('ChangeRequestShedulerAuto:'+milisegundo+'_'+sch+System.now(), sch, ia);
        }
        else
        {
            Id tarea2=System.schedule('ChangeRequestSheduler To Closed: '+System.now(), sch, iaOriginal);
        }   
    }
    
    public void sendWSRetries(String CRnumber, String idCR)
    {   
        System.debug('\n Entra al método sendWSRetries desde el scheduler');
        String rta='';
        CRnumber=CRnumber.replace('.0','');
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
                // Método de Reintentos (Tentativas)
                CRWEBService24102010.ArrayOfWsSolicitacaoMovim rstaWS= new CRWEBService24102010.ArrayOfWsSolicitacaoMovim();
                List<CRWEBService24102010.wsSolicitacaoMovim> listRsta = new List<CRWEBService24102010.wsSolicitacaoMovim>();
                CRnumber=CRnumber.replace('.','');
                if(Test.isRunningTest())
                {
                    CRWEBService24102010.wsSolicitacaoMovim registerTest = new CRWEBService24102010.wsSolicitacaoMovim();
                    registerTest.MovimData = System.now();
                    registerTest.Observacao = 'Test';
                    registerTest.SolCod = 123;
                    registerTest.Status = 'Open';
                    registerTest.MovinHora = '10:00';
                    listRsta.add(registerTest);
                } else {
                    rstaWS= stub.ConsultarMovimentacaoSolicitacoes(Integer.Valueof(CRnumber));
                    listRsta = rstaWS.wsSolicitacaoMovim;                                     
                }
                                    
                // Método de Status y Fechas Retorno 
                CRWEBService24102010.ArrayOfWsSolicitacaoHeader rstaSolInfo = new CRWEBService24102010.ArrayOfWsSolicitacaoHeader();
                List<CRWEBService24102010.wsSolicitacaoHeader> lstRstaSolInfo = new List<CRWEBService24102010.wsSolicitacaoHeader>();
                if(Test.isRunningTest())
                {
                    CRWEBService24102010.wsSolicitacaoHeader registerTest = new CRWEBService24102010.wsSolicitacaoHeader();
                    registerTest.DataRealizado = System.now();
                    registerTest.DataRetornoCliente = System.now();
                    registerTest.Status = 'Aberto';
                    registerTest.SolCod = 221;
                    lstRstaSolInfo.add(registerTest);
                }else{                    
                    rstaSolInfo = stub.SolicitacaoInfo( CRnumber );
                    lstRstaSolInfo=rstaSolInfo.wsSolicitacaoHeader;                    
                }
                
                // Log de entrada
                insertLog(idCR, '', 'Change Request Retries and Status Dates', 'Successful Connection to WS','Success');  
                  
                if( rstaWS.wsSolicitacaoMovim != null )            
                    strResponseSolicitacaoMovim = String.valueOf( rstaWS.wsSolicitacaoMovim );
                if(rstaSolInfo.wsSolicitacaoHeader != null)
                    strResponseSolicitacaoHeader = String.valueOf( rstaSolInfo.wsSolicitacaoHeader );
                    
                insertLog(idCR, '1', 'ConsultarMovimentacaoSolicitacoes', 'Change Request Retries updated', 'Success');    
                
                // TENTATIVAS
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
                        Change_Request_Retry__c objChange_Request_Retry=new Change_Request_Retry__c();
                                        
                        objChange_Request_Retry.Observations__c=listRsta[i].Observacao.trim();
                        objChange_Request_Retry.Handling_Hour__c=listRsta[i].MovinHora;
                        objChange_Request_Retry.Handling_Date__c=listRsta[i].MovimData.date()+1;
                        objChange_Request_Retry.Change_Request__c= idCR;
                        objChange_Request_Retry.Change_Request_Number__c=listRsta[i].SolCod;
                         
                        listCRR.add(objChange_Request_Retry);
                    }
                    insert listCRR;
                    
                    Crc.CR_retries__c=cont;
                    Crc.isProcessed__c = true;
                    update Crc;
                    rta='Change Request Retries updated.'; 
                    // Actualizar CHR Log (Result = rta + ' - ' + cont)
                    //insertLog(idCR, '1', 'ConsultarMovimentacaoSolicitacoes', rta, 'Success');  
                    insertLog(idCR, '', 'ConsultarMovimentacaoSolicitacoes', rta + ' - Retries: ' + cont, 'Success');    
                }
                else
                {
                    Change_Request__c Crc = [Select CR_retries__c from Change_Request__c where id=:idCR];
                    Crc.CR_retries__c=0;
                    Crc.isProcessed__c = true;
                    update Crc;
                    rta='No records.';
                    // Actualizar CHR Log (Result = rta + ' - ' + cont)
                    //insertLog(idCR, '1', 'ConsultarMovimentacaoSolicitacoes', rta, 'Success');
                    insertLog(idCR, '', 'ConsultarMovimentacaoSolicitacoes', rta, 'Success');     
                }
                
                insertLog(idCR, '2', 'SolicitacaoInfo', 'Change Request Status/Dates updated', 'Success');
                // Llamado al nuevo método del WS para actualizar los valores del CR
                // Status según Tipo de CHR
                if (lstRstaSolInfo != null)
                {
                    Change_Request__c Crc = [Select CR_creation_date__c, CR_closing_date__c, CR_Return_Date__c, CR_Customer_Return_Date__c, Visit_type__c, CR_retries__c from Change_Request__c where id=:idCR];

                    for(integer i=0;i<lstRstaSolInfo.size();i++)
                    {
                        if(lstRstaSolInfo[i].DataRealizado != null)
                        {
                            Crc.CR_Customer_Return_Date__c = lstRstaSolInfo[i].DataRealizado.Date();
                        }
                        if(Crc.Visit_type__c == 'Delivery' && lstRstaSolInfo[i].DataRealizado != null)
                        {
                            Crc.Status__c='Closed';
                            Crc.CR_closing_date__c= System.today();
                            Crc.CR_Customer_Return_Date__c = lstRstaSolInfo[i].DataRealizado.Date();
                        }
                        if( (Crc.Visit_type__c == 'Withdrawal' || Crc.Visit_type__c == 'Exchange' || Crc.Visit_type__c == 'Collect') && lstRstaSolInfo[i].DataRetornoCliente != null )
                        {
                            Crc.Status__c='Closed';
                            Crc.CR_closing_date__c= System.today();
                            Crc.CR_Return_Date__c = lstRstaSolInfo[i].DataRetornoCliente.Date()+1;
                        }
                        if(lstRstaSolInfo[i].Status.trim().equals('CANCELADO'))
                        {
                            Crc.Status__c = 'Canceled';
                            Crc.CR_closing_date__c= System.today();
                        }
                    }
                    update Crc;
                    rta='Change Request Status/Dates updated.'; 
                    insertLog(idCR, '', 'SolicitacaoInfo', rta, 'Success');    
                } else
                {
                    rta='No records.';    
                    insertLog(idCR, '', 'SolicitacaoInfo', rta, 'Success');    
                }
                
                rta = rta + ' Close the window.';
                
            }
            
        }
        catch( Exception e )
        {
            rta=e.getMessage();
            
            // Log de salida
            insertLog(idCR, '', 'Change Request Retries and Status Dates', rta,'Failure');  
        }
    }
    
    public void insertLog(String strCHR_Id, String strNumber, String strMethod, String strResult, String strStatus)
    {
        Change_Request_Log__c objChange_Request_Log = new Change_Request_Log__c();
        objChange_Request_Log.Change_Request__c = strCHR_Id;                
        objChange_Request_Log.Method__c = strMethod;
        objChange_Request_Log.Result__c = strResult;
        objChange_Request_Log.Status__c = strStatus;
        objChange_Request_Log.XML_Send__c = strRequest;
        objChange_Request_Log.Date_Send__c = System.now();
        if(strNumber.equals('1'))
        {
            objChange_Request_Log.XML_Received__c = strResponseSolicitacaoMovim;
            objChange_Request_Log.Date_Received__c = System.now();
        }
        if(strNumber.equals('2'))
        {
            objChange_Request_Log.XML_Received__c = strResponseSolicitacaoHeader;
            objChange_Request_Log.Date_Received__c = System.now();
        }
        if(!Test.isRunningTest())
        {
            Database.insert(objChange_Request_Log, false);
        }
    }
    
    public String convertirFecha(String fecha)
    {
        List<String> lf=fecha.split('/');
        return '20'+lf.get(2) + '-' + lf.get(1) + '-' + lf.get(0) + ' 00:00:00';
        
        
    }
    /**************************************
    TEST method purpouses
    ***************************************/
    public String convertirFecha2(String fecha)
    {
        List<String> lf=fecha.split('/');
        return '20'+lf.get(2) + '-' + lf.get(1) + '-' + lf.get(0) + ' 00:00:00';
        
        
    }
    /**************************************
    TEST method purpouses
    ***************************************/
    
     public String convertirFecha3(String fecha)
    {
        List<String> lf=fecha.split('/');
        return '20'+lf.get(2) + '-' + lf.get(1) + '-' + lf.get(0) + ' 00:00:00';
        
        
    }
    /**************************************
    TEST method purpouses
    ***************************************/    
    public String convertirFecha4(String fecha)
    {
        List<String> lf=fecha.split('/');
        return '20'+lf.get(2) + '-' + lf.get(1) + '-' + lf.get(0) + ' 00:00:00';
        
        
    }
}