/****************************************************************************************************
    General Information
    -------------------
    Developer:          Avanxo Colombia
    Autor:              Juan Pablo Gracia
    Project:            Novartis Brazil
    Description:        Page's Controller which allow edit SIR.
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     08-03-2011  Juan Pablo Gracia           Create class.
    ****************************************************************************************************/
public class SIREdit_ctr {
    private Map<ID,Reporter__c> reporterMap;
    public ApexPages.Standardcontroller controller;
    public String host {get;set;}
    public Case caseObj{get;set;}
    public String caseId{get;set;}
    public Integer selectedIndex {get;set;}
    public String defaultAccount {get;set;}
    public String defaultAccountName {get;set;}
    public Boolean editFrozen {get;set;}
    public Boolean editField {get;set;}
    
    public List<AdverseEventWrapper> adverseEvents {get;set;}
    public List<Adverse_Event__c> adverseEventsDeleted {get;set;}
    
    public List<Medicines_in_use__c> medicinesInUseDeleted {get;set;}
    public List<MedicinesInUseWrapper> medicinesInUses {get;set;} 
    
    
    public List<Reporter__c> reportersDeleted {get;set;}
    public List<ReportersWrapper> reporters {get;set;} 
    
    public class AdverseEventWrapper{
        public integer index {get;set;}
        public Adverse_Event__c objAdverseEvent  {get;set;}
        public AdverseEventWrapper(integer index, Adverse_Event__c objAdverseEvent){
            this.index=index;
            this.objAdverseEvent = objAdverseEvent;
        }
    }
    
    public class MedicinesInUseWrapper{
        public integer index {get;set;}
        public Medicines_in_use__c objMedicinesInUse  {get;set;}
        public MedicinesInUseWrapper(integer index, Medicines_in_use__c objMedicinesInUse){
            this.index=index;
            this.objMedicinesInUse = objMedicinesInUse;
        }
    }
    
    public class ReportersWrapper{
        public integer index {get;set;}
        public boolean isNew {get;set;}
        public Reporter__c objReporter  {get;set;}
        public ReportersWrapper(integer index, Reporter__c objReporter, boolean isNew){
            this.index=index;
            this.objReporter = objReporter;
            this.isNew = isNew;
        }
    }

    
    public SIREdit_ctr(ApexPages.Standardcontroller controller){
        this.controller = controller;
        Map<String,String> mapParameters = Apexpages.currentPage().getParameters();
        Safety_Individual_Report__c SIR = (Safety_Individual_Report__c)controller.getRecord();
        if(controller.getId()!=null){
            //Cargar Medicines in uses
            List<Medicines_in_use__c> medicinesInUseLst = getMedicinesInUseBySir(controller.getId());
            if(medicinesInUseLst.size()==0){
                medicinesInUses=null;
            }else{
                medicinesInUses = new List<MedicinesInUseWrapper>();
                for(Medicines_in_use__c m:medicinesInUseLst){
                    medicinesInUses.add(new MedicinesInUseWrapper(medicinesInUses.size(),m));
                }
            }
            
            //Cargar Adverse Events 
            List<Adverse_Event__c> adverseEventsLst = getAdverseEventsBySir(controller.getId());
            if(adverseEventsLst.size()==0){
                adverseEvents=null;
            }else{
                adverseEvents = new List<AdverseEventWrapper>();
                for(Adverse_Event__c a:adverseEventsLst){
                    adverseEvents.add(new AdverseEventWrapper(adverseEvents.size(),a));
                }
            }
        
            //Cargar Reporters
            List<Reporter__c>  reportersLst = getReportersBySir(controller.getId());
            if(reportersLst.size()==0){
                reporters=null;
            }else{
                reporters = new List<ReportersWrapper>();
                for(Reporter__c r:reportersLst){
                    reporters.add(new ReportersWrapper(reporters.size(),r, false));
                }
                reporterMap = new Map<ID,Reporter__c>(reportersLst.deepClone());
            }
            
            
        }else{
            Set <String> keys = mapParameters.keySet();
            for(String key:keys){
                if(key.contains('_lkid')){
                    SIR.Subcase_Number__c = mapParameters.get(key);
                    caseId = mapParameters.get(key);
                }
            }
        }   
        
        //Cargar Info del Subcaso Relacionado si existe.
        if(SIR.Subcase_Number__c!=null){
            caseObj = getCase (SIR.Subcase_Number__c);
            if(SIR.id==null){
                SIR.Client_Name__c = caseObj.AccountId;
                SIR.Patient_Name__c = caseObj.patient_name__c;
                SIR.Client_Name_Frozen__c = caseObj.Account.LastName;
                SIR.Client_Profession_Frozen__c = caseObj.Account.Occupation_Specialty__pc;
                SIR.Patient_Name_Frozen__c = caseObj.patient_name__r.LastName;
                SIR.Patient_Birthdate_Frozen__c = caseObj.patient_name__r.PersonBirthdate;
                SIR.Patient_Gender_Frozen__c = caseObj.patient_name__r.Gender__pc;
            }
        }
        
        //Crear Objetos auxiliares
        host='https://' + ApexPages.currentPage().getHeaders().get('Host') + '/';
        adverseEventsDeleted = new List<Adverse_Event__c> ();
        medicinesInUseDeleted = new List<Medicines_in_use__c> ();
        reportersDeleted = new List<Reporter__c> ();
        List<Account> lstAcc = [Select Name from Account Where Name!=null And Name!='' Limit 1];
        if (lstAcc.size()>0 ){ 
            defaultAccount = lstAcc[0].id;
            defaultAccountName = lstAcc[0].Name;
        }
        
        //Calcular si son editables los campos frozen
        editFrozen = false;
        editField=true;
        
        //JGDP. 26-08-2013. Cambio configuración personaliza para incluir más de un perfil
        List<FV_Profile_Config__c> vfpc = FV_Profile_Config__c.getall().values();
        set<String> lstIdProfiles = new set<String>();
        for( FV_Profile_Config__c objFV :vfpc )
        {
          lstIdProfiles.add(objFV.IdProfile__c);
        }
        
        if( lstIdProfiles.contains(Userinfo.getProfileId()) ){
            if(SIR.id!=null)editFrozen = true;
            editField=false;
        }
    }
    
    
    //Get items for field Subcase_seriousness__c
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =
        Safety_Individual_Report__c.Subcase_seriousness__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        //JGDP. 26-08-2013. Cambio configuración personaliza para incluir más de un perfil
        List<FV_Profile_Config__c> vfpc = FV_Profile_Config__c.getall().values();
        set<String> lstIdProfiles = new set<String>();
        for( FV_Profile_Config__c objFV :vfpc )
        {
          lstIdProfiles.add(objFV.IdProfile__c);
        }
         
        options.add(new SelectOption('', System.Label.None));     
        Safety_Individual_Report__c SIR = (Safety_Individual_Report__c)controller.getRecord();
        for( Schema.PicklistEntry f : ple){
            /*if(f.getValue().equalsIgnoreCase('Non Serious') || f.getValue().equalsIgnoreCase('Non Case')){
                if(Userinfo.getProfileId().substring(0,15)==conf.FV_Profile_Id__c.substring(0,15)||SIR.Subcase_seriousness__c==f.getValue()){
                        options.add(new SelectOption(f.getValue(), f.getLabel()));
                }else if((Userinfo.getProfileId().substring(0,15)==conf.Id_2nd_Level__c.substring(0,15) && f.getValue().equalsIgnoreCase('Non Serious'))||SIR.Subcase_seriousness__c==f.getValue()) options.add(new SelectOption(f.getValue(), f.getLabel()));
            }else{
                options.add(new SelectOption(f.getValue(),f.getLabel()));
            }*/
            if(f.getValue().equalsIgnoreCase('Non Case')){
                if( lstIdProfiles.contains(Userinfo.getProfileId()) || SIR.Subcase_seriousness__c==f.getValue() ){
                        options.add(new SelectOption(f.getValue(), f.getLabel()));
                }
            }else{
                options.add(new SelectOption(f.getValue(),f.getLabel()));
            }
        }   
        return options;
    }
        
    
    //Event Chance Reporter Related Name
    public PageReference changeReporterRelatedName(){
        Account accountObj = [Select a.fOcupation__c, a.fName__c
                           From Account a 
                           Where a.id=:reporters[selectedIndex].objReporter.Reporter_related_name__c]; 
        Reporter__c rep = reporters[selectedIndex].objReporter;
        rep.Reporter_Name_Frozen__c = accountObj.fName__c;
        rep.Reporter_Profession_Frozen__c = accountObj.fOcupation__c;
        return null;
    }
    
    //Event Add Adverse Event
    public PageReference btnAddAdverseEvent(){
        if(adverseEvents==null)adverseEvents = new List<AdverseEventWrapper>();
        adverseEvents.add(new AdverseEventWrapper(adverseEvents.size(),new Adverse_Event__c()));
        return null;
    }
    
    //Event Add Medicines In Use
    public PageReference btnAddMedicineInUse(){
        if(medicinesInUses==null) medicinesInUses = new List<MedicinesInUseWrapper>();
        medicinesInUses.add(new MedicinesInUseWrapper(medicinesInUses.size(),new Medicines_in_use__c() ));
        return null;
    }
    
    //Event Add Reports
    public PageReference btnAddReporter(){
        if(reporters==null)reporters = new List<ReportersWrapper>();
        reporters.add(new ReportersWrapper(reporters.size(),new Reporter__c(),true));
        return null;
    }
    
    //Event Delete Adverse Event
    public pageReference  deleteAdverseEvent(){
        Adverse_Event__c remove=adverseEvents[selectedIndex].objAdverseEvent; 
        if(remove.Id!=null){
            adverseEventsDeleted.add(remove);
        }
        adverseEvents.remove(selectedIndex);
        for(Integer i=selectedIndex;i<adverseEvents.Size();i++){
            adverseEvents[i].index = i; 
        }
        if(adverseEvents.size()==0)adverseEvents=null;
        return null;
    }
    
    //Event Delete Medicine In Use
    public pageReference  deleteMedicineInUse(){
        Medicines_in_use__c remove=medicinesInUses[selectedIndex].objMedicinesInUse; 
        if(remove.Id!=null){
            medicinesInUseDeleted.add(remove);
        }
        medicinesInUses.remove(selectedIndex);
        for(Integer i=selectedIndex;i<medicinesInUses.Size();i++){
            medicinesInUses[i].index = i; 
        }
        if(medicinesInUses.size()==0)medicinesInUses=null;
        return null;
    }
    
    
    //Event Delete  Reporter
    public pageReference  deleteReporter(){
        Reporter__c remove=reporters[selectedIndex].objReporter; 
        if(remove.Id!=null){
            reportersDeleted.add(remove);
        }
        reporters.remove(selectedIndex);
        for(Integer i=selectedIndex;i<reporters.Size();i++){
            reporters[i].index = i; 
        }
        if(reporters.size()==0)reporters=null;
        return null;
    }
    
    //Event Save 
    public pageReference btnSave(){
        Savepoint sp;
        String UpdateObject;
        try{
            sp = Database.setSavepoint();
            List<Adverse_Event__c> adverseEventsLst = new List<Adverse_Event__c>();
            List<Medicines_in_use__c> medicinesInUseLst = new List<Medicines_in_use__c>();
            List<Reporter__c> reportersLst= new List<Reporter__c>();
            
            Safety_Individual_Report__c SIR = (Safety_Individual_Report__c)controller.getRecord();
            Safety_Individual_Report__c copySir = SIR.clone(true,true);
            
            UpdateObject =  Safety_Individual_Report__c.SObjectType.getDescribe().getlabel();
            upsert copySir;
            
            if(adverseEvents!=null){
                for(AdverseEventWrapper a:adverseEvents){
                    Adverse_Event__c copyAdverseEvent = a.objAdverseEvent.clone(true,true);
                    if(copyAdverseEvent.PV_number_SINA__c==null){
                        copyAdverseEvent.PV_number_SINA__c = copySir.Id;
                    }
                    copyAdverseEvent.Patient_Name__c = copySir.Patient_Name__c;
                    adverseEventsLst.add(copyAdverseEvent);
                }
            }
            if(medicinesInUses!=null){
                for(MedicinesInUseWrapper m:medicinesInUses){
                    Medicines_in_use__c copyMedicinesInUse = m.objMedicinesInUse.clone(true,true);
                    if(copyMedicinesInUse.Safety_Individual_Report__c==null){
                        copyMedicinesInUse.Safety_Individual_Report__c = copySir.Id; 
                    }
                    medicinesInUseLst.add(copyMedicinesInUse);
                }
            }
            if(reporters!=null){
                for(ReportersWrapper r:reporters){
                    Reporter__c reporterCopy = r.objReporter.clone(true,true);
                    if(reporterCopy.Safety_Individual_Report__c==null){
                        reporterCopy.Safety_Individual_Report__c = copySir.Id; 
                    }
                    if(reporterMap==null || reporterMap.get(r.objReporter.Id)!=r.objReporter){
                        reportersLst.add(reporterCopy);
                    }
                }
            }
            
            
            UpdateObject =  Adverse_Event__c.SObjectType.getDescribe().getlabel();
            delete adverseEventsDeleted;
            upsert adverseEventsLst;
            
            UpdateObject =  Medicines_in_use__c.SObjectType.getDescribe().getlabel();
            delete medicinesInUseDeleted;
            upsert medicinesInUseLst;
            
            UpdateObject =  Reporter__c.SObjectType.getDescribe().getlabel();   
            delete reportersDeleted;
            upsert reportersLst;
            
            UpdateObject =  Case.SObjectType.getDescribe().getlabel();
            if (caseObj!=null)update caseObj;
            
            PageReference pr = new PageReference('/apex/SIRDisplay?id=' + copySir.Id);
            pr.setRedirect(true);
            return pr;
        }catch(DMLException e){
            System.debug('---->' + e.getMessage());
            for(Integer i=0;i<e.getNumDml();i++){
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,UpdateObject + ' ' + System.Label.Row + ' ' + e.getDmlIndex(i) + ':' + e.getDmlMessage(i).replace('&quot;','"')));
            }
            Database.rollback(sp);
            return null;
        }
        
    }
    
    //Event Cancel
    public pageReference btnCancel(){
        PageReference pr;
        if(controller.getId()!=null){
          pr = new PageReference('/apex/SIRDisplay?id=' + controller.getId());
        }else{
            if(caseId!=null){
                pr = new PageReference('/' + caseId);
            }else{
                pr = new PageReference('/a0a/o');
            }
        }
        pr.setRedirect(true);
        return pr;
    }
    
    
    public Case getCase(String caseid){
        try{
        Case c = [Select Product__c,
                    Product_Batch_number__c,
                    Manufacture_Date_Day__c,
                    Expire_Date_Day__c,
                    Manufacture_Date_Month__c,
                    Expire_Date_Month__c,
                    Manufacture_Date_Year__c,
                    Expire_Date_Year__c,
                    Subcase_Description__c, 
                    Account.Occupation_Specialty__pc,
                    Account.LastName,
                    patient_name__r.LastName,
                    patient_name__r.PersonBirthdate,
                    patient_name__r.Gender__pc    
                From Case c
                Where c.Id =: caseid];
            return c;       
        }catch(System.QueryException e){
            return null;
        }
    }
    
    
    
    private List<Adverse_Event__c> getAdverseEventsBySir(id sir){
        return [Select a.Start__c,
                a.Name, 
                a.SIR__c, 
                a.Patient_Name__c, 
                a.Id, 
                a.Event_Seriousness__c, 
                a.Client_Name__c, 
                a.Case_Subcase_Number__c, 
                a.PV_number_SINA__c,
                a.Evolution__c
                From Adverse_Event__c a
                Where a.PV_number_SINA__c =: sir ];
    }
    
    private List<Medicines_in_use__c> getMedicinesInUseBySir(id sir){
    return [Select m.SystemModstamp, 
            m.Suspect_Products__c, 
            m.Start_Date__c, 
            m.Safety_Individual_Report__c, 
            m.SIR_name__c, 
            m.SIR__c, 
            m.Product_name__c, 
            m.Product_from_other_labs__c,
            m.Posology__c, 
            m.Patient_Name__c, 
            m.Ongoing__c, 
            m.Novartis_Product_Name__c, 
            m.Name, 
            m.Migration_Id__c, 
            m.LastModifiedDate, 
            m.LastModifiedById, 
            m.LastActivityDate, 
            m.IsDeleted, 
            m.Indication__c, 
            m.Id, 
            m.End_Date__c, 
            m.CreatedDate, 
            m.CreatedById, 
            m.Client_Name__c, 
            m.Batch_Number__c, 
            m.Administration_route__c,
            m.Safety_Individual_Report__r.Subcase_Number__c 
            From Medicines_in_use__c m
            Where m.Safety_Individual_Report__c =: sir ];
    }
    
    private List<Reporter__c> getReportersBySir(id sir){
    return [Select r.Reporter_related_name__c, 
                   r.Name, 
                   r.Id, 
                   r.CreatedDate,
                   r.Safety_Individual_Report__c,
                   r.Reporter_Profession_Frozen__c, 
                   r.Reporter_Name_Frozen__c
            From Reporter__c r 
            Where r.Safety_Individual_Report__c =: sir];
    }
    
    
}