/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 * @author Diego Satoba
 */
@isTest
private class CRWEBService24102010_tst {
	
	static String PASSWORD = 'novartis2010';
	static String USER = 'USR010';

	/**
	 * Prueba de solicitudes
	 */
    static testMethod void myUnitTest() {
    	System.debug(':::: BEGIN');
    	
    	CRWEBService24102010.wsEssSoap stub = new CRWEBService24102010.wsEssSoap();
    	CRWEBService24102010.ConsultarSolicitacoes1_element consultarSolicitacoes1_element = new CRWEBService24102010.ConsultarSolicitacoes1_element();
    	CRWEBService24102010.ConsultarSolicitacoes1Response_element consultarSolicitacoes1Response_element= new CRWEBService24102010.ConsultarSolicitacoes1Response_element();
    	CRWEBService24102010.ConsultarSolicitacoes1Result_element consultarSolicitacoes1Result_element= new CRWEBService24102010.ConsultarSolicitacoes1Result_element();
    	CRWEBService24102010.ConsultarSolicitacoes2_element consultarSolicitacoes2_element= new CRWEBService24102010.ConsultarSolicitacoes2_element();
    	CRWEBService24102010.ConsultarSolicitacoes2Response_element consultarSolicitacoes2Response_element = new CRWEBService24102010.ConsultarSolicitacoes2Response_element();
    	CRWEBService24102010.InserirNovaSolicitacao1_element inserirNovaSolicitacao1_element = new CRWEBService24102010.InserirNovaSolicitacao1_element();
    	CRWEBService24102010.InserirNovaSolicitacao1Response_element inserirNovaSolicitacao1Response_element = new CRWEBService24102010.InserirNovaSolicitacao1Response_element();
    	CRWEBService24102010.InserirNovaSolicitacao2_element inserirNovaSolicitacao2_element = new CRWEBService24102010.InserirNovaSolicitacao2_element();
    	CRWEBService24102010.InserirNovaSolicitacao2Response_element inserirNovaSolicitacao2Response_element = new CRWEBService24102010.InserirNovaSolicitacao2Response_element();
    	CRWEBService24102010.InserirNovaSolicitacao3_element inserirNovaSolicitacao3_element = new CRWEBService24102010.InserirNovaSolicitacao3_element();
    	CRWEBService24102010.InserirNovaSolicitacao3Response_element inserirNovaSolicitacao3Response_element = new CRWEBService24102010.InserirNovaSolicitacao3Response_element();
    	CRWEBService24102010.ValidationSoapHeader validationSoapHeader = new CRWEBService24102010.ValidationSoapHeader();
    	CRWEBService24102010.wsEssSoap wsEssSoap = new CRWEBService24102010.wsEssSoap();
    	CRWEBService24102010.wsSolicitacao wsSolicitacao = new CRWEBService24102010.wsSolicitacao();
    	CRWEBService24102010.xmlFile_element xmlFile_element = new CRWEBService24102010.xmlFile_element();
    	
    	System.debug(':::: END');
    	/*
    	System.debug(':::: BEGIN');    	
    	
    	CRWEBService24102010.wsEssSoap stub = new CRWEBService24102010.wsEssSoap();
    	    	
    	CRWEBService24102010.ValidationSoapHeader validationSoapHeader = new CRWEBService24102010.ValidationSoapHeader();    	
		validationSoapHeader.Password = PASSWORD;
		validationSoapHeader.UserID = USER;
		
		System.debug(':::: using PASSWORD:'+PASSWORD+',USER:'+USER+'.');
		
		String strNumerosDeSolicitacoes = '';
		for (Integer i = 1; i < 100; i++) 
			strNumerosDeSolicitacoes += ','+i;
		
		System.debug(':::: Testing ConsultarSolicitacoes1:...');
		CRWEBService24102010.ConsultarSolicitacoes1Result_element respElement = stub.ConsultarSolicitacoes1(strNumerosDeSolicitacoes);
		System.debug(':::: Response: ' + respElement);
		
		System.debug(':::: Testing ConsultarSolicitacoes2:...');
		String resp = stub.ConsultarSolicitacoes2(strNumerosDeSolicitacoes);
		System.debug(':::: Response: ' + resp + '.');
		
		System.debug(':::: END');
		*/		
    }
}