/****************************************************************************************************
    General Information. 
    -------------------
    Developed by:   	Avanxo Colombia
    Author:             Giovanny Rey Cediel.
    Project:           	Novartis (CRM)
    Description:        Test class to validCPG class.
    
    Information about version
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     02-05-2011  Giovanny Rey Cediel          Creation.
**************************************************************************************************/

@isTest
private class TestValidaCPF {
    static testMethod void testOne() {				 
		Validations.flatTest=true;
		Validations.valida_CPF('100');
		Validations.valida_CPF('1000000000000000');
		Validations.valida_CPF('1000-00000%0000.000');
		Validations.valida_CPF('0');
		Validations.flatTest=false;
		Validations.valida_CPF('1000000000000000');
    }
    static testMethod void testValida_cnpj() {
			System.assert(!Validations.valida_cnpj('123456'));//false
			System.assert(!Validations.valida_cnpj('12345678901234'));//false
			System.assert(!Validations.valida_cnpj('11111111111111'));//false
			System.assert(!Validations.valida_cnpj('11111111111.111'));//false
			System.assert(!Validations.valida_cnpj('12121212121212')); //false
			System.assert(!Validations.valida_cnpj('12312312312312')); //false
			System.assert(!Validations.valida_cnpj('24512345867210')); //false
			System.assert(!Validations.valida_cnpj('24512345867380')); //false			
			System.assert(Validations.valida_cnpj('24512345867200')); //true
    }
    
}