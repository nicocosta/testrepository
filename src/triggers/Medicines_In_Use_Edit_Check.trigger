/****************************************************************************************************
    General Information
    -------------------
    Developer:          Avanxo Colombia
    Autor:              Daniel Delgado (DFDC)
    Project:            Novartis Brazil
    Description:        Validation Rules for Medicines In Use (MIU).
                        If the CaseType related into Case related in the SIR reference has de FV check selected:
                        * User can only edit MIU's records if the related case has at least one open task assigned
                         to a User with the same profile that the User tha execute this process.
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     08-03-2011  Daniel Delgado (DFDC)       Trigger creation.
    ****************************************************************************************************/
trigger Medicines_In_Use_Edit_Check on Medicines_in_use__c (after update)
{
    Map<String, List<Medicines_in_use__c>> lstMIUByCaseId = new Map<String, List<Medicines_in_use__c>>();
    List<String> lstCaseIdForTaskSearch = new List<String>();
    
    
    ///*****************************************************
    /// Corrección para traer el id del caso
    /// JPG 25/03/2011
    Set<ID> setSIRid = new set<ID>();
    for( Medicines_in_use__c miu : Trigger.new ){
        setSIRid.add(miu.Safety_Individual_Report__c);
    }
    Map<ID,Safety_Individual_Report__c> miuMap= new Map<ID,Safety_Individual_Report__c>([Select s.Subcase_Number__c FROM Safety_Individual_Report__c  s Where s.id IN: setSIRid]);
    //Get cases to search and store medinices in use records by case.
    for( Medicines_in_use__c miu : Trigger.new )
    {
        System.debug( 'miu.Safety_Individual_Report__c: ' + miu.Safety_Individual_Report__c );
        //System.debug( 'miu.Safety_Individual_Report__r.Subcase_Number__c: ' + miu.Safety_Individual_Report__r.Subcase_Number__c );
        System.debug( 'miu.Safety_Individual_Report__r.Subcase_Number__c: ' + miuMap.get(miu.Safety_Individual_Report__c) );
        Id subcaseId =  miuMap.get(miu.Safety_Individual_Report__c).Subcase_Number__c;
        if( miu.Safety_Individual_Report__c != null )// && miu.Safety_Individual_Report__r.Subcase_Number__c != null )
        {
            List<Medicines_in_use__c> lstTemp;
            if( lstMIUByCaseId.containsKey( subcaseId ) )
                lstTemp = lstMIUByCaseId.get(subcaseId );
            else
                lstTemp = new List<Medicines_in_use__c>();
            lstTemp.add( miu );
            lstMIUByCaseId.put( subcaseId , lstTemp );
        }
    }
    
    ////***************************************************
    
    /*//Get cases to search and store medinices in use records by case.
    for( Medicines_in_use__c miu : Trigger.new )
    {
        System.debug( 'miu.Safety_Individual_Report__c: ' + miu.Safety_Individual_Report__c );
        System.debug( 'miu.Safety_Individual_Report__r.Subcase_Number__c: ' + miu.Safety_Individual_Report__r.Subcase_Number__c );
        if( miu.Safety_Individual_Report__c != null )// && miu.Safety_Individual_Report__r.Subcase_Number__c != null )
        {
            List<Medicines_in_use__c> lstTemp;
            if( lstMIUByCaseId.containsKey( miu.Safety_Individual_Report__r.Subcase_Number__c ) )
                lstTemp = lstMIUByCaseId.get( miu.Safety_Individual_Report__r.Subcase_Number__c );
            else
                lstTemp = new List<Medicines_in_use__c>();
            lstTemp.add( miu );
            lstMIUByCaseId.put( miu.Safety_Individual_Report__r.Subcase_Number__c, lstTemp );
        }
    }*/
    
    //Search cases
    for( Case c : [ Select  Id, Status, IsClosed, Case_Type__r.EditInfoDisable__c From  Case    Where   Id IN :lstMIUByCaseId.keySet() ] )
    {
        System.debug('***** case:' + c);
        //If a subcase is closed nobody can edit the record
        if( c.IsClosed )
        {
            System.debug('***** case closed:' + c);
            for( Medicines_in_use__c miu : lstMIUByCaseId.get( c.Id ) )
            {
                miu.addError( System.label.Cannot_Edit_Record_Closed_Case );
                lstMIUByCaseId.remove( c.Id );
            }
        }
        else if( c.Case_Type__r.EditInfoDisable__c ){
            System.debug('***** case add:' + c.Id);
            lstCaseIdForTaskSearch.add( c.Id ); //What cases need to check the user's profile
        }else{
            System.debug('***** case remove:' + c.Id);
            lstMIUByCaseId.remove( c.Id ); //Remove Medicines In Use that can be edited without FV Check
        }
    }
    
    //Search Task
    String strPerfil = [select Profiles_Subordinates__c from User where id = :UserInfo.getUserId()].Profiles_Subordinates__c;
    System.debug('DebugLine 69: Subordinado:' + strPerfil );
        
    for( Task t : [ Select  WhatId, WhoId
                    From    Task
                    Where   WhatId IN :lstCaseIdForTaskSearch 
                            and IsClosed = false
                            and StageId__c <> null 
                            and ((Owner.ProfileId = :UserInfo.getProfileId()) OR (Owner.ProfileId = :strPerfil))] )
        lstMIUByCaseId.remove( t.WhatId ); //Remove Medicines In Use that can be edited.
    
    //Add error message to those Medicines In Use that cannot be edited due that the user don't have permit.
    for( String strKey : lstMIUByCaseId.keySet() )
    {
        for( Medicines_in_use__c miu : lstMIUByCaseId.get( strKey ) ){
            System.debug('***** add error:' + miu);
            miu.addError( System.label.Cannot_Edit_Medicines_In_Use_FV );
        }
    }
}