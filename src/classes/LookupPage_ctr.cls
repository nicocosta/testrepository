public class LookupPage_ctr 
{
	/* PRIVATE */
	private final String MSG_INFO = 'Info';
	private final String MSG_WARNING = 'Warning';
	private final String MSG_ERROR = 'Error';
	private final String MSG_CONFIRM = 'Confirm';
	private final String MSG_FATAL = 'Fatal';
	
	/* PUBLIC */
	public Boolean blnName { get; set; }
	public Boolean blnType { get; set; }
	public Boolean blnSubType { get; set; }
	public Boolean blnTheme { get; set; }
	public List<Case_Type__c> lstCaseType { get; set; }
	public String strSearch {get; set; }
	
	/* CONSTRUCTOR */
	public LookupPage_ctr()
	{
		blnName = true;
		blnType = true;
		blnSubType = true;
		blnTheme = true;
		Map<String, String> mapParameters = ApexPages.currentPage().getParameters();
		if( mapParameters.containsKey( 'src' ) )
			strSearch = mapParameters.get( 'src' ).trim();
		else
			strSearch = '';
		String strQuery = 'Select Id, Name, Subcase_type__c, Subcase_subtype__c, Theme__c, Scenario__c From Case_Type__c ';
		strQuery += getWhereString() + ' limit 1000';
		
		System.debug( '+*+*+ ' + strQuery );
		try
		{
			lstCaseType = (List<Case_Type__c>) Database.query( strQuery );
			if( lstCaseType.isEmpty() )
				addMsg( MSG_WARNING, 'No records found.', '' );
		}
		catch( System.exception e )
		{
			System.debug( '+*+*+ EXCEPTION: ' + e );
			addMsg( MSG_FATAL, 'An exception has occurred.', 'Sorry for the inconvenience.' );
			lstCaseType = new List<Case_Type__c>();
		}
	}
	
	/* METHODS */
	public PageReference DoSearch()
	{
		if( blnName || blnType || blnSubType || blnTheme )//|| blnScenario )
		{
			String strQuery = 'Select Id, Name, Subcase_type__c, Subcase_subtype__c, Theme__c, Scenario__c From Case_Type__c ';
			strQuery += getWhereString() + ' limit 1000';
			
			System.debug( '+*+*+ ' + strQuery );
			try
			{
				lstCaseType = (List<Case_Type__c>) Database.query( strQuery );
				if( lstCaseType.isEmpty() )
					addMsg( MSG_WARNING, 'No records found.', 'Check the inserted value.' );
			}
			catch( System.exception e )
			{
				System.debug( '+*+*+ EXCEPTION: ' + e );
				addMsg( MSG_FATAL, 'An exception has occurred.', 'Sorry for the inconvenience.' );
				lstCaseType = new List<Case_Type__c>();
			}
		}
		else
			addMsg( MSG_ERROR, 'Choose at least one check box to apply a filter.', '' );
		
		return null;
	}
	
	private String getWhereString()
	{
		String strWhereQuery = 'Where Is_active__c = true ', strOR = '', strName = '', strType = '', strSubType = '', strTheme = '', strScenario = '';
		String strInfo = strSearch.trim();
		
		if( strInfo == null || strInfo.length() == 0 )
		{
			strWhereQuery = 'Where Is_active__c = true ';
		}
		//else if( strInfo.startsWith( '"' ) && strInfo.endsWith( '"' ) )
		else
		{
			//JPG 22-06-2011 Quitar caracteres especiales.
			strInfo = strInfo.replace('[','').replace(']','').replace('"','').replace('\'','').replace('*','').replace(' ','%');
		
			strInfo = '%' + strInfo + '%';
			if( blnName )
			{
				strOR = ' Name LIKE \'' + strInfo + '\' ';
			}
			
			if( blnType )
			{
				if( strOR.length() == 0 )
					strOR = 'Subcase_type__c LIKE \'' + strInfo + '\' ';
				else
					strOR += 'or Subcase_type__c LIKE \'' + strInfo + '\' ';
			}
			
			if( blnSubType )
			{
				if( strOR.length() == 0 )
					strOR = 'Subcase_subtype__c LIKE \'' + strInfo + '\' ';
				else
					strOR += 'or Subcase_subtype__c LIKE \'' + strInfo + '\' ';
			}
			
			if( blnTheme )
			{
				if( strOR.length() == 0 )
					strOR = 'Theme__c LIKE \'' + strInfo + '\' ';
				else
					strOR += 'or Theme__c LIKE \'' + strInfo + '\' ';
			}
		}
		//JPG 22-06-2011
		/*
		else
		{
			List<String> lstValues = strInfo.split( ' ' );
			
			for( Integer i = 0; i < lstValues.size(); i++ )
			{
				if( lstValues.get( i ).trim() != '' )
					lstValues[i] = lstValues.get( i ).trim();
				else
					lstValues.remove( i );
			}
			System.debug( '-*-*-*- lstValues: ' + lstValues + ' -- strInfo ' + strInfo );
			List<String> lstValueFinal = new List<String>();
			for( String str : lstValues )
			{
				String strTemp = '';
				str = str.replace(' ','%');
				strTemp = '%' + str + '%';
				
				//Cambio JPG 18/05/2011 No se tienen en cuenta los *
				/*if( str.startsWith( '*' ) && str.endsWith( '*' ) )
					strTemp = '%' + str.subString( 1, str.length() - 1 ) + '%';
				else if( str.startsWith( '*' ) )
					strTemp = '%' + str.subString( 1 );
				else if( str.endsWith( '*' ) )
					strTemp = str.subString( 0, str.length() - 1 ) + '%';
				else
					strTemp = str;*/
			/*		
				lstValueFinal.add( strTemp );
			}
			System.debug( '-*-*-*- lstValueFinal: ' + lstValueFinal );
			
			for( String str : lstValueFinal )
			{
				if( strName.length() == 0 )
					strName = 'Name like \'' + str + '\' ';
				else
					strName += 'OR Name like \'' + str + '\' ';
					
				if( strType.length() == 0 )
					strType = 'Subcase_type__c like \'' + str + '\' ';
				else
					strType += 'OR Subcase_type__c like \'' + str + '\' ';
					
				if( strSubType.length() == 0 )
					strSubType = 'Subcase_subtype__c like \'' + str + '\' ';
				else
					strSubType += 'OR Subcase_subtype__c like \'' + str + '\' ';
					
				if( strTheme.length() == 0 )
					strTheme = 'Theme__c like \'' + str + '\' ';
				else
					strTheme += 'OR Theme__c like \'' + str + '\' ';
				
				if( strScenario.length() == 0 )
					strScenario = 'Scenario__c like \'' + str + '\' ';
				else
					strScenario += 'OR Scenario__c like \'' + str + '\' ';
			}
			
			if( blnName )
			{
				strOR = strName;
			}
			
			if( blnType )
			{
				if( strOR.length() == 0 )
					strOR = strType;
				else
					strOR += 'OR ' + strType;
			}
			
			if( blnSubType )
			{
				if( strOR.length() == 0 )
					strOR = strSubType;
				else
					strOR += 'OR ' + strSubType;
			}
			
			if( blnTheme )
			{
				if( strOR.length() == 0 )
					strOR = strTheme;
				else
					strOR += 'OR ' + strTheme;
			}
		}*/
		
		if( strOR.length() > 0 )
			strWhereQuery = strWhereQuery + ' and ( ' + strOR + ' )';
		
		System.debug( '*-*-*-* strWhereQuery: ' + strWhereQuery );
		return strWhereQuery;
	}
	
	public void addMsg( String tipo, String titulo, String detalle )
	{
		ApexPages.Message myMsg = null;
		if( tipo.EqualsIgnoreCase( MSG_INFO ) )
			myMSg = new ApexPages.Message( ApexPages.Severity.INFO, titulo, detalle );
		else if( tipo.EqualsIgnoreCase( MSG_WARNING ) )
			myMSg = new ApexPages.Message( ApexPages.Severity.WARNING, titulo, detalle );
		else if( tipo.EqualsIgnoreCase( MSG_ERROR ) )
			myMSg = new ApexPages.Message( ApexPages.Severity.ERROR, titulo, detalle );
		else if( tipo.EqualsIgnoreCase( MSG_CONFIRM ) )
			myMSg = new ApexPages.Message( ApexPages.Severity.CONFIRM, titulo, detalle );
		else if( tipo.EqualsIgnoreCase( MSG_FATAL ) )
			myMSg = new ApexPages.Message( ApexPages.Severity.FATAL, titulo, detalle );
			
		if( myMsg != null )		
			ApexPages.addMessage( myMsg );
	}
}