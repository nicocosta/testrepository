/****************************************************************************************************
    General Information
    -------------------
    Developer:          Avanxo Colombia
    Autor:              Juan Sebastián Cardona
    Project:            Novartis Brazil
    Description:        Page's Controller which Display SubCase PDF.
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     12-09-2013  Juan Sebastián Cardona       Create class.
    ****************************************************************************************************/
public class SubCaseDisplayPDF_ctr {


    /********************************************
        Class Attributes
    ********************************************/

    private static final List<String> fieldList = new List<String>{'Case'};  
    private static final Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();    
    private static Map<String, Schema.SObjectField> fieldMap = new Map<String, Schema.SObjectField>();
    private static Map<String, Schema.SObjectField> fieldMap_updated = new Map<String, Schema.SObjectField>();
            
    public List<Case_Mail_Response__c> lstMailRsp {get;set;}                           
    public Case case_getCase {get;set;}
    
    public Id caseId {get;set;}      
    
    public list<WrapperNoteAndAttachment> CaseComments {get;set;}
    public list<WrapperNoteAndAttachment> opnActvty {get;set;}    
    public list<WrapperNoteAndAttachment> actvtyHstry {get;set;}
    public list<WrapperNoteAndAttachment> faqXcase {get;set;}
    public list<WrapperNoteAndAttachment> sftyRprt {get;set;} 
    public list<WrapperNoteAndAttachment> chngRqts {get;set;}
    public list<WrapperNoteAndAttachment> scrpthdr {get;set;}    
    public list<WrapperNoteAndAttachment> caseHstr {get;set;} 
    public list<WrapperNoteAndAttachment> attchmnts {get;set;}
    public list<WrapperNoteAndAttachment> caseHstr_cstm {get;set;}
       
    public ApexPages.Standardcontroller controller;
    
    public List<SomeObjectHistory> SomeObjectHistories {
        get { return getSomeObjectHistory(caseId); }
    }
             
    public class WrapperNoteAndAttachment{
        public id identifier{get;set;}  
 
        public String title{get;set;}       
        public String description{get;set;}
        public String lastModifiedDate{get;set;}
        public String createdDate{get;set;}
        public String createdName{get;set;}
        public String lastModifiedName{get;set;}
        public String dueDate{get;set;}
        public String userName{get;set;}
        public String userName2{get;set;}
        public String groupName{get;set;}
                        
        public String justification{get;set;}
        public String Comments2{get;set;}
        public String Comments3{get;set;}                               
      
        public String patientName{get;set;}
        public String PVsystemBumber{get;set;}
        public String subCaseNumber{get;set;}
        
        public String status{get;set;}        
        public String CRnumber{get;set;}  
        public String CRerror{get;set;} 
        
        public String score{get;set;}
        public String action{get;set;}                 
        public String Comments{get;set;}
        
        public String newValue{get;set;}        
        public String oldValue{get;set;}  
                                                            
        public SObject obj {get;set;}
    }
    
    
    public SubCaseDisplayPDF_ctr(ApexPages.Standardcontroller controller){
        
        System.debug('\n<init constructor>');
        
        String newName;        
        for (String fieldName: fieldList) {
            system.debug('<<Field API Name>> '+fieldName);// list of all field API name
        
            fieldMap.putAll(schemaMap.get(fieldName).getDescribe().fields.getMap());//It provides to get the object fields label.
        
            system.debug('<<FieldMap Size>> '+fieldMap.size());// list of all field API name
        }       
        for(String name : fieldMap.keySet()){

            system.debug('\n << Field Name >> ' + name);

            if(name.endsWithIgnoreCase('id'))
                newName = name.removeEnd('id');
            else
                newName = name;

            system.debug('\n << New Field Name >> ' + newName);
                
            fieldMap_updated.put( newName, fieldMap.get(name));     
        }           
                         
        Case case_view = (Case) controller.getRecord();       
        case_getCase = getCase(case_view.Id);       
        caseId = case_view.Id;

        if( case_getCase!=null ){
            
            CaseComments = new list<WrapperNoteAndAttachment>();
            for(CaseComment cc : case_getCase.CaseComments){
                WrapperNoteAndAttachment w = new WrapperNoteAndAttachment();
                w.description = cc.CommentBody;
                w.createdName = cc.CreatedBy.Name;
                w.identifier = cc.Id;
                w.lastModifiedDate = cc.LastModifiedDate!=null ? cc.LastModifiedDate.format() : null;
                w.title = cc.CommentBody;
                w.createdDate = cc.CreatedDate!=null ? cc.CreatedDate.format() : null;
                w.obj = cc;
                CaseComments.add(w);
            } 
            if(CaseComments.size()==0)CaseComments=null;    
                      
            opnActvty = new list<WrapperNoteAndAttachment>();
            for(OpenActivity oa : case_getCase.OpenActivities){
                WrapperNoteAndAttachment w = new WrapperNoteAndAttachment();
                w.identifier = oa.Id;
                w.title = oa.Subject;
                w.dueDate = oa.DueDate__c!=null ? oa.DueDate__c.format() : null;
                w.description = oa.Status; 
                w.userName = oa.Owner.Name;
                w.groupName = oa.Group_Name__c;
                w.Comments = oa.Description;               
                w.obj = oa;
                opnActvty.add(w);
            } 
            if(opnActvty.size()==0)opnActvty=null;    
            
            actvtyHstry = new list<WrapperNoteAndAttachment>();
            for(ActivityHistory ah : case_getCase.ActivityHistories){
                WrapperNoteAndAttachment w = new WrapperNoteAndAttachment();
                w.identifier = ah.Id;
                w.title = ah.Subject;
                w.description = ah.Status; 
                w.justification = ah.Justification__c;
                w.Comments2 = ah.Comments_2__c;
                w.Comments3 = ah.Comments_3__c;                                                                 
                w.dueDate = ah.DueDate__c!=null ? ah.DueDate__c.format() : null;
                w.lastModifiedDate = ah.lastModifiedDate!=null ? ah.lastModifiedDate.format() : null;                
                w.userName = ah.Owner.Name;
                w.userName2 = ah.LastModifiedBy.Alias;
                w.groupName = ah.Group_Name__c;
                w.Comments = ah.Description;               
                w.obj = ah;
                actvtyHstry.add(w);
            } 
            if(actvtyHstry.size()==0)actvtyHstry=null; 
            
            faqXcase = new list<WrapperNoteAndAttachment>();
            for(FAQ_x_Case__c fq : case_getCase.FAQ_x_Cases__r){
                WrapperNoteAndAttachment w = new WrapperNoteAndAttachment();
                w.identifier = fq.Id;
                w.title = fq.Name;
                w.description = fq.FAQ__r.Name;                                                                 
                w.lastModifiedDate = fq.lastModifiedDate!=null ? fq.lastModifiedDate.format() : null;
                w.lastModifiedName = fq.LastModifiedBy.Name;                
                w.createdDate = fq.CreatedDate!=null ? fq.CreatedDate.format() : null;                               
                w.createdName = fq.CreatedBy.Name;               
                w.obj = fq;
                faqXcase.add(w);
            } 
            if(faqXcase.size()==0)faqXcase=null; 
            
            sftyRprt = new list<WrapperNoteAndAttachment>();
            for(Safety_Individual_Report__c sr : case_getCase.Safety_Individual_Reports__r){
                WrapperNoteAndAttachment w = new WrapperNoteAndAttachment();
                w.identifier = sr.Id;
                w.title = sr.Name;
                w.description = sr.Subcase_seriousness__c;                                                                                
                w.dueDate = sr.Receipt_date_of_report__c!=null ? sr.Receipt_date_of_report__c.format() : null;                               
                w.userName = sr.Client_Name__r.Name; 
                w.patientName = sr.Patient_Name__r.Name;
                w.PVsystemBumber = sr.PV_system_number_Sina__c;
                w.subCaseNumber = sr.Case_Subcase_Number__c;            
                w.obj = sr;
                sftyRprt.add(w);
            } 
            if(sftyRprt.size()==0)sftyRprt=null; 
            
            chngRqts = new list<WrapperNoteAndAttachment>();
            for(Change_Request__c chr : case_getCase.Change_Requests__r){
                WrapperNoteAndAttachment w = new WrapperNoteAndAttachment();
                w.identifier = chr.Id;
                w.title = chr.Name;
                w.description = chr.Visit_type__c;                                                                                
                w.createdDate = chr.CreatedDate!=null ? chr.CreatedDate.format() : null;                               
                w.status = chr.Status__c;
                w.CRnumber = chr.CR_number__c!=null ? String.valueOf( chr.CR_number__c ) : null;
                w.CRerror = chr.CR_error_message__c;            
                w.obj = chr;
                chngRqts.add(w);
            } 
            if(chngRqts.size()==0)chngRqts=null; 
            
            scrpthdr = new list<WrapperNoteAndAttachment>();
            for(SFDC_Script_Header__c shd : case_getCase.R00N30000001OR5bEAG__r){
                WrapperNoteAndAttachment w = new WrapperNoteAndAttachment();
                w.identifier = shd.Id;
                w.title = shd.Name;
                w.description = shd.Script__r.Name;                                                                                
                w.createdDate = shd.CreatedDate!=null ? shd.CreatedDate.format() : null;                               
                w.score = shd.Score__c!=null ? String.valueOf( shd.Score__c ) : null;
                w.action = shd.Action__c;
                w.Comments = shd.Comments__c;
                w.dueDate = shd.Date_Taken__c!=null ? shd.Date_Taken__c.format() : null;
                w.userName = shd.Account__r.Name; 
                w.userName2 = shd.Contact__r.Name;                                         
                w.obj = shd;
                scrpthdr.add(w);
            } 
            if(scrpthdr.size()==0)scrpthdr=null; 
            
            /*caseHstr = new list<WrapperNoteAndAttachment>();
            for(CaseHistory ch : getCaseHistory(case_view.Id)){
                system.debug('\n fieldMap ' + fieldMap_updated.keySet());
                system.debug('\n field ' + ch.Field + '  fieldMap Key ' + fieldMap_updated.containskey(ch.Field.toLowerCase()) );               
                if( !fieldMap_updated.containskey(ch.Field.toLowerCase()) || 
                    ( fieldMap_updated.containskey(ch.Field.toLowerCase())  && fieldMap_updated.get(ch.Field.toLowerCase()).getDescribe().isAccessible() )                  
                  ){            
                        //fieldMap.containskey(rep.Field.toLowerCase()) ? ''+ fieldMap.get(rep.Field.toLowerCase()).getDescribe().Label : ''+ rep.Field;
                        WrapperNoteAndAttachment w = new WrapperNoteAndAttachment();
                        w.identifier = ch.Id;
                        w.title = ch.CreatedDate!=null ? ch.CreatedDate.format(): null;
                        w.description = ch.Field;                                                                                                              
                        w.createdName = ch.CreatedBy.Name;
                        w.newValue = ch.NewValue!=null ? String.valueOf( ch.NewValue ): null;
                        w.oldValue = ch.OldValue!=null ? String.valueOf( ch.OldValue ): null;                                                      
                        w.obj = ch;
                        caseHstr.add(w);                                                  
                  }
            } 
            if(caseHstr.size()==0)caseHstr=null;*/                                                                                    

            attchmnts = new list<WrapperNoteAndAttachment>();
            for(Attachment atch : case_getCase.Attachments){
                WrapperNoteAndAttachment w = new WrapperNoteAndAttachment();
                w.identifier = atch.Id;
                w.title = atch.Name;
                w.description = atch.ContentType;                                                                                                              
                w.createdName = atch.CreatedBy.Name;
                w.lastModifiedDate = atch.LastModifiedDate!=null ? atch.LastModifiedDate.format() : null;                                                      
                w.obj = atch;
                attchmnts.add(w);
            } 
            if(attchmnts.size()==0)attchmnts=null; 
            
            caseHstr_cstm = new list<WrapperNoteAndAttachment>();
            for(Case_History__c ch_c : case_getCase.Cases_History__r){
                WrapperNoteAndAttachment w = new WrapperNoteAndAttachment();
                w.identifier = ch_c.Id; 
                w.title = ch_c.CreatedDate!=null ? ch_c.CreatedDate.format(): null;                
                w.lastModifiedDate = ch_c.Modify_Date_Time__c!=null ? ch_c.Modify_Date_Time__c.format(): null;
                w.description = ch_c.Field__c;                                                                                                              
                w.newValue = ch_c.New_Value__c!=null ? String.valueOf( ch_c.New_Value__c ): null;
                w.oldValue = ch_c.Old_Value__c!=null ? String.valueOf( ch_c.Old_Value__c ): null;
                w.userName = ch_c.Tracking_User__r.Name;                                                                       
                w.obj = ch_c;
                caseHstr_cstm.add(w);
            } 
            if(caseHstr_cstm.size()==0)caseHstr_cstm=null;               

            lstMailRsp =  case_getCase.Case_Mail_Responses__r!=null && !case_getCase.Case_Mail_Responses__r.isEmpty()  ? case_getCase.Case_Mail_Responses__r : null;
        
        }
      
    }
  
    public Case getCase(id idCase){
        try{
            Case c = [Select (SELECT IsPublished, CreatedDate, CommentBody, LastModifiedDate, CreatedBy.Name, CreatedById FROM CaseComments ORDER BY CreatedDate DESC),
                             (SELECT DueDate__c, Subject, toLabel(Status), Description, Owner.Name, CreatedBy.Name, CreatedById, Group_Name__c FROM OpenActivities ORDER BY CreatedDate DESC),
                             (SELECT DueDate__c, Subject, toLabel(Status), Owner.Name, LastModifiedDate, Justification__c, Comments_2__c, Comments_3__c, LastModifiedById, 
                                     CreatedBy.Name, CreatedById, LastModifiedBy.Alias, Description, Group_Name__c
                              FROM ActivityHistories ORDER BY CreatedDate DESC),
                             (SELECT FAQ_Name__c, FAQ__c, FAQ__r.Name, Name, CreatedDate, CreatedBy.Name, LastModifiedDate, LastModifiedBy.Name 
                              FROM FAQ_x_Cases__r ORDER BY CreatedDate DESC),
                             (SELECT Name, toLabel(Subcase_seriousness__c), Receipt_date_of_report__c, Client_Name__r.Name, Patient_Name__r.Name, PV_system_number_Sina__c,  
                                     Case_Subcase_Number__c, CreatedDate, CreatedBy.Name, LastModifiedDate, LastModifiedBy.Name 
                              FROM Safety_Individual_Reports__r ORDER BY CreatedDate DESC), 
                             (SELECT Name, toLabel(Visit_type__c), toLabel(Status__c), CR_number__c, CR_error_message__c, CreatedBy.Name, CreatedDate 
                              FROM Change_Requests__r ORDER BY CreatedDate DESC),
                             (SELECT Name, Script__r.Name, Score__c, Action__c, Comments__c, Date_Taken__c, Account__r.Name, Contact__r.Name, CreatedBy.Name, CreatedDate 
                              FROM R00N30000001OR5bEAG__r ORDER BY CreatedDate DESC),
                             (SELECT Field, NewValue, OldValue, CreatedBy.Name, CreatedDate FROM Histories ORDER BY CreatedDate DESC),
                             (SELECT Name, BodyLength, ContentType, CreatedBy.Name, CreatedDate, LastModifiedDate FROM Attachments ORDER BY CreatedDate DESC),
                             (SELECT Name, Sender__c, Message__c, CreatedBy.Name, CreatedDate, LastModifiedDate FROM Case_Mail_Responses__r ORDER BY CreatedDate DESC),
                             (SELECT Name, Field__c, New_Value__c, Old_Value__c, Tracking_User__c, Tracking_User__r.Name, Modify_Date_Time__c, CreatedDate, LastModifiedDate 
                              FROM Cases_History__r ORDER BY CreatedDate DESC)                                                                                                                                                                                                    
                From Case c
                Where c.Id =: idCase];
            return c;
        }catch(Exception e){
            return null;
        }
    }
    
  
    /**
     * Returns SomeObject History records associated to the current SomeObject
     *
     * @param   SomeObjectId     the SomeObject__c record id to retrieve
     * @return  a list of SomeObjectHistory objects
     */
    public List<SomeObjectHistory> getSomeObjectHistory(Id idCase) {
        List<SomeObjectHistory> listSomeObjectHistory = new List<SomeObjectHistory>();
        List<CaseHistory> listEntityHistory;
        
        if (caseId != null) {
            DateTime dLastCreatedDate = null;
            
            
            if(Test.isRunningTest()){  //Sí es prueba se crea un CaseHistory dummy.
         		listEntityHistory = new List<CaseHistory>{}; //OldValue, NewValue no son editables.
         		listEntityHistory.add(new CaseHistory(CaseId=idCase, Field='Type'));
         		    
            }else{
            
	            listEntityHistory = [ SELECT Field, NewValue, OldValue, CreatedBy.Name, CreatedDate                                                                                                                                                                                                     
                            		  FROM CaseHistory
                                	  WHERE CaseId =:idCase ORDER BY CreatedDate DESC, Id DESC];            
            }
                         
            for (CaseHistory oHistory : listEntityHistory) {
                SomeObjectHistory oSomeObjectHistory = new SomeObjectHistory(oHistory);
                
                if (fieldMap_updated.containsKey(oHistory.Field.toLowerCase())) {
                    oSomeObjectHistory.FieldLabel = fieldMap_updated.get(oHistory.Field.toLowerCase()).getDescribe().Label;
                }
                                    
                if( !fieldMap_updated.containskey(oHistory.Field.toLowerCase()) || 
                    ( fieldMap_updated.containskey(oHistory.Field.toLowerCase())  && fieldMap_updated.get(oHistory.Field.toLowerCase()).getDescribe().isAccessible() )                  
                  ){                  
                        listSomeObjectHistory.add(oSomeObjectHistory);

                   }
                                  
            }
        }
        
        return listSomeObjectHistory;
    }
    
    //Internal Classes
 
    /**
     * Data structure representing a SomeObject History record for display
     */
    public class SomeObjectHistory {
        //Properties
        public string FieldLabel {get;set;}
        public CaseHistory History {get; private set;}
        
        public string ActionFormat {
            get { return getActionFormat(); }
        }
        
        public SomeObjectHistory(CaseHistory oHistory) {
            History = oHistory;
        }
        
        //Constructors
        public SomeObjectHistory() {
        }
        
        //Private Methods
        public string getActionFormat() {
            string sActionFormat = '';
            
            if (History != null) {
                sActionFormat = 'Record {0}';
                
                if (History.newValue != null && History.oldValue == null) {
                    sActionFormat = System.Label.Set_Field_value;    
                }
                else if (History.newValue != null && History.oldValue != null) {
                    sActionFormat = 'Changed <strong>{1}</strong> from {2} to <strong>{3}</strong>';   
                }
                else if (History.Field != null && History.Field.equalsIgnoreCase('created')) {
                    sActionFormat = System.Label.Created;
                }
            }
            
            return sActionFormat;
        }
    }


             
}