/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Pablo Gracia
	Project:			Novartis Brazil
	Description: 		Special validation over account fields
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		08-03-2011	Juan Pablo Gracia			Create class.
	****************************************************************************************************/
trigger ValidateAccountCodes on Account (before insert, before update) {
	System.debug('\nINIT TRIGGER - SIZE ACCOUNT ='+Trigger.new.size());
	for(Account a:Trigger.new){
		if(a.Person_identification_number_CPF__pc!=null && Validations.getArray(a.Person_identification_number_CPF__pc).size()==0){
			a.Person_identification_number_CPF__pc = null;
			System.debug('\nENTER FIRST IF');
		}
		if( a.Person_identification_number_CPF__pc!=null && !Validations.valida_CPF(a.Person_identification_number_CPF__pc)){
			a.Person_identification_number_CPF__pc.addError(System.Label.CPFInvalid);
			System.debug('\nENTER SECOND IF');
		}	
		if(a.AccountNumber!=null && Validations.getArray(a.AccountNumber).size()==0){
			a.AccountNumber=null;
			System.debug('\nENTER THIRD IF');
		}
		if( a.AccountNumber!=null  && !Validations.valida_cnpj(a.AccountNumber)){
			a.AccountNumber.addError(System.Label.CNPJInvalid);
			System.debug('\nENTER FOURTH IF, msg: '+System.Label.CNPJInvalid);
		}	
	}

}