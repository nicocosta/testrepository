trigger SubCase_Counter on Case (before delete, before insert) {

	Map<String,Double> mapNumSubCasesByParentCaseId = new Map<String,Double>();
	String recordTypeId = [ Select Id From RecordType Where Name = 'Subcase' limit 1 ].Id;
	recordTypeId = recordTypeId.substring( 0, 15 );
	
	if( Trigger.isInsert ) {
		
		for( Case c : Trigger.new ) {
			if( c.RecordTypeId == recordTypeId ) {
				Double d = 0;
				if( mapNumSubCasesByParentCaseId.containsKey( c.ParentId ) )
					d = mapNumSubCasesByParentCaseId.get( c.ParentId );
				d++;
				mapNumSubCasesByParentCaseId.put( c.ParentId, d );
			}
		}
	}
	else if( Trigger.isDelete ) {
		
		for( Case c : Trigger.old ) {
			if( c.RecordTypeId == recordTypeId ) {
				Double d = 0;
				if( mapNumSubCasesByParentCaseId.containsKey( c.ParentId ) )
					d = mapNumSubCasesByParentCaseId.get( c.ParentId );
				d++;
				mapNumSubCasesByParentCaseId.put( c.ParentId, d );
			}
		}
	}
	
	System.debug( 'mapNumSubCasesByParentCaseId: ' + mapNumSubCasesByParentCaseId );
	System.debug( 'size: ' + mapNumSubCasesByParentCaseId.size() );
	
	List<Case> lstToUpdateCases = [ Select Id, total_subcases__c From Case Where Id IN :mapNumSubCasesByParentCaseId.keySet() ];
	for( Case c : lstToUpdateCases ) {
		if( Trigger.isInsert && ( c.total_subcases__c == null || c.total_subcases__c == 0 ) )
			c.total_subcases__c = mapNumSubCasesByParentCaseId.get( c.Id );
		else if( Trigger.isDelete && ( c.total_subcases__c == null || ( c.total_subcases__c != null && c.total_subcases__c - mapNumSubCasesByParentCaseId.get( c.Id ) <= 0 ) ) )
			c.total_subcases__c = 0;
		else if( c.total_subcases__c != null && Trigger.isInsert )
			c.total_subcases__c += mapNumSubCasesByParentCaseId.get( c.Id );
		else if( c.total_subcases__c != null && Trigger.isDelete )
			c.total_subcases__c -= mapNumSubCasesByParentCaseId.get( c.Id );
	}
	
	update lstToUpdateCases;
}