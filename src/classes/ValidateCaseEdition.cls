/****************************************************************************************************
    General Information
    -------------------
    Developer:          Avanxo Colombia
    Autor:              Juan Pablo Gracia
    Project:            Novartis Brazil
    Description:        Validate whether the cases can be edited.
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     04-03-2011  Juan Pablo Gracia           Create class.
    ****************************************************************************************************/
public class ValidateCaseEdition {
    
    public static boolean executeInsert = false;
    
    /*This method validate whether the cases can be edited.
    *@param lstCase List of cases to validate
    *@param profileId Profile Id
    *@return Map<ID,String> Where id is a case's id and string is a error message,
    *if message is null, case can be edited.
    *return null if lstCase or profileId are null.
    */
    public Map<ID,String> validateEdition(List<Case> lstCase, ID profileId){
        if(lstCase==null || profileId==null){
            return null;
        }
        Map<ID,String> resp = new Map<ID,String>(); 
        Set<ID> caseTypesIds = new Set<ID>();
        Map<ID,Case_Type__c> caseTypeMap = new Map<ID,Case_Type__c>();
        Set<Case> lstCaseVerifyCheck = new Set<Case>(); 
        List<ID> lstCaseVerifyTaskIds = new List<ID>(); 
        
        //Verify if case is closed
        System.debug('--->Verify if case is closed');
        for(Case c:lstCase){
            if(c.IsClosed){
                resp.put(c.Id,Label.Cannot_Edit_Record_Closed_Case);
            }else{
                resp.put(c.Id,null);
                caseTypesIds.add(c.Case_Type__c); 
                lstCaseVerifyCheck.add(c);
            }
        } 
        
        //Get Case Type
        System.debug('--->Get Case Type');
        List<Case_Type__c> lstCaseType = getCaseTypeByIDs(caseTypesIds);
        for(Case_Type__c ct:lstCaseType){
            caseTypeMap.put(ct.Id,ct);
        }
        
        //Verify Case Type Check
        System.debug('--->Verify Case Type Check');
        for(Case c:lstCaseVerifyCheck){
            Case_Type__c cType = caseTypeMap.get(c.Case_Type__c);
            if(cType!=null && cType.EditInfoDisable__c){
                lstCaseVerifyTaskIds.add(c.Id);
            }
        }
        
        //Verify Tasks
        System.debug('--->Verify Tasks');
        List<Task> tasks = getTasksByIDsForValidateCaseEdition(lstCaseVerifyTaskIds);
        lstCaseVerifyTaskIds.sort();
        Integer i=0;
        String strPerfil = [select Profiles_Subordinates__c from User where id = :UserInfo.getUserId()].Profiles_Subordinates__c;
        System.debug('DebugLine 69: Subordinado:' + strPerfil );
        Boolean allow;
        for(ID idCase:lstCaseVerifyTaskIds ){
            allow = false;
            System.debug('>>>>idCase:' + idCase);
            System.debug('>>>>tasks[i].WhatId:' + tasks[i].WhatId);
            while(i<tasks.size() && idCase==tasks[i].WhatId){
                System.debug('>>>>tasks[i].Owner.Profile.Id:' + tasks[i].Owner.Profile.Id);
                System.debug('>>>>profileId:' + profileId);
                
                if((tasks[i].Owner.Profile.Id == profileId) || (tasks[i].Owner.Profile.Id == strPerfil))
                {
                    System.debug('DebugLine 78: tasks[i].Owner.Profile.Id:' + tasks[i].Owner.Profile.Id);
                System.debug('DebugLine 79: profileId:' + profileId);
                System.debug('DebugLine 80: tasks[i]:' + tasks[i].Id);
                    allow = true;
                    i++;
                    break;
                }
                i++;
            }
            if(!allow){
                resp.put(idCase,'TESTE' + Label.Cannot_Edit_Medicines_In_Use_FV);
            }
        } 
        
        return resp;
    }
    
    /*This method returns a case's list with changes except stage 
    *@param lstNew New Cases
    *@param lstOld Old Cases
    *@return  List<Case> Old Cases edited.
    */
    public List<Case> validateCasesChanges(list<Case> lstNew, list<Case> lstOld) {
        List<Case> resp = new List<Case>();
        Map<String, Schema.SObjectField> M = Schema.SObjectType.Case.fields.getMap();
        for(integer i=0;i<lstNew.Size();i++){
            for (String str : M.keyset()) {
                 if(lstNew[i].get(str) != lstOld[i].get(str) && str!='Status'){
                     resp.add(lstOld[i]);
                     break;
                 }
            }
        }
        return resp;
    }
    
    /*Get Case Types due a set of ids
    @param setIDs set of case types ids
    @return list of case types
    */
    public List<Case_Type__c> getCaseTypeByIDs(Set<ID> setIDs){
        return [SELECT c.EditInfoDisable__c 
                FROM Case_Type__c c
                WHERE c.id IN :setIDs]; 
    }
    
    
    /*Get tasks due a set of ids, which allow case edition. 
    @param setIDs set of case types ids
    @return list of case types
    */
    public List<Task> getTasksByIDsForValidateCaseEdition(List<ID> lstIDs){
     return [Select Id, t.Owner.Profile.Id, t.WhatId  
             From Task t 
             Where t.WhatId IN :lstIDs 
             AND t.StageId__c !=null
             AND t.IsClosed=false
             ORDER BY t.WhatId];  
    }
    
        
    
    /***************************************************
        Eval if is edited Subcase_Description__c field
        @param Case caseNew
        @param Case caseOld
        @return boolean 
    **************************************************/
     public boolean isEditSubcaseDescriptionFieled(Case caseNew, Case caseOld)
     {
        System.Debug('DebugLine 145: ValidateCaseEdition: caseNew.Subcase_Description__c: '+caseNew.Subcase_Description__c+', caseOld.Subcase_Description__c: '+caseOld.Subcase_Description__c);
        try{
            if(!caseNew.Subcase_Description__c.equalsIgnoreCase(caseOld.Subcase_Description__c)){
                return  true;                       
            }           
        
        }catch(Exception e){
            return false;
        }
        return false;
    }

}