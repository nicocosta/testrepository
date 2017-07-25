/****************************************************************************************************
    General Information
    -------------------
    Developer:          Avanxo Colombia
    Autor:              Juan Gabriel Duarte
    Project:            Novartis Brazil
    Description:        Page's Controller which allow edit or create lookup fields.
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     24-08-2012  Juan Gabriel Duarte P.      Create class.
    2.0		13-05-2014	Juan Gabriel Duarte P.		Included subcase.
******************************************************************************************************/
    
public class LookupReference_ctr 
{
       
        public String strSearch { get; set; }
        public String strGroupId { get; set; }
        public Boolean blnIsGroup { get; set; }
        public String strTitle{ get; set; }
        public String strSubcaseId { get; set; }
        public Boolean blnIsSubcase { get; set; }
        
        public String strNumRegXPag
        {
                get
                {
                if (strNumRegXPag == null)
                {
                        strNumRegXPag = '20';
                }
                
                return strNumRegXPag;
                }
                
                set;
        }
        public List<SelectOption> lstNumRegXPag 
        {
                get
                {
                if (lstNumRegXPag == null)
                {
                        lstNumRegXPag = new List<SelectOption>();
                        lstNumRegXPag.add( new SelectOption( '5','5' ) );
                        lstNumRegXPag.add( new SelectOption( '20','20' ) );
                        lstNumRegXPag.add( new SelectOption( '50','50' ) );
                        lstNumRegXPag.add( new SelectOption( '100','100' ) );
                        lstNumRegXPag.add( new SelectOption( '500','500' ) );
                }
                
                return lstNumRegXPag;
                }
                
                set;
        }
        public String strNumPag
        {
                get
                {
                if (setCon != null)
                {
                        Integer intActual = setCon.getPageNumber();
                        setCon.last();
                        strNumPag = '' + setCon.getPageNumber();
                        setCon.setpageNumber( intActual );
                }
                else
                {
                        strNumPag = '0';
                }
                        
                return strNumPag;
                }
                
                set;
        }
        public String strNumPagActual
        {
                get
                {
                if (setCon != null)
                {
                        strNumPagActual = '' + setCon.getPageNumber();
                }
                else
                {
                        strNumPagActual = '0';
                }
                        
                return strNumPagActual;
                }
                
                set;
        }
        public String strNumRegs
        {
                get
                {
                if (setCon != null)
                {
                        strNumRegs = '' + (setCon.getResultSize());
                }
                else
                {
                        strNumRegs = '0';
                }
                        
                return strNumRegs;
                }
                
                set;
        }
        public Boolean blnVerPrimera
        {
                get
                {
                if (setCon != null)
                {
                        blnVerPrimera = setCon.getHasPrevious();
                }
                else
                {
                        blnVerPrimera = false;
                }
                        
                return blnVerPrimera;
                }
                
                set;
        }
        public Boolean blnVerUltima
        {
                get
                {
                if (setCon != null)
                {
                        blnVerUltima = setCon.getHasNext();
                }
                else
                {
                        blnVerUltima = false;
                }
                        
                return blnVerUltima;
                }
                
                set;
        }
        public ApexPages.StandardSetController setCon
        {
                get
                {
                        if (setCon == null)
                        {                                                                       
                                if( blnIsGroup )
                                        setCon = getGroups( strSearch );
                                if( blnIsSubcase )
                                        setCon = getSubcases( strSearch );
                                
                                if( setCon == null )
                                        ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR,System.Label.Lookup_References_Error ) );
                                else if( setCon.getResultSize() == 0 )
                                        ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.WARNING,System.Label.Lookup_References_Not_Found ) );
                        }
                        System.debug( '+-+-++-+-+ setCon: ' + setCon );
                        if (setCon != null)
                        {
                                setCon.setPageSize(Integer.valueOf(strNumRegXPag));
                        }
                        
                        return setCon;
                }

                set;
        }
                
        public List<Group__c> lstGroups
        {
            get
            {
                if( blnIsGroup )
                {
                    if ( setCon != null)
                        lstGroups = (List<Group__c>) setCon.getRecords();
                    
                    if( lstGroups == null)
                            lstGroups = new List<Group__c>();
                    return lstGroups;            
                }
                else    
                    return new List<Group__c>();
            }
            
            set;
        }
        
        public List<Case> lstCases
        {
            get
            {
                if( blnIsSubcase )
                {
                    if ( setCon != null)
                        lstCases = (List<Case>) setCon.getRecords();
                    
                    if( lstCases == null)
                            lstCases = new List<Case>();
                    return lstCases;            
                }
                else    
                    return new List<Case>();
            }
            
            set;
        }
                        
        public PageReference cambioRegXPag()
        {
                return null;
        }
        
        public pageReference NextPage()
                {
                        try
                        {
                                if (setCon.getHasNext())
                                {
                                        setCon.next();
                                }
                        }
                catch(Exception errorSistema)
                {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Lookup_References_Error_Page + errorSistema.getMessage() + System.Label.Lookup_References_Info_Admin));
                        System.debug(System.Label.Lookup_References_Error_Page + errorSistema.getMessage() + System.Label.Lookup_References_Info_Admin);
                }
                
                return null;
        }
        
        public PageReference PreviousPage()
        {
                try
                {
                        if (setCon.getHasPrevious())
                        {
                                setCon.previous();
                        }
                }
                catch(Exception errorSistema)
                {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Lookup_References_Error_Page + errorSistema.getMessage() + System.Label.Lookup_References_Info_Admin));
                        System.debug(System.Label.Lookup_References_Error_Page + errorSistema.getMessage() + System.Label.Lookup_References_Info_Admin);
                }
                
                return null;
        }
        
        public pageReference FirstPage()
        {
                try
                {
                        setCon.first();
                }
                catch(Exception errorSistema)
                {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Lookup_References_Error_Page + errorSistema.getMessage() + System.Label.Lookup_References_Info_Admin));
                        System.debug(System.Label.Lookup_References_Error_Page + errorSistema.getMessage() + System.Label.Lookup_References_Info_Admin);
                }
                
                return null;
        }
        
        public PageReference LastPage()
        {
                try
                {
                        if (setCon.getHasNext())
                        {
                                setCon.last();
                        }
                }
                catch(Exception errorSistema)
                {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Lookup_References_Error_Page + errorSistema.getMessage() + System.Label.Lookup_References_Info_Admin));
                        System.debug(System.Label.Lookup_References_Error_Page + errorSistema.getMessage() + System.Label.Lookup_References_Info_Admin);
                }
                
                return null;
        }


       public LookupReference_ctr()
        {       
                strGroupId = Apexpages.currentPage().getParameters().get( 'idgroup' );
                blnIsGroup = false;
                                               
                if( Apexpages.currentPage().getParameters().get( 'type' ) == 'Group' )
                        blnIsGroup = true;
                                
                if( blnIsGroup )
                        strTitle = System.Label.Lookup_References_Search_Group;
                        
				
				strSubcaseId = Apexpages.currentPage().getParameters().get( 'idsubcase' );
                blnIsSubcase = false;
                                               
                if( Apexpages.currentPage().getParameters().get( 'type' ) == 'Subcase' )
                        blnIsSubcase = true;
                                
                if( blnIsSubcase )
                        strTitle = 'Búsqueda de subcaso';
        }
        
        public PageReference doSearch()
        {
                setCon = null;
                return null;
        }
        
    //Metodos de consulta de datos
        
    public Apexpages.Standardsetcontroller getGroups( string strFilter )
    {           
        
        list<string> lstStr = new list<string>(); 
        map<string, string> mapTempo = new map<string, string>();
        Apexpages.Standardsetcontroller ApexStOut=null;
        string strSOQL='';      
        string strComodin='*';
        string strTmp;
                    
        strSOQL+=   'SELECT Id,Name ';
        strSOQL+=   'FROM Group__c ';       
        strSOQL+=   'WHERE Active__c = true ';
        
            if( strFilter!=null && strFilter.contains(strComodin))
            {//con comodines
                strTmp=strFilter.replace(strComodin,'%');           
                strSOQL+= ' AND Name LIKE \''+strTmp+'\' ';                     
            }
            else if( strFilter!=null && strFilter!='')
            {//sin comodines
                strSOQL+= ' AND Name = \''+strFilter+'\' ';
            }                               
            strSOQL+=   ' Order By Name limit 1000';
            
        system.debug('===>strSOQL='+strSOQL);
        
        ApexStOut=new Apexpages.Standardsetcontroller(DataBase.getQueryLocator(strSOQL));           
            
        return ApexStOut;
    }
    
	public Apexpages.Standardsetcontroller getSubcases( string strFilter )
    {
        
        list<string> lstStr = new list<string>(); 
        map<string, string> mapTempo = new map<string, string>();
        Apexpages.Standardsetcontroller ApexStOut=null;
        string strSOQL='';      
        string strComodin='*';
        string strTmp;
                    
        strSOQL+=   'SELECT Id,CaseNumber,QC_number_Technical_Claim_Number_sample__c,QC_number_Technical_Claim_Number__c,Case_Type__r.Name ';
        strSOQL+=   'FROM Case ';
        strSOQL+=   'WHERE RecordType.Name = \'Subcase\' ';
        
            if( strFilter!=null && strFilter.contains(strComodin))
            {//con comodines
                strTmp=strFilter.replace(strComodin,'%');           
                strSOQL+= ' AND CaseNumber LIKE \''+strTmp+'\' ';            
            }
            else if( strFilter!=null && strFilter!='')
            {//sin comodines
                strSOQL+= ' AND CaseNumber = \''+strFilter+'\' ';
            }                               
            strSOQL+=   ' Order By CreatedDate limit 1000';
            
        system.debug('===>strSOQL='+strSOQL);
        
        ApexStOut=new Apexpages.Standardsetcontroller(DataBase.getQueryLocator(strSOQL));
            
        return ApexStOut;
    }
}