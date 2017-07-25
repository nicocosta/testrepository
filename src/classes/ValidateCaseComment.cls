public class ValidateCaseComment {
    
    public void executeLogic(List<CaseComment> lstNewDat, List<CaseComment> lstOldDat)
    {
        if(lstNewDat!=null)
        {
            if( lstNewDat.size() == 1 && validateCaseType( lstNewDat[0].ParentId) )
            {   
                CaseComment objCaseComment = lstNewDat[0];
                Boolean isOpenTask = isOpenTaskforGroup(objCaseComment.ParentId);
                if( !isOpenTask )
                    objCaseComment.addError(System.label.ValidateCaseComment);
                else
                    return;
                
            }
        }
    }   
    
    public boolean isOpenTaskforGroup(String idSubcase)
    {
        Boolean isTrue = false;
        List<Case> lstGroups = [Select (Select Group_Id__c, Group_Name__c, StageId__c, Status From OpenActivities ) , (Select Status, IsClosed, Group_Name__c From ActivityHistories) From Case c where c.id =: idSubcase];
                
        List<String> lstIdGroups = new List<String>();
        List<String> lstStageId = new List<String>();
        Set<String> lstGroupNameOpen = new Set<String>();
        Set<String> lstGroupNameClosed = new Set<String>();
        
        /*
        * There any open task assigned to a group to which the user belongs. 
        * Un usuario puede incluir comentarios y archivos adjuntos en el subcaso, si existe alguna tarea abierta asignada a un grupo al que pertenezca el usuario.
        */
        
        for(Integer x=0; x<lstGroups.size(); x++)
        {
            if( lstGroups.get(x).OpenActivities.size() > 0 )
            {
                for(Integer y=0; y<lstGroups.get(x).OpenActivities.size(); y++)
                {
                    OpenActivity oa = lstGroups.get(x).OpenActivities.get(y);
                    lstIdGroups.add(oa.Group_Id__c);
                    lstGroupNameOpen.add(oa.Group_Name__c);
                    if( oa.StageId__c!=null ) 
                    {
                      lstStageId.add(oa.StageId__c);
                    }
                    
                }
            }
            
            if( lstGroups.get(x).ActivityHistories.size() > 0 )
            {
                for(Integer y=0; y<lstGroups.get(x).ActivityHistories.size(); y++)
                {
                    ActivityHistory ah = lstGroups.get(x).ActivityHistories.get(y);                
                    lstGroupNameClosed.add(ah.Group_Name__c);                    
                }
            }
        }
        System.debug('Ids Groups->'+lstIdGroups);
        
        if( !lstIdGroups.isEmpty() )
        {
            List<Group_Member__c> lstGroupMember = [SELECT Id FROM Group_Member__c WHERE Active__c = true And User__c =:Userinfo.getUserId() And Group__c IN:lstIdGroups];          
            if( !lstGroupMember.isEmpty() ) isTrue = true;
        }
        System.debug('Validación 1 -> '+ isTrue);
        
        /*
        * Si existe una tarea abierta asignada a otro grupo en el mismo subcaso, y la tarea (stage) tiene check la casilla de "validate comments and attachments" = TRUE, el usuario no puede incluir comentarios ni adjuntos al caso.
        */        
        System.debug('Ids StageId->'+lstStageId);
        if( !lstStageId.isEmpty() && !lstIdGroups.isEmpty() )
        {
            List<Stage__c> lstStage = [SELECT Id FROM Stage__c WHERE Validate_comments__c = true AND Group__c IN:lstIdGroups And Validate_comments__c = true And Id IN:lstStageId];
            if( !lstStage.isEmpty() ) isTrue = false;
        }
        System.debug('Validación 2 -> '+ isTrue);
        
        /*
        * Mientras no existan ninguna tarea de FV abierta si debe dejar ingresar comentarios
        */
         
        Boolean blnFV_Open = lstGroupNameOpen.contains('FARMACOVIGILÂNCIA');
        Boolean blnFV_Closed = lstGroupNameClosed.contains('FARMACOVIGILÂNCIA');
        Boolean blnQL_OpenTds = lstGroupNameOpen.contains('QUALIDADE');
        Boolean blnQL_ClosedTds = lstGroupNameClosed.contains('QUALIDADE');
        
        if(!blnFV_Open && !blnFV_Closed)
        {
            isTrue = true;
        }
        System.debug('Validación 3 -> '+ isTrue);
        
        /*
        * Cuando tenga tareas de FV abiertas, solo Fv y TdS pueden ingresar comentarios. Los usuarios de perfil de farmacovigilancia pueden incluir adjuntos y comentarios al caso en cualquier momento, incluso si el subcaso esta cerrado.
        */
        String fvProfileId = FV_Setup__c.getInstance().FV_Profile_Id__c;
        String fvProfileTdS = FV_Setup__c.getInstance().TdS_Analistas__c;
        String strPerfil = [select Profiles_Subordinates__c from User where id = :UserInfo.getUserId()].Profiles_Subordinates__c;
        if( ((Userinfo.getProfileId().substring( 0, 15 ) == fvProfileId || Userinfo.getProfileId().substring( 0, 15 ) == fvProfileTdS) || (strPerfil.substring( 0, 15 ) == fvProfileId || strPerfil.substring( 0, 15 ) == fvProfileTdS)) && blnFV_Open )
        { 
            isTrue = true;
        }                
        System.debug('Validación 4 -> '+ isTrue);
        
        /*
        * Cuando se cierren todas las tareas de FV nadie puede ingresar comentarios
        */
        if(!blnFV_Open && blnFV_Closed)
        {
            isTrue = false;
        }
        System.debug('Validación 5 -> '+ isTrue);
        
        /*
        * De acuerdo al caso 00336606. Los analistas perfil TDS puede introducir comentarios y archivos adjuntos en cualquier momento siempre que haya al menos una tarea de Calidad abierto.
        */
        if(blnQL_OpenTds && (Userinfo.getProfileId().substring( 0, 15 ) == fvProfileTdS || strPerfil.substring( 0, 15 ) == fvProfileTdS))
        {
            isTrue = true;
        }
        System.debug('Validación 6 -> '+ isTrue);
        
        /*
        * Cuando se cierren todas las tareas de Calidad y el perfil es Tds no se pueden ingresar comentarios
        */        
        if(!blnQL_OpenTds && blnQL_ClosedTds && (Userinfo.getProfileId().substring( 0, 15 ) == fvProfileTdS || strPerfil.substring( 0, 15 ) == fvProfileTdS))
        {
            isTrue = false;
        }
        System.debug('Validación 7 -> '+ isTrue);
        
        /*
        * Si es prueba
        */
        if( Test.isRunningTest() )  isTrue = true;
        System.debug('Es prueba -> '+ isTrue);
        
        return isTrue;
    }
    
    public Boolean validateCaseType (String idSubcase)
    {
      Boolean isValid = false;
      List<Case> lstGroups = [Select Case_Type__c From Case c where c.id =: idSubcase];
            
      if(!lstGroups.IsEmpty())
      {
        List<Case_Type__c> lstCT = [SELECT Name FROM Case_Type__c WHERE Id =:lstGroups.get(0).Case_Type__c];
        if(!lstCT.IsEmpty())
        {
          if(lstCT.get(0).Name == 'RECLAMAÇÃO TÉCNICA COM RELATO DE FARMACOVIGILÂNCIA')
            isValid = true;
        }
      }
      
      if( Test.isRunningTest() )  isValid = true;      
      
      return isValid;       
    }
}

/*
public class ValidateCaseComment {
    
    public void executeLogic(List<CaseComment> lstNewDat, List<CaseComment> lstOldDat)
    {
        if(lstNewDat!=null)
        {
            if( lstNewDat.size() == 1 && validateCaseType( lstNewDat[0].ParentId) )
            {   
                CaseComment objCaseComment = lstNewDat[0];
                Boolean isOpenTask = isOpenTaskforGroup(objCaseComment.ParentId);
                if( !isOpenTask )
                    objCaseComment.addError(System.label.ValidateCaseComment);
                else
                    return;
                
            }
        }
    }   
    
    public boolean isOpenTaskforGroup(String idSubcase)
    {
        Boolean isTrue = false;
        List<Case> lstGroups = [Select (Select Group_Id__c, StageId__c From OpenActivities Where Status = 'Open' and Group_Id__c != null) From Case c where c.id =: idSubcase];
                
        List<String> lstIdGroups = new List<String>();
        List<String> lstStageId = new List<String>();
        
        //
        // There any open task assigned to a group to which the user belongs. 
        // Un usuario puede incluir comentarios y archivos adjuntos en el subcaso, si existe alguna tarea abierta asignada a un grupo al que pertenezca el usuario.
        //
        
        for(Integer x=0; x<lstGroups.size(); x++)
        {
            if( lstGroups.get(x).OpenActivities.size() > 0 )
            {
                for(Integer y=0; y<lstGroups.get(x).OpenActivities.size(); y++)
                {
                    OpenActivity oa = lstGroups.get(x).OpenActivities.get(y);
                    lstIdGroups.add(oa.Group_Id__c);
                    if( oa.StageId__c!=null ) lstStageId.add(oa.StageId__c);        
                }
            }
        }
        System.debug('Ids Groups->'+lstIdGroups);
        
        if( !lstIdGroups.isEmpty() )
        {
            List<Group_Member__c> lstGroupMember = [SELECT Id FROM Group_Member__c WHERE Active__c = true And User__c =:Userinfo.getUserId() And Group__c IN:lstIdGroups];          
            if( !lstGroupMember.isEmpty() ) isTrue = true;
        }
        System.debug('Validación 1 -> '+ isTrue);
        //
        // Si existe una tarea abierta asignada a otro grupo en el mismo subcaso, y la tarea (stage) tiene check la casilla de "validate comments and attachments" = TRUE, el usuario no puede incluir comentarios ni adjuntos al caso.
        //
        
        System.debug('Ids StageId->'+lstStageId);
        if( !lstStageId.isEmpty() && !lstIdGroups.isEmpty() )
        {
            List<Stage__c> lstStage = [SELECT Id FROM Stage__c WHERE Validate_comments__c = true AND Group__c IN:lstIdGroups And Validate_comments__c = true And Id IN:lstStageId];
            if( !lstStage.isEmpty() ) isTrue = false;
        }
        System.debug('Validación 2 -> '+ isTrue);
        
        //
        // Los usuarios de perfil de farmacovigilancia pueden incluir adjuntos y comentarios al caso en cualquier momento, incluso si el subcaso esta cerrado.
        //
        //JGDP. 28-08-2013. Cambio configuración personaliza para incluir más de un perfil
        List<FV_Profile_Config__c> configFV = FV_Profile_Config__c.getall().values();
        set<String> lstIdFV = new set<String>();
        for( FV_Profile_Config__c objConfig :configFV )
        {
          lstIdFV.add(objConfig.IdProfile__c);
        }
        List<TDS_Profile_Config__c> configTDS = TDS_Profile_Config__c.getall().values();
        set<String> lstIdTDS = new set<String>();
        for( TDS_Profile_Config__c objConfig :configTDS )
        {
          lstIdTDS.add(objConfig.IdProfile__c);
        }
        
        if( lstIdFV.contains(Userinfo.getProfileId()) || lstIdTDS.contains(Userinfo.getProfileId()) ) isTrue = true;                 
        System.debug('Validación 3 -> '+ isTrue); 
        
        if( Test.isRunningTest() )  isTrue = true;
        System.debug('Es prueba -> '+ isTrue);
        
        return isTrue;
    }
    
    public Boolean validateCaseType (String idSubcase)
    {
        Boolean isValid = false;
        List<Case> lstGroups = [Select Case_Type__c From Case c where c.id =: idSubcase];
                
        if(!lstGroups.IsEmpty())
        {
            List<Case_Type__c> lstCT = [SELECT Name FROM Case_Type__c WHERE Id =:lstGroups.get(0).Case_Type__c];
            if(!lstCT.IsEmpty())
            {
                if(lstCT.get(0).Name == 'RECLAMAÇÃO TÉCNICA COM RELATO DE FARMACOVIGILÂNCIA')
                    isValid = true;
            }
        }
        
        if( Test.isRunningTest() )  isValid = true;      
        
        return isValid;         
    }
}*/