public class HistoryTrackClass_cls 
{
    public HistoryTrackClass_cls()
    {
        
    } 
    
    public void HistoryCaseTrg(Case objOldValues, Case objNewValues)
    {
        HistoryTrackObjects.historyInput input= new HistoryTrackObjects.historyInput();     
        HistoryTrackObjects hstCase= new HistoryTrackObjects();
        
        input.idRegister=objOldValues.Id;        
        input.modifyDateTime=DateTime.now();
        input.currentUser=Userinfo.getUserId();
        
        input.fieldName='Case.Description';
        input.oldValue=objOldValues.Subcase_Description__c;
        input.newValue=objNewValues.Subcase_Description__c;
        
        if(objOldValues.Subcase_Description__c!=objNewValues.Subcase_Description__c)
        {
            hstCase.TrackHistoryCase(input);        
        }
        
        input.fieldName='Case.Subcase Solution Description';
        input.oldValue=objOldValues.Subcase_Solution_Description__c;
        input.newValue=objNewValues.Subcase_Solution_Description__c;
                
        if(objOldValues.Subcase_Solution_Description__c!=objNewValues.Subcase_Solution_Description__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Adress';
        input.oldValue=objOldValues.Address__c;
        input.newValue=objNewValues.Address__c;
                
        if(objOldValues.Address__c!=objNewValues.Address__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Complaint_investigation_results';
        input.oldValue=objOldValues.Complaint_investigation_results__c;
        input.newValue=objNewValues.Complaint_investigation_results__c;
                
        if(objOldValues.Complaint_investigation_results__c!=objNewValues.Complaint_investigation_results__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Description';
        input.oldValue=objOldValues.Description;
        input.newValue=objNewValues.Description;
                
        if(objOldValues.Description!=objNewValues.Description)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Answer_Task__c';
        input.oldValue=objOldValues.Answer_Task__c;
        input.newValue=objNewValues.Answer_Task__c;
                
        if(objOldValues.Answer_Task__c!=objNewValues.Answer_Task__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        /***** Campos a Hacer Track*****/
        input.fieldName='AccountName';
        List<Account> lstAcc=[Select Id,Name from Account where Id=:objOldValues.AccountId limit 1];
        if(lstAcc.size()>0)
        {
            input.oldValue=lstAcc[0].Name;
        }
        lstAcc=[Select Id,Name from Account where Id=:objNewValues.AccountId limit 1];
        if(lstAcc.size()>0)
        {
            input.newValue=lstAcc[0].Name;
        }
        
        if(input.oldValue!=input.newValue)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Asset';
        input.oldValue=objOldValues.Asset.Id;
        input.newValue=objNewValues.Asset.Id;
                
        if(objOldValues.Asset.Id!=objNewValues.Asset.Id)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Bank_Account_number';
        input.oldValue=objOldValues.Bank_Account_number__c;
        input.newValue=objNewValues.Bank_Account_number__c;
                
        if(objOldValues.Bank_Account_number__c!=objNewValues.Bank_Account_number__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='OwnerId';
        input.oldValue=objOldValues.OwnerId;
        input.newValue=objNewValues.OwnerId;
                
        if(objOldValues.OwnerId!=objNewValues.OwnerId)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='RecordTypeId';
        input.oldValue=objOldValues.RecordTypeId;
        input.newValue=objNewValues.RecordTypeId;
                
        if(objOldValues.RecordTypeId!=objNewValues.RecordTypeId)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='IsClosedOnCreate';
        input.oldValue=''+objOldValues.IsClosedOnCreate;
        input.newValue=''+objNewValues.IsClosedOnCreate;
                
        if(objOldValues.IsClosedOnCreate!=objNewValues.IsClosedOnCreate)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Copy_data_from_client';
        input.oldValue=''+objOldValues.Copy_data_from_client__c;
        input.newValue=''+objNewValues.Copy_data_from_client__c;
                
        if(objOldValues.Copy_data_from_client__c!=objNewValues.Copy_data_from_client__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='IsEscalated';
        input.oldValue=''+objOldValues.IsEscalated;
        input.newValue=''+objNewValues.IsEscalated;
                
        if(objOldValues.IsEscalated!=objNewValues.IsEscalated)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Flow_Type';
        input.oldValue=objOldValues.Flow_Type__c;
        input.newValue=objNewValues.Flow_Type__c;
                
        if(objOldValues.Flow_Type__c!=objNewValues.Flow_Type__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Invoice_number';
        input.oldValue=objOldValues.Invoice_number__c;
        input.newValue=objNewValues.Invoice_number__c;
                
        if(objOldValues.Invoice_number__c!=objNewValues.Invoice_number__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Media';
        input.oldValue=objOldValues.Media__c;
        input.newValue=objNewValues.Media__c;
                
        if(objOldValues.Media__c!=objNewValues.Media__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Non_attendance_reason';
        input.oldValue=objOldValues.Non_attendance_reason__c;
        input.newValue=objNewValues.Non_attendance_reason__c;
                
        if(objOldValues.Non_attendance_reason__c!=objNewValues.Non_attendance_reason__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Person_identification_number_CPF';
        input.oldValue=objOldValues.Person_identification_number_CPF__c;
        input.newValue=objNewValues.Person_identification_number_CPF__c;
                
        if(objOldValues.Person_identification_number_CPF__c!=objNewValues.Person_identification_number_CPF__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Price';
        input.oldValue=''+objOldValues.Price__c;
        input.newValue=''+objNewValues.Price__c;
                
        if(objOldValues.Price__c!=objNewValues.Price__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Product';
        List<Product2> lstPrt=[Select Id, Name from Product2 where Id=:objOldValues.Product__c limit 1];
        
        if(lstPrt.size()>0)
        {
            input.oldValue=lstPrt[0].Name;
        }
        
        lstPrt=[Select Id, Name from Product2 where Id=:objNewValues.Product__c limit 1];
        
        if(lstPrt.size()>0)
        {
            input.newValue=lstPrt[0].Name;
        }
                 
        if(input.oldValue!=input.newValue)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Request_Numbers';
        input.oldValue=''+objOldValues.Request_Numbers__c;
        input.newValue=''+objNewValues.Request_Numbers__c;
                
        if(objOldValues.Request_Numbers__c!=objNewValues.Request_Numbers__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Technical_Request_subtype';
        input.oldValue=objOldValues.Technical_Request_subtype__c;
        input.newValue=objNewValues.Technical_Request_subtype__c;
                
        if(objOldValues.Technical_Request_subtype__c!=objNewValues.Technical_Request_subtype__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Total_subcases';
        input.oldValue=''+objOldValues.total_subcases__c;
        input.newValue=''+objNewValues.total_subcases__c;
                
        if(objOldValues.total_subcases__c!=objNewValues.total_subcases__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Agency_number';
        input.oldValue=objOldValues.Agency_number__c;
        input.newValue=objNewValues.Agency_number__c;
                
        if(objOldValues.Agency_number__c!=objNewValues.Agency_number__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Bank_Account_Name';
        input.oldValue=objOldValues.Bank_Account_Name__c;
        input.newValue=objNewValues.Bank_Account_Name__c;
                
        if(objOldValues.Bank_Account_Name__c!=objNewValues.Bank_Account_Name__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Bank_Name';
        input.oldValue=objOldValues.Bank_Name__c;
        input.newValue=objNewValues.Bank_Name__c;
                
        if(objOldValues.Bank_Name__c!=objNewValues.Bank_Name__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='CadFor';
        input.oldValue=''+objOldValues.CadFor__c;
        input.newValue=''+objNewValues.CadFor__c;
                
        if(objOldValues.CadFor__c!=objNewValues.CadFor__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Origin';
        input.oldValue=objOldValues.Origin;
        input.newValue=objNewValues.Origin;
                
        if(objOldValues.Origin!=objNewValues.Origin)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='IsSelfServiceClosed';
        input.oldValue=''+objOldValues.IsSelfServiceClosed;
        input.newValue=''+objNewValues.IsSelfServiceClosed;
                
        if(objOldValues.IsSelfServiceClosed!=objNewValues.IsSelfServiceClosed)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Friday';
        input.oldValue=objOldValues.Friday__c;
        input.newValue=objNewValues.Friday__c;
                
        if(objOldValues.Friday__c!=objNewValues.Friday__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Migration_Id';
        input.oldValue=objOldValues.Migration_Id__c;
        input.newValue=objNewValues.Migration_Id__c;
                
        if(objOldValues.Migration_Id__c!=objNewValues.Migration_Id__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Number_of_complained_packages';
        input.oldValue=''+objOldValues.Number_of_complained_packages__c;
        input.newValue=''+objNewValues.Number_of_complained_packages__c;
                
        if(objOldValues.Number_of_complained_packages__c!=objNewValues.Number_of_complained_packages__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Phone';
        input.oldValue=objOldValues.Phone__c;
        input.newValue=objNewValues.Phone__c;
                
        if(objOldValues.Phone__c!=objNewValues.Phone__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Product_Batch_number';
        input.oldValue=objOldValues.Product_Batch_number__c;
        input.newValue=objNewValues.Product_Batch_number__c;
                
        if(objOldValues.Product_Batch_number__c!=objNewValues.Product_Batch_number__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Reimbursement_via';
        input.oldValue=objOldValues.Reimbursement_via__c;
        input.newValue=objNewValues.Reimbursement_via__c;
                
        if(objOldValues.Reimbursement_via__c!=objNewValues.Reimbursement_via__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Spam';
        input.oldValue=''+objOldValues.Spam__c;
        input.newValue=''+objNewValues.Spam__c;
                
        if(objOldValues.Spam__c!=objNewValues.Spam__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Technical_Request_Type';
        input.oldValue=objOldValues.Technical_Request_Type__c;
        input.newValue=objNewValues.Technical_Request_Type__c;
                
        if(objOldValues.Technical_Request_Type__c!=objNewValues.Technical_Request_Type__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='IsVisibleInSelfService';
        input.oldValue=''+objOldValues.IsVisibleInSelfService;
        input.newValue=''+objNewValues.IsVisibleInSelfService;
                
        if(objOldValues.IsVisibleInSelfService!=objNewValues.IsVisibleInSelfService)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Do_you_want_to_receive_an_email_response';
        input.oldValue=''+objOldValues.Do_you_want_to_receive_an_email_response__c;
        input.newValue=''+objNewValues.Do_you_want_to_receive_an_email_response__c;
                
        if(objOldValues.Do_you_want_to_receive_an_email_response__c!=objNewValues.Do_you_want_to_receive_an_email_response__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Avaliação de Farmacovigilância';
        input.oldValue=objOldValues.PV_EVALUATION__c;
        input.newValue=objNewValues.PV_EVALUATION__c;
                
        if(objOldValues.PV_EVALUATION__c!=objNewValues.PV_EVALUATION__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Avaliação de Qualidade';
        input.oldValue=objOldValues.QA_EVALUATION__c;
        input.newValue=objNewValues.QA_EVALUATION__c;
                
        if(objOldValues.QA_EVALUATION__c!=objNewValues.QA_EVALUATION__c)
        {
             hstCase.TrackHistoryCase(input);
        }  
             
        input.fieldName='Classificação';
        input.oldValue=objOldValues.Classification__c;
        input.newValue=objNewValues.Classification__c;
                
        if(objOldValues.Classification__c!=objNewValues.Classification__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Relato completa critérios de LOE para RT';
        input.oldValue=''+objOldValues.Report_Full_LOE_Criteria_for_RT__c;
        input.newValue=''+objNewValues.Report_Full_LOE_Criteria_for_RT__c;
                
        if(objOldValues.Report_Full_LOE_Criteria_for_RT__c!=objNewValues.Report_Full_LOE_Criteria_for_RT__c)
        {
             hstCase.TrackHistoryCase(input);
        }
        
        input.fieldName='Relato NÃO completa critérios LOE p/ RT';
        input.oldValue=''+objOldValues.Do_Not_Report_Full_LOE_Criteria_for_RT__c;
        input.newValue=''+objNewValues.Do_Not_Report_Full_LOE_Criteria_for_RT__c;
                
        if(objOldValues.Do_Not_Report_Full_LOE_Criteria_for_RT__c!=objNewValues.Do_Not_Report_Full_LOE_Criteria_for_RT__c)
        {
             hstCase.TrackHistoryCase(input);
        }
    }
}