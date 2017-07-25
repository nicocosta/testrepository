/****************************************************************************************************
    General Information
    -------------------
    Developer:          Avanxo Colombia
    Autor:              Juan Pablo Gracia
    Project:            Novartis Brazil
    Description:        Page's Controller which allow edit or create business account.
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     26-05-2011  Juan Pablo Gracia           Create class.
    1.1     26-05-2014  Juan Gabriel Duarte         Modify class.
    ****************************************************************************************************/
public class EditBusinessAccount_ctr {
    private Map<String,String> mapParameters;
    private ApexPages.Standardcontroller controller;
    public boolean renderOPSSections {get;set;}
    public Integer selectedIndex {get;set;}
    public String defaultAccount {get;set;}
    public String defaultAccountName {get;set;}
    public Boolean isBusinessAccount {get;set;}
    
    //Phones
    public List<Phone__c> phonesDeleted {get;set;}
    public List<PhoneWrapper> phones {get;set;} 
    
    public class PhoneWrapper{
        public integer index {get;set;}
        public Phone__c objPhone{get;set;}
        public PhoneWrapper(integer index, Phone__c objPhone){
            this.index=index;
            this.objPhone = objPhone;
        }
    }
    
    //Addresses
    public List<Address__c> addressesDeleted {get;set;}
    public List<AddressWrapper> addresses {get;set;} 
    
    public class AddressWrapper{
        public integer index {get;set;}
        public Address__c objAddress{get;set;}
        public AddressWrapper(integer index, Address__c objAddress){
            this.index=index;
            this.objAddress = objAddress;
        }
    }
    
    //Emails
    public List<Email_Address__c> emailsDeleted {get;set;}
    public List<EmailWrapper> emails {get;set;} 
    
    public class EmailWrapper{
        public integer index {get;set;}
        public Email_Address__c objEmail{get;set;}
        public EmailWrapper(integer index, Email_Address__c objEmail){
            this.index=index;
            this.objEmail = objEmail;
        }
    }
    
    //BA_PA__c
    public List<BA_PA__c> BAxPAsDeleted {get;set;}
    public List<BAxPAWrapper> BAxPAs {get;set;} 
    
    public class BAxPAWrapper{
        public integer index {get;set;}
        public BA_PA__c objBAxPA{get;set;}
        public BAxPAWrapper(integer index, BA_PA__c objBAxPA){
            this.index=index;
            this.objBAxPA = objBAxPA;
        }
    }
    
    
    //Constructor
    public EditBusinessAccount_ctr(ApexPages.Standardcontroller controller){
        mapParameters = Apexpages.currentPage().getParameters();
        this.controller = controller;
        isBusinessAccount = false;
        //Parametros GET
        Account recordAccount = (Account)controller.getRecord();
        if(!mapParameters.containsKey( 'id' ) ){
            recordAccount.Name = mapParameters.get( 'AccNameNew' );
            String phoneNumber = mapParameters.get( 'AccPhoneNew' );
            if(phoneNumber!= null && phoneNumber != '' ){
                btnAddPhone();
                phones[phones.size()-1].objPhone.Phone_Number__c = phoneNumber;
            }
            recordAccount.RecordTypeId = RecordTypesId__c.getInstance('BusinessCustomer').RecordTypeId__c;            
        }
        FV_Setup__c setup = FV_Setup__c.getInstance();
        renderOPSSections = setup.ProfilesEditOPSSection__c.contains(Userinfo.getProfileId());
        List<Account> lstAcc = [Select Name from Account Where Name!=null And Name!='' Limit 1];
        if (lstAcc.size()>0 ){ 
            defaultAccount = lstAcc[0].id;
            defaultAccountName = lstAcc[0].Name;
        }
      
        if(controller.getId()!=null){
            
            //Load Phones
            List<Phone__c> phoneLst = getPhonesByAccount(controller.getId());
            if(phoneLst.size()==0){
                phones=null;
            }else{
                phones = new List<PhoneWrapper>();
                for(Phone__c p:phoneLst){
                    phones.add(new PhoneWrapper(phones.size(),p));
                }
            }
            
            //Load Address
            List<Address__c> addressLst = getAddressesByAccount(controller.getId());
            if(addressLst.size()==0){
                addresses=null;
            }else{
                addresses = new List<AddressWrapper>();
                for(Address__c a:addressLst){
                    addresses.add(new AddressWrapper(addresses.size(),a));
                }
            }
            
            //Load Mail
            List<Email_Address__c> emailLst = getEmailsByAccount(controller.getId());
            if(emailLst.size()==0){
                emails=null;
            }else{
                emails = new List<EmailWrapper>();
                for(Email_Address__c a:emailLst){
                    emails.add(new EmailWrapper(emails.size(),a));
                }
            }
            
            //Load BA_PA__c
            System.debug('controller.getId--> '+controller.getId());
            List<BA_PA__c> BAxPALst = getBAxPAByAccount(controller.getId());
            if(BAxPALst.size()==0){
                BAxPAs=null;
            }else{
                BAxPAs = new List<BAxPAWrapper>();
                for(BA_PA__c a:BAxPALst){
                    BAxPAs.add(new BAxPAWrapper(BAxPAs.size(),a));
                }
            }
            
            //Update field Business Type when this is null and Type is not null
           List<Account> lstAccount = getAcount(controller.getId());
           if(!lstAccount.isEmpty())
           {    
                recordAccount.Bussines_Type__c = lstAccount.get(0).Type__c;
           }               
            
        }
        
        //Create other objects
        phonesDeleted = new List<Phone__c>();
        addressesDeleted = new List<Address__c>();
        emailsDeleted = new List<Email_Address__c>();
        BAxPAsDeleted = new List<BA_PA__c>();
        
    }
    
    
    //Event add email
    public PageReference btnAddEmail(){
        if(emails==null)emails = new List<EmailWrapper>();
        emails.add(new EmailWrapper(emails.size(),new Email_Address__c()));
        return null;
    }
    
    //Event add phone
    public PageReference btnAddPhone(){
        if(phones==null)phones = new List<PhoneWrapper>();
        Phone__c p = new Phone__c();
        Schema.DescribeFieldResult fieldResult = Phone__c.Main_Phone__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            if(f.isDefaultValue()){
                p.Main_Phone__c = f.getValue();
            }
        }
        fieldResult = Phone__c.Status__c.getDescribe();
        ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            if(f.isDefaultValue()){
                p.Status__c = f.getValue();
            }
        }
        phones.add(new PhoneWrapper(phones.size(),p));
        
        return null;
    }
    
    //Event add address
    public PageReference btnAddAddress(){
        Address__c addr = new Address__c();
        if(addresses==null)addresses = new List<AddressWrapper>();
        Schema.DescribeFieldResult fieldResult = Address__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            if(f.isDefaultValue()){
                addr.Status__c = f.getValue();
            }
        }
        addresses.add(new AddressWrapper(addresses.size(),addr));
        return null;
    }
    
    //Event add BAxPA
    public PageReference btnAddBAxPA(){
        if(BAxPAs==null)BAxPAs = new List<BAxPAWrapper>();
        BAxPAs.add(new BAxPAWrapper(BAxPAs.size(),new BA_PA__c()));
        return null;
    }
    
    //Event delete BAxPA
    public pageReference  btnDeleteBAxPA(){
        BA_PA__c remove = BAxPAs[selectedIndex].objBAxPA; 
        if(remove.Id!=null){
            BAxPAsDeleted.add(remove);
        }
        BAxPAs.remove(selectedIndex);
        for(Integer i=selectedIndex;i<BAxPAs.Size();i++){
            BAxPAs[i].index = i; 
        }
        if(BAxPAs.size()==0)BAxPAs=null;
        return null;
    }
    
    
    //Event delete phone
    public pageReference  btnDeletePhone(){
        Phone__c remove = phones[selectedIndex].objPhone; 
        if(remove.Id!=null){
            phonesDeleted.add(remove);
        }
        phones.remove(selectedIndex);
        for(Integer i=selectedIndex;i<phones.Size();i++){
            phones[i].index = i; 
        }
        if(phones.size()==0)phones=null;
        return null;
    }
    
    //Event delete address
    public pageReference  btnDeleteAddress(){
        Address__c remove = addresses[selectedIndex].objAddress; 
        if(remove.Id!=null){
            addressesDeleted.add(remove);
        }
        addresses.remove(selectedIndex);
        for(Integer i=selectedIndex;i<addresses.Size();i++){
            addresses[i].index = i; 
        }
        if(addresses.size()==0)addresses=null;
        return null;
    }
    
    
    //Event delete email
    public pageReference  btnDeleteEmail(){
        Email_Address__c remove = emails[selectedIndex].objEmail; 
        if(remove.Id!=null){
            emailsDeleted.add(remove);
        }
        emails.remove(selectedIndex);
        for(Integer i=selectedIndex;i<emails.Size();i++){
            emails[i].index = i; 
        }
        if(emails.size()==0)emails=null;
        return null;
    }
    
    //Event search local code
    public pageReference searchLocalCode(){
        List<String> lstLocalCode = new List<String>();
        if(phones!=null){
            for(PhoneWrapper p:phones ){
                if(p.objPhone.Local_Code__c !=null) lstLocalCode.add(String.valueOf(p.objPhone.Local_Code__c));
            }
            List<PhoneLocalCode__c> lpc = getPhoneLocalCode(lstLocalCode);
            Map<String,String> mappc = new Map<String,String>();
            for(PhoneLocalCode__c p:lpc ){
                mappc.put(p.Name,p.State__c);
            }
            for(PhoneWrapper p:phones ){
                if (p.objPhone.Local_Code__c !=null){
                    p.objPhone.State__c = mappc.get(String.valueOf(p.objPhone.Local_Code__c));
                }
            }
        }
        return null;
    }
    
    
    
    //Event Save
    public pageReference btnSave(){
        ID id = save();
        if(id!=null){
            PageReference pr;
            if(mapParameters.containsKey('NewSC')){
                String redirect='https://' + ApexPages.currentPage().getHeaders().get('Host') + '/apex/SubcaseCreator?retURL=/apex/AccountSearch&NewSC=1&AccIdNew='+ id;
                pr = new PageReference(redirect);
            }else{
                pr = new PageReference('/' + id);   
            }
             pr.setRedirect(true);
            return pr;
        }
        return null;
    }
    
    //Event Save & New Personal Account
    public pageReference btnSaveAndNewPA(){
        ID id = save();
        if(id!=null){
            PageReference pr;
            if(mapParameters.containsKey('NewSC')){
                pr = new PageReference('/apex/EditAccount?NewSC=' + mapParameters.get( 'NewSC' ));
            }else{
                pr = new PageReference('/apex/EditAccount');    
            }
             pr.setRedirect(true);
            return pr;
        }
        return null;
    }
    
    //Event Save & New Bussines Account
    public pageReference btnSaveAndNewBA(){
        ID id = save();
        if(id!=null){
            PageReference pr;
            if(mapParameters.containsKey('NewSC')){
                pr = new PageReference('/apex/EditBusinessAccount?NewSC=' + mapParameters.get( 'NewSC' ));
            }else{
                pr = new PageReference('/apex/EditBusinessAccount');        
            }
             pr.setRedirect(true);
            return pr;
        }
        return null;
    }
    
    public pageReference btnCancel(){
        PageReference pr;
        if(mapParameters.containsKey('id')){
            pr = new PageReference('/' + controller.getId());
        }else{
            pr = new PageReference('/apex/AccountSearch');
        }
        pr.setRedirect(true);
        return pr;
    }
    
    //Event Save 
    public ID save(){
        List<Phone__c> phoneLst = new List<Phone__c>();
        List<Address__c> addressLst = new List<Address__c>();
        List<Email_Address__c> emailLst = new List<Email_Address__c>();
        List<BA_PA__c> BAxPALst = new List<BA_PA__c>();     
        searchLocalCode();
        
        Account recordAccount = (Account)controller.getRecord();
        
         
        String UpdateObject = '';
        
        Savepoint sp;
        try{
            sp = Database.setSavepoint();
            System.debug('recordAccount-> '+recordAccount);
            List<Account> lstAccounts = new List<Account>();
            lstAccounts.add(recordAccount);
            Database.UpsertResult[] srList = Database.upsert(lstAccounts, false);

            // Iterate through each returned result
            for (Database.UpsertResult sr : srList) {
                if (sr.isSuccess()) 
                {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                    if(phones!=null){
                        for(PhoneWrapper p:phones){
                            Phone__c copyPhone = p.objPhone.clone(true,true);
                            if(copyPhone.Account__c==null){
                                copyPhone.Account__c=recordAccount.ID; 
                            }
                            phoneLst.add(copyPhone);
                        }
                    }
            
                    if(addresses!=null){
                        for(AddressWrapper ad:addresses){
                            Address__c copyAddress = ad.objAddress.clone(true,true);
                            if(copyAddress.Account__c==null){ 
                                copyAddress.Account__c=recordAccount.ID; 
                            }
                            addressLst.add(copyAddress);
                        }
                    }
                    
                    if(emails!=null){
                        for(EmailWrapper e:emails){
                            Email_Address__c copyEmail = e.objEmail.clone(true,true);
                            if(copyEmail.Account__c==null){ 
                                copyEmail.Account__c=recordAccount.ID; 
                            }
                            emailLst.add(copyEmail);
                        }
                    }
                    
                    if(BAxPAs!=null){
                        for(BAxPAWrapper b:BAxPAs){
                            BA_PA__c copyBAxPA = b.objBAxPA.clone(true,true);
                            if(copyBAxPA.Personal_Customer__c==null){ 
                                copyBAxPA.Personal_Customer__c=recordAccount.ID;  
                            }
                            if(copyBAxPA.Business_Customer__c==null){
                                copyBAxPA.Business_Customer__c = sr.getId();
                            }
                            BAxPALst.add(copyBAxPA);
                        }
                    }
                    
        
                    
                    UpdateObject = Phone__c.SObjectType.getDescribe().getlabel();
                    System.debug('phoneLst-> '+phoneLst);
                    Database.delete(phonesDeleted, false);
                    Database.upsert(phoneLst, false);
                                
                    UpdateObject = Address__c.SObjectType.getDescribe().getlabel();
                    upsert addressLst;
                    delete addressesDeleted;
                    
                    UpdateObject = Email_Address__c.SObjectType.getDescribe().getlabel();
                    upsert emailLst;
                    delete emailsDeleted;
                    
                    UpdateObject = BA_PA__c.SObjectType.getDescribe().getlabel();
                    System.debug('BAxPALst-> '+BAxPALst);
                    Database.upsert(BAxPALst, false);
                    Database.delete(BAxPAsDeleted, false);
                    
                }
                else 
                {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                }
            }
            
            
            
            return recordAccount.Id;
            
        }catch(DMLException e){
            System.debug('---->' + e.getMessage());
            for(Integer i=0;i<e.getNumDml();i++){
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,UpdateObject + ' ' + System.Label.Row + ' ' + e.getDmlIndex(i) + ':' + e.getDmlMessage(i).replace('&quot;','"')));
            }
            Database.rollback(sp);
            return null;
        }
        
    }
    
    public List<Phone__c> getPhonesByAccount(ID AccountId){
        return [Select p.Type__c, 
                       p.Phone_Number__c, 
                       p.Main_Phone__c, 
                       p.Local_Code__c, 
                       p.Exten__c, 
                       p.Account__c,
                       p.State__c,
                       p.Status__c 
                       From Phone__c p
                       Where p.Account__c =:AccountId ];
    }
    
    public List<Address__c> getAddressesByAccount(ID AccountId){
        return [Select a.Type__c, 
                       a.Status__c, 
                       a.State__c, 
                       a.Post_code_number__c, 
                       a.Post_Code__c, 
                       a.Number__c, 
                       a.Is_Main_Address__c, 
                       a.District__c, 
                       a.Complement__c, 
                       a.City__c, 
                       a.Address_Name__c, 
                       a.Account__c 
                       From Address__c a
                       Where a.Account__c =:AccountId];
    }
    
    public List<Email_Address__c> getEmailsByAccount(ID AccountId){
        return [Select e.email_Address__c, 
                        e.Main_email__c, 
                        e.Account__c 
                        From Email_Address__c e
                          Where e.Account__c =:AccountId];
    }
    
    public List<PhoneLocalCode__c> getPhoneLocalCode(List<String> names){
        List<PhoneLocalCode__c> p = [Select p.Name,p.State__c
                           From PhoneLocalCode__c p 
                           Where p.Name IN: names ]; 
        return p;
    }
    
    public List<BA_PA__c> getBAxPAByAccount(Id idAccount){
        System.debug('idAccount--> '+idAccount);
        
        List<BA_PA__c> b;
        List<Account> lstAccount = [SELECT RecordType.Name FROM Account WHERE Id =:idAccount];
        if( !lstAccount.IsEmpty() )
        {
            if( lstAccount.get(0).RecordType.Name == 'Business Customer' )
            {
                b = [SELECT Active__c, 
                                   Business_Customer__c,
                                   Personal_Customer__c 
                                   FROM BA_PA__c
                                   WHERE Business_Customer__c =:idAccount ];
               isBusinessAccount = false;
            }
            else
            {
                b = [SELECT Active__c, 
                                       Business_Customer__c,
                                       Personal_Customer__c 
                                       FROM BA_PA__c
                                       WHERE Personal_Customer__c =:idAccount ];
               isBusinessAccount = true;
            }                      
        }
        
        
        return b;
    }
    
    public List<Account> getAcount(Id idAccount){
        
        List<Account> a = [SELECT Type__c 
                                   FROM Account
                                   WHERE Id =:idAccount
                                   AND Type__c != null
                                   AND (Bussines_Type__c = null OR Bussines_Type__c = '')];
                                           
        return a;
    }
    //Get items for field Type__c
    public String getItems() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Account.Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        List<PersonalAccountTypes__c> conf= PersonalAccountTypes__c.getAll().values();
        String items='';
        for( Schema.PicklistEntry f : ple){
            for(PersonalAccountTypes__c p: conf){
                if(p.Value__c == f.getValue()){
                    items += f.getLabel() + ';';
                    break;
                }
            }
        } 
        return items; 
    }
    
}