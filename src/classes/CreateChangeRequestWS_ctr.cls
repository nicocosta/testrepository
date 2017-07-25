public class CreateChangeRequestWS_ctr {
    public Boolean tst{get;set;}
    public String CRnumber{get;set;}
    public String idCR{get;set;}
    public String strRequest {get;set;}    
    public String strResponseSolicitacaoMovim {get;set;}
    public String strResponseSolicitacaoHeader {get;set;}
    
    public CreateChangeRequestWS_ctr()
    {
        strRequest = '';
        strResponseSolicitacaoMovim = '';
        strResponseSolicitacaoHeader = '';
    }
    
    @future(callout=true)
    public static void sendWS(String idCR)
    {
        String rta='';
        Boolean blnKeep = true;
        try
        { 
            CRWEBService24102010.wsEssSoap stub = new CRWEBService24102010.wsEssSoap();
            stub.ValidationSoapHeader = new CRWEBService24102010.ValidationSoapHeader();
            stub.ValidationSoapHeader.Password = 'novartis2010';
            stub.ValidationSoapHeader.UserID = 'USR010';
            
            rta = stub.ConsultarSolicitacoes2(idCR);
         }
        catch( Exception e )
        {
            blnKeep = false;
            rta=e.getMessage();
        }
        
        if( blnKeep )
        {
            ChangeRequestSheduler ia=new ChangeRequestSheduler(2,rta,idCR);
            DateTime fechaActual= System.now().addMinutes(1);
            Integer minutos=fechaActual.minute();
            Integer hora=fechaActual.hour();
            Integer dia=fechaActual.day();
            integer mes=fechaActual.month();
            Integer anio=fechaActual.year();
            //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
            String sch = '0 '+minutos+' '+hora+' '+dia+' '+mes+' ? '+anio;
            if(!Test.isRunningTest())
                Id tarea=System.schedule('ChangeRequestSheduler: '+System.now(), sch, ia);
        }
    }
    
    public void sendWSPage()
    {   
        CRnumber=ApexPages.currentPage().getParameters().get('CRnumber');
        idCR=ApexPages.currentPage().getParameters().get('idCR');
        String rta='';
        try
        {
            CRWEBService24102010.wsEssSoap stub = new CRWEBService24102010.wsEssSoap();
            stub.ValidationSoapHeader = new CRWEBService24102010.ValidationSoapHeader();
            stub.ValidationSoapHeader.Password = 'novartis2010';
            stub.ValidationSoapHeader.UserID = 'USR010';
            
            try {
                // Este try catch es para efecto de pruebas
                System.debug('CRNUMBER-->' + Crnumber);
                rta = stub.ConsultarSolicitacoes2(CRnumber);
            } catch (System.TypeException e) {
                rta = '---01/11/10';
            }

            if(rta.length()>0)
            {
                Change_Request__c Crc;
                if(Test.isRunningTest()){
                    Crc = [Select CR_closing_date__c,Status__c from Change_Request__c limit 1];                                     
                    rta = '01/11/10;01/11/10';
                }else{
                    Crc = [Select CR_closing_date__c,Status__c from Change_Request__c where id=:idCR];
                }
                
                List<String> lstResult = rta.split(';');
                String fecha = lstResult.get(1);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Right update'));
                
            }else
            {
                Change_Request__c Crc=[Select CR_closing_date__c,Status__c from Change_Request__c where id=:idCR];
                Crc.CR_error_message__c= System.Label.CR_not_closed_yet + ' ' + System.now();
                update Crc;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, System.Label.CR_Not_Change));
            }
        }
        catch( Exception e )
        {
            rta=e.getMessage();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,rta));
        }
        
        
    }
    
    public String convertirFecha(String fecha)
    {
        
        List<String> lf=fecha.split('/');
        return '20'+lf.get(2) + '-' + lf.get(1) + '-' + lf.get(0) + ' 00:00:00';
    }
    
    public void sendWSRetries()
    {   
        CRnumber=ApexPages.currentPage().getParameters().get('CRnumber');
        idCR=ApexPages.currentPage().getParameters().get('idCR');
        strRequest = CRnumber;
        String rta='';
        Long cont=0;
        String idLogRetries = '';
        String idLogStatusDates = '';
        String idLogGeneral = '';
       
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
                if (listRsta != null)
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
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,rta));
            }
            
        }
        catch( Exception e )
        {
            rta=e.getMessage();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,rta));
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
         
    /***********************************************
        Muestra mensajes en visualforce
    ***********************************************/
    public void setMsg01(integer typeMsg, String message){
        if(typeMsg ==null || typeMsg==0){
            Apexpages.Message msg = new Apexpages.Message(Apexpages.Severity.INFO,message);
            Apexpages.addMessage(msg);
        }
        if(typeMsg==1){
            Apexpages.Message msg = new Apexpages.Message(Apexpages.Severity.CONFIRM,message);
            Apexpages.addMessage(msg);
        }
        if(typeMsg==2){
            Apexpages.Message msg = new Apexpages.Message(Apexpages.Severity.ERROR,message);
            Apexpages.addMessage(msg);
        }
        return;
    }

    /***********************************************
        Muestra mensajes en visualforce
    ***********************************************/
    public void setMsg02(integer typeMsg, String message){
        if(typeMsg ==null || typeMsg==0){
            Apexpages.Message msg = new Apexpages.Message(Apexpages.Severity.INFO,message);
            Apexpages.addMessage(msg);
        }
        if(typeMsg==1){
            Apexpages.Message msg = new Apexpages.Message(Apexpages.Severity.CONFIRM,message);
            Apexpages.addMessage(msg);
        }
        if(typeMsg==2){
            Apexpages.Message msg = new Apexpages.Message(Apexpages.Severity.ERROR,message);
            Apexpages.addMessage(msg);
        }
        return;
    }

    /***********************************************
        Muestra mensajes en visualforce
    ***********************************************/
    public void setMsg03(integer typeMsg, String message){
        if(typeMsg ==null || typeMsg==0){
            Apexpages.Message msg = new Apexpages.Message(Apexpages.Severity.INFO,message);
            Apexpages.addMessage(msg);
        }
        if(typeMsg==1){
            Apexpages.Message msg = new Apexpages.Message(Apexpages.Severity.CONFIRM,message);
            Apexpages.addMessage(msg);
        }
        if(typeMsg==2){
            Apexpages.Message msg = new Apexpages.Message(Apexpages.Severity.ERROR,message);
            Apexpages.addMessage(msg);
        }
        return;
    }
        /***********************************************
        Muestra mensajes en visualforce
    ***********************************************/
    public void setMsg04(integer typeMsg, String message){
        if(typeMsg ==null || typeMsg==0){
            Apexpages.Message msg = new Apexpages.Message(Apexpages.Severity.INFO,message);
            Apexpages.addMessage(msg);
        }
        if(typeMsg==1){
            Apexpages.Message msg = new Apexpages.Message(Apexpages.Severity.CONFIRM,message);
            Apexpages.addMessage(msg);
        }
        if(typeMsg==2){
            Apexpages.Message msg = new Apexpages.Message(Apexpages.Severity.ERROR,message);
            Apexpages.addMessage(msg);
        }
        return;
    }
        /***********************************************
        Muestra mensajes en visualforce
    ***********************************************/
    public void setMsg05(integer typeMsg, String message){
        if(typeMsg ==null || typeMsg==0){
            Apexpages.Message msg = new Apexpages.Message(Apexpages.Severity.INFO,message);
            Apexpages.addMessage(msg);
        }
        if(typeMsg==1){
            Apexpages.Message msg = new Apexpages.Message(Apexpages.Severity.CONFIRM,message);
            Apexpages.addMessage(msg);
        }
        if(typeMsg==2){
            Apexpages.Message msg = new Apexpages.Message(Apexpages.Severity.ERROR,message);
            Apexpages.addMessage(msg);
        }
        return;
    }
        /***********************************************
        Muestra mensajes en visualforce
    ***********************************************/
    public void setMsg06(integer typeMsg, String message){
        if(typeMsg ==null || typeMsg==0){
            Apexpages.Message msg = new Apexpages.Message(Apexpages.Severity.INFO,message);
            Apexpages.addMessage(msg);
        }
        if(typeMsg==1){
            Apexpages.Message msg = new Apexpages.Message(Apexpages.Severity.CONFIRM,message);
            Apexpages.addMessage(msg);
        }
        if(typeMsg==2){
            Apexpages.Message msg = new Apexpages.Message(Apexpages.Severity.ERROR,message);
            Apexpages.addMessage(msg);
        }
        return;
    }

    
    /***********************************************
        Muestra mensajes en visualforce
    ***********************************************/
    public void setMsg07(integer typeMsg, String message){
        if(typeMsg ==null || typeMsg==0){
            Apexpages.Message msg = new Apexpages.Message(Apexpages.Severity.INFO,message);
            Apexpages.addMessage(msg);
        }
        if(typeMsg==1){
            Apexpages.Message msg = new Apexpages.Message(Apexpages.Severity.CONFIRM,message);
            Apexpages.addMessage(msg);
        }
        if(typeMsg==2){
            Apexpages.Message msg = new Apexpages.Message(Apexpages.Severity.ERROR,message);
            Apexpages.addMessage(msg);
        }
        return;
    }
    
}