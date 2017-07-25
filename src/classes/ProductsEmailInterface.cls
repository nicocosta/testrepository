/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Daniel Delgado (DFDC)
	Project:			Novartis Brazil
	Description: 		Email handler for Products Interface fuctionality.
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		23-09-2010	Daniel Delgado (DFDC)		Create class.
	****************************************************************************************************/
global class ProductsEmailInterface implements Messaging.InboundEmailHandler
{
	/**
	*	This methods upsert products records contained into the attachemnt file. Finally, sends an email
	*	in order to notify the process result.
	*	@param	email	|	Email sent to salesforce.
	*			envelop	|	Email's envelop
	*	@authors: DFDC
	*/
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope)
	{
		Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
		List<Messaging.InboundEmail.BinaryAttachment> lstAttachmentsBinary = email.binaryAttachments;
		List<Messaging.InboundEmail.Textattachment> lstText = email.textAttachments;
		PIC__c interfaceConfiguration = PIC__c.getInstance();
		Map<String, PIMF__c> mapProductFields = PIMF__c.getAll();
		Map<String, Schema.SObjectType> mapSchema = Schema.getGlobalDescribe();
		Schema.SObjectType so = mapSchema.get( 'Product2' );
		String strSeparador = '';
		String strFile;
		String strHeader;
		String strRenglon;
		//Integer intEnter;
		Blob blbFile;
		List<String> lstHeader;
		List<Product2> lstProducts;
		List<String> lstValores;
		Product2 newProduct;
		Datetime dtStartTime = System.now();
		Integer INT_MAX_VALUE = 2147483647;
		
		if( interfaceConfiguration != null )
			strSeparador = interfaceConfiguration.Separator__c;
		if( strSeparador.equalsIgnoreCase( 'TAB' ) )
			strSeparador = '	';
		System.debug( '*-*-*-*-*-*- strSeparador: ' + strSeparador );
		
		if( lstAttachmentsBinary != null && !lstAttachmentsBinary.isEmpty() )
		{
			for( Messaging.InboundEmail.BinaryAttachment Attachments : lstAttachmentsBinary )
			{
				blbFile = Attachments.body;
				strFile = blbFile.toString();
				
				System.debug( '*-*-*-*-*- strFile: \n\n' + strFile );
				
				String EOL = '';
				
				Integer intUnixEOLIdx = strFile.indexOf('\n');				
				Integer intWinEOLIdx  = strFile.indexOf('\r\n');
				
				intUnixEOLIdx = intUnixEOLIdx == -1 ? INT_MAX_VALUE : intUnixEOLIdx;
				intWinEOLIdx  = intWinEOLIdx  == -1 ? INT_MAX_VALUE : intWinEOLIdx;
				
				Integer intEOLIndex = -1;
				
				if (intUnixEOLIdx < intWinEOLIdx) {
					System.debug('::::EOL Unix');
					EOL = '\n';
					intEOLIndex = intUnixEOLIdx;
				} else if (intUnixEOLIdx > intWinEOLIdx) {
					System.debug('::::EOL Windows');
					EOL = '\r\n';
					intEOLIndex = intWinEOLIdx;
				} else {
					//Archivo mal formado
					System.debug('::::Malformed File or Empty File');
					return result;
				}

				if ( intEOLIndex != -1 )
				{
					strHeader = strFile.subString( 0, intEOLIndex );
					strFile = strFile.subString( intEOLIndex + EOL.length() );
					lstHeader = strHeader.split( strSeparador );
					lstProducts = new List<Product2>();
					System.debug( '*-*-*-*-*-*- lstHeader: ' + lstHeader );
					for( String strHeaderValue : lstHeader )
					{
						if( !mapProductFields.containsKey( strHeaderValue ) )
						{
							String strError = 'Configuration Map doesn´t have the specification for: ' + strHeaderValue;
							SendFailureNotification( interfaceConfiguration.Failure_Notification__c, strError, dtStartTime );
							System.debug( '*-*-*-*-*-*- Configuration Map doesn´t have: \'' + strHeaderValue + '\'');
							return result;
						}
					}
					
					while (strFile.length() > 0) {						
						intEOLIndex = strFile.indexOf( EOL );
						
						if (intEOLIndex == -1 && strFile.length() == 0) { // El ultimo caracter antes del EOF es EOL
							break;
						} else if (intEOLIndex == -1 && strFile.trim().length() == 0) { // La ultima linea tiene mas de un espacio y termina en EOF
							break;
						} else if (intEOLIndex == -1 && strFile.trim().length() > 0) { // La ultima linea trae datos y termina en EOF en lugar de EOL
							strRenglon = strFile;
							strFile = ''; // Para asegurar terminacion de ciclo luego de proceso de linea
						} else {
							strRenglon = strFile.substring(0, intEOLIndex);
							if (strFile.length() == intEOLIndex + EOL.length()) {
								strFile = '';
							} else {
								strFile = strFile.substring(intEOLIndex + EOL.length());
							}
						}

						lstValores = strRenglon.split( strSeparador );
						
						if( lstValores.size() >= lstHeader.size() )
						{
							newProduct = (Product2) so.newSObject();
							for( Integer i = 0; i < lstHeader.size(); i++ )
							{
								try
								{
									if( mapProductFields.get( lstHeader.get( i ) ).isString__c )
										newProduct.put( mapProductFields.get( lstHeader.get( i ) ).Value__c, lstValores.get( i ).trim() );
									else if( mapProductFields.get( lstHeader.get( i ) ).isNumeric__c )
										newProduct.put( mapProductFields.get( lstHeader.get( i ) ).Value__c, Double.valueOf( lstValores.get( i ) ) );
								}
								catch( System.exception e )
								{
									SendFailureNotification( interfaceConfiguration.Failure_Notification__c, e.getMessage(), dtStartTime );
									return result;
								}
							}
							lstProducts.add( newProduct );
						}
					}
					
					System.debug( '*-*-*-*-*-* lstProducts: \n\n' + lstProducts );
					Schema.SObjectField UniqueField = Product2.Fields.SAP_code__c;
					Database.UpsertResult []srResult = Database.upsert( lstProducts,UniqueField ,false );
					Integer numOK = 0, numFail = 0;
					List<String> lstErrors = new List<String>();
					
					for( Database.UpsertResult dbResult: srResult )
					{
						if( dbResult.isSuccess() )
							numOk++;
						else
						{
							numFail++;
							Integer intLine = numOk + numFail - 1;
							for( Database.Error err : dbResult.getErrors() )
							{
								lstErrors.add( 'Line ' + intLine + ', error: ' + err.getMessage() );
							}
						}
					}
					
					SendSuccessNotification( interfaceConfiguration.Success_Notification__c, numOK, numFail, lstErrors, dtStartTime, System.now() );					
				}
			}
		} else if (lstAttachmentsBinary == null) {
			System.debug('lstAttachmentsBinary == null');
		} else if (lstAttachmentsBinary.isEmpty()) {
			System.debug('lstAttachmentsBinary.isEmpty()');
		}
		
		return result;
	}
	
	public static void SendSuccessNotification( String strToAddresses, Integer intOK, Integer intFail, List<String> lstErrors, Datetime start, Datetime finish )
	{
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = strToAddresses.split( ',' );
		mail.setToAddresses( toAddresses );
		mail.setSubject( System.Label.Products_Interface_Subject );
		String strEnter = '<br></br>';
		String strBody = System.Label.Products_Interface_Header + ' ' + start.format( 'yyyy/MM/dd HH:mm:ss' );
		strBody += ' ' + System.Label.Products_Interface_Footer + ' ' + finish.format( 'yyyy/MM/dd HH:mm:ss' ) + '.';
		strBody += strEnter + strEnter;
		strBody += '*****************	PROCESS SUMMARY *********************';
		strBody += strEnter + strEnter;
		strBody += '<Table border="0">';
		strBody += '<tr>';
		strBody += '<td>';
		strBody += '' + System.Label.Products_ok;
		strBody += '</td>';
		strBody += '<td>';
		strBody += '' + intOK;
		strBody += '</td>';
		strBody += '</tr>';
		strBody += '<tr>';
		strBody += '<td>';
		strBody += '' + System.Label.Products_fail;
		strBody += '</td>';
		strBody += '<td>';
		strBody += '' + intFail;
		strBody += '</td>';
		strBody += '</tr>';
		if( !lstErrors.isEmpty() )
		{
			strBody += '<tr>';
			strBody += '<td colspan="2">';
			strBody += '<center>ERROR LIST</center>';
			strBody += '</td>';
			strBody += '</tr>';
			for( String strError : lstErrors )
			{
				strBody += '<tr>';
				strBody += '<td colspan="2">';
				strBody += strError;
				strBody += '</td>';
				strBody += '</tr>';
			}
		}
		strBody += '</table>';
		
		mail.setHtmlBody( strBody );
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}
	
	public static void SendFailureNotification( String strToAddresses, String strError, Datetime start )
	{
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = strToAddresses.split( ',' );
		mail.setToAddresses( toAddresses );
		mail.setSubject( System.Label.Products_Interface_Subject );
		String strEnter = '<br></br>';
		String strBody = System.Label.Products_Interface_Header + ' ' + start.format( 'yyyy/MM/dd HH:mm:ss' );
		strBody += ' ' + System.Label.Products_Interface_Fail_Footer + ' ' + strError;
		strBody += strEnter + strEnter;
		
		mail.setHtmlBody( strBody );
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}
}