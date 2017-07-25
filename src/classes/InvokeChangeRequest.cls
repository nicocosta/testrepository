global class InvokeChangeRequest {
	
	webService static void invokeChangeRequest(Id crId) {
		System.debug('::::BEGIN');
        InvokeChangeRequestWS.invokeChangeRequestWS(crId);
        System.debug('::::END');
    }

}