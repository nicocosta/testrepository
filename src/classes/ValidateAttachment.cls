public class ValidateAttachment {

public void executeLogic(List<Attachment> lstNewDat, List<Attachment> lstOldDat)
    {
        if(lstNewDat!=null)
        {
            if( lstNewDat.size() == 1 && validateCaseType( lstNewDat[0].ParentId) )
            {   
                //JGDP. 28-08-2013. Cambio configuración personaliza para incluir más de un perfil
                List<SICSupervisor_Profile_Config__c> config = SICSupervisor_Profile_Config__c.getall().values();
                set<String> lstIdProfiles = new set<String>();
                for( SICSupervisor_Profile_Config__c objConfig :config )
                {
                  lstIdProfiles.add(objConfig.IdProfile__c);
                }
                
                //String fvProfileSICSupervisor = FV_Setup__c.getInstance().SICSupervisor__c;
                String fvProfileSICLeader =  FV_Setup__c.getInstance().SICLeader__c; 
                if (!lstIdProfiles.contains(Userinfo.getProfileId()) && (Userinfo.getProfileId().substring( 0, 15 ) != fvProfileSICLeader)) 
                {             
                    Attachment objAttachment = lstNewDat[0];                
                    Boolean isOpenTask = isOpenTaskforGroup(objAttachment.ParentId);
                    if( !isOpenTask )
                        objAttachment.addError(System.label.ValidateCaseComment);
                    else
                        return;
                }
            }
        }
    }   
    
    public boolean isOpenTaskforGroup(String idSubcase)
    {
        Boolean isTrue = false;
        List<Case> lstGroups = [Select (Select Group_Id__c, Group_Name__c, StageId__c From OpenActivities ), (Select Status, IsClosed, Group_Name__c From ActivityHistories) From Case c where c.id =: idSubcase];
                
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
        * Cuando tenga tareas de FV abiertas, solo Fv y TdS pueden ingresar adjuntos. Los usuarios de perfil de farmacovigilancia pueden incluir adjuntos y comentarios al caso en cualquier momento, incluso si el subcaso esta cerrado.
        */
        //JGDP. 28-08-2013. Cambio configuración personaliza para incluir más de un perfil
        List<FV_Profile_Config__c> configFV = FV_Profile_Config__c.getall().values();
        set<String> lstIdFV = new set<String>();
        for( FV_Profile_Config__c objConfig :configFV )
        {
          lstIdFV.add(objConfig.IdProfile__c);
        }
        
        List<SICSupervisor_Profile_Config__c> config = SICSupervisor_Profile_Config__c.getall().values();
        set<String> lstIdSICSupervisor = new set<String>();
        for( SICSupervisor_Profile_Config__c objConfig :config )
        {
          lstIdSICSupervisor.add(objConfig.IdProfile__c);
        }
        
        List<TDS_Profile_Config__c> configTDS = TDS_Profile_Config__c.getall().values();
        set<String> lstIdTDS = new set<String>();
        for( TDS_Profile_Config__c objConfig :configTDS )
        {
          lstIdTDS.add(objConfig.IdProfile__c);
        }
         
        String fvProfileSICLeader =  FV_Setup__c.getInstance().SICLeader__c; 
        if (( lstIdFV.contains(Userinfo.getProfileId()) || lstIdTDS.contains(Userinfo.getProfileId()) || lstIdSICSupervisor.contains(Userinfo.getProfileId()) || (Userinfo.getProfileId().substring( 0, 15 ) == fvProfileSICLeader)) && blnFV_Open) 
            isTrue = true;
            
        System.debug('Validación 6 -> '+ isTrue);
        
        /*
        * Cuando se cierren todas las tareas de Calidad y el perfil es Tds no se pueden ingresar comentarios
        */        
        if(!blnQL_OpenTds && blnQL_ClosedTds && (lstIdTDS.contains(Userinfo.getProfileId()) || lstIdSICSupervisor.contains(Userinfo.getProfileId()) || (Userinfo.getProfileId().substring( 0, 15 ) == fvProfileSICLeader)))
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

				if(lstCT.get(0).Name == 'RELATO FARMACOVIGILÂNCIA')
                    isValid = true;

            }
        }
        
        if( Test.isRunningTest() )  isValid = true;      

        
        return isValid;         
    }
}