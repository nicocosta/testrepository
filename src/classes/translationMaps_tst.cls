@isTest
private class translationMaps_tst 
{
	static testmethod void pruebaGeneral()
	{
		translationMaps trans;
		
		trans = new translationMaps( 'task' );
		trans = new translationMaps( 'Contact' );
		trans = new translationMaps( 'Account' );
		trans = new translationMaps( 'Address' );
		trans = new translationMaps( 'Phone' );
		trans = new translationMaps( 'Case' );
		trans = new translationMaps( 'CaseType' );
		trans = new translationMaps( 'SIR' );
		trans = new translationMaps( 'AdverseEvent' );
		trans = new translationMaps( 'medicinesinuse' );
		trans = new translationMaps( 'FAQ' );
		trans = new translationMaps( 'FAQ_X_Document' );
		trans = new translationMaps( 'ChangeRequest' );
		
		Map<String,Map<String,Map<String,String>>> mapCompleto = trans.mapTraduccionesXObjeto;
		String objeto;
		for( String s : mapCompleto.keySet() )
			objeto = s;
		String campo;
		for( String s : trans.mapTraduccionesXObjeto.get( objeto ).keySet() )
			campo = s;
		String valor;
		for( String s : trans.mapTraduccionesXObjeto.get( objeto ).get( campo ).keySet() )
			valor = s;
		String traduccion = trans.getTranslation( objeto, campo, valor );
		System.assert( traduccion != null );
		traduccion = trans.getTranslation( 'basura!!!!', campo, valor );
		System.assert( traduccion == null );
		traduccion = trans.getTranslation( NULL, NULL, '--' );
		System.assert( traduccion == '--' );
	}
}