/****************************************************************************************************
    General Information
    -------------------
    Developer:          Avanxo Colombia
    Autor:              Juan Pablo Gracia
    Project:            Novartis Brazil
    Description:        Page's Controller which can search accounts.
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     18-04-2011  Juan Pablo Gracia           Create class.
    ****************************************************************************************************/
public class AccountSearch_ctr 
{
    public String name {get;set;}
    public String phone {get;set;}
    public List<Account> accounts {get;set;}
    public String selectUrl {get;set;}
    public String editUrl {get;set;}
    public Boolean searched {get;set;}
    public boolean showControlsPaginator{get;set;}
    private integer minCharValidation = 3; 
    private integer pageSize = 10; 
    public Integer MaxRegisters{get;set;}
    public Integer MaxvalueResearch{get;set;}
    /* 
    * Constructor
    */
    public AccountSearch_ctr()
    {
        this.MaxRegisters=50000;
        this.MaxvalueResearch=1000;
        selectUrl='https://' + ApexPages.currentPage().getHeaders().get('Host') + '/apex/SubcaseCreator?retURL=/apex/AccountSearch&NewSC=1&AccIdNew=';
        editUrl = 'https://' + ApexPages.currentPage().getHeaders().get('Host') + '/apex/EditAccount?NewSC=2&id=';
        searched = false;
        showControlsPaginator=false;        
    }
    
    /* 
    * Redirect towards page to create Account(Subcase)
    * @return  pageReference towards page to create Account(Subcase)
    */
    public pageReference newAccount()
    {
        PageReference pr = new PageReference('/apex/EditAccount?NewSC=2&AccNameNew=' + name + '&AccPhoneNew=' + phone);
        pr.setRedirect(true);
        return pr;
    }
    
    
    /* 
    * Redirect towards page to create Business Account(Subcase)
    * @return  pageReference towards page to create Account(Subcase)
    */
    public pageReference newAccountBusiness()
    {
        PageReference pr = new PageReference('/apex/EditBusinessAccount?NewSC=2&AccNameNew=' + name + '&AccPhoneNew=' + phone);
        pr.setRedirect(true);
        return pr;
    }
    
    /* 
    * Search accounts in accordance with search's params
    * @return  pageReference null
    */
    public pageReference search()
    {
        searched = true;
        if(name=='' && phone=='')
        {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.WARNING,System.Label.SearchParametesMin.replace('%n','' + minCharValidation )));
            return null;
        }
        if(name !=null && name!='' && name.length()<minCharValidation)
        {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.WARNING,System.Label.SearchParametesMin.replace('%n','' + minCharValidation )));
            return null;
        }
        if(name !=null && phone!='' && phone.length()<minCharValidation)
        {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.WARNING,System.Label.SearchParametesMin.replace('%n','' + minCharValidation )));
            return null;
        }
        Set<ID> accountIDs = new Set<ID>();
        if(phone!=null && phone!='')
        {
            List<Phone__c> phones = getPhonesLikeName(phone);
            for(Phone__c p:phones) accountIDs.add(p.Account__r.id);
        }
        accounts = getAccountByNameOrIds(name,accountIDs);
        if(accounts.size()>this.MaxvalueResearch)
        {
            accounts.clear();
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.WARNING,Label.AccountSearch_ctrWarning));
            
        }
        this.process();
        if(accounts.size()==0)
        {
             accounts=null;     
        }
        return null;
    }
    
    /* 
    * Get phones that contain the param name
    * @return list phones 
    */
    public List<Phone__c> getPhonesLikeName(String name)
    {
        String likeName = '%' + name + '%';
        return [Select  Account__r.id From Phone__c Where Phone_Number__c LIKE :likeName];
    }
    
    /* 
    * Get Accounts that contain the param name or have a id of params ids
    * @return list phones 
    */
    /*public List<Account> getAccountByNameOrIds(String name, Set<Id> ids){
        String idsString;
        String query = 'Select a.professional_identification_document__pc,' + 
                       'a.fMain_phone__c,' + 
                       'a.fMain_e_mail__c,' + 
                       'a.fMain_address__c,' + 
                       'a.RecordType.Name,' + 
                       'a.RecordType.Id,' + 
                       'a.RecordTypeId,' + 
                       'a.Owner.Alias,' + 
                       'a.OwnerId,' + 
                       'a.Main_Phone_2__c,' + 
                       'a.Name,' + 
                       'a.AccountNumber'+ 
        ' From Account a Where ';
        
        if(ids!=null && ids.size>0){
            idsString = '' + ids;
            idsString = idsString.replace('{','(').replace('}',')');
            query += ' id IN ' + idsString + ' ';
        }
        if(name!=null){
            if(idsString!=null)query += ' OR ';
            query += '(';
            List<String> names = name.split(' ');
            String sAND = '';
            for(String n:names){
                query +=  sAND + 'a.Name LIKE \'%' + n + '%\'';
                sAND = ' AND ';
            }
            query += ')';
        }
        System.debug('****QUERY:' + query);
        return Database.query(query);
        
    }*/
    /* 
    * Get Accounts that contain the param name or have a id of params ids
    * @return list phones 
    */
    public List<Account> getAccountByNameOrIds(String name, Set<Id> ids)
    {
        String likeName=null;
        if(name!=null && name!='') 
        {
              likeName = '%' + name.replace(' ','%') + '%';
        }
        if( ProfilesInactiveAccounts__c.getAll().containsKey(Userinfo.getProfileId()) )
            return [Select a.professional_identification_document__pc, 
                           a.fMain_phone__c, 
                           a.fMain_e_mail__c, 
                           a.fMain_address__c, 
                           TOLABEL(a.RecordType.Name), 
                           a.RecordType.Id, 
                           a.RecordTypeId, 
                           a.Owner.Alias, 
                           a.OwnerId, 
                           a.Main_Phone_2__c, 
                           a.Name, 
                           a.AccountNumber,
                           a.State_Phone_1__c,
                           a.State_Phone_2__c,
                           TOLABEL(a.Type__c),
                           TOLABEL(a.Occupation_Specialty__pc),
                           Person_identification_number_CPF__pc
            From Account a
            Where (id IN :ids OR a.Name LIKE :likeName) limit : this.MaxRegisters];
        else
            return [Select a.professional_identification_document__pc, 
                       a.fMain_phone__c, 
                       a.fMain_e_mail__c, 
                       a.fMain_address__c, 
                       TOLABEL(a.RecordType.Name), 
                       a.RecordType.Id, 
                       a.RecordTypeId, 
                       a.Owner.Alias, 
                       a.OwnerId, 
                       a.Main_Phone_2__c, 
                       a.Name, 
                       a.AccountNumber,
                       a.State_Phone_1__c,
                       a.State_Phone_2__c,
                       TOLABEL(a.Type__c),
                       TOLABEL(a.Occupation_Specialty__pc),
                       Person_identification_number_CPF__pc
            From Account a
            Where (id IN :ids OR a.Name LIKE :likeName) AND a.Status__c ='Active' limit : this.MaxRegisters];
    
    }
        
    public ApexPages.StandardSetController con 
    {
        get      
        {
            if(con == null) 
            {
                    con = new ApexPages.StandardSetController(new List<Account>());
                    // sets the number of records in each page set
                    con.setPageSize(5);
            }
            return con;
        }
        set;
    }
     
    public PageReference process() 
    {
        
        if(accounts == null || accounts.size()<pageSize) 
        {
            showControlsPaginator=false;
        }
        else
        {
            showControlsPaginator=true;
        }
        
        con = new ApexPages.StandardSetController(accounts);
        con.setPageSize(pageSize);      
        return null;
    }
     
    public List<Account> getWrappers() 
    {       
        List<Account> listAcc= new List<Account>();  
        for (Account  acc : (List<Account>)con.getRecords())
        {
            listAcc.add(acc);
        }
        return listAcc;
    } 
    public Boolean hasNext 
    {
        get 
        {
            return con.getHasNext();
        }
        set;
    }
 
    public Boolean hasPrevious 
    {
        get 
        {
            return con.getHasPrevious();
        }
        set;
    }
 
    public Integer pageNumber 
    {
        get 
        {
            return con.getPageNumber();
        }
        set;
    }
 
    public void first() 
    {
        con.first();
    }
 
    public void last() 
    {
        con.last();
    }
 
    public void previous() 
    {
        con.previous();
    }
 
    public void next() 
    {
        con.next();
    }
 
    public void cancel() 
    {
        con.cancel();
    } 
}