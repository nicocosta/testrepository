public class ValidateCase_AccountNumber {
    public void executeLogic(List<Case> lstNewDat, List<Case> lstOldDat)
    {
        if(lstNewDat!=null)
        {
            if(lstNewDat.size() == 1)
            {   
                Case objCase = lstNewDat[0];                
                //Verificamos que el registro sea de un subcaso
                String strRecordType = objCase.RecordTypeId;
                /*
                * JGDP. 26-03-2013. Se excluye validación para CaseType. Inicio del cambio.
                */
                Set<String> setIdCaseType = new Set<String>();

                List<CaseTypeUnvalidated__c> lstIds = CaseTypeUnvalidated__c.getall().values();
                for(CaseTypeUnvalidated__c ctu:lstIds)  
                {        
                    setIdCaseType.add(ctu.Name); 
                }
	            System.debug('Lista de ids-> '+setIdCaseType);
	            System.debug('Case_Type__c-> '+objCase.Case_Type__c);
	            
	            Boolean blnIsExcluded = setIdCaseType.contains(objCase.Case_Type__c);
	            System.debug('blnIsExcluded-> '+blnIsExcluded);
	            /*Fin del cambio*/
            
                if(strRecordType!=null && RecordTypesId__c.getInstance('Subcase').RecordTypeId__c == strRecordType.substring(0,15) && blnIsExcluded)
                {                	
                    //Realizamos las consultas para identificar si los campos son obligatorios en el FlowType y en la Cuenta
                    List<Flow_Type__c> lstFT = [ SELECT Id,Set_CNPJ_Required__c,Set_CPF_Required__c,Set_Insc_Estadual_Required__c FROM Flow_Type__c Where Id =:objCase.Flow_Type__c ];
                    List<Account> lstAccount = [ SELECT Id,AccountNumber,Person_identification_number_CPF__pc,Insc_Estadual__c,recordTypeId FROM Account Where Id =:objCase.AccountId ];
                    
                    if( !lstFT.isEmpty() && !lstAccount.isEmpty() )
                    {
                        //Validamos que si son obligatorios en el FlowType deban estar capturados en la cuenta
                        if( lstFT.get(0).Set_CNPJ_Required__c && lstAccount.get(0).AccountNumber == null && lstAccount.get(0).recordTypeId == RecordTypesId__c.getInstance('BusinessCustomer').RecordTypeId__c)
                        {
                            objCase.addError(System.label.SetCNPJRequired);
                        }
                        else if ( lstFT.get(0).Set_CPF_Required__c && lstAccount.get(0).Person_identification_number_CPF__pc == null && lstAccount.get(0).recordTypeId == RecordTypesId__c.getInstance('Personal Account').RecordTypeId__c)
                        {
                            objCase.addError(System.label.SetCPFRequired);
                        }
                        else if ( lstFT.get(0).Set_Insc_Estadual_Required__c && lstAccount.get(0).Insc_Estadual__c == null && lstAccount.get(0).recordTypeId == RecordTypesId__c.getInstance('BusinessCustomer').RecordTypeId__c)
                        {
                            objCase.addError(System.label.Set_Insc_Estadual_Required);
                        }
                        else 
                            return;
                    }                   
                }                
                
            }
        }
    }
}