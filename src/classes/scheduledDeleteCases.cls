/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Mario Chaves (MCH)
	Project:			Novartis Brazil
	Description: 		delete cases with the field spam__c in true and send email. 
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		20-09-2010	Mario Chaves (MCH)		Create class.
	****************************************************************************************************/


global class scheduledDeleteCases implements Schedulable {
	
	
	global void execute(SchedulableContext sc) 
	{
		Datetime processStart=system.now().addHours(-3);
		List<Case> lstCases=new List<Case>();
        if(!test.isRunningTest()){
		for(Case theCase:[select id from Case where spam__c=true] )
		{
			lstCases.add(theCase);
		}
        }else{
            for(Case theCase:[select id from Case where spam__c=true limit 10] )
			{
			lstCases.add(theCase);
			}
        }
		if(lstCases.size()>0)
		{
			try
			{
				database.delete(lstCases);
			}
			catch(System.exception e)
			{
				
			}
		}
		Datetime processFinish=system.now().addHours(-3);
		sendEmailNotification(lstCases.size(), processFinish,processStart);
	}
	public void sendEmailNotification(Integer totalReg, Datetime processFinish, Datetime processStart )
	{
		
		try
		{
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			String[] toAddresses =searchEmails();
			mail.setToAddresses( toAddresses );
			mail.setSubject( 'Sheduled delete Spam Cases' );
			String strEnter = '<br></br>';
			String strBody = '<strong>' + 'DELETE SPAM CASES HAS FINISHED ' + '</strong> ' + + ':';
			strBody += strEnter +'Process Started at: '+processStart+ strEnter;
			strBody += 'Total Cases deleted: '+totalreg+ strEnter;
			strBody += 'Process finished at: '+ processFinish+ strEnter;
			strBody +=  strEnter;
			mail.setHtmlBody( strBody );
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		 }
		catch( System.exception e )
		{}
	}
	public List<String> searchEmails()
	{
		Map<String,emailDelSpamCases__c> mapEmailsConf=emailDelSpamCases__c.getAll();
		List<emailDelSpamCases__c> lstEmailConf;
		List<String> lstEmailAddress=new List<String>();
		if(mapEmailsConf.size()>0)
		{
			lstEmailConf=mapEmailsConf.values();
			for(emailDelSpamCases__c email:lstEmailConf)
			{
				lstEmailAddress.add(email.emailvalue__c);
			}
		}
		return lstEmailAddress;		
	}
}