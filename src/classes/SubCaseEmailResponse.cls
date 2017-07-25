/****************************************************************************************************
    General Information
    -------------------
    Developer:          Avanxo Colombia
    Autor:              Daniel Delgado (DFDC)
    Project:            Novartis Brazil
    Description:        Email handler for SubCase Email Response fuctionality.
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     20-09-2010  Daniel Delgado (DFDC)       Create class.
    2.0     12-07-2011  Juan Pablo Gracia           Add record in Case_Mail_Response__c
    3.0     17-03-2014  Juan Gabriel Duarte P       Change the owner of the task
    ****************************************************************************************************/
global class SubCaseEmailResponse implements Messaging.InboundEmailHandler
{
    /**
    *   This methods send email notification to the owner id included into the email received. 
    *   The Answer response field is updated into the subcase related.
    *   @param  email   |   Email sent to salesforce.
    *           envelop |   Email's envelop
    *   @authors: DFDC
    *             
    */
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope)
    {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String strEmail = email.htmlBody, strSubCaseId = '', strOwnerId = '', strResponse = '', strTemp = '', strDivision = '';
        Integer intStart = -1, intEnd = -1;
        Case subcase = null;
        User usr = null;
        Map<String, FTS__c> mapFTS = FTS__c.getAll();
        
        System.debug( '-*-*-*-*-* RESULT: ' + strEmail );
        
        intStart = strEmail.indexOf( '*SUBCASE_ID*' );
        intEnd = strEmail.indexOf( '*END_SUBCASE_ID*' );
        
        System.debug( '\nLine 38: intStart ' + intStart + ' intEnd ' + intEnd );
        
        if( intStart != -1 && intEnd != -1 )
            strSubCaseId = strEmail.subString( intStart + 12, intEnd );
        
        System.debug( '\nLine 43:strSubCaseId '+strSubCaseId);
        
        intStart = strEmail.indexOf( '*OWNER_ID*' );
        intEnd = strEmail.indexOf( '*END_OWNER_ID*' );
        
        System.debug( '\nLine 48: intStart ' + intStart + ' intEnd ' + intEnd );
        
        if( intStart != -1 && intEnd != -1 )
            strOwnerId = strEmail.subString( intStart + 10, intEnd );
        
        System.debug( '\nLine 53: strSubCaseId ' + strSubCaseId + ' strOwnerId ' + strOwnerId );
        
        strTemp = '&lt;' + System.Label.Start_response + '&gt;';
        intStart = strEmail.IndexOf( strTemp );
        intEnd = strEmail.IndexOf( '&lt;' + System.Label.End_response + '&gt;' );
        
        System.debug( '\nLine 59: intStart ' + intStart + ' intEnd ' + intEnd +' ,strTemp: '+strTemp+', EndTemp: '+'&lt;' + System.Label.End_response + '&gt;');
        
        if( intStart != -1 && intEnd != -1 )
            strResponse = CleanResponse( strEmail.subString( intStart + strTemp.length(), intEnd ), strSubCaseId, strOwnerId );

/*********************************************/
        intStart = strEmail.indexOf( '*DIVISION*' );
        intEnd = strEmail.indexOf( '*END_DIVISION*' );
        
        System.debug( '\nLine 38: intStart ' + intStart + ' intEnd ' + intEnd );
        
        if( intStart != -1 && intEnd != -1 )
            strDivision = strEmail.subString( intStart + 10, intEnd );
        
        System.debug( '\nLine 43:strSubCaseId '+strSubCaseId);
/*********************************************/
            
        System.debug( 'Line 64: strSubCaseId ' + strSubCaseId + ' strOwnerId ' + strOwnerId );
        System.debug('Line 65:> strResponse: '+strResponse);
        
        //if( strSubCaseId != '' && strOwnerId != '' && strResponse != '' )
        if( strSubCaseId != '' )
        {
            try
            {
                subcase = [ Select Id, Answer_Task__c, OwnerId, Case_Subcase_Number__c From Case Where Id = :strSubCaseId ];
                
                //JPG 12-07-2011
                
                Case_Mail_Response__c resp = new Case_Mail_Response__c();
                resp.Case__c = subcase.Id;
                strEmail = strEmail.replaceAll('%(?![0-9a-fA-F]{2})', '%25');
                
                resp.Message__c = strEmail;
                resp.Message__c = EncodingUtil.urlDecode(strEmail, 'UTF-8');  
                resp.Sender__c = email.fromAddress;
                insert resp;
                
                //Lee la configuración personalizada para las tareas de seguimiento
                Follow_Task_Setup__c setup = new Follow_Task_Setup__c();
                
                if (strDivision == 'ALCON')
                    setup = Follow_Task_Setup__c.getInstance('ALCON');
                else
                    setup = Follow_Task_Setup__c.getInstance('SIC');
                    
                /* 30-07-2013. Ingresar Tarea de Seguimiento */
                /* 17-03-2014. Change the owner of the task */
                
                List<Group_Member__c> lstGM = [SELECT User__r.Id FROM Group_Member__c WHERE Group_Leader__c = true and Group__r.Name= :setup.Group__c];
                Task FollowTask = new Task();
                FollowTask.Subject = setup.Subject__c;
                FollowTask.Description__c = setup.Description__c;
                FollowTask.WhatId = subcase.Id;
                FollowTask.OwnerId = lstGM.get(0).User__r.Id;
                FollowTask.Status = setup.Status__c;
                FollowTask.ActivityDate = Date.Today() + Integer.valueOf(setup.Due_Date__c);
                
                insert FollowTask;
                /**********************************/
                
                if (strOwnerId == '' || strResponse == ''){
                    result.success = false;
                    return result;
                }  
                
                //*******************************************************
                
                usr = [ Select Id, Email, Name From User Where Id = :strOwnerId ];
                String strFrom = email.fromName != null ? email.fromName : email.fromAddress;
                strTemp = strFrom + ' ' + System.Label.Responded_on + ' ' + System.now().format( 'dd/MM/yyyy' ) + ' \n\n' + strResponse;
                if( subcase.Answer_Task__c == null || subcase.Answer_Task__c.trim().length() == 0 )
                    subcase.Answer_Task__c = strTemp;
                else
                    subcase.Answer_Task__c += '\n\n' + strTemp;
                update subcase;
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] { usr.Email };
                mail.setToAddresses( toAddresses );
                mail.setSubject( System.Label.Email_Response_Notification_Response_Subject + ': ' + email.Subject );
                String strEnter = '<br></br>';
                String strBody = '<strong>' + usr.Name + '</strong>, ' + System.Label.Email_Response_Notification_Header + ' ' + subcase.Case_Subcase_Number__c;
                strBody += strEnter + strEnter;
                strBody += '"' + strResponse + '"';
                strBody += strEnter + strEnter;
                strBody += System.Label.For_more_details + ':' + strEnter + strEnter;
                if( mapFTS.containsKey( 'SFDC Address' ) )
                {
                    String strURL = '' + mapFTS.get( 'SFDC Address' ).value__c + subcase.Id;
                    strBody += '<a href="' + strURL + '" target="_blank">' + strURL + '</a>';
                }
                strBody += strEnter;
                strBody += '****************************************************************************';
                strBody += strEnter;
                strBody += email.htmlBody;
                mail.setHtmlBody( strBody );
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                
                result.success = true;
            }
            catch( System.Exception e )
            {
                System.debug( '*-*-*-*-*-*- EXCEXPTION ' + e  + ':' + e.getStackTraceString());
                result.success = false;
            }
        }
        else
            result.success = false;
        return result;
    }
    
    public static String CleanResponse( String strText, String strSubCaseId, String strOwnerId )
    {
        String strResp = '', strTemp = '';
        System.debug( '---***--- strText ' + strText );
        strTemp = strText.replace( '<input value="*SUBCASE_ID*' + strSubCaseId + '*END_SUBCASE_ID*" type="hidden">', '');
        System.debug( '---***--- strTemp ' + strTemp );
        strResp = strTemp.replace( '<input value="*OWNER_ID*' + strOwnerId + '*END_OWNER_ID*" type="hidden">', '');
        System.debug( '---***--- strResp ' + strResp );
        return strResp.trim();
    }
}