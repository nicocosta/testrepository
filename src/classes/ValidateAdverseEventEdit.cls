/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Pablo Gracia
	Project:			Novartis Brazil
	Description: 		Validate whether the Adverse Event can be edited.
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		09-03-2011	Juan Pablo Gracia			Create class.
	****************************************************************************************************/
public class ValidateAdverseEventEdit {
	
	/*This method validate whether the Adverse Event can be edited.
	*@param lstAdverseEvent List of Adverse Event to validate
	*@param profileId Profile Id
	*@return Map<ID,String> Where id is a Adverse_Event's id and string is a error message,
	*if message is null, Adverse Event can be edited.
	*return null if lstAdverseEvent or profileId are null.
	*/
	public Map<ID,String> validateEdition(List<Adverse_Event__c> lstAdverseEvent, ID profileId){
		if(lstAdverseEvent==null || profileId==null){
			return null;
		}
		Map<ID,String> resp = new Map<ID,String>();
		List<ID> adverseEventIds = new List<ID>();
		for(Adverse_Event__c ae:lstAdverseEvent){
			adverseEventIds.add(ae.Id);
		}
		List<Adverse_Event__c> lstAdverseEventWhitCaseId = getAdverseEventCaseId(adverseEventIds);
		List<ID> lstCaseIds = new List<ID>();
		for(Adverse_Event__c ae:lstAdverseEventWhitCaseId){
			lstCaseIds.add(ae.PV_number_SINA__r.Subcase_Number__r.id);
		}
		List<Case> cases = getCases(lstCaseIds);
		ValidateCaseEdition vc = new ValidateCaseEdition();
		Map<ID,String> casesResp = vc.validateEdition(cases,profileId);
		for(Adverse_Event__c ae:lstAdverseEventWhitCaseId){
			String message = casesResp.get(ae.PV_number_SINA__r.Subcase_Number__r.id);
			resp.put(ae.Id,message);
		}
		return resp;
	}
	
	/*Get List Adverse Event with case's id. 
	@param ids Cases' Ids
	@return list Adverse Event with case's id.
	*/
	public List<Adverse_Event__c> getAdverseEventCaseId(List<Id> ids){
		return [SELECT id, a.PV_number_SINA__r.Subcase_Number__r.id FROM Adverse_Event__c a WHERE a.id IN :ids];
	}
	
	/*Get Cases By Ids. 
	@param ids Cases' Ids
	@return list of cases 
	*/
	public List<Case> getCases(List<Id> ids){
		return [SELECT id, IsClosed, Case_Type__c FROM Case WHERE id IN :ids];
	}

}