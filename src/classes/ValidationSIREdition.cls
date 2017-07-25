/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Pablo Gracia
	Project:			Novartis Brazil
	Description: 		Validate whether the SIR can be edited.
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		08-03-2011	Juan Pablo Gracia			Create class.
	****************************************************************************************************/
public class ValidationSIREdition {
	
	public static boolean executeInsert = false;

	/*This method validate whether the Safety Individual Report can be edited.
	*@param lstSIR List of Safety Individual Report to validate
	*@param profileId Profile Id
	*@return Map<ID,String> Where id is a Safety Individual Report's id and string is a error message,
	*if message is null, Safety Individual Report can be edited.
	*return null if lstSIR or profileId are null.
	*/
	public Map<ID,String> validateEdition(List<Safety_Individual_Report__c> lstSIR, ID profileId){
		if(lstSIR==null || profileId==null){
			return null;
		}
		Map<ID,String> resp = new Map<ID,String>();
		List<ID> sirCaseIds = new List<ID>();
		for(Safety_Individual_Report__c sir:lstSIR){
			sirCaseIds.add(sir.Subcase_Number__c);
		}
		List<Case> cases = getCases(sirCaseIds);
		ValidateCaseEdition vc = new ValidateCaseEdition();
		Map<ID,String> casesResp = vc.validateEdition(cases,profileId);
		for(Safety_Individual_Report__c sir:lstSIR){
			String message = casesResp.get(sir.Subcase_Number__c);
			resp.put(sir.Id,message);
		}
		return resp;
	}
	
	

	/*Get Cases By Ids. 
	@param ids Cases' Ids
	@return list of cases 
	*/
	public List<Case> getCases(List<Id> ids){
		return [SELECT id, IsClosed, Case_Type__c FROM Case WHERE id IN :ids];
	}
	
	
	
}