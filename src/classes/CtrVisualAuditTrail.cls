/****************************************************************************************************
    General Information. 
    -------------------
    Developed by:   	Avanxo Colombia
    Author:             Giovanny Rey Cediel.
    Project:           	Novartis (CRM)
    Description:       	Controller to VisualAuditTrailPage. 
    
    Information about version
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     17-03-2011  Giovanny Rey Cediel          Creation.
    1.1     16-04-2011  Juan Pablo Gracia          	 Set the date to GMT.
**************************************************************************************************/

public with sharing class CtrVisualAuditTrail {
	/********************************************
		Class Attributes
	********************************************/
	public String strSIRId;
	public static boolean testFlat=false;//only for testing porpouses
	public static boolean testFlatTwo=false;//only for testing porpouses
	/***************************************************
		Class Constructor. Is it get parameters from 
		visualforce "VisualAuditTrail.page".		 
	***************************************************/
	public CtrVisualAuditTrail(){
		System.debug('\n<init constructor>');
		strSIRId = ApexPages.currentPage().getParameters().get( 'id' );
		
	}
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
			JPG - 16/04/2011
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
			if((listReporterHistory!=null&&listReporterHistory.size()>0) || CtrVisualAuditTrail.testFlatTwo){
				if(CtrVisualAuditTrail.testFlatTwo){//Only testing porpouses
					listReporterHistory=[
					SELECT id, OldValue, NewValue, Field, CreatedDate, CreatedById, CreatedBy.Name  
					FROM Reporter__History 
					limit 1];
				}
				for(Reporter__History rep:listReporterHistory){																							
					Values val = new Values();
					val.regType = Reporter__History.SObjectType.getDescribe().getlabel();
					//val.regType = System.label.VAuditTrailHistoryReports;		
					if(rep.id!=null || CtrVisualAuditTrail.testFlat){ 
						val.regId=''+rep.id;			
					}
					if(rep.OldValue!=null || CtrVisualAuditTrail.testFlat){ 
						val.oldValue=''+rep.OldValue;			
					}
					if(rep.NewValue!=null || CtrVisualAuditTrail.testFlat){ 
						val.newValue=''+rep.NewValue;			
					}
					if(rep.Field!=null || CtrVisualAuditTrail.testFlat){ 
						val.field=''+rep.Field;			
					}																									
					if(rep.CreatedDate!=null || CtrVisualAuditTrail.testFlat){ 
						val.dateChange = rep.CreatedDate; 
						val.createdDate=''+ formatDate(rep.CreatedDate);			
					}
					if(rep.CreatedBy.name!=null || CtrVisualAuditTrail.testFlat){ 
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
			if((listMedicinesInUseHistory!=null && listMedicinesInUseHistory.size()>0) || CtrVisualAuditTrail.testFlatTwo){
				if(CtrVisualAuditTrail.testFlatTwo){//Only testing porpouses
					listMedicinesInUseHistory=[
					SELECT id, OldValue, NewValue, Field, CreatedDate, CreatedById, CreatedBy.Name  
					FROM Medicines_in_use__History
					limit 1];
				}							
				for(Medicines_in_use__History med:listMedicinesInUseHistory){																		 										
					Values val = new Values();
					val.regType = Medicines_in_use__History.SObjectType.getDescribe().getlabel();
					//val.regType = System.label.VAuditTrailHistoryMedicinesInUse;
					if(med.id!=null || CtrVisualAuditTrail.testFlat){ 
						val.regId=''+med.id;			
					}					
					if(med.oldValue!=null || CtrVisualAuditTrail.testFlat){
						val.oldValue=''+med.OldValue;
					}													
					if(med.NewValue!=null || CtrVisualAuditTrail.testFlat){ 
						val.newValue=''+med.NewValue;			
					}
					if(med.Field!=null || CtrVisualAuditTrail.testFlat){ 
						val.field=''+med.Field;			
					}																									
					if(med.CreatedDate!=null || CtrVisualAuditTrail.testFlat){
						val.dateChange = med.CreatedDate;  
						val.createdDate=''+formatDate(med.CreatedDate);			
					}
					if(med.CreatedById!=null || CtrVisualAuditTrail.testFlat){ 
						val.createdById=''+med.CreatedById;			
					}
					if(med.CreatedBy.name!=null || CtrVisualAuditTrail.testFlat){ 
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
			if((listAdverseEventHistory !=null && listAdverseEventHistory.size()>0)||CtrVisualAuditTrail.testFlatTwo){
				if(CtrVisualAuditTrail.testFlatTwo){//Only testing pourposes
					listAdverseEventHistory=[
					SELECT id, OldValue, NewValue, Field, CreatedDate, CreatedById, CreatedBy.Name  
					FROM Adverse_Event__History
					limit 1];
				}									
				for(Adverse_Event__History adv:listAdverseEventHistory){																		 										
					Values val = new Values();
					val.regType = Adverse_Event__History.SObjectType.getDescribe().getlabel();
					//val.regType = System.label.VAuditTrailHistoryAdversesEvents;
					if(adv.id!=null || CtrVisualAuditTrail.testFlat){ 
						val.regId=''+adv.id;			
					}					
					if(adv.oldValue!=null || CtrVisualAuditTrail.testFlat){
						val.oldValue=''+adv.OldValue;
					}													
					if(adv.NewValue!=null || CtrVisualAuditTrail.testFlat){ 
						val.newValue=''+adv.NewValue;			
					}
					if(adv.Field!=null || CtrVisualAuditTrail.testFlat){ 
						val.field=''+adv.Field;			
					}																									
					if(adv.CreatedDate!=null || CtrVisualAuditTrail.testFlat){
						val.dateChange = adv.CreatedDate; 
						val.createdDate=''+formatDate(adv.CreatedDate);			
					}
					if(adv.CreatedById!=null || CtrVisualAuditTrail.testFlat){ 
						val.createdById=''+adv.CreatedById;			
					}
					if(adv.CreatedBy.name!=null || CtrVisualAuditTrail.testFlat){ 
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
					if(saf.id!=null || CtrVisualAuditTrail.testFlat ){ 
						val.regId=''+saf.id;			
					}										
					if(saf.oldValue!=null || CtrVisualAuditTrail.testFlat){
						val.oldValue=''+saf.OldValue;
					}													
					if(saf.NewValue!=null || CtrVisualAuditTrail.testFlat){ 
						val.newValue=''+saf.NewValue;			
					}
					if(saf.Field!=null || CtrVisualAuditTrail.testFlat){ 
						val.field=''+saf.Field;			
					}																									
					if(saf.CreatedDate!=null || CtrVisualAuditTrail.testFlat){ 
						val.dateChange = saf.CreatedDate;
						val.createdDate=''+formatDate(saf.CreatedDate);			
					}
					if(saf.CreatedById!=null || CtrVisualAuditTrail.testFlat){ 
						val.createdById=''+saf.CreatedById;			
					}
					if(saf.CreatedBy.name!=null || CtrVisualAuditTrail.testFlat){ 
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
					if(saf.id!=null || CtrVisualAuditTrail.testFlat ){ 
						val.regId=''+saf.id;			
					}										
					if(saf.Old_Value__c!=null || CtrVisualAuditTrail.testFlat){
						val.oldValue=''+saf.Old_Value__c;
					}													
					if(saf.New_Value__c!=null || CtrVisualAuditTrail.testFlat){ 
						val.newValue=''+saf.New_Value__c;			
					}
					if(saf.Field__c!=null || CtrVisualAuditTrail.testFlat){ 
						val.field=''+saf.Field__c;			
					}																									
					if(saf.CreatedDate!=null || CtrVisualAuditTrail.testFlat){
						val.dateChange = saf.CreatedDate; 
						val.createdDate=''+formatDate(saf.CreatedDate);			
					}
					if(saf.CreatedById!=null || CtrVisualAuditTrail.testFlat){ 
						val.createdById=''+saf.CreatedById;			
					}
					if(saf.CreatedBy.name!=null || CtrVisualAuditTrail.testFlat){ 
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