/**
 * @author Diego Satoba
 */
trigger SubcaseNumberAutomaticGeneration_tgr on Case (before insert) {
    /**
     * Bulk
     */
    if (Trigger.isBefore && Trigger.isInsert) {
        
        List<Case> lstSubcases = new List<Case>();
        
        RecordType rTSubcases = [select Name from RecordType where Name = 'Subcase'];
        
        // (Id Parent Case => Subcases List) Casos relacionados con su lista de subcasos.
        Map<Id, List<Case>> mapCaseSubcases = new Map<Id, List<Case>>();
        // (Id SubCase => Parent Case) Id de Subcaso relacionado con su respectivo Case parent.
        Map<Id, Case> mapSubcaseCase;
        // Lista de ids de subcasos
        List<Id> lstSubcaseId = new List<Id>();
        
        for (Case c : Trigger.new) { 
            if (rTSubcases.Id == c.RecordTypeId && c.ParentId != null) {// c es subcaso
                lstSubcases.add(c); // agrega a la lista de subcasos
                List<Case> lst = mapCaseSubcases.get(c.ParentId);
                if (lst == null) 
                    mapCaseSubcases.put(c.ParentId, lst = new List<Case>());
                lst.add(c);
                lstSubcaseId.add(c.Id);
            }
        }
        /*
        System.debug('Subcase numbers: ' + lstSubcaseId.size());
        for (Id id : mapCaseSubcases.keySet()) {
            List<Case> lst = mapCaseSubcases.get(id);
            String buff = '';
            Integer i = 0;
            for (Case c : lst) buff += (i++==0?'':',') + c.Id;
            System.debug('Parent Case Id (' + id + '): ' + buff);
        }*/

        // Id Parent Case => Parent Case
        Map<Id, Case> mapIdParentCase = new Map<Id, Case>([select Id, CaseNumber from Case where Id in :mapCaseSubcases.keySet()]);
        System.debug('');
        
        // Id Parent Case => Subcase number
        Map<Id, Integer[]> mapParentCaseIdSubcaseNumber = new Map<Id, Integer[]>();
        
        for (Case c: [select Id, ParentId from Case where ParentId in : mapCaseSubcases.keySet()]) {
            Integer [] arr = mapParentCaseIdSubcaseNumber.get(c.ParentId);
            if (arr == null) mapParentCaseIdSubcaseNumber.put(c.ParentId, arr = new Integer[] { 0 });
            arr[0]++;
        }
        
        for (Id id : mapCaseSubcases.keySet()) {
            Case parentCase = mapIdParentCase.get(id);
            Integer [] arr = mapParentCaseIdSubcaseNumber.get(id); 
            Integer n = arr == null ? 0 : arr[0];
            for (Case subcase : mapCaseSubcases.get(id)) {
                subcase.Case_Subcase_Number__c = parentCase.CaseNumber + '.' + (++n);
            }
        }
        //
    }
}