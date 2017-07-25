@isTest
private class ProductsEmailInterface_tst
{
	static testMethod void handleInboundEmailTest()
	{
		// Create a new email, envelope object and Attachment
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
		String strHtmlBody = '';
		Blob blbAttachemnt;
		Messaging.InboundEmail.BinaryAttachment atFile = new Messaging.InboundEmail.BinaryAttachment();
		PIC__c interfaceConfiguration = PIC__c.getInstance();
		String strSeparador = '';
		if( interfaceConfiguration != null )
			strSeparador = interfaceConfiguration.Separator__c;
		if( strSeparador.equalsIgnoreCase( 'TAB' ) )
			strSeparador = '	';
		
		strHtmlBody += 'SKU' + strSeparador + 'Subgroup' + strSeparador + 'Group' + strSeparador + 'SAPCode' + strSeparador + 'BarCode' + strSeparador + 'Price\n';
		strHtmlBody += 'TestMYFORTIC FCT 180MG 120CE GOV' + strSeparador + 'MYFORTIC' + strSeparador + 'CORTICEIDES' + strSeparador + '326545' + strSeparador + '7896261017399' + strSeparador + '.00\n';
		strHtmlBody += 'TestMYFORTIC FCT 180MG 120CE GOV' + strSeparador + 'MYFORTIC' + strSeparador + 'CORTICEIDES' + strSeparador + '145698' + strSeparador + '7896261017399' + strSeparador + '.00';
		
		System.debug( '-*-*-*-*-* strHtmlBody ' + strHtmlBody );

		blbAttachemnt = Blob.valueOf( strHtmlBody );
		atFile.body = blbAttachemnt;
		
		email.binaryAttachments = new List<Messaging.InboundEmail.BinaryAttachment>{ atFile };
		email.subject = 'Subject Test';
		email.fromName = 'test test';
		email.htmlBody = strHtmlBody;
		envelope.fromAddress = 'user@acme.com';

		System.assertEquals( 0 , [Select Count() From Product2 Where SAP_code__c = 326545 or SAP_code__c = 145698 ] );

		// setup controller object
		ProductsEmailInterface handler = new ProductsEmailInterface();
		Messaging.InboundEmailResult result = handler.handleInboundEmail(email, envelope);
		
		//System.assertEquals( 2 , [Select Count() From Product2 Where SAP_code__c = 326545 or SAP_code__c = 145698 ] );
	}
	
	static testMethod void errorsTest()
	{
		// Create a new email, envelope object and Attachment
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
		String strHtmlBody = '';
		Blob blbAttachemnt;
		Messaging.InboundEmail.BinaryAttachment atFile = new Messaging.InboundEmail.BinaryAttachment();
		PIC__c interfaceConfiguration = PIC__c.getInstance();
		String strSeparador = '';
		if( interfaceConfiguration != null )
			strSeparador = interfaceConfiguration.Separator__c;
		if( strSeparador.equalsIgnoreCase( 'TAB' ) )
			strSeparador = '	';
		
		strHtmlBody += 'Error fields Test';
		
		System.debug( '-*-*-*-*-* strHtmlBody ' + strHtmlBody );

		blbAttachemnt = Blob.valueOf( strHtmlBody );
		atFile.body = blbAttachemnt;
		
		email.binaryAttachments = new List<Messaging.InboundEmail.BinaryAttachment>{ atFile };
		email.subject = 'Subject Test';
		email.fromName = 'test test';
		email.htmlBody = strHtmlBody;
		envelope.fromAddress = 'user@acme.com';

		// setup controller object
		ProductsEmailInterface handler = new ProductsEmailInterface();
		Messaging.InboundEmailResult result = handler.handleInboundEmail(email, envelope);
		
		strHtmlBody = 'SKU' + strSeparador + 'Subgroup' + strSeparador + 'Group' + strSeparador + 'SAPCode' + strSeparador + 'BarCode' + strSeparador + 'Price\n';
		strHtmlBody += 'TestMYFORTIC FCT 180MG 120CE GOV' + strSeparador + 'MYFORTIC' + strSeparador + 'CORTICEIDES' + strSeparador + '720527' + strSeparador + '7896261017399' + strSeparador + 'daskjdha.00\n';
		strHtmlBody += 'TestMYFORTIC FCT 180MG 120CE GOV' + strSeparador + 'MYFORTIC' + strSeparador + 'CORTICEIDES' + strSeparador + '720528' + strSeparador + '7896261017399' + strSeparador + '.00';
		
		System.debug( '-*-*-*-*-* strHtmlBody ' + strHtmlBody );

		blbAttachemnt = Blob.valueOf( strHtmlBody );
		atFile.body = blbAttachemnt;
		
		email.binaryAttachments = new List<Messaging.InboundEmail.BinaryAttachment>{ atFile };
		email.subject = 'Subject Test';
		email.fromName = 'test test';
		email.htmlBody = strHtmlBody;
		envelope.fromAddress = 'user@acme.com';

		result = handler.handleInboundEmail(email, envelope);
		
		strHtmlBody = 'SKU' + strSeparador + 'Subgroup' + strSeparador + 'Group' + strSeparador + 'SAPCode' + strSeparador + 'BarCode' + strSeparador + 'Price\r\n';
		strHtmlBody += 'TestMYFORTIC FCT 180MG 120CE GOV' + strSeparador + 'MYFORTIC' + strSeparador + 'CORTICEIDES' + strSeparador + '720527' + strSeparador + '7896261017399' + strSeparador + '.00\r\n';
		strHtmlBody += 'TestMYFORTIC FCT 180MG 120CE GOV' + strSeparador + 'MYFORTIC' + strSeparador + 'CORTICEIDES' + strSeparador + '720528' + strSeparador + '7896261017399' + strSeparador + 'daskjdha.00';
		
		System.debug( '-*-*-*-*-* strHtmlBody ' + strHtmlBody );

		blbAttachemnt = Blob.valueOf( strHtmlBody );
		atFile.body = blbAttachemnt;
		
		email.binaryAttachments = new List<Messaging.InboundEmail.BinaryAttachment>{ atFile };
		email.subject = 'Subject Test';
		email.fromName = 'test test';
		email.htmlBody = strHtmlBody;
		envelope.fromAddress = 'user@acme.com';

		result = handler.handleInboundEmail(email, envelope);
		
		strHtmlBody = 'SKU' + strSeparador + 'Subgroup' + strSeparador + 'Group' + strSeparador + 'SAPCode' + strSeparador + 'BarCode' + strSeparador + 'Price \n';
		strHtmlBody += 'TestMYFORTIC FCT 180MG 120CE GOV' + strSeparador + 'MYFORTIC' + strSeparador + 'CORTICEIDES' + strSeparador + '720527' + strSeparador + '7896261017399' + strSeparador + '.00\n';
		strHtmlBody += 'TestMYFORTIC FCT 180MG 120CE GOV' + strSeparador + 'MYFORTIC' + strSeparador + 'CORTICEIDES' + strSeparador + '720528' + strSeparador + '7896261017399' + strSeparador + '.00\n';
		
		System.debug( '-*-*-*-*-* strHtmlBody ' + strHtmlBody );

		blbAttachemnt = Blob.valueOf( strHtmlBody );
		atFile.body = blbAttachemnt;
		
		email.binaryAttachments = new List<Messaging.InboundEmail.BinaryAttachment>{ atFile };
		email.subject = 'Subject Test';
		email.fromName = 'test test';
		email.htmlBody = strHtmlBody;
		envelope.fromAddress = 'user@acme.com';

		result = handler.handleInboundEmail(email, envelope);
		
		strHtmlBody = 'SKU' + strSeparador + 'Subgrou' + strSeparador + 'Group' + strSeparador + 'SAPCode' + strSeparador + 'BarCode' + strSeparador + 'Price \n';
		strHtmlBody += 'TestMYFORTIC FCT 180MG 120CE GOV' + strSeparador + 'MYFORTIC' + strSeparador + 'ORTICEIDES' + strSeparador + '720530' + strSeparador + '7896261017399' + strSeparador + '12345678901234567890.00';
		
		System.debug( '-*-*-*-*-* strHtmlBody ' + strHtmlBody );

		blbAttachemnt = Blob.valueOf( strHtmlBody );
		atFile.body = blbAttachemnt;
		
		email.binaryAttachments = new List<Messaging.InboundEmail.BinaryAttachment>{ atFile };
		email.subject = 'Subject Test';
		email.fromName = 'test test';
		email.htmlBody = strHtmlBody;
		envelope.fromAddress = 'user@acme.com';

		result = handler.handleInboundEmail(email, envelope);
	}
}