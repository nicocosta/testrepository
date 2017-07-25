global class CreateChangeRequestRecord {
  
  webService static void CreateChangeRequestRecord(Id idCase) {
        
        Change_Request__c cr = new Change_Request__c();
        Case SubCaseAux = [select Id, Reimbursement_via__c from Case where Id = :idCase];
        cr.Status__c = 'Open';
        cr.Subcase_number__c = SubCaseAux.Id;
        if(SubCaseAux.Reimbursement_via__c != null)
        {
            if (SubCaseAux.Reimbursement_via__c.equalsIgnoreCase('Money') || SubCaseAux.Reimbursement_via__c.equalsIgnoreCase('Ressarcimento em dinheiro')) {
                cr.Visit_type__c = 'Withdrawal';
            } else if (SubCaseAux.Reimbursement_via__c.equalsIgnoreCase('Product') || SubCaseAux.Reimbursement_via__c.equalsIgnoreCase('Troca do produto')) {
                cr.Visit_type__c = 'Exchange';
            } else if (SubCaseAux.Reimbursement_via__c.equalsIgnoreCase('Delivery') || SubCaseAux.Reimbursement_via__c.equalsIgnoreCase('Entrega')) {
                cr.Visit_type__c = 'Delivery';
            } else if (SubCaseAux.Reimbursement_via__c.equalsIgnoreCase('N/A (Analysis only)') || SubCaseAux.Reimbursement_via__c.equalsIgnoreCase('Retirada da amostra do cliente')) {
              cr.Visit_type__c = 'Withdrawal';
            }
            insert cr;
            InvokeChangeRequestWS.invokeChangeRequestWS(cr.Id);
        }
    }
}