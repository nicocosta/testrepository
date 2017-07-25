/****************************************************************************************************
    General Information
    -------------------
    Developer:          Avanxo Colombia
    Autor:              Daniel Delgado (DFDC)
    Project:            Novartis Brazil
    Description:        Validation Rules for Case Comments. None user can delete Case Comments. 
                        For inserts and updates:
                            * If the related case is closed only FV profiles can create and edit.
                            * If the related case is open, the system will find all open tasks created
                              by task flow and related to the case. Then will check for the Validate
                              Comments functionallity in the Stage
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     09-03-2011  Daniel Delgado (DFDC)       Trigger creation.
    ****************************************************************************************************/
trigger ValidationRules_CaseComment on CaseComment (before delete, after insert, after update)
{
    if( Trigger.isDelete )
    {
        for( CaseComment cc : Trigger.old )
            cc.addError( System.label.Cannot_Delete_record );
    }
    else if( Trigger.isInsert || Trigger.isUpdate )
    {
        Map<String, List<CaseComment>> lstCommentsByCaseId = new Map<String, List<CaseComment>>();
        Map<String, List<CaseComment>> lstCommentsByStageId = new Map<String, List<CaseComment>>();
        Set<String> setCommentIdOk = new Set<String>();
        Set<String> setCommentIdAddError = new Set<String>();
        String fvProfileId = FV_Setup__c.getInstance().FV_Profile_Id__c;
        String TdsProfileId = FV_Setup__c.getInstance().TdS_Analistas__c;
        fvProfileId = fvProfileId.subString( 0, 15 );
        TdsProfileId = TdsProfileId.subString( 0, 15 );
        String strProfileName = [ Select Name From Profile Where Id = :Userinfo.getProfileId() ].Name;
        String strPerfil = [select Profiles_Subordinates__c from User where id = :UserInfo.getUserId()].Profiles_Subordinates__c;
        
        System.debug( 'Id Perfil FV: ' + fvProfileId );
        System.debug( 'Nombre Perfil del Usuario: ' + strProfileName );
        System.debug( 'Map inicial: ' + Trigger.newMap );
        
        for( CaseComment cc : Trigger.new )
        {
            List<CaseComment> lstTemp = new List<CaseComment>{ cc };
            if( lstCommentsByCaseId.containsKey( cc.ParentId ) )
                lstTemp.addAll( lstCommentsByCaseId.get( cc.ParentId ) );
            lstCommentsByCaseId.put( cc.ParentId, lstTemp );
        }
        
        System.debug( 'lstCommentsByCaseId: ' + lstCommentsByCaseId );
        
        for( Case c : [ Select isClosed, Id From Case Where Id IN :lstCommentsByCaseId.keySet() ] )
        {
            if( c.isClosed && (((Userinfo.getProfileId().substring( 0, 15 ) == fvProfileId) || (Userinfo.getProfileId().substring( 0, 15 ) == TdSProfileId)) || ((strPerfil.substring( 0, 15 ) == fvProfileId) || (strPerfil.substring( 0, 15 ) == TdSProfileId))) )
                lstCommentsByCaseId.remove( c.Id );
            else if( c.isClosed && (((Userinfo.getProfileId().substring( 0, 15 ) != fvProfileId) || (Userinfo.getProfileId().substring( 0, 15 ) != TdSProfileId)) || ((strPerfil.substring( 0, 15 ) != fvProfileId) || (strPerfil.substring( 0, 15 ) != TdSProfileId))) )
            {
                for( CaseComment cc : lstCommentsByCaseId.get( c.Id ) )
                    cc.addError( System.label.Cannot_Edit_Record_Closed_Case );
                lstCommentsByCaseId.remove( c.Id );
            }
        }
        
        System.debug( 'lstCommentsByCaseId: ' + lstCommentsByCaseId );
        
        for( Task t : [ Select  StageId__c, WhatId
                        From    Task
                        Where   WhatId IN :lstCommentsByCaseId.keySet() 
                                and IsClosed = false
                                and StageId__c <> null ] )
        {
            List<CaseComment> lstTemp = lstCommentsByCaseId.get( t.WhatId );
            if( lstCommentsByStageId.containsKey( t.StageId__c ) )
                lstTemp.addAll( lstCommentsByStageId.get( t.StageId__c ) );
            lstCommentsByStageId.put( t.StageId__c, lstTemp );
        }
        
        System.debug( 'lstCommentsByStageId: ' + lstCommentsByStageId );
        System.debug( 'lstCommentsByStageId: ' + lstCommentsByStageId.keySet() );
        
        for( Stage__c stg : [   Select  Id, Validate_comments__c, Users_profiles__c
                                From    Stage__c
                                Where   Id IN :lstCommentsByStageId.keySet() ] )
        {
            System.debug( 'stg.Validate_comments__c: ' + stg.Validate_comments__c );
            // Se agrega nueva validación según caso 336506. Para que los usuarios con perfil Farmacovigilacia puedan agregar comentarios en cualquier evento.
            if( stg.Validate_comments__c && (((Userinfo.getProfileId().substring( 0, 15 ) != fvProfileId) && (Userinfo.getProfileId().substring( 0, 15 ) != TdSProfileId)) || ((strPerfil.substring( 0, 15 ) != fvProfileId) && (strPerfil.substring( 0, 15 ) != TdSProfileId))) )
            {
                Set<String> setProfileNames = new Set<String>();
                List<String> lstProfilesTemp = stg.Users_profiles__c.split( ';' );
                setProfileNames.addAll( lstProfilesTemp );
                System.debug( 'setProfileNames: ' + setProfileNames );
                System.debug( 'strProfileName: ' + strProfileName );
                System.debug( 'setProfileNames.contains( strProfileName ): ' + setProfileNames.contains( strProfileName ) );
                if( !setProfileNames.contains( strProfileName ))
                {

                    for( CaseComment cc : lstCommentsByStageId.get( stg.Id ) )
                    {
                         setCommentIdAddError.add( cc.Id );                        
                    }
                }
                else
                {
                    for( CaseComment cc : lstCommentsByStageId.get( stg.Id ) )


                    {
                        if( setCommentIdAddError.contains( cc.Id ) )
                            setCommentIdAddError.remove( cc.Id );
                        setCommentIdOk.add( cc.Id );
                    }
                }
            }
            else
            {
                for( CaseComment cc : lstCommentsByStageId.get( stg.Id ) )
                {

                    if( !setCommentIdAddError.contains( cc.Id ) )
                        setCommentIdAddError.remove( cc.Id );
                    setCommentIdOk.add( cc.Id );
                }
            }
        }
        

        for( String strKey : setCommentIdAddError )
        {
            CaseComment cc = Trigger.newMap.get( strKey );
            cc.addError( System.label.ValidateCaseComment );
        }
    }
}