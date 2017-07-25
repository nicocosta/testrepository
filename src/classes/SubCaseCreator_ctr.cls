public with sharing class  SubCaseCreator_ctr
{
    /* ATRIBUTOS PRIVADOS */ 
    private final String MSG_INFO = 'Info';
    private final String MSG_WARNING = 'Warning';
    private final String MSG_ERROR = 'Error';
    private final String MSG_CONFIRM = 'Confirm';
    private final String MSG_FATAL = 'Fatal';
    private Map<String,String> mapParameters;
    private final ApexPages.StandardController controller;
    
    /* ATRIBUTOS PÚBLICOS */
    public boolean renderAccount{ get; set; }
    public boolean isEdit{ get; set; }
    public boolean isCreate{ get; set; }
    public String accNameNew{ get; set; }
    public String accPhoneNew{ get; set; }   
    public Boolean blnDisplayPage { get; set; }
    public Case SubCase { get; set; }
    public Case_Type__c caseType { get; set; }
    public String strCaseTypeName { get; set; }
    public String strFlowTypeName { get; set; }
    public Boolean isFlowAutomaticSIRCreation { get; set; }
    public String strSubTitle { get; set; }
    public Boolean inputParentId { get; set; }
    public String host {get;set;}
    public Boolean isVisibleReimbursement{get;set;}    
    public Boolean isVisibleAutoReimbursement{get;set;}        
    public String autoReimbursementValue{get;set;}
    
        
    public Boolean blnFAQPanel{get;set;}
    public List<FAQxProduct__c > lstFAQ{get;set;}
    public Boolean blnIsNotCreated { get;set; }
    
    public List<SelectOption> lstFlows
    {
        get
        {
            lstFlows = new List<SelectOption>();
            lstFlows.add( new SelectOption( '', ' --None--' ) );
            if( SubCase.Case_Type__c != null )
            {
                for( Case_Type_x_Flow_Type__c ft : [    Select  Id, Flow_Type__r.Description__c, Flow_Type__r.Flow_Number__c,
                                                                Flow_Type__c, Case_Type__c 
                                                        From    Case_Type_x_Flow_Type__c 
                                                        Where   Case_Type__c = :SubCase.Case_Type__c ] )
                {
                    lstFlows.add( new SelectOption( ft.Flow_Type__c, ft.Flow_Type__r.Flow_Number__c + ' -- ' + ft.Flow_Type__r.Description__c) );
                }
            }
            return lstFlows;
        }
        
        set;
    }
    
    public Boolean showRevalidation
    {
        get
        {
            if(CaseType!=null && CaseType.Show_Revalidation_Section__c)
                return true;
            else
                return false;
        }
        set;
    }
    
    public Boolean showComplaint
    {
        get
        {
            
            //JPG 13-03-2012 Cambio por nuevo campo de configuración Show_Technical_Complaint__c
            /*if( CaseType != null && CaseType.Subcase_type__c.equalsIgnoreCase( 'Complaint' ) && CaseType.Subcase_Subtype__c.equalsIgnoreCase( 'Technical Complaint' ) )
                return true;
            else if( CaseType != null && CaseType.Subcase_subtype__c.equalsIgnoreCase( 'Safety Report' ) && (CaseType.Theme__c.equalsIgnoreCase( 'tecnovigilância' ) || CaseType.Theme__c.equalsIgnoreCase( 'Technical surveillance' ) ) )
                return true;*/
                
            if(CaseType!=null && CaseType.Show_Technical_Complaint__c)
                return true;
            /* Siempre los valores están en ingles... OJO PROBAR!!!!
            else if( CaseType != null && CaseType.Subcase_type__c.equalsIgnoreCase( 'reclamação' ) && CaseType.Subcase_subtype__c.equalsIgnoreCase( 'reclamação técnica' ) )
                return true;*/
            else
                return false;
        }
        set;
    }
    
    public Boolean showRequest
    {
        get
        {
            
            
            if( CaseType != null && CaseType.Subcase_type__c.equalsIgnoreCase( 'Request' ) && CaseType.Subcase_Subtype__c.equalsIgnoreCase( 'Request Technical' ) )
                return true;
            /*Siempre los valores están en ingles... OJO PROBAR!!!!
            else if( CaseType != null && CaseType.Subcase_type__c.equalsIgnoreCase( 'solicitação' ) && CaseType.Subcase_subtype__c.equalsIgnoreCase( 'reclamação técnica' ) )
                return true;*/
            else
                return false;
        }
        set;
    }
    
    public Boolean showReimbursment
    {
        get
        {
            Case c = (Case) this.controller.getRecord();
            System.debug( 'showReimbursment c: ' + c );
            System.debug( 'showReimbursment CaseType: ' + CaseType );
            if( showComplaint && c.Reimbursement_via__c != null && ( c.Reimbursement_via__c.equalsIgnoreCase( 'Money' ) || c.Reimbursement_via__c.equalsIgnoreCase( 'Ressarcimento em dinheiro' ) || c.Reimbursement_via__c.equalsIgnoreCase( 'Delivery' ) ) )
                return true;
            else
                return false;
        }
        set;
    }
    
    public Boolean showPatient
    {
        get
        {
            /*System.debug( '*¨*¨*¨* CaseType: ' + CaseType );
            if( CaseType != null )
                System.debug( '*¨*¨*¨* CaseType.Subcase_type__c.equalsIgnoreCase( relato ): ' + CaseType.Subcase_type__c.equalsIgnoreCase( 'relato' ) );
            /*if( CaseType != null && ( CaseType.Subcase_type__c.equalsIgnoreCase( 'relato' ) || CaseType.Subcase_type__c.equalsIgnoreCase( 'Safety Report' )) )
                return true;
            else*//* if( CaseType != null && CaseType.Subcase_subtype__c.equalsIgnoreCase( 'Safety Report' ) && ( CaseType.Theme__c.equalsIgnoreCase( 'Pharmacovigilance' ) || CaseType.Theme__c.equalsIgnoreCase( 'Technovigilance' ) ) )
                return true;
            else if( CaseType != null && CaseType.Subcase_subtype__c.equalsIgnoreCase( 'Technical Complaint' ) && CaseType.Theme__c.contains( 'with pharmacovigilance reporting and recall' )  )
                return true;
            /* Siempre los valores están en ingles... OJO PROBAR!!!!
            else if( CaseType != null && CaseType.Subcase_type__c.equalsIgnoreCase( 'reclamação' ) && CaseType.Subcase_subtype__c.equalsIgnoreCase( 'reclamação técnica' ) && CaseType.Theme__c.contains( 'com relato de farmacovigilância' ) )
                return true;*/
            /*else
                return false;*/
            if( CaseType != null )
                return CaseType.Show_Patient_Field__c;
            else
                return false;
        }
        set;
    }
    
    /*****   Sección Subcasos Relacionados   *********/
    public Integer indiceLista {get;set;}
    public Integer consecutivo {get;set;}   
    public Boolean showRemoveBttn {get;set;}
    public String strSubcase {get;set;}
    public String strIdSubcase {get;set;}
    
    public list<String> lst_items {get;set;}    
    public list< WrapperClass> lst_wrp {get;set;}
    public map<Integer,WrapperClass> map_wrp {get;set;} 

    public class WrapperClass{
        public Integer posicion {get;set;}
        public String   strSubcaseId {get;set;}
        public String   strSubcaseName {get;set;}
        public Boolean blnDisabled {get;set;}
        public Related_Subcase__c obj_rs {get;set;}
        public String strRTNumberDocumentation {get;set;}
        public String strRTNumberSample {get;set;}
        public String strSystemNumber {get;set;}
        public String strSubcaseType {get;set;}
    }

    /**************************************************/
    
    /* CONSTRUCTOR */
    public SubCaseCreator_ctr( ApexPages.Standardcontroller controller )
    {
        
        this.isVisibleAutoReimbursement=false;
        this.isVisibleReimbursement=true;        
        this.isEdit=true;   
        this.isCreate=false;
        this.autoReimbursementValue='...';
        System.debug('EntroTest0');
        this.controller = controller;
        this.blnFAQPanel= false;
        SubCase = (Case)this.controller.getRecord();
        System.debug('*********Subcase.Id-->' + SubCase.Id);
         
        System.debug('*********-->' + SubCase.RecordTypeId);
        blnDisplayPage = false;
        strCaseTypeName = '';
        mapParameters = Apexpages.currentPage().getParameters();
        inputParentId = false;
        if( mapParameters.containsKey( 'clone' ) && mapParameters.get( 'clone' ) == '1' )
            strSubTitle = System.Label.New_SubCase;
        else
            strSubTitle = SubCase.CaseNumber;
        if( SubCase.Flow_Type__c != null ){
            Flow_Type__c ftype = [Select Id,Automatic_SIR_Creation__c,toLabel(Reimbursement_via__c) From Flow_Type__c Where Id = :SubCase.Flow_Type__c limit 1]; 
            
            //scardona 15/08/2013. Se añade la sentencia toLabel() al Query para traer la información del campo "Reimbursement_via__c"
            // en el idioma del Usuario.        
            Flow_Type__c ftypeNoTranslate = [Select Id,toLabel(Reimbursement_via__c) From Flow_Type__c Where Id = :SubCase.Flow_Type__c limit 1];
            
            strFlowTypeName = ftype.Id;
            isFlowAutomaticSIRCreation=ftype.Automatic_SIR_Creation__c;
            //grey@17/08/2012 Change Control for auto asign reimbursement...            
            System.debug('\n:SubCase.Reimbursement_via__c: '+ SubCase.Reimbursement_via__c);           
            if(SubCase.Reimbursement_via__c!=null&& ftype.Reimbursement_via__c!=null){              
                this.autoReimbursementValue=ftype.Reimbursement_via__c;
                SubCase.Reimbursement_via__c=ftypeNoTranslate.Reimbursement_via__c;            
            }
            System.debug('\nAssign autoReimbursementValue: '+ this.autoReimbursementValue);
            System.debug('\nID_FlowType: '+ strFlowTypeName);           
        }else
        //JPG 02-05-2011    
        if(SubCase.Status==null) SubCase.Status ='open'; 
        host='https://' + ApexPages.currentPage().getHeaders().get('Host') + '/';   
         
         //JGD 27-07-2012. Cambio 336351. Se oculta lupa de Tipo subcaso y lista de selección del flujo de tarea.
        if( mapParameters.containsKey( 'clone' ) && mapParameters.get( 'clone' ) == '1' ){
            blnIsNotCreated = true;
            this.isEdit=false;
            this.isCreate =true;
            System.debug('\nES CLONADO');            
        }        
        else if (mapParameters.containsKey( 'NewSC' ) && mapParameters.get( 'NewSC' ) == '1'){
            blnIsNotCreated = true;
            this.isCreate=true;
            System.debug('\nES newSC'); 
        }
            
        else        
            blnIsNotCreated = false;
            
        System.debug('blnIsNotCreated-> '+blnIsNotCreated);
        System.debug('SubCase-> '+SubCase);
        System.debug('SubCase.Id-> '+SubCase.Id);
        
        System.debug('\nSubCase Reimbursement: '+SubCase.Reimbursement_value__c);
        //grey@21/08/2012 Change Control for auto asign reimbursement...                
        if(this.isEdit && this.autoReimbursementValue!=null&&SubCase.Flow_Type__c!=null&& (!this.autoReimbursementValue.equals('...'))){                                   
            this.isVisibleAutoReimbursement=true;
            this.isVisibleReimbursement=false;                                                                                                          
        }
        
        /***** Subcaso Relacionado *********/
        showRemoveBttn = false;
        consecutivo = 1;
        strSubcase = '';
        
        map_wrp = new map<Integer,WrapperClass>();      

        WrapperClass wrp = new WrapperClass();
        wrp.posicion = consecutivo;
        wrp.strSubcaseName = strSubcase;
        wrp.strSubcaseId = strIdSubcase;
        wrp.blnDisabled = false;
        wrp.obj_rs = new Related_Subcase__c();
        wrp.strRTNumberDocumentation = ''; 
        wrp.strRTNumberSample = '';
        wrp.strSystemNumber = '';
        wrp.strSubcaseType = '';
        
        map_wrp.put( consecutivo, wrp );
        System.debug('map_wrp.size() -> '+map_wrp.size());
        System.debug('map_wrp.values() -> '+map_wrp.values());
        lst_wrp = map_wrp.values();
        System.debug('lst_wrp-> '+lst_wrp);
        
        /*****************************************/
    }
    /* PUBLIC METHODS */
    public void searchFAQProduct()
    {
        System.debug('********>>>'+ SubCase.Product__c);
        System.debug(' Existe en la configuración personalizada-> ' + ProfilesAreAllFAQ__c.getAll().containsKey(Userinfo.getProfileId()) );
        //JGD 28-07-2012. Cambio 336359. Se incluye una validación de perfiles, para que sólo estos puedan ver todos los FAQ, de lo contrario solo verán los que estén activos.
        if( ProfilesAreAllFAQ__c.getAll().containsKey(Userinfo.getProfileId()) )
        {   
            this.lstFAQ=[Select f.Product__c, f.Name, f.Id, f.FAQ_title__c, FAQ_title__r.Name, f.FAQ_key_words__c, f.FAQ_Summary__c, f.FAQ_Addressee__c 
                                                   From FAQxProduct__c f
                                                        where f.Product__c=:SubCase.Product__c];                                                                    
        }
        else
        {   
            this.lstFAQ=[Select Product__c, Name, Id, FAQ_title__c, FAQ_title__r.Name,FAQ_title__r.Status__c,FAQ_key_words__c, FAQ_Summary__c, FAQ_Addressee__c 
                                                   From FAQxProduct__c 
                                                        where Product__c=:SubCase.Product__c
                                                        and FAQ_title__r.Status__c = 'Active'];
        }                                                       
        
        this.blnFAQPanel=true;
        if(this.lstFAQ.size()==0)
        {                                            
            this.lstFAQ=null;
        }
    }
    
    public PageReference URL_Analist()
    {
        System.debug('\n  INIT ANALITYCS  URL ');
        try
        {
            showRelatedSubcase();//Muestra los subcasos relacionados una vez se intenta editar un subcaso
            if( mapParameters.containsKey( 'id' ) && !mapParameters.containsKey( 'RecordType' ) )
            {
                if( SubCase.RecordType.Name.equalsIgnoreCase( 'SubCase' ) )
                {
                    blnDisplayPage = true;
                    if( SubCase.Case_Type__c != null )
                    {
                        caseType = [    Select  Theme__c, Subcase_type__c, Subcase_subtype__c, Script__c, 
                                                Scenario__c, Name, Show_Patient_Field__c, Show_Technical_Complaint__c, Show_Revalidation_Section__c
                                        From    Case_Type__c
                                        Where   id = :SubCase.Case_Type__c ];
                        strCaseTypeName = caseType.Name;
                    }
                    if( SubCase.ParentId != null )
                        SubCase.Origin = [ Select Origin From Case Where id = :SubCase.ParentId ].Origin;
                    inputParentId = false;
                }
                else
                {
                    String strUrlTemp = '';
                    for( String strKey : mapParameters.keySet() )
                    {
                        if( !strKey.equalsIgnoreCase( 'save_new' ) )
                            strUrlTemp += '&' + strKey + '=' + mapParameters.get( strKey );
                    }
                    
                    System.debug( '/*/*/*/*/*/ strUrlTemp: ' + strUrlTemp );
                    
                    PageReference pr = new PageReference( '/500/e?nooverride=1' + strUrlTemp );
                    pr.setRedirect( true );
                    return pr;
                }
            }
            else if( mapParameters.containsKey( 'id' ) && mapParameters.containsKey( 'RecordType' ) )
            {
                strSubTitle = System.Label.New_SubCase;
                RecordType rt = [ Select id, Name From RecordType Where id = :mapParameters.get( 'RecordType' ) ];
                if( rt.Name.equalsIgnoreCase( 'SubCase' ) )
                {
                    blnDisplayPage = true;
                    String strParentId = SubCase.ParentId;
                    inputParentId = true;
                    if( mapParameters.containsKey( 'id' ) && mapParameters.containsKey( 'RecordType' ) )
                    {
                        SubCase.ParentId = mapParameters.get( 'id' );
                        inputParentId = false;
                    }
                    SubCase.RecordTypeId = mapParameters.get( 'RecordType' );
                    if( strParentId != null )
                        SubCase.Origin = [ Select Origin From Case Where id = :strParentId ].Origin;
                    
                }
                else
                {
                    String strUrlTemp = '';
                    for( String strKey : mapParameters.keySet() )
                    {
                        if( !strKey.equalsIgnoreCase( 'save_new' ) )
                            strUrlTemp += '&' + strKey + '=' + mapParameters.get( strKey );
                    }
                    
                    System.debug( '/*/*/*/*/*/ <A>  strUrlTemp: ' + strUrlTemp );
                    
                    PageReference pr = new PageReference( '/500/e?nooverride=1' );
                    pr.setRedirect( true );
                    return pr;
                }
            }
            //Determine if is variable New_SC
            else if ( mapParameters.containsKey('NewSC' )){
                //Get val from  NewSC varible.              
                String newSC = mapParameters.get( 'NewSC');             
                System.debug('\nNewSC : '+newSC);
                //if is  New_SC=1               
                if(newSC.equals('1')){
                    Account a = getAccountById(mapParameters.get('AccIdNew'));
                    if(a!=null){
                        SubCase.AccountId= a.Id; 
                        RecordTypesId__c rt = RecordTypesId__c.getInstance('BusinessCustomer');
                        if(rt.RecordTypeId__c== a.RecordTypeId){
                            if(a.Main_Contact__c!=null){
                                Contact c = getContactByIdAccount(a.Main_Contact__c);
                                if(c!=null)SubCase.ContactId = c.Id;
                            }
                        }else{
                            Contact c = getContactByIdAccount(a.Id);
                            if(c!=null)SubCase.ContactId = c.Id;
                        }
                    }
                    renderAccount=true;
                    System.debug('\nNewSC is <ONE>' );
                    System.debug('\nSubCase.AccountId:'+  SubCase.AccountId);
                    System.debug('\nRenderAccount:'+  renderAccount);
                }else if(newSC.equals('2')){
                    renderAccount=false;
                    accNameNew=mapParameters.get('AccNameNew');
                    accPhoneNew=mapParameters.get('AccPhoneNew');
                    System.debug('++++******ok1');
                    SubCase.Apply_Validation_Rules__c = true;
                    System.debug('\nNewSC is <TWO>' );
                    System.debug('\n accNameNew'+accNameNew);
                    System.debug('\n accountPhoneNew'+accPhoneNew);                                                     
                }
                
                //Establece SubCase__c.AccountId=
            
            
            }
            //Determine if is variable New_SC = 2
            else if ( mapParameters.containsKey( 'id' ) && mapParameters.containsKey( 'RecordType' )  ){
            
            
            }
                        
            else
            {
                String strUrlTemp = '';
                for( String strKey : mapParameters.keySet() )
                {
                    if( !strKey.equalsIgnoreCase( 'save_new' ) )
                        strUrlTemp += '&' + strKey + '=' + mapParameters.get( strKey );
                }
                
                System.debug( '/*/*/*/*/*/ <B> strUrlTemp: ' + strUrlTemp );
                
                PageReference pr = new PageReference( '/500/e?nooverride=1' + strUrlTemp );
                pr.setRedirect( true );
                return pr;
            }
        }
        catch( System.exception e )
        {
            addMsg( MSG_FATAL, 'Invalid parameters', '' );
        }
        System.debug( '-*/-*/ SubCase: ' + SubCase );
        return null;
    }
    
    public Account getAccountById(String idAccount){
        try{
            Account a = [Select a.RecordTypeId, a.Main_Contact__c From Account a Where id=:idAccount];
            return a;
        }catch( System.Exception e ){
            return null;
        }
    }
    
    public Contact getContactByIdAccount(String idAccount){
        try{
            Contact c = [Select c.Id From Contact c Where c.AccountId=:idAccount LIMIT 1];
            return c;
        }catch( System.Exception e ){
            return null;
        }
    }
    
    public PageReference updateCaseTypeInfo()
    {
        try
        {
            caseType = [    Select  Theme__c, Subcase_type__c, Subcase_subtype__c, Script__c, 
                                    Scenario__c, Name, Show_Patient_Field__c, Show_Technical_Complaint__c, Show_Revalidation_Section__c
                            From    Case_Type__c
                            Where   id = :SubCase.Case_Type__c ];
            strCaseTypeName = caseType.Name;            
            
        }
        catch( System.Exception e )
        {
            addMsg( MSG_FATAL, 'Case Type Id invalid', 'SubCase.Case_Type__c' + SubCase.Case_Type__c );
            caseType = new Case_Type__c();
        }        
        return null;
    }
    
    public PageReference btnSave()
    {
        
        Savepoint sp = Database.setSavepoint();
          
        if(mapParameters.containsKey('NewSC' )){ 
            System.debug('Estro: NewSC ');                  
            Case var =this.createCase(SubCase.AccountId, SubCase.ContactId);
            if(var==null)return null;
            SubCase.ParentId  = var.id;
            
            //JPG 16/05/2011
            if(SubCase.RecordTypeId==null){
                RecordType rTSubcases = [select Name from RecordType where Name = 'Subcase'];
                SubCase.RecordTypeId=rTSubcases.id; 
            }
                    
        }
                        
        System.debug('EstroTest1: ');
        Case SubCaseFinal = (Case)this.controller.getRecord();
        if( strCaseTypeName == null || strCaseTypeName == '' )
        {
            SubCase.Case_Type__c = null;
            strFlowTypeName = null;
        }
        
        subCaseFinal.Case_Type__c = SubCase.Case_Type__c;
        SubCaseFinal.Flow_Type__c = strFlowTypeName;
        if (strFlowTypeName!=null && strFlowTypeName!='')
        isFlowAutomaticSIRCreation=[Select Automatic_SIR_Creation__c From Flow_Type__c Where Id = :strFlowTypeName limit 1].Automatic_SIR_Creation__c;
        //SubCaseFinal.ContactId = subCase.ContactId;
        System.debug( '>>> Contact: ' + SubCase.ContactId );
        System.debug( '>>> SubCaseFinal Contact: ' + SubCaseFinal.ContactId );
        if( SubCase.Origin != null && SubCase.Origin != '' )
            SubCaseFinal.Origin = SubCase.Origin;
        if( SubCase.ParentId != null )
            SubCaseFinal.ParentId = SubCase.ParentId;
            
       
            
        try
        {           
            System.debug( '@@>>> SubCase: ' + SubCase );
            System.debug( '@@>>> SubCaseFinal: ' + SubCaseFinal );
                System.debug( '@@>>> = strFlowTypeName: ' + strFlowTypeName );
                System.debug( '@@>>> = isFlowAutomaticSIRCreation: ' + isFlowAutomaticSIRCreation );
            if( subCaseFinal.ParentId != null )
                subCaseFinal.Origin = [ Select Origin From Case Where id = :subCaseFinal.ParentId ].Origin;
            
            system.debug('@@-condicion clone->: '+( mapParameters.containsKey( 'clone' ) && mapParameters.get( 'clone' ) == '1' ));
            if( mapParameters.containsKey( 'clone' ) && mapParameters.get( 'clone' ) == '1' )
            {
                Case clonedCase = SubCaseFinal.clone( false, true );
               
                /*upsert clonedCase;
                 //-- ndiaz@avanxo.com --Creating automaticaly a SIR record for the subcase if FLOW has isFlowAutomaticSIRCreation=TRUE.
                if (strFlowTypeName!=null && strFlowTypeName!='' && isFlowAutomaticSIRCreation!=null && isFlowAutomaticSIRCreation==true){
                    createSirRecord(clonedCase);
                }*/
                Database.upsertResult result = Database.upsert(clonedCase,true);
                 System.debug( '@@-clonedCase' + clonedCase+', result: '+result );
                if (result.isSuccess() && result.isCreated()){               
                    if (strFlowTypeName!=null && strFlowTypeName!='' && isFlowAutomaticSIRCreation!=null && isFlowAutomaticSIRCreation==true){
                        createSirRecord(clonedCase);
                    }
                }
                     
                //--JGDP. Creating related subcases
                saveRelatedSubcase(clonedCase);
                PageReference pr = new PageReference( '/' + clonedCase.id );
                system.debug('@@-clonedCase.id->'+clonedCase.id);
                pr.setRedirect( true );
                return pr;
            }
            else
            {
               /* upsert subCaseFinal;
                 //-- ndiaz@avanxo.com --Creating automaticaly a SIR record for the subcase if FLOW has isFlowAutomaticSIRCreation=TRUE.
                if (strFlowTypeName!=null && strFlowTypeName!='' && isFlowAutomaticSIRCreation!=null && isFlowAutomaticSIRCreation==true){
                    createSirRecord(subCaseFinal);
                }*/
                 Database.upsertResult result = Database.upsert(subCaseFinal,false);
                 /*
                 system.debug('result.isSuccess() ->'+result.isSuccess());
                 
                 // silvana
                 if (!result.isSuccess())
                 {
                    String errorMessage = '';             
                      for(Database.Error err : result.getErrors())
                      {
                        errorMessage += (err.getMessage() + '  ');
                      }
                      system.debug(errorMessage);
                      ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Error, errorMessage);
                      ApexPages.addMessage(errMsg);  
                      return null;     
                 }
                 / fin silvana */
                 
             
                 if (result.isSuccess() && result.isCreated()){                  
                    if (strFlowTypeName!=null && strFlowTypeName!='' && isFlowAutomaticSIRCreation!=null && isFlowAutomaticSIRCreation==true){
                        createSirRecord(subCaseFinal);
                    }
                 }
                
                //--JGDP. Creating related subcases
                saveRelatedSubcase(subCaseFinal);
                PageReference pr = new PageReference( '/' + subCaseFinal.id );
                system.debug('@@-clonedCase.id->'+subCaseFinal.id);
                //JPG 23/05/2011 Siempre se queda en la pantalla en modo vista
                /*if(renderAccount==true){
                    
                    if(mapParameters.containsKey('NewSC' )){
                        //JPG 19/05/2011 Se debe reenviar a la pagina de edición del Paciente  
                        pr = new PageReference( '/apex/EditAccount?id=' + subCaseFinal.AccountId);
                    }else{
                        // se debe crear un caso (RecordType), luego de esto se debe asociar el caso con el subcaso y seguir flujo de guardado normal.
                        pr = new PageReference( '/' + subCaseFinal.id );
                      }
                }else{
                    //PARAM CaseId=SubCaseFinal.Id
                    //Si renderAccount es false se debe hacer una redirección a la página /apex/EditAccount?AccNameNew=accNameNew&AccPhoneNew=accPhoneNew, no seguir con el flujo normal.       
                    if(mapParameters.containsKey('NewSC' )){
                        pr = new PageReference( '/apex/EditAccount?AccNameNew='+accNameNew+'&AccPhoneNew='+accPhoneNew+'&CaseId='+SubCaseFinal.Id );
                    }else{
                        pr = new PageReference( '/' + subCaseFinal.id );
                    }
                }*/
                
                pr.setRedirect( true );
                return pr;   
            }
        }
        catch( System.DmlException dml )
        {
            system.debug('@@**Except-dml******>>>');
            Database.rollback(sp); 
            Integer posicionFinal = dml.getMessage().indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION');        
            system.debug('@@**posicionFinal ******>>>'+posicionFinal);    
            /*empieza nico  despues sacar*/
                        if(posicionFinal != -1)
            {
                ApexPages.Message mensajeError = null;
                mensajeError = new ApexPages.Message(ApexPages.Severity.ERROR, dml.getMessage().subString(posicionFinal));
                ApexPages.addMessage(mensajeError);
            }
            
        }
        catch( System.Exception e )
        {
          system.debug('@@**Except-e******>>>');
            Database.rollback(sp);
            system.debug('********>>>' + e.getStackTraceString());
            addMsg( MSG_FATAL, '' + e.getMessage(), '' );
        }
         return null;
    }
    /*Fin nico  despues sacar*/
            /* despues acomoda nico if(posicionFinal != -1)
            {
                ApexPages.Message errMsg = null; 
                errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, dml.getMessage().subString(posicionFinal));
                ApexPages.addMessage(errMsg); 
            }
            
        }
        catch( System.Exception errMsg )
        {
            system.debug('@@**Except-e******>>>');
            Database.rollback(sp);
            system.debug('********>>>' + errMsg.getStackTraceString());
            addMsg( MSG_FATAL, '' + errMsg.getMessage(), '' );
            Apexpages.addMessages(errMsg); 
        }
        return null;
    } */
    
    
     public void createSirRecord (Case searchedSubCaseFinal ){
        System.debug( '>>> = searchedSubCaseFinal: ' + searchedSubCaseFinal );
        /*Case searchedSubCaseFinal=[SELECT id,AccountId,Patient_Name__c,Receipt_date_of_report__c FROM Case WHERE Id= :subCaseFinal.Id ];*/
        Safety_Individual_Report__c subCaseSIR= new Safety_Individual_Report__c();
        
        if (searchedSubCaseFinal.AccountId!=null){
          
            subCaseSIR.Client_Name__c=searchedSubCaseFinal.AccountId;
            Account client=[ Select fName__c,fOcupation__c From Account Where id = :searchedSubCaseFinal.AccountId ];
            if (client!=null){
                subCaseSIR.Client_Name_Frozen__c=client.fName__c;
                subCaseSIR.Client_Profession_Frozen__c=client.fOcupation__c;
            }
        }
        if (searchedSubCaseFinal.Patient_Name__c!=null){
            subCaseSIR.Patient_Name__c=searchedSubCaseFinal.Patient_Name__c;
            
            Account patient=[ Select fName__c,fGender__c From Account Where id = :searchedSubCaseFinal.Patient_Name__c ];
            if (patient!=null){
                subCaseSIR.Patient_Gender_Frozen__c=patient.fGender__c;
                subCaseSIR.Patient_Name_Frozen__c=patient.fName__c;
            }
        }
        //subCaseSIR.Case_Subcase_Number__c=searchedSubCaseFinal.Case_Subcase_Number__c;
        subCaseSIR.Receipt_date_of_report__c=searchedSubCaseFinal.Receipt_date_of_report__c;
        subCaseSIR.Subcase_Number__c=searchedSubCaseFinal.Id;
        //subCaseSIR.Subcase_Product__c=[ Select Name From Product2 Where id = :subCaseFinal.Product__c ].Name;
         System.debug( '>>> = subCaseSIR: ' + subCaseSIR );
        insert subCaseSIR;
         System.debug( '>>> = subCaseSIR inserted: ' + subCaseSIR );
    }
    
    public PageReference updatePage()
    {
        return null;
    }
    
    public void addMsg( String tipo, String titulo, String detalle )
    {
        ApexPages.Message myMsg = null;
        if( tipo.EqualsIgnoreCase( MSG_INFO ) )
            myMSg = new ApexPages.Message( ApexPages.Severity.INFO, titulo, detalle );
        else if( tipo.EqualsIgnoreCase( MSG_WARNING ) )
            myMSg = new ApexPages.Message( ApexPages.Severity.WARNING, titulo, detalle );
        else if( tipo.EqualsIgnoreCase( MSG_ERROR ) )
            myMSg = new ApexPages.Message( ApexPages.Severity.ERROR, titulo, detalle );
        else if( tipo.EqualsIgnoreCase( MSG_CONFIRM ) )
            myMSg = new ApexPages.Message( ApexPages.Severity.CONFIRM, titulo, detalle );
        else if( tipo.EqualsIgnoreCase( MSG_FATAL ) )
            myMSg = new ApexPages.Message( ApexPages.Severity.FATAL, titulo, detalle );
            
        if( myMsg != null )     
            ApexPages.addMessage( myMsg );
    }
    
    /* PRIVATE METHODS */
    
    /**************************************************************
        Create Case object.
        @param Case subCase
    ***************************************************************/
    /*private  Case createCase(){
        Case c = new Case();        
        try{
            c.Origin = 'Phone';     
            //c.ParentId=subCase.id;
            c.Priority='N/A';
            c.Status = 'Open';    
            c.Apply_Validation_Rules__c = true;  
            c.RecordTypeId =  [Select Id From RecordType  where Name ='Case' limit 1].Id;
            insert c;
            return c;               
        }catch(Exception e){
            //addMsg( MSG_FATAL, '' + e.getMessage(), '' );
        }
        return null;
        
    }*/
    
    private  Case createCase(ID accountID, ID contactId){
        Case c = new Case();        
        try{
            c.Origin = 'Phone';     
            //c.ParentId=subCase.id;
            if(accountID!=null){
                c.AccountId = accountID;
            }
            if(contactId !=null){            
                c.ContactId=contactId;              
            }else{
                System.debug('\nCONTACT_ID IS NULL' );
            }
            
            c.Priority='N/A';
            c.Status = 'Open';    
            System.debug('++++******ok');
            c.Apply_Validation_Rules__c = true;  
            c.RecordTypeId =  [Select Id From RecordType  where Name ='Case' limit 1].Id;
            insert c;
            return c;               
        }catch(Exception e){
            System.debug('++++******' + e.getMessage());
            //addMsg( MSG_FATAL, '' + e.getMessage(), '' );
        }
        return null;
        
    }

    //grey@17/08/2012 Change Control for auto asign reimbursement...    
    public void autoAsignReimbursement(){
        Flow_Type__c ft=null;
        Flow_Type__c ftNoTranslate=null;
        this.isVisibleAutoReimbursement=false;
        this.isVisibleReimbursement=true;                                                                               
            
        try{
            ft=[select id,toLabel(Reimbursement_via__c) from Flow_Type__c where id=:this.strFlowTypeName limit 1];
            ftNoTranslate=[select id,Reimbursement_via__c from Flow_Type__c where id=:this.strFlowTypeName limit 1];
        }catch(Exception e){
            System.debug('\nFT:'+ null); 
        }                         
        System.debug('\nFT_FLOW_TYPE ID:'+ft);     
        
        System.debug('\nSubCase.Flow_Type__c: '+SubCase.Flow_Type__c);
        if(this.isCreate){//Si es creación del subcaso                  
            this.autoReimbursementValue='';
            SubCase.Reimbursement_via__c='';            
            if(ft!=null && ft.Reimbursement_via__c!=null){
                SubCase.Reimbursement_via__c=ftNoTranslate.Reimbursement_via__c;
                this.autoReimbursementValue=SubCase.Reimbursement_via__c;
                this.isVisibleAutoReimbursement=true;
                this.isVisibleReimbursement=false;                                          
            }else{
                this.isVisibleAutoReimbursement=false;
                this.isVisibleReimbursement=true;                                                                       
            }
        }
        if(ft == null ){
            this.strFlowTypeName='';
            this.isVisibleAutoReimbursement=false;
            this.isVisibleReimbursement=true;                                                                               
        }
        else if(this.isEdit && ft.Reimbursement_via__c!=null&& (!this.autoReimbursementValue.equals('...'))){
            System.debug('\nINTO UNO IF is Edit');            
            this.autoReimbursementValue=ft.Reimbursement_via__c;
            SubCase.Reimbursement_via__c=ftNoTranslate.Reimbursement_via__c;            
            this.isVisibleAutoReimbursement=true;
            this.isVisibleReimbursement=false;                                                                      
        }else if(this.isEdit && ft.Reimbursement_via__c!=null&& this.autoReimbursementValue.equals('...')){
            System.debug('\nINTO DOS IF is Edit');
            this.autoReimbursementValue=ft.Reimbursement_via__c;
            SubCase.Reimbursement_via__c=ftNoTranslate.Reimbursement_via__c;
            this.isVisibleAutoReimbursement=true;
            this.isVisibleReimbursement=false;                                                                      
        }
        
        System.debug('\nisVisibleAutoReimbursement='+ this.isVisibleAutoReimbursement+
            '\nisVisibleReimbursement='+ this.isVisibleReimbursement);
        
        
    }
    
    /*****   Ajuste funcionalidad site. Permitir Agregar diferentes Productos *********/        
    public void agregarSubcasoRelacionado()
    {
        system.debug('\n << Agregar subcaso relacionado >>' + lst_wrp[0] );
        system.debug('\n << Tamaño de la lista >>' + lst_wrp.size() );
        
        consecutivo = map_wrp.size()+1;
        consecutivo +=1;
        
        system.debug('\n << Consecutivo >>' + consecutivo );
                
        WrapperClass wrp = new WrapperClass();
        wrp.obj_rs = new Related_Subcase__c();  
        wrp.posicion = consecutivo;
                        
        map_wrp.put(consecutivo, wrp);
        
        reordenar();
        
        if(map_wrp.size() > 1)
            showRemoveBttn = true;
    }   
    
    public void removerSubcasoRelacionado()
    {
        system.debug('\n << Eliminar subcaso relacionado >>');
        map_wrp.remove(indiceLista);
        reordenar();    
        
        if(map_wrp.size() == 1)
            showRemoveBttn = false;         
    }   
    
    public void reordenar()
    {
        system.debug('\n << Reordenar subcaso relacionado >>');
        list<Integer> order_list = new list<Integer>(); 
        
        lst_wrp.clear();
    
        order_list.addAll(map_wrp.keySet());
        order_list.sort();
        for(Integer i : order_list )
        {
            lst_wrp.add(map_wrp.get(i));
        }
    }
    
    public PageReference updateCase()
    {
        System.debug('strIdSubcase-> '+strIdSubcase);
        System.debug('consecutivo-> '+consecutivo);
        System.debug('indiceLista-> '+indiceLista);
        /*pone nico despues saca*/ List<Case> lstCase = [SELECT Id,CaseNumber,QC_number_Technical_Claim_Number_sample__c,QC_number_Technical_Claim_Number__c,Case_Type__r.Name From Case WHERE RecordType.Name = 'Subcase' And Id =:strIdSubcase limit 1 ];

       /* List<Case> lstCase = [SELECT Id,CaseNumber,SIR_SINA_Number__c,QC_number_Technical_Claim_Number_sample__c,QC_number_Technical_Claim_Number__c,Case_Type__r.Name From Case WHERE RecordType.Name = 'Subcase' And Id =:strIdSubcase limit 1 ];*/
        if(!lstCase.isEmpty())
        {
            strSubcase = lstCase.get(0).CaseNumber;
        }
        
        System.debug( 'lst_wrp-> '+lst_wrp );
        
        for(WrapperClass objWrapper:lst_wrp)
        {  
           if(objWrapper.posicion == consecutivo)
           {
                objWrapper.strRTNumberDocumentation = lstCase.get(0).QC_number_Technical_Claim_Number__c;
                objWrapper.strRTNumberSample = lstCase.get(0).QC_number_Technical_Claim_Number_sample__c;
                /*agrega nico despues saca*/objWrapper.strSystemNumber = '';

                /*objWrapper.strSystemNumber = lstCase.get(0).SIR_SINA_Number__c;*/
                objWrapper.strSubcaseType = lstCase.get(0).Case_Type__r.Name;
                objWrapper.strSubcaseName = lstCase.get(0).CaseNumber;
                objWrapper.strSubcaseId = strIdSubcase;
                objWrapper.blnDisabled = true;
           }
        }
        
        System.debug( 'lst_wrp after size-> '+lst_wrp.size() );
        System.debug( 'lst_wrp after-> '+lst_wrp );
        
        return null;
    }
    
    /*****************************************/ 
    
    public void saveRelatedSubcase(Case objSubCase)
    {
        System.debug( 'Save lst_wrp-> '+lst_wrp );
        List<Related_Subcase__c> lstRS = new List<Related_Subcase__c>(); 
        
        for(WrapperClass objWrapper:lst_wrp)
        {  
           if(objWrapper.strSubcaseId != null && !objWrapper.strSubcaseId.trim().equals(''))
           {
                Related_Subcase__c objRS = new Related_Subcase__c();
                Related_Subcase__c objRSPar = new Related_Subcase__c();
                objRS.SubcaseA__c = objSubCase.Id;
                objRS.SubcaseB__c = objWrapper.strSubcaseId;
                objRSPar.SubcaseB__c = objSubCase.Id;
                objRSPar.SubcaseA__c = objWrapper.strSubcaseId;
                lstRS.add(objRS);
                lstRS.add(objRSPar);
           }
        }
        system.debug('@@-lstRS->'+lstRS);
        if( !lstRS.isEmpty() )
        {
            List<Related_Subcase__c> lstRSOld= [SELECT SubcaseB__c FROM Related_Subcase__c WHERE SubcaseA__c =:objSubCase.Id OR SubcaseB__c =:objSubCase.Id];
            system.debug('@@-lstRSOld-@@->'+lstRSOld);
            delete lstRSOld;
            insert lstRS;
        }
    }
    
    public PageReference showRelatedSubcase()
    {
        if(SubCase.Id != null)
        {
             
            List<String> lstIdSubcases = new List<String>();
            //Consultamos los subcasos relacionados
            List<Related_Subcase__c> lstRS= [SELECT SubcaseB__c FROM Related_Subcase__c WHERE SubcaseA__c =:SubCase.Id];
            for(Related_Subcase__c objRS: lstRS)
            {
                lstIdSubcases.add(objRS.SubcaseB__c);
            }
            //Con los Id de los subcasos relacionados buscamos los casos para mostrar en el wrapper
            if( !lstIdSubcases.isEmpty() )
            {
                map_wrp = new map<Integer,WrapperClass>();
                List<Case> lstCase = [SELECT Id,CaseNumber,SIR_SINA_Number__c,QC_number_Technical_Claim_Number_sample__c,QC_number_Technical_Claim_Number__c,Case_Type__r.Name From Case WHERE RecordType.Name = 'Subcase' And Id IN:lstIdSubcases ];
                
                Integer conse = 0;
                for(Case objSubcase:lstCase)
                {
                    conse +=1;
                    WrapperClass objWrapper = new WrapperClass();
                    objWrapper.strRTNumberDocumentation = objSubcase.QC_number_Technical_Claim_Number__c;
                    objWrapper.strRTNumberSample = objSubcase.QC_number_Technical_Claim_Number_sample__c;
                    objWrapper.strSystemNumber = objSubcase.SIR_SINA_Number__c;
                    objWrapper.strSubcaseType = objSubcase.Case_Type__r.Name;
                    objWrapper.strSubcaseName = objSubcase.CaseNumber;
                    objWrapper.strSubcaseId = objSubcase.Id;
                    objWrapper.blnDisabled = true;
                    objWrapper.posicion = conse;
                    map_wrp.put(conse, objWrapper);
                    System.debug('map_wrp-> show '+map_wrp);
                    lst_wrp = map_wrp.values();
                    System.debug('lst_wrp-> show '+lst_wrp);
                }
            }
            
        }
        
        return null;
    }
}