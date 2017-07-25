trigger FieldTraductionCase_tgr on Case (before insert, before update) {
    translationMaps transMap = new translationMaps('Case'); 
     
    for (Case objCase : Trigger.new) {
         
        //Origin 
        
        if (objCase.Origin != null) {
            
            String strTrad = transMap.getTranslation('Case', 'Origin',objCase.Origin);
            
            if (strTrad == null) {
                //objCase.Origin.addError('Valor inválido');
            } else {
                objCase.Origin  = strTrad;
            }
        }
        
        //Status 
        
        if (objCase.Status != null) {
            
            String strTrad = transMap.getTranslation('Case', 'Status',objCase.Status);
            if (strTrad == null) {
                //objCase.Status.addError('Valor inválido');
            } else {
                objCase.Status  = strTrad;
            }
        }


        //Non_attendance_reason__c 
        
        if (objCase.Non_attendance_reason__c != null) {
            
            String strTrad = transMap.getTranslation('Case', 'Non_attendance_reason__c',objCase.Non_attendance_reason__c);
            if (strTrad == null) {
                //objCase.Non_attendance_reason__c.addError('Valor inválido');
            } else {
                objCase.Non_attendance_reason__c  = strTrad;
            }
        }
        
        //Manufacture_Date_Month__c
        
        if (objCase.Manufacture_Date_Month__c != null) {
            
            String strTrad = transMap.getTranslation('Case', 'Manufacture_Date_Month__c',objCase.Manufacture_Date_Month__c);
            if (strTrad == null) {
                //objCase.Manufacture_Date_Month__c.addError('Valor inválido');
            } else {
                objCase.Manufacture_Date_Month__c  = strTrad;
            }
        }

        //Expire_Date_Month__c 
        
        if (objCase.Expire_Date_Month__c != null) {
            
            String strTrad = transMap.getTranslation('Case', 'Expire_Date_Month__c',objCase.Expire_Date_Month__c);
            if (strTrad == null) {
                //objCase.Expire_Date_Month__c.addError('Valor inválido');
            } else {
                objCase.Expire_Date_Month__c  = strTrad;
            }
        }

        //Reimbursement_via__c 
        
        if (objCase.Reimbursement_via__c != null) {
            
            String strTrad = transMap.getTranslation('Case', 'Reimbursement_via__c',objCase.Reimbursement_via__c);
            if (strTrad == null) {
                //objCase.Reimbursement_via__c.addError('Valor inválido');
            } else {
                objCase.Reimbursement_via__c  = strTrad;
            }
        }

        //Complaint_Response__c 
        
        if (objCase.Complaint_Response__c != null) {
            
            String strTrad = transMap.getTranslation('Case', 'Complaint_Response__c',objCase.Complaint_Response__c);
            if (strTrad == null) {
                //objCase.Complaint_Response__c.addError('Valor inválido');
            } else {
                objCase.Complaint_Response__c  = strTrad;
            }
        }


        //Technical_Request_Type__c 
        
        if (objCase.Technical_Request_Type__c != null) {
            
            String strTrad = transMap.getTranslation('Case', 'Technical_Request_Type__c',objCase.Technical_Request_Type__c);
            if (strTrad == null) {
                //objCase.Technical_Request_Type__c.addError('Valor inválido');
            } else {
                objCase.Technical_Request_Type__c  = strTrad;
            }
        }

        //Technical_Request_subtype__c 
        
        if (objCase.Technical_Request_subtype__c != null) {
            
            String strTrad = transMap.getTranslation('Case', 'Technical_Request_subtype__c',objCase.Technical_Request_subtype__c);
            if (strTrad == null) {
                //objCase.Technical_Request_subtype__c.addError('Valor inválido');
            } else {
                objCase.Technical_Request_subtype__c  = strTrad;
            }
        }

    
    }
}