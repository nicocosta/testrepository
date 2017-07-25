/****************************************************************************************************
    General Information
    -------------------
    Developer:          Avanxo Colombia
    Autor:              Juan Sebastián Cardona
    Project:            Novartis Brazil
    Description:        Page's Controller which Display SIR PDF.
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     12-09-2013  Juan Sebastián Cardona       Create class.
    ****************************************************************************************************/
public class SIRDisplay_PDF_ctr {


    /********************************************
        Class Attributes
    ********************************************/

    private static final List<String> fieldList = new List<String>{'Safety_Individual_Report__c','SIR_History__c','Adverse_Event__c','Medicines_in_use__c','Reporter__c'};  
    private static final Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();    
    private static Map<String, Schema.SObjectField> fieldMap = new Map<String, Schema.SObjectField>();
        
    public boolean flatTest=false;
    public boolean showAttachments {get;set;}
    public List<Adverse_Event__c> adverseEvents {get;set;}
    public List<Medicines_in_use__c> medicinesInUse {get;set;}
    public List<Reporter__c> reporters {get;set;}
    public String edit {get;set;}
    public String editComm {get;set;}
    public String newNote {get;set;}
    public String newAttch {get;set;}
    public Id deleteId {get;set;}
    public ApexPages.Standardcontroller controller;
    public List<WrapperNoteAndAttachment> notesAndAttachmentLst {get;set;}
    public List<WrapperNoteAndAttachment> caseAttachments {get;set;}

    public String strSIRId;
    public static boolean testFlat=false;//only for testing porpouses
    public static boolean testFlatTwo=false;//only for testing porpouses
    
    
    public class WrapperNoteAndAttachment{
        public String description{get;set;}     
        public String title{get;set;}
        public String lastModifiedDate{get;set;}
        public id identifier{get;set;}
        public id createdId{get;set;}
        public String createdName{get;set;}
        public Boolean isAttachment {get;set;}
        public SObject obj {get;set;}
    }
    
    
    public SIRDisplay_PDF_ctr(ApexPages.Standardcontroller controller){
        
        System.debug('\n<init constructor>');
        strSIRId = controller.getId();      
        //Get the perfil form Custom Settings
        Attachments_View__c av= Attachments_View__c.getInstance();
        //Validate if idProfile exists, if this is true then not show the attachments, otherwise show the attachments.
        showAttachments=av.Display_Attachments__c;                          
        this.controller = controller;
        if(showAttachments){
           Safety_Individual_Report__c sir =  getNoteAndAttachmentBySir(controller.getId());
           List<Note> notes = sir.Notes;
           List<Attachment> attachments = sir.Attachments; 
           
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
                            w.description = n.Body;                     
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
                            w.description = a.Description;                          
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
                w.description = a.Description;
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
                w.description = cc.CommentBody;
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
        
    }

      
    private Safety_Individual_Report__c getNoteAndAttachmentBySir(id sir){
        return [SELECT Id,
                (SELECT Title, LastModifiedDate, CreatedBy.Name, CreatedById, Body, Owner.ProfileId FROM Notes ORDER BY LastModifiedDate DESC),
                (SELECT Name, LastModifiedDate, CreatedBy.Name, CreatedById, Description, Owner.ProfileId FROM Attachments ORDER BY LastModifiedDate DESC)
                From Safety_Individual_Report__c s
                Where s.Id =: sir];
    }
    
    public Case getCase(id idCase){
        try{
            Case c = [Select (SELECT Name, LastModifiedDate, CreatedBy.Name, CreatedById, Description, Owner.ProfileId FROM Attachments ORDER BY LastModifiedDate DESC),
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
                toLabel(a.Event_Seriousness__c), 
                a.Client_Name__c, 
                a.Case_Subcase_Number__c 
                From Adverse_Event__c a
                Where a.PV_number_SINA__c =: sir ];
    }
    
    private List<Medicines_in_use__c> getMedicinesInUseBySir(id sir){
    return [Select 
            m.Novartis_Product_Name__r.Name,
            m.Novartis_Product_Name__c,
            toLabel(m.Administration_route__c), 
            m.Indication__c,
            m.Posology__c,
            m.Batch_Number__c,
            toLabel(m.Ongoing__c),
            m.End_Date__c,     
            toLabel(m.Suspect_Products__c), 
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
                   r.Reporter_related_name__r.Name, 
                   r.Name, 
                   r.Id, 
                   r.CreatedDate,
                   r.Reporter_Name_Frozen__c,
                   r.Reporter_Profession_Frozen__c 
            From Reporter__c r 
            Where r.Safety_Individual_Report__c =: sir];
    }
      
    
    public class TestException extends Exception {}
    
    
    /**********************************************************
        Core Class, this return data wrap to render table.
    **********************************************************/ 
    public WrapperData_new getHistoryFieldsRelatedWithSIR(){
        System.debug('\n<init getHistoryFieldsRelatedWithSIR>');
        //get list of Reporter__c, Medicines_in_use__c, Adverse_Event__c and SIR_History__c, related with Safety_Indicvidual_Report__c      
        Safety_Individual_Report__c sirList = this.getListsOfFieldsRelatedWithSIR();
        System.debug('\n<init WrapperData_new>');
        WrapperData_new wrap = new WrapperData_new(
            this.getListReporterHistoryRelatedSIRReporter(sirList.Reporters__r), 
            this.getListMedicinesInUseHistoryRelatedSIRMedicinesInUse(sirList.Medicines_in_uses1__r), 
            this.getListAdverseEventHistoryRelatedSIRAdverseEvent(sirList.Adverse_Events__r),
            this.getListSafetyIndividualReportHistory(),
            this.getListSIRHistory()
        );
        return wrap;        
    }
    
    

    /****************************************************************************************************************
        Get list of SIR_History__c, with fields Old_Value__c, New_Value__c, Field__c, CreatedDate, CreatedById 
        and CreatedBy.Name
        @return  List<SIR_History__c>
    ***************************************************************************************************************/

    public List<SIR_History__c>  getListSIRHistory(){
        List<SIR_History__c> listSIRHistory = [
        SELECT id, Old_Value__c, New_Value__c, Field__c, CreatedDate, CreatedById, CreatedBy.Name 
        FROM SIR_History__c WHERE Safety_Individual_Report__c=:strSIRId];
        if(listSIRHistory.size()>0){
            return listSIRHistory;
        }else{
            return null;
        }
         
    }
        
    
    /****************************************************************************************************************
        Get list of Reporter__c, Medicines_in_use__c and Adverse_Event__c related with Safety_Indicvidual_Report__c     
        @return Safety_Individual_Report__c 
        EXAMPLES:
        System.debug ('THIS FIRST REPORTER:'+ sirList.get(0).Reporters__r.get(0).id);
        System.debug ('THIS LIST REPORTER:'+ sirList.get(0).Reporters__r);
    ***************************************************************************************************************/
    public Safety_Individual_Report__c getListsOfFieldsRelatedWithSIR(){
        List<Safety_Individual_Report__c > sirList=
        [Select 
            (Select Id From Reporters__r), 
            (Select Id From Medicines_in_uses1__r), 
            (Select Id From Adverse_Events__r) 
        From Safety_Individual_Report__c 
        where id=:strSIRId];        
        if(sirList.size()>0){
            return sirList.get(0);      
        }else{
            return null;
        }           
    }  
    
    /**************************************************************************************
        Perform query to get list Reporter__History , related with a list of Reporter__c
        @param List<Reporter__c> listReporter
        @return List<Reporter__History>
    **************************************************************************************/ 
    public List<Reporter__History> getListReporterHistoryRelatedSIRReporter(List<Reporter__c> listReporter){
        List<Reporter__History> reporterHist = 
        [Select id, OldValue, NewValue, Field, CreatedDate, CreatedById, CreatedBy.Name 
        From Reporter__History 
        where ParentId 
        IN :listReporter];
        if(reporterHist.size()>0){
            return reporterHist;
        }else{
            return null;
        }       
    }

    /*****************************************************************************************************
        Perform query to get list Medicines_in_uses__History, related with a list of Medicines_in_uses__c
        @param List<Medicines_in_use__c> listMedicinesInUse
        @return List<Medicines_in_use__History> 
    *****************************************************************************************************/  
    public List<Medicines_in_use__History> getListMedicinesInUseHistoryRelatedSIRMedicinesInUse(List<Medicines_in_use__c> listMedicinesInUse){
        List<Medicines_in_use__History> medicinesInUseHist = 
        [Select id,OldValue, NewValue, Field, CreatedDate, CreatedById, CreatedBy.Name 
        From Medicines_in_use__History
        where ParentId 
        IN :listMedicinesInUse]; 
        if(medicinesInUseHist.size()>0){
            return medicinesInUseHist;
        }else{
            return null;
        }       
    }

    /*****************************************************************************************************
        Perform query to get list Adverse_Event__History, related with a list of Adverse_Event__c
        @param List<Adverse_Event__c> listAdverseEvent
        @return List<Medicines_in_use__History> 
    *****************************************************************************************************/  
    public List<Adverse_Event__History> getListAdverseEventHistoryRelatedSIRAdverseEvent(List<Adverse_Event__c> listAdverseEvent){
        List<Adverse_Event__History> adverseEventHist= 
        [Select id, OldValue, NewValue, Field, CreatedDate, CreatedById, CreatedBy.Name 
        From Adverse_Event__History
        where ParentId 
        IN :listAdverseEvent];
        if(adverseEventHist.size()>0){
            return adverseEventHist;
        }else{
            return null;
        }       
    }


    /***************************************************************************************************
        Get releted fields with Safety_Individual_Report__History, from idSafety_Individual_Report__c
        @return  List<Safety_Individual_Report__History>
    ***************************************************************************************************/
    public List<Safety_Individual_Report__History> getListSafetyIndividualReportHistory(){
        List<Safety_Individual_Report__History> listSir = [
        SELECT id, OldValue, NewValue, Field, CreatedDate, CreatedById, CreatedBy.Name  
        FROM Safety_Individual_Report__History 
        WHERE ParentId =:strSIRId];
        if(listSir.size()>0){
            return listSir;
        }else{
            return null;
        }
    
    }
    
    
        
    /**************************************************
        Principal wrapper class to render table.
    **************************************************/
    public class WrapperData_new{
        
        /***** Attributes Area ******/
        public List<Values> listValues{get;set;}
        
        
        /*****************************************************************************
            Constructor
        *****************************************************************************/
        public WrapperData_new(List<Reporter__History> listReporterHistory,
        List<Medicines_in_use__History> listMedicinesInUseHistory,
        List<Adverse_Event__History> listAdverseEventHistory,
        List<Safety_Individual_Report__History> listSafetyIndividualReportHistory,
        List<SIR_History__c> listSIRHistory     
        ){
            System.debug('\n<init WrapperData_new>');
                        
            for (String fieldName: fieldList) {
                system.debug('<<Field API Name>> '+fieldName);// list of all field API name
            
                fieldMap.putAll(schemaMap.get(fieldName).getDescribe().fields.getMap());//It provides to get the object fields label.
            
                system.debug('<<FieldMap Size>> '+fieldMap.size());// list of all field API name
            }
                    
            listValues = new List<Values>();
            
            this.buildListValuesReporterHistory(listReporterHistory);
            System.debug('\n<EXEC buildListValuesReporterHistory> listReporterHistory:'+listReporterHistory);
                        
            this.getListValuesMedicinesInUseHistory(listMedicinesInUseHistory);
            System.debug('\n<EXEC getListValuesMedicinesInUseHistory> listMedicinesInUseHistory:'+listMedicinesInUseHistory);
            
            this.getListValuesAdverseEventHistory(listAdverseEventHistory);
            System.debug('\n<EXEC getListValuesAdverseEventHistory> listAdverseEventHistory:'+listAdverseEventHistory);
            
            this.getListValuesSafetyIndividualReportHistory(listSafetyIndividualReportHistory);                     
            System.debug('\n<EXEC getListValuesSafetyIndividualReportHistory>:'+listValues);
            
            this.getListValuesSIRHistyory(listSIRHistory);          
            System.debug('\n<<EXEC getListValuesSIRHistyory listSIRHistory>:'+listSIRHistory);
            
            //Ordenar Lista por fecha
            Values tmp;
            for(Integer i=0;i<listValues.size();i++){
                for(Integer j=i;j<listValues.size();j++){
                    if(listValues[i].dateChange < listValues[j].dateChange){
                        tmp = listValues[i];
                        listValues[i] = listValues[j];
                        listValues[j] = tmp;
                    }
                }
            }
            
        }
        
        /********************************************************************
            Set the date to GMT.
        ********************************************************************/
        public Datetime formatDate(Datetime current) { 
            Date currDate = current.date();
            Time currTime = current.time();
            return  datetime.newinstanceGMT(currDate,currTime); 
        }
        
        /**********************************************************************
            Build list values of reporter hoistory type.
            @param List<Reporter__History> listReporterHist
        *********************************************************************/      
        private void buildListValuesReporterHistory(List<Reporter__History> listReporterHistory){                                                               
            if((listReporterHistory!=null&&listReporterHistory.size()>0) || SIRDisplay_PDF_ctr.testFlatTwo){
                if(SIRDisplay_PDF_ctr.testFlatTwo){//Only testing porpouses
                    listReporterHistory=[
                    SELECT id, OldValue, NewValue, Field, CreatedDate, CreatedById, CreatedBy.Name  
                    FROM Reporter__History 
                    limit 1];
                }
                for(Reporter__History rep:listReporterHistory){                                                                                         
                    Values val = new Values();
                    val.regType = Reporter__History.SObjectType.getDescribe().getlabel();
                    //val.regType = System.label.VAuditTrailHistoryReports;     
                    if(rep.id!=null || SIRDisplay_PDF_ctr.testFlat){ 
                        val.regId=''+rep.id;            
                    }
                    if(rep.OldValue!=null || SIRDisplay_PDF_ctr.testFlat){ 
                        val.oldValue=''+rep.OldValue;           
                    }
                    if(rep.NewValue!=null || SIRDisplay_PDF_ctr.testFlat){ 
                        val.newValue=''+rep.NewValue;           
                    }
                    if(rep.Field!=null || SIRDisplay_PDF_ctr.testFlat){ 
                        //val.field= fieldMap.containskey(rep.Field.toLowerCase()) ? ''+ fieldMap.get(rep.Field.toLowerCase()).getDescribe().Label : ''+ rep.Field;
                        val.field= rep.Field;                               
                    }                                                                                                   
                    if(rep.CreatedDate!=null || SIRDisplay_PDF_ctr.testFlat){ 
                        val.dateChange = rep.CreatedDate; 
                        val.createdDate=''+ formatDate(rep.CreatedDate);            
                    }
                    if(rep.CreatedBy.name!=null || SIRDisplay_PDF_ctr.testFlat){ 
                        val.createdByName=''+rep.CreatedBy.name;            
                    }
                    listValues.add(val);                                                                
                }
                
            }
            
        }
     
    
        /**********************************************************************
            Build list values of reporter hoistory type.
            @param List<Medicines_in_use__History> listMedicinesInUseHistory
        *********************************************************************/      
        private void getListValuesMedicinesInUseHistory(List<Medicines_in_use__History> listMedicinesInUseHistory){                                             
            if((listMedicinesInUseHistory!=null && listMedicinesInUseHistory.size()>0) || SIRDisplay_PDF_ctr.testFlatTwo){
                if(SIRDisplay_PDF_ctr.testFlatTwo){//Only testing porpouses
                    listMedicinesInUseHistory=[
                    SELECT id, OldValue, NewValue, Field, CreatedDate, CreatedById, CreatedBy.Name  
                    FROM Medicines_in_use__History
                    limit 1];
                }                           
                for(Medicines_in_use__History med:listMedicinesInUseHistory){                                                                                                               
                    Values val = new Values();
                    val.regType = Medicines_in_use__History.SObjectType.getDescribe().getlabel();
                    //val.regType = System.label.VAuditTrailHistoryMedicinesInUse;
                    if(med.id!=null || SIRDisplay_PDF_ctr.testFlat){ 
                        val.regId=''+med.id;            
                    }                   
                    if(med.oldValue!=null || SIRDisplay_PDF_ctr.testFlat){
                        val.oldValue=''+med.OldValue;
                    }                                                   
                    if(med.NewValue!=null || SIRDisplay_PDF_ctr.testFlat){ 
                        val.newValue=''+med.NewValue;           
                    }
                    if(med.Field!=null || SIRDisplay_PDF_ctr.testFlat){
                        //val.field= fieldMap.containskey(med.Field.toLowerCase()) ? ''+ fieldMap.get(med.Field.toLowerCase()).getDescribe().Label : ''+ med.Field;
                        val.field= med.Field;                       
                    }                                                                                                   
                    if(med.CreatedDate!=null || SIRDisplay_PDF_ctr.testFlat){
                        val.dateChange = med.CreatedDate;  
                        val.createdDate=''+formatDate(med.CreatedDate);         
                    }
                    if(med.CreatedById!=null || SIRDisplay_PDF_ctr.testFlat){ 
                        val.createdById=''+med.CreatedById;         
                    }
                    if(med.CreatedBy.name!=null || SIRDisplay_PDF_ctr.testFlat){ 
                        val.createdByName=''+med.CreatedBy.name;            
                    }
                                            
                    listValues.add(val);                                                
                }
        
            }
                
        }
        
        /**********************************************************************
            Build list values of reporter hoistory type.
            @param List<Adverse_Event__History> listAdverseEventHistory
        *********************************************************************/      
        private void getListValuesAdverseEventHistory(List<Adverse_Event__History> listAdverseEventHistory){                                                
            if((listAdverseEventHistory !=null && listAdverseEventHistory.size()>0)||SIRDisplay_PDF_ctr.testFlatTwo){
                if(SIRDisplay_PDF_ctr.testFlatTwo){//Only testing pourposes
                    listAdverseEventHistory=[
                    SELECT id, OldValue, NewValue, Field, CreatedDate, CreatedById, CreatedBy.Name  
                    FROM Adverse_Event__History
                    limit 1];
                }                                   
                for(Adverse_Event__History adv:listAdverseEventHistory){                                                                                                                
                    Values val = new Values();
                    val.regType = Adverse_Event__History.SObjectType.getDescribe().getlabel();
                    //val.regType = System.label.VAuditTrailHistoryAdversesEvents;
                    if(adv.id!=null || SIRDisplay_PDF_ctr.testFlat){ 
                        val.regId=''+adv.id;            
                    }                   
                    if(adv.oldValue!=null || SIRDisplay_PDF_ctr.testFlat){
                        val.oldValue=''+adv.OldValue;
                    }                                                   
                    if(adv.NewValue!=null || SIRDisplay_PDF_ctr.testFlat){ 
                        val.newValue=''+adv.NewValue;           
                    }
                    if(adv.Field!=null || SIRDisplay_PDF_ctr.testFlat){
                        //val.field= fieldMap.containskey(adv.Field.toLowerCase()) ? ''+ fieldMap.get(adv.Field.toLowerCase()).getDescribe().Label : ''+ adv.Field;
                        val.field= adv.Field;                   
                    }                                                                                                   
                    if(adv.CreatedDate!=null || SIRDisplay_PDF_ctr.testFlat){
                        val.dateChange = adv.CreatedDate; 
                        val.createdDate=''+formatDate(adv.CreatedDate);         
                    }
                    if(adv.CreatedById!=null || SIRDisplay_PDF_ctr.testFlat){ 
                        val.createdById=''+adv.CreatedById;         
                    }
                    if(adv.CreatedBy.name!=null || SIRDisplay_PDF_ctr.testFlat){ 
                        val.createdByName=''+adv.CreatedBy.name;            
                    }
                    
                    listValues.add(val);                                                
                }
        
            }
            
        }
        
        
        /**********************************************************************
            Build list values of reporter hoistory type.
            @param List<Safety_Individual_Report__History> listSafetyIndividualReportHistory            
        *********************************************************************/      
        private void getListValuesSafetyIndividualReportHistory(List<Safety_Individual_Report__History> listSafetyIndividualReportHistory){                                             
            if((listSafetyIndividualReportHistory!=null&&listSafetyIndividualReportHistory.size()>0)||testFlatTwo){
                if(testFlatTwo){//only testing porpouses
                    listSafetyIndividualReportHistory=[                 
                    SELECT id, OldValue, NewValue, Field, CreatedDate, CreatedById, CreatedBy.Name  
                    FROM Safety_Individual_Report__History 
                    limit 1];
                }               
                for(Safety_Individual_Report__History saf:listSafetyIndividualReportHistory){                                                                                                               
                    Values val = new Values();
                    val.regType = Safety_Individual_Report__History.SObjectType.getDescribe().getlabel();
                    //val.regType = System.label.VAuditTrailHistorySafetyIndividualReports;
                    if(saf.id!=null || SIRDisplay_PDF_ctr.testFlat ){ 
                        val.regId=''+saf.id;            
                    }                                       
                    if(saf.oldValue!=null || SIRDisplay_PDF_ctr.testFlat){
                        val.oldValue=''+saf.OldValue;
                    }                                                   
                    if(saf.NewValue!=null || SIRDisplay_PDF_ctr.testFlat){ 
                        val.newValue=''+saf.NewValue;           
                    }
                    if(saf.Field!=null || SIRDisplay_PDF_ctr.testFlat){
                        system.debug('<<Field>> '+saf.Field);// list of all field API name
                        system.debug('<<FieldMap Contains>> '+fieldMap.containskey(saf.Field));// list of all field API name                                                        
                        //val.field= fieldMap.containskey(saf.Field.toLowerCase()) ? ''+ fieldMap.get(saf.Field.toLowerCase()).getDescribe().Label : ''+ saf.Field;
                        val.field= saf.Field;           
                    }                                                                                                   
                    if(saf.CreatedDate!=null || SIRDisplay_PDF_ctr.testFlat){ 
                        val.dateChange = saf.CreatedDate;
                        val.createdDate=''+formatDate(saf.CreatedDate);         
                    }
                    if(saf.CreatedById!=null || SIRDisplay_PDF_ctr.testFlat){ 
                        val.createdById=''+saf.CreatedById;         
                    }
                    if(saf.CreatedBy.name!=null || SIRDisplay_PDF_ctr.testFlat){ 
                        val.createdByName=''+saf.CreatedBy.name;            
                    }
                    
                    listValues.add(val);                                                
                }
                        
            }
    
        }
        
        /**********************************************************************
            NEW
            Build list values of reporter hoistory type.
            @param List<Safety_Individual_Report__History> listSafetyIndividualReportHistory            
        *********************************************************************/      
        private void getListValuesSIRHistyory(List<SIR_History__c> listSIRHistory){                                             
            if((listSIRHistory!=null&&listSIRHistory.size()>0)||testFlatTwo){
                if(testFlatTwo){//only testing porpouses
                    listSIRHistory=[                    
                    SELECT id, Old_Value__c, New_Value__c, Field__c, CreatedDate, CreatedById, CreatedBy.Name  
                    FROM SIR_History__c 
                    limit 1];
                }               
                for(SIR_History__c saf:listSIRHistory){                                                                                                             
                    Values val = new Values();
                    val.regType = SIR_History__c.SObjectType.getDescribe().getlabel();
                    //val.regType =System.label.VAuditTrailSIRHistory;
                    if(saf.id!=null || SIRDisplay_PDF_ctr.testFlat ){ 
                        val.regId=''+saf.id;            
                    }                                       
                    if(saf.Old_Value__c!=null || SIRDisplay_PDF_ctr.testFlat){
                        val.oldValue=''+saf.Old_Value__c;
                    }                                                   
                    if(saf.New_Value__c!=null || SIRDisplay_PDF_ctr.testFlat){ 
                        val.newValue=''+saf.New_Value__c;           
                    }
                    if(saf.Field__c!=null || SIRDisplay_PDF_ctr.testFlat){                      
                        //val.Field = fieldMap.containskey(saf.Field__c.toLowerCase()) ? ''+ fieldMap.get(saf.Field__c.toLowerCase()).getDescribe().Label : ''+ saf.Field__c;                               
                        val.Field = saf.Field__c;
                    }                                                                                                   
                    if(saf.CreatedDate!=null || SIRDisplay_PDF_ctr.testFlat){
                        val.dateChange = saf.CreatedDate; 
                        val.createdDate=''+formatDate(saf.CreatedDate);         
                    }
                    if(saf.CreatedById!=null || SIRDisplay_PDF_ctr.testFlat){ 
                        val.createdById=''+saf.CreatedById;         
                    }
                    if(saf.CreatedBy.name!=null || SIRDisplay_PDF_ctr.testFlat){ 
                        val.createdByName=''+saf.CreatedBy.name;            
                    }
                    
                    listValues.add(val);                                                
                }
                        
            }
    
        }   
                
                    
    } 
    
    
    /********************************************************************
        Values list obtained by VisualAuditTrail page to buid the table
    ********************************************************************/
    public List<Values> listValues { 
        get{
            try{
                return this.getHistoryFieldsRelatedWithSIR().ListValues;        
            }catch(Exception e){
                return new List<Values>();
            }
        }   
        set;
    }
    
    
    /***************************************************
        Defines the values per register type
    ***************************************************/
    public class Values{
        public String regId {get;set;}
        public String regType {get;set;}
        public String oldValue {get;set;}
        public String newValue {get;set;}
        public String field {get;set;}  
        public Datetime dateChange {get;set;}
        public String createdDate {get;set;}    
        public String createdById{get;set;} 
        public String createdByName{get;set;}       
    }   
       
}