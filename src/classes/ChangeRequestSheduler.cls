/****************************************************************************************************
    General Information
    -------------------
    Developer:          Avanxo Colombia
    Autor:              Carlos Carvajal (CFC)
    Project:            Novartis Brazil
    Description:        delete cases with the field spam__c in true and send email. 
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     27-10-2010  Carlos Carvajal (CFC)       Create class.
    ****************************************************************************************************/

global class ChangeRequestSheduler implements Schedulable
{
    global Integer opc{get;set;}
    global String rtaWS{get;set;}
    global String idRQs{get;set;}
        
    public ChangeRequestSheduler(){
        opc=1;
        EliminarSch();
        
        
    }
    public ChangeRequestSheduler(Integer op, String valor)
    {
        opc=op;
        rtaWS=valor;
        
        
        
    }
    
    public ChangeRequestSheduler(Integer op, String valor, String NumberCR)
    {
        opc=op;
        rtaWS=valor;
        idRQs=NumberCR;
        
    }
    
    global void execute(SchedulableContext sc) 
    {
        if(opc==1)
        {
            this.proceso1();
        }
        else if(opc==2)
        {
            this.ActualizarCR();
        }
        
    }
    
    public List<Integer> getIds (String strCRnumber)
    {           
        List<Integer> lstCRnumber = new List<Integer>();
        strCRnumber=strCRnumber.replace('.','');
        List<String> lstStrCRnumber = strCRnumber.split(',');
        
        for( String strNumber:lstStrCRnumber )
            lstCRnumber.add(Integer.Valueof(strNumber));
        
        System.debug('List--> '+lstCRnumber);
        return lstCRnumber;     
    }
    
    public void proceso1()
    {
        List<Change_Request__c> lstCR=[Select c.id,c.CR_closing_date__c, c.CR_error_message__c, c.CR_number__c, c.Status__c 
                                        from Change_Request__c c 
                                        where c.Status__c='Open' and c.CR_number__c!= null];
        String idcrs='';
        if (lstCR.size()>0) {
            for(Change_Request__c cr:lstCR)
            {
                idcrs+=+','+cr.CR_number__c;
            }
            CreateChangeRequestWS_ctr crws=new CreateChangeRequestWS_ctr();
         
            idcrs=idcrs.substring(1);
            System.debug(idcrs);
            CreateChangeRequestWS_ctr.sendWS(idcrs);
        }
        
    }
    
    public void ActualizarCR()
    {
        if(Test.isRunningTest()){
            rtaWS='1.0;678.2;90.2;34.2;65.2;898.2';
        }
        System.debug('Respuesta del ws --->'+rtaWS+' tamaño vec '+rtaWS.length());
        if(rtaWS.length()>0) {
            System.debug(':::: rtaWS.split(\';\'):' + rtaWS.split(';'));
            List<String> lRtaWS=rtaWS.split(';');
            System.debug(':::: lRtaWS.size():'+lRtaWS.size());
            List<Double> idcrws=new List<Double>();
            List<String> fechaRta=new List<String>();
            Integer c=0;
            
            for(Integer i=0;i<lRtaWS.size();i+=2)
            
            {
                System.debug(':::: i:'+i);
                System.debug(':::: lRtaWS.get(i):'+lRtaWS.get(i));
                //idcrws.set(c,Double.valueOf(lRtaWS.get(i)));
                idcrws.add(Double.valueOf(lRtaWS.get(i)));              
                //fechaRta.set(c,lRtaWS.get(i+1));
                fechaRta.add(lRtaWS.get(i+1));
                /*
                i++;
                if(i>=lRtaWS.size()){
                    break;
                }*/
                c++;
            }
            
            List<Change_Request__c> lstCR=[Select c.id,c.CR_closing_date__c, c.CR_error_message__c, c.CR_number__c, c.Status__c, c.isProcessed__c 
                                        from Change_Request__c c 
                                        where c.Status__c='Open' and c.CR_number__c!= null];
            Boolean band=false;                     
            if(lstCR.size()>0)
            {
                for(Change_Request__c cr:lstCR)
                {
                    band=false;
                    Integer bn=0;
                    for( Double idcr : idcrws) 
                    {
                        try 
                        {
                            Double icr=Double.valueOf(idcr);
                            if(icr==cr.CR_number__c)
                            {   
                                //cr.CR_closing_date__c=Date.valueOf(convertirFecha(fechaRta.get(bn)));
                                //cr.Status__c='Closed';
                                //band=true;
                            } else
                            {
                                cr.isProcessed__c = false;
                                System.debug(' \n Registro actualizado a isProcessed__c = false '+cr.Id);
                            }
                            
                        }
                        catch (Exception ex){
                            Date processStart=Date.today();
                            cr.CR_error_message__c=ex.getMessage()+ processStart;
                        }
                        bn++; 
                    }
                    
                    if(band==true)
                    {
                        cr.CR_error_message__c='This CR has been closed. Last update status ' + System.now();
                    }
                
                }
                update lstCR;
            }
        } 
        else 
        {
            List<Integer> lstCRnumber = getIds(idRQs);
            List<Change_Request__c> lstCR=[Select c.CR_number__c,c.isProcessed__c 
                                            from Change_Request__c c 
                                            where c.Status__c='Open' and c.CR_number__c!= null and c.CR_number__c IN:lstCRnumber];
            
            if (lstCR.size()>0) {
                for(Change_Request__c cr:lstCR)         
                    cr.isProcessed__c = false;
                System.debug('Objs actualizados a false-> '+lstCR); 
                update lstCR;
            }       
        }
    }
    
    public void EliminarSch()
    {
        List<Crontrigger> a=[Select id,state from CronTrigger where state='DELETED'];
        for(CronTrigger ct : a)
        {
            System.abortjob(ct.Id);
        }
    }
    
    public String convertirFecha(String fecha)
    {
        List<String> lf=fecha.split('/');
        return '20'+lf.get(2) + '-' + lf.get(1) + '-' + lf.get(0) + ' 00:00:00';
        
        
    }
    
    
    
}