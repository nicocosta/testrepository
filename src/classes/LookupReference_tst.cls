/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Gabriel Duarte Pacheco
	Project:			Novartis Brazil
	Description: 		Test's LookupReference_ctr.
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor							Description
	------  ----------	--------------------------		-----------
	1.0		28-08-2012	Juan Gabriel Duarte P.			Create class.
	****************************************************************************************************/
@isTest
private class LookupReference_tst {

    static testMethod void myUnitTest() {
        // Crear data para el objeto Grupo
        List<Group__c> lstGroup = new List<Group__c>();
        List<Group_Member__c> lstGroupMember = new List<Group_Member__c>();
        
        Group__c objGroup = new Group__c();        
        objGroup.Name = 'Group Name Test ';    	
        lstGroup.add(objGroup);        
        insert lstGroup;
        
        Group_Member__c objGroupMember = new Group_Member__c();        
        objGroupMember.Group__c = lstGroup.get(0).Id;
        objGroupMember.User__c  = UserInfo.getUserId();
        lstGroupMember.add(objGroupMember);
         
        insert lstGroupMember;
                        
        Test.startTest();
		LookupReference_ctr controller = new LookupReference_ctr();
		ApexPages.StandardSetController setConTest = controller.setCon;
		List<Group__c> lstGroupTest = controller.lstGroups;
		
		Apexpages.currentPage().getParameters().put( 'type', 'Group' );
		controller = new LookupReference_ctr();		
		lstGroupTest = controller.lstGroups;
		
		Test.stopTest();
		
    }
    
    static testMethod void methodsTest()
	{
		LookupReference_ctr controller = new LookupReference_ctr();
		controller.doSearch();
		controller.cambioRegXPag();
		controller.FirstPage();
		controller.LastPage();
		controller.NextPage();
		controller.LastPage();
		controller.PreviousPage();
						
		controller.strNumPagActual = '1';
		String valNumPagActual = controller.strNumPagActual; 
		String valNumRegs = controller.strNumRegs;
		Boolean blnVerPrimera = controller.blnVerPrimera;
		String strNumPag = controller.strNumPag;
		Boolean blnVerUltima = controller.blnVerUltima;
	}
}