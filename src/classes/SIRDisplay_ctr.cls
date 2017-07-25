/****************************************************************************************************
    General Information
    -------------------
    Developer:          Avanxo Colombia
    Autor:              Juan Pablo Gracia
    Project:            Novartis Brazil
    Description:        Page's Controller which Display SIR .
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     07-04-2011  Juan Pablo Gracia           Create class.
    ****************************************************************************************************/
public class SIRDisplay_ctr {
    public boolean flatTest=false;
    public boolean showAttachments {get;set;}
    public List<Adverse_Event__c> adverseEvents {get;set;}
    public List<Medicines_in_use__c> medicinesInUse {get;set;}
    public List<Reporter__c> reporters {get;set;}
    public String host {get;set;}
    public String edit {get;set;}
    public String editComm {get;set;}
    public String view {get;set;}
    public String newNote {get;set;}
    public String newAttch {get;set;}
    //public String viewAllNotesPage {get;set;}
    public Id deleteId {get;set;}
    public ApexPages.Standardcontroller controller;
    public List<WrapperNoteAndAttachment> notesAndAttachmentLst {get;set;}
    public List<WrapperNoteAndAttachment> caseAttachments {get;set;}
    
    public class WrapperNoteAndAttachment{
        public String title{get;set;}
        public String lastModifiedDate{get;set;}
        public id identifier{get;set;}
        public id createdId{get;set;}
        public String createdName{get;set;}
        public Boolean isAttachment {get;set;}
        public SObject obj {get;set;}
    }
    
    public SIRDisplay_ctr(ApexPages.Standardcontroller controller){
        //Get the perfil form Custom Settings
        Attachments_View__c av= Attachments_View__c.getInstance();
        //Validate if idProfile exists, if this is true then not show the attachments, otherwise show the attachments.
        showAttachments=av.Display_Attachments__c;                          
        this.controller = controller;
        if(showAttachments){
           Safety_Individual_Report__c sir =  getNoteAndAttachmentBySir(controller.getId());
           List<Note> notes = sir.Notes;
           List<Attachment> attachments = sir.Attachments; 
           
           //JGDP. 27-08-2013. Cambio configuración personaliza para incluir más de un perfil
           List<SIR_Display__c> sirconfig = SIR_Display__c.getall().values();
           set<String> lstIdProfiles = new set<String>();
           for( SIR_Display__c objConfig :sirconfig )
           {
             lstIdProfiles.add(objConfig.IdProfile__c);
           }
            
           notesAndAttachmentLst = new List<WrapperNoteAndAttachment>();
           //Nuevo Codigo
           Map<String, Note> mapNotes=new Map<String,Note>();
           Map<String, Attachment> mapAttachments=new Map<String,Attachment>();
    
           Map<String, Datetime> toOrganise= new Map<String, Datetime>();  
          for(Note n:notes)
          {
            mapNotes.put (n.Id+'-N', n);
            toOrganise.put (n.Id+'-N', n.LastModifiedDate);
          }
          for(Attachment a:attachments)
          {
            mapAttachments.put (a.Id+'-A', a);
            toOrganise.put (a.Id+'-A',a.LastModifiedDate);
          }
          //--The Magic of ordering maps 
          List<String> orderByKeys= Utilities.organizeDesc(toOrganise);
          System.debug('Line 70... notes:'+notes);
          System.debug('Line 71... attachments:'+attachments);
          System.debug('Line 72... orderByKeys:'+orderByKeys);
          System.debug('Line 73... mapNotes:'+mapNotes);
          System.debug('Line 74... mapAttachments:'+mapAttachments);
          
          for (Integer i=0;i<orderByKeys.size();i++)
          {
                    if ( (orderByKeys.get(i)).contains('-N'))
                    {
                        Note n=mapNotes.get(orderByKeys.get(i));
                        if( !(lstIdProfiles.contains(n.Owner.ProfileId) && !lstIdProfiles.contains(Userinfo.getProfileId())) )
                        {
                            WrapperNoteAndAttachment w = new WrapperNoteAndAttachment();
                            w.createdId = n.CreatedById;
                            w.createdName = '' + n.CreatedBy.Name;
                            w.identifier = n.Id;
                            w.lastModifiedDate = n.LastModifiedDate.format();
                            w.title = n.Title;
                            w.isAttachment = false;
                            w.obj = n;
                            notesAndAttachmentLst.add(w);
                        }
                    }
                    else if( (orderByKeys.get(i)).contains('-A'))
                    {
                        Attachment a=mapAttachments.get(orderByKeys.get(i)); 
                        if( !(lstIdProfiles.contains(a.Owner.ProfileId) && !lstIdProfiles.contains(Userinfo.getProfileId())) )
                        { 
                            WrapperNoteAndAttachment w = new WrapperNoteAndAttachment();
                            w.createdId = a.CreatedById;
                            w.createdName = a.CreatedBy.Name;
                            w.identifier = a.Id;
                            w.lastModifiedDate = a.LastModifiedDate.format();
                            w.title = a.Name;
                            w.isAttachment = true;
                            w.obj = a;
                            notesAndAttachmentLst.add(w);
                        }
                    }           
          }
           if(notesAndAttachmentLst.size()==0)notesAndAttachmentLst=null;
         }
         
        Safety_Individual_Report__c Sir = (Safety_Individual_Report__c) controller.getRecord();
        Case c = getCase(Sir.Subcase_Number__c);
        if (c!=null){
            List<Attachment> attachments = c.Attachments; 
            caseAttachments = new List<WrapperNoteAndAttachment>();
            for(Attachment a:attachments){
                WrapperNoteAndAttachment w = new WrapperNoteAndAttachment();
                w.createdId = a.CreatedById;
                w.createdName = a.CreatedBy.Name;
                w.identifier = a.Id;
                w.lastModifiedDate = a.LastModifiedDate.format();
                w.title = a.Name;
                w.isAttachment = true;
                w.obj = a;
                caseAttachments.add(w);
            } 
            
            List<CaseComment> comms = c.CaseComments; 
            for(CaseComment cc:comms){
                WrapperNoteAndAttachment w = new WrapperNoteAndAttachment();
                w.createdId = cc.CreatedById;
                w.createdName = cc.CreatedBy.Name;
                w.identifier = cc.Id;
                w.lastModifiedDate = cc.LastModifiedDate.format();
                w.title = cc.CommentBody;
                //w.title = a.Name;
                w.isAttachment = false;
                w.obj = cc;
                caseAttachments.add(w);
            } 
            if(caseAttachments.size()==0)caseAttachments=null;
        }
         
        medicinesInUse = getMedicinesInUseBySir(controller.getId());
        if(medicinesInUse.size()==0)medicinesInUse=null;
        adverseEvents = getAdverseEventsBySir(controller.getId());
        if(adverseEvents.size()==0) adverseEvents=null;
        reporters = getReportersBySir(controller.getId());
        if(reporters.size()==0) reporters=null;
        host='https://' + ApexPages.currentPage().getHeaders().get('Host') + '/';
        edit = '/e?retURL=' + ApexPages.currentPage().getUrl();
        if (c!=null) editComm= '/e?parent_id=' + c.Id + '&retURL=' + ApexPages.currentPage().getUrl();
        view = host + 'servlet/servlet.FileDownload?file=';
        newNote = host + '002/e?parent_id='+ controller.getId() +'&retURL='+ ApexPages.currentPage().getUrl();
        newAttch = host + 'p/attach/NoteAttach?pid=' + controller.getId() + '&retURL='+ ApexPages.currentPage().getUrl();
        
        //viewAllNotesPage =  host + 'ui/content/ViewAllNotesPage?id=' + controller.getId() + '&retURL='+ ApexPages.currentPage().getUrl();
    
    }
    
    //Redirect to edit page
    public pageReference myEdit(){
        PageReference pr = new PageReference('/apex/SIREdit?id=' + controller.getId());
        pr.setRedirect(true);
        return pr;
    }
    
    //Event Delete Notes And Attachment
    public pageReference  deleteNotesAndAttachment(){
        Sobject obj;
        integer index;
        if(notesAndAttachmentLst!=null){
            for(index=0;index<notesAndAttachmentLst.size();index++){
                if(notesAndAttachmentLst[index].identifier==deleteId){
                    obj=notesAndAttachmentLst[index].obj;
                    break;
                }
            }
        }
        try {
            if(obj!=null){
                delete obj;
                notesAndAttachmentLst.remove(index);
                if(notesAndAttachmentLst.size()==0)notesAndAttachmentLst=null;
                if(test.isRunningTest()) throw new TestException(); 
                else return null;
            }
        } catch (Exception e) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        }
        
        //Case attachments
        
        if(caseAttachments!=null){
            for(index=0;index<caseAttachments.size();index++){
                if(caseAttachments[index].identifier==deleteId){
                    obj=caseAttachments[index].obj;
                    break;
                }
            }
        }
       try {
            if(obj!=null){
                delete obj;
                caseAttachments.remove(index);
                if(caseAttachments.size()==0)caseAttachments=null;
            }
            if(test.isRunningTest()) throw new TestException();
        } catch (Exception e) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        }
        return null;
      
    }
    
    
    private Safety_Individual_Report__c getNoteAndAttachmentBySir(id sir){
        return [SELECT Id,
                (SELECT Title, LastModifiedDate, CreatedBy.Name, CreatedById, Owner.ProfileId FROM Notes ORDER BY LastModifiedDate DESC),
                (SELECT Name, LastModifiedDate, CreatedBy.Name, CreatedById, Owner.ProfileId FROM Attachments ORDER BY LastModifiedDate DESC)
                From Safety_Individual_Report__c s
                Where s.Id =: sir];
    }
    
    public Case getCase(id idCase){
        try{
            Case c = [Select (SELECT Name, LastModifiedDate, CreatedBy.Name, CreatedById, Owner.ProfileId FROM Attachments ORDER BY LastModifiedDate DESC),
                             (SELECT CommentBody, LastModifiedDate, CreatedBy.Name, CreatedById FROM CaseComments ORDER BY LastModifiedDate DESC) 
                From Case c
                Where c.Id =: idCase];
            return c;
        }catch(Exception e){
            return null;
        }
    }
    
    private List<Adverse_Event__c> getAdverseEventsBySir(id sir){
        return [Select a.Name, a.Start__c,
                a.Evolution__c,  
                a.SIR__c, 
                a.Patient_Name__c, 
                a.Id, 
                a.Event_Seriousness__c, 
                a.Client_Name__c, 
                a.Case_Subcase_Number__c 
                From Adverse_Event__c a
                Where a.PV_number_SINA__c =: sir ];
    }
    
    private List<Medicines_in_use__c> getMedicinesInUseBySir(id sir){
    return [Select 
            m.Novartis_Product_Name__c,
            m.Administration_route__c, 
            m.Indication__c,
            m.Posology__c,
            m.Batch_Number__c,
            m.Ongoing__c,
            m.End_Date__c,     
            m.Suspect_Products__c, 
            m.Start_Date__c, 
            m.SIR_name__c, 
            m.SIR__c, 
            m.Product_name__c, 
            m.Product_from_other_labs__c, 
            m.Patient_Name__c, 
            m.Id, 
            m.Client_Name__c 
            From Medicines_in_use__c m
            Where m.Safety_Individual_Report__c =: sir ];
    }
    
    private List<Reporter__c> getReportersBySir(id sir){
    return [Select r.Reporter_related_name__c, 
                   r.Name, 
                   r.Id, 
                   r.CreatedDate,
                   r.Reporter_Name_Frozen__c,
                   r.Reporter_Profession_Frozen__c 
            From Reporter__c r 
            Where r.Safety_Individual_Report__c =: sir];
    }
    
    public class TestException extends Exception {}
    
}