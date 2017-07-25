@isTest
private class LookupPage_tst
{
	static testMethod void LookupPage_ctr_Test()
	{
		LookupPage_ctr controller;
		PageReference paginaPrueba = Page.LookupPage;
		test.setCurrentPage(paginaPrueba);
		
		controller = new LookupPage_ctr();
		
		paginaPrueba.getParameters().put('src', 'akdajsdhkakdajsdhkajshkajdhakd' );
		controller = new LookupPage_ctr();
	}
	
	static testMethod void DoSearch_Test()
	{
		LookupPage_ctr controller;
		PageReference paginaPrueba = Page.LookupPage;
		test.setCurrentPage(paginaPrueba);
		
		controller = new LookupPage_ctr();
		
		controller.strSearch = '';
		controller.DoSearch();
		
		controller.strSearch = 'a  b   c';
		controller.DoSearch();
		
		controller.strSearch = 'akdajsdhkakdajsdhkajshkajdhakd';
		controller.DoSearch();
		
		controller.blnName = true;
		controller.blnType = true;
		controller.blnSubType = true;
		controller.blnTheme = true;
		
		controller.strSearch = '*a*';
		controller.DoSearch();
		
		controller.strSearch = 'a*';
		controller.DoSearch();
		
		controller.strSearch = '*a';
		controller.DoSearch();
		
		controller.strSearch = '"a"';
		controller.DoSearch();
		
		controller.blnName = false;
		controller.blnType = true;
		controller.blnSubType = true;
		controller.blnTheme = true;
		
		controller.strSearch = '*a*';
		controller.DoSearch();
		
		controller.strSearch = 'a*';
		controller.DoSearch();
		
		controller.strSearch = '*a';
		controller.DoSearch();
		
		controller.strSearch = '"a"';
		controller.DoSearch();
		
		controller.blnName = false;
		controller.blnType = false;
		controller.blnSubType = true;
		controller.blnTheme = true;
		
		controller.strSearch = '*a*';
		controller.DoSearch();
		
		controller.strSearch = 'a*';
		controller.DoSearch();
		
		controller.strSearch = '*a';
		controller.DoSearch();
		
		controller.strSearch = '"a"';
		controller.DoSearch();
		
		controller.blnName = false;
		controller.blnType = false;
		controller.blnSubType = false;
		controller.blnTheme = true;
		
		controller.strSearch = '*a*';
		controller.DoSearch();
		
		controller.strSearch = 'a*';
		controller.DoSearch();
		
		controller.strSearch = '*a';
		controller.DoSearch();
		
		controller.strSearch = '"a"';
		controller.DoSearch();
		
		controller.blnName = false;
		controller.blnSubType = false;
		controller.blnTheme = false;
		controller.blnType = false;
		
		controller.DoSearch();
	}
	
	static testMethod void addMsg_test()
	{
		LookupPage_ctr controller = new LookupPage_ctr();
		controller.addMsg( 'Info', '', '' );
		controller.addMsg( 'Confirm', '', '' );
		controller.addMsg( 'Warning', '', '' );
		controller.addMsg( 'Error', '', '' );
		controller.addMsg( 'Fatal', '', '' );
	}
}